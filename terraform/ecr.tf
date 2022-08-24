resource "aws_ecr_repository" "dbt" {
  name                 = "${var.project_name}/dbt"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
