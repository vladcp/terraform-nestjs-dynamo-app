resource "aws_dynamodb_table" "books_table" {
  name = var.book_table_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

output "dynamo_table_name" {
  value = aws_dynamodb_table.books_table.id
}