############################
# General Purpouse variables
############################

variable "profile" {
  description = "The AWS authentication profile"
  type        = string
  default     = "mohit"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment for the app"
  type        = string
  default     = "aaa"
}

#This application varient is used to contribute in dynamic naming convention only
variable "application" {
  description = "Name of the application"
  type        = string
  default     = "aaa-01"
}

#This represent the Deployment Pipeline type we executed
variable "project" {
  description = "Name of the project"
  type        = string
  default     = "project-aaa-01"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    "managed_by"  = "Terraform"
    "application" = "FortressIQ"
  }
}

variable "vpc_id" {
  description = "Specify the VPC id"
  type        = string
  default     = ""
}

#######################################
# VPC SETTINGS
#######################################

# CIDR Block
variable "VPCCidr_Block" {
  default     = "10.70.0.0/16"
  description = "CIDR block for the VPC."
  type        = string
}

variable "PrivateSubnetCidr_Blocks" {
  description = "Cidr blocks for private subnets, located in Availability Zone 1,2 and 3 respectively"
  type        = list(string)
  default = [
    "10.70.10.0/24",
    "10.70.20.0/24",
    "10.70.30.0/24",
  ]
}

variable "PublicSubnetCidr_Blocks" {
  description = "Cidr blocks for public subnets, located in Availability Zone 1,2 and 3 respectively"
  type        = list(string)
  default = [
    "10.70.40.0/24",
    "10.70.50.0/24",
    "10.70.60.0/24",
  ]
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

