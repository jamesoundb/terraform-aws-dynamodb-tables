output "table_ids" {
  description = "Map of table names to their IDs"
  value       = { for k, v in aws_dynamodb_table.table : k => v.id }
}

output "table_arns" {
  description = "Map of table names to their ARNs"
  value       = { for k, v in aws_dynamodb_table.table : k => v.arn }
}

output "table_names" {
  description = "List of all table names"
  value       = [for v in aws_dynamodb_table.table : v.name]
}

output "tables" {
  description = "Map of all table objects"
  value       = aws_dynamodb_table.table
}
