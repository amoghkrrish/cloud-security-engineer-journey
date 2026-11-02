# Return the application security group ID after deployment.
output "app_security_group_id" {

  # Explain the output.
  description = "Application security group ID"

  # Retrieve the ID from the created resource.
  value = aws_security_group.app.id
}

# Return the database security group ID after deployment.
output "database_security_group_id" {

  # Explain the output.
  description = "Database security group ID"

  # Retrieve the ID from the created resource.
  value = aws_security_group.database.id
}
