# ---------------------------------------------------------
# PART 1: READ EXISTING WEB SECURITY GROUP
# ---------------------------------------------------------

# A data source reads an AWS resource that already exists.
# It does not create or manage the existing security group.
data "aws_security_group" "web" {

  # Retrieve the security group using the input variable.
  id = var.web_security_group_id
}


# ---------------------------------------------------------
# PART 2: CREATE APPLICATION SECURITY GROUP
# ---------------------------------------------------------

# This security group represents the application tier.
resource "aws_security_group" "app" {

  # Generate a unique name beginning with this prefix.
  name_prefix = "cloudsec-day01-app-"

  # Explain the network security purpose.
  description = "Application tier with restricted web ingress and database egress"

  # Place the security group in the existing VPC.
  vpc_id = var.vpc_id

  # Add resource-specific identification tags.
  tags = {
    Name = "cloudsec-day01-app-tier"
    Tier = "application"
  }

  # Validate an important security assumption before creation.
  lifecycle {

    precondition {

      # Confirm that the existing web SG belongs to this VPC.
      condition = data.aws_security_group.web.vpc_id == var.vpc_id

      # Stop deployment with an understandable error if it does not.
      error_message = "The web security group must belong to the target VPC."
    }
  }
}


# ---------------------------------------------------------
# PART 3: CREATE DATABASE SECURITY GROUP
# ---------------------------------------------------------

# This security group represents the database tier.
resource "aws_security_group" "database" {

  # Generate a unique database security group name.
  name_prefix = "cloudsec-day01-db-"

  # Document its permitted traffic purpose.
  description = "Database tier accepting PostgreSQL from application tier only"

  # Use the same existing VPC.
  vpc_id = var.vpc_id

  # Add identification tags.
  tags = {
    Name = "cloudsec-day01-database-tier"
    Tier = "database"
  }
}


# ---------------------------------------------------------
# PART 4: APPLICATION INBOUND RULE
# ---------------------------------------------------------

# Permit web-tier traffic into the application tier.
resource "aws_vpc_security_group_ingress_rule" "app_from_web" {

  # Apply the rule to the application security group.
  security_group_id = aws_security_group.app.id

  # Only the existing web security group is allowed as source.
  referenced_security_group_id = data.aws_security_group.web.id

  # Restrict permitted traffic to TCP.
  ip_protocol = "tcp"

  # Permit application requests on port 8080.
  from_port = 8080
  to_port   = 8080

  # Provide an understandable rule description.
  description = "Application requests from web tier only"
}


# ---------------------------------------------------------
# PART 5: APPLICATION OUTBOUND RULE
# ---------------------------------------------------------

# Permit the application tier to initiate database connections.
resource "aws_vpc_security_group_egress_rule" "app_to_database" {

  # Apply the outbound rule to the application security group.
  security_group_id = aws_security_group.app.id

  # Limit the destination to the database security group.
  referenced_security_group_id = aws_security_group.database.id

  # Permit TCP traffic only.
  ip_protocol = "tcp"

  # PostgreSQL standard port.
  from_port = 5432
  to_port   = 5432

  # Describe the business purpose of this connection.
  description = "PostgreSQL traffic from application to database"
}


# ---------------------------------------------------------
# PART 6: DATABASE INBOUND RULE
# ---------------------------------------------------------

# Permit the application tier to connect to the database tier.
resource "aws_vpc_security_group_ingress_rule" "database_from_app" {

  # Apply this inbound rule to the database security group.
  security_group_id = aws_security_group.database.id

  # Only the application security group is permitted as source.
  referenced_security_group_id = aws_security_group.app.id

  # Permit TCP traffic only.
  ip_protocol = "tcp"

  # Allow the standard PostgreSQL port.
  from_port = 5432
  to_port   = 5432

  # Document the intended access relationship.
  description = "PostgreSQL requests from application tier only"
}
