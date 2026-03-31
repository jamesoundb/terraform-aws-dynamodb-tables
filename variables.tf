variable "tables" {
  description = "Map of DynamoDB tables to create"
  type = map(object({
    name           = string
    billing_mode   = string
    hash_key       = string
    range_key      = optional(string)
    read_capacity  = optional(number)
    write_capacity = optional(number)
    attributes = list(object({
      name = string
      type = string
    }))
    global_secondary_indexes = optional(list(object({
      name            = string
      hash_key        = string
      range_key       = optional(string)
      projection_type = string
      read_capacity   = optional(number)
      write_capacity  = optional(number)
    })))
    point_in_time_recovery = optional(bool)
    server_side_encryption = optional(bool)
    tags                   = optional(map(string))
  }))
}

variable "tags" {
  description = "Tags to apply to all DynamoDB tables"
  type        = map(string)
  default     = {}
}
