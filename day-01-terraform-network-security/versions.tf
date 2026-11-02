# Define the Terraform engine and provider requirements.
terraform {

  # Require Terraform 1.6 or newer.
  required_version = ">= 1.6.0"

  # Declare the external providers this project requires.
  required_providers {

    aws = {
      # Use the official AWS provider maintained by HashiCorp.
      source = "hashicorp/aws"

      # Use compatible AWS provider releases in the 6.x series.
      version = "~> 6.0"
    }
  }
}

# Configure the provider responsible for communicating with AWS.
provider "aws" {

  # Read the deployment region from variables.tf.
  region = var.aws_region

  # Automatically add standard tags to resources.
  default_tags {
    tags = {
      # Identify the learning programme.
      Project = "CloudSecurityEngineerJourney"

      # Identify the mission.
      Day = "01"

      # Record which tool manages the resources.
      ManagedBy = "Terraform"
    }
  }
}
