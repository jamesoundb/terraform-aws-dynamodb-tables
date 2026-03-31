resource "aws_dynamodb_table" "table" {
  for_each = var.tables

  name         = each.value.name
  billing_mode = each.value.billing_mode
  hash_key     = each.value.hash_key
  range_key    = lookup(each.value, "range_key", null)

  read_capacity  = lookup(each.value, "read_capacity", null)
  write_capacity = lookup(each.value, "write_capacity", null)

  dynamic "attribute" {
    for_each = each.value.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = lookup(each.value, "global_secondary_indexes", [])
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = lookup(global_secondary_index.value, "range_key", null)
      projection_type = global_secondary_index.value.projection_type
      read_capacity   = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity  = lookup(global_secondary_index.value, "write_capacity", null)
    }
  }

  point_in_time_recovery {
    enabled = lookup(each.value, "point_in_time_recovery", false)
  }

  server_side_encryption {
    enabled = lookup(each.value, "server_side_encryption", true)
  }

  tags = merge(
    var.tags,
    lookup(each.value, "tags", {})
  )
}
