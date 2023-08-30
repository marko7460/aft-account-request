# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
variable "account-request-table" {
  type        = string
  description = "name of account-request-table"
  default     = "aft-request"
}


variable "account-request-table-hash" {
  type        = string
  description = "name of account-request-table hash key"
  default     = "id"
}

variable "aft_home_region" {
  description = "The region from which this module will be executed. This MUST be the same region as Control Tower is deployed."
  type        = string
  validation {
    condition     = can(regex("(us(-gov)?|ap|ca|cn|eu|sa|me|af)-(central|(north|south)?(east|west)?)-\\d", var.aft_home_region))
    error_message = "Variable var: region is not valid."
  }
}


variable "accounts" {
    description = "List of account requests to be issued to AFT"
    type = list(object({
        AccountEmail              = string
        AccountName               = string
        ManagedOrganizationalUnit = string
        SSOUserEmail              = string
        SSOUserFirstName          = string
        SSOUserLastName           = string
        change_requested_by       = string
        change_reason             = string
        custom_fields             = optional(list(object({
            key   = string
            value = string
        })), [])
        account_tags             = optional(list(object({
            key   = string
            value = string
        })), [])
    }))
    default = []
}

variable "aft_partion" {
    type    = string
    default = "aws"
}

variable "aft_management_account_id" {
    type = string
}
