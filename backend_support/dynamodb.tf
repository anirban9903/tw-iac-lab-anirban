resource "aws_dynamodb_table" "terraform_state_lock_anirban" {
  name         = "anirban_terraform-state-lock" # Or any name you prefer
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  stream_enabled = false # Streams are not needed for state locking
  point_in_time_recovery {
    enabled = true # Recommended for data durability
  }

  server_side_encryption {
    enabled = true # Recommended for security
  }

  tags = {
    Name        = "terraform-state-lock"
    Environment = "terraform"
  }
}