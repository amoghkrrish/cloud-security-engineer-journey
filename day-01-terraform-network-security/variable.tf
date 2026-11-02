# Define the AWS region used by the entire project.
variable "aws_region" {

  # Explain the purpose of this input.
  description = "AWS region for the Day 1 network security lab"

  # Require a text value.
  type = string

  # Use the Mumbai region by default.
  default = "ap-south-1"
}

# Define the existing VPC ID.
variable "vpc_id" {

  # Explain that this VPC is reused, not created.
  description = "Existing VPC where the new security groups will be created"

  # The VPC ID must be a string.
  type = string
}

# Define the existing web security group ID.
variable "web_security_group_id" {

  # Explain why this security group is required.
  description = "Existing web security group that can reach the application tier"

  # The security group ID must be a string.
  type = string
}
