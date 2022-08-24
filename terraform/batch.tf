resource "aws_batch_job_definition" "dwh" {
  name                  = "${var.project_name}-batch-job-definition"
  type                  = "container"
  platform_capabilities = ["EC2"]
  propagate_tags        = true
  container_properties = templatefile(
    "${path.module}/job_definition/dbt.json",
    {
      aws_ecr_repository__dbt__repository_url : aws_ecr_repository.dbt.repository_url,
      aws_iam_role__job_role__arn : aws_iam_role.job_role.arn,
    }
  )

  lifecycle {
    ignore_changes = [container_properties]
  }
}

resource "aws_batch_compute_environment" "dwh_batch" {
  compute_environment_name = "${var.project_name}-dwh-batch-compute-env"
  service_role             = aws_iam_role.batch_service_role.arn
  type                     = "MANAGED"
  state                    = "ENABLED"

  compute_resources {
    // https://docs.aws.amazon.com/ja_jp/batch/latest/userguide/allocation-strategies.html
    max_vcpus           = 4
    security_group_ids  = [aws_security_group.batch.id]
    subnets             = [aws_subnet.public_dwh.id]
    allocation_strategy = "BEST_FIT"
    instance_role       = aws_iam_instance_profile.batch_instance_role.arn
    instance_type       = ["c5.large"]
    min_vcpus           = 0
    type                = "EC2"
  }

  depends_on = [aws_iam_role_policy_attachment.batch_service_role]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_batch_job_queue" "dwh_batch" {
  name     = "${var.project_name}-dwh-batch"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.dwh_batch.arn,
  ]
}
