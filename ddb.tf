# Copyright Amazon.com, Inc. or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

locals {
    accounts = {for account in var.accounts : account.AccountEmail => {
        AccountEmail              = account.AccountEmail
        AccountName               = account.AccountName
        ManagedOrganizationalUnit = account.ManagedOrganizationalUnit
        SSOUserEmail              = account.SSOUserEmail
        SSOUserFirstName          = account.SSOUserFirstName
        SSOUserLastName           = account.SSOUserLastName
        change_requested_by       = account.change_requested_by
        change_reason             = account.change_reason
        custom_fields             = {for custom_field in account.custom_fields : custom_field.key => custom_field.value}
        account_tags              = {for account_tag in account.account_tags : account_tag.key => account_tag.value}
    }}
}

resource "aws_dynamodb_table_item" "account-requests" {
  for_each   = local.accounts
  table_name = var.account-request-table
  hash_key   = var.account-request-table-hash

  item = jsonencode({
    id = { S = each.key }
    control_tower_parameters = { M = {
      AccountEmail              = { S = lookup(each.value, "AccountEmail") }
      AccountName               = { S = lookup(each.value, "AccountName") }
      ManagedOrganizationalUnit = { S = lookup(each.value, "ManagedOrganizationalUnit") }
      SSOUserEmail              = { S = lookup(each.value, "SSOUserEmail") }
      SSOUserFirstName          = { S = lookup(each.value, "SSOUserFirstName") }
      SSOUserLastName           = { S = lookup(each.value, "SSOUserLastName") }
      }
    }
    change_management_parameters = { M = {
      change_reason       = { S = lookup(each.value, "change_reason") }
      change_requested_by = { S = lookup(each.value, "change_requested_by") }
      }
    }
    account_tags                = { S = jsonencode(lookup(each.value, "account_tags")) }
    account_customizations_name = { S = "" }
    custom_fields               = { S = jsonencode(lookup(each.value, "custom_fields")) }
  })
}
