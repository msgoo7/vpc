terraform {
  required_version = "~> 0.14.0"

  required_providers {
    aws      = ">= 3.33.0"
    local    = ">= 1.4"
    null     = ">= 2.1"
    template = ">= 2.1"
  }
}
