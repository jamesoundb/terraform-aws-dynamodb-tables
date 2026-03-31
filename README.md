# DynamoDB Tables Module

This module creates one or more AWS DynamoDB tables with flexible configuration options.

## Features

- Creates multiple DynamoDB tables from a single module call
- Supports both provisioned and on-demand billing modes
- Global Secondary Indexes (GSI) support
- Point-in-time recovery configuration
- Server-side encryption
- Flexible attribute definitions

## Usage

```hcl
module "dynamodb_tables" {
  source = "./modules/dynamodb-tables"

  tables = {
    visitors = {
      name         = "Visitors"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "visitor"
      attributes = [
        {
          name = "visitor"
          type = "N"
        }
      ]
      point_in_time_recovery = true
      server_side_encryption = true
    }
    
    statefile_lock = {
      name         = "Statefile_lock"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "LockID"
      attributes = [
        {
          name = "LockID"
          type = "S"
        }
      ]
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

## Attribute Types

DynamoDB supports three attribute types:
- `S` - String
- `N` - Number
- `B` - Binary

## Billing Modes

- `PROVISIONED` - Traditional billing with specified read/write capacity
- `PAY_PER_REQUEST` - On-demand billing (recommended for variable workloads)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tables | Map of DynamoDB tables to create | `map(object)` | n/a | yes |
| tags | Tags to apply to all tables | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| table_ids | Map of table names to IDs |
| table_arns | Map of table names to ARNs |
| table_names | List of all table names |
| tables | Map of all table objects |

## Example with GSI

```hcl
module "dynamodb_tables" {
  source = "./modules/dynamodb-tables"

  tables = {
    users = {
      name         = "Users"
      billing_mode = "PROVISIONED"
      hash_key     = "user_id"
      range_key    = "timestamp"
      read_capacity  = 5
      write_capacity = 5
      
      attributes = [
        {
          name = "user_id"
          type = "S"
        },
        {
          name = "timestamp"
          type = "N"
        },
        {
          name = "email"
          type = "S"
        }
      ]
      
      global_secondary_indexes = [
        {
          name            = "EmailIndex"
          hash_key        = "email"
          projection_type = "ALL"
          read_capacity   = 5
          write_capacity  = 5
        }
      ]
    }
  }
}
```
