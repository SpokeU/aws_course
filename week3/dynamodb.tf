resource "aws_dynamodb_table" "vehicles_dynamo_table" {
  name           = "vehicles"
  hash_key       = "id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "id"
    type = "N"
  }
  
}
