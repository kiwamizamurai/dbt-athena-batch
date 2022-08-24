resource "aws_athena_workgroup" "dwh" {
  name          = "some_athena_work_group"
  force_destroy = true

  configuration {
    enforce_workgroup_configuration    = false
    publish_cloudwatch_metrics_enabled = true
    result_configuration {
      output_location = "s3://${aws_s3_bucket.dwh.bucket}/athena_output_location/"
    }
  }
}

# ----------------------------------------------
# https://docs.aws.amazon.com/athena/latest/ug/tables-databases-columns-names.html
# Special characters other than underscore (_) are not supported
# ----------------------------------------------
resource "aws_athena_database" "dwh" {
  name          = "some_athena_database_for_default"
  bucket        = aws_s3_bucket.dwh.bucket
  force_destroy = true
}
