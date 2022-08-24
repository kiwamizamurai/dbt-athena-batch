data "aws_iam_policy_document" "job_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}


resource "aws_iam_role_policy" "job_policy" {
  name = "${var.project_name}-dwh-batch-job-policy"
  role = aws_iam_role.job_role.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:AbortMultipartUpload",
            "s3:PutObject",
            "s3:ListMultipartUploadParts"
          ],
          "Resource" : [
            aws_s3_bucket.dwh.arn,
            aws_s3_bucket.log.arn,
            "${aws_s3_bucket.dwh.arn}/*",
            "${aws_s3_bucket.log.arn}/*",
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "athena:ListEngineVersions",
            "athena:ListWorkGroups",
            "athena:ListDataCatalogs",
            "athena:ListDatabases",
            "athena:GetDatabase",
            "athena:ListTableMetadata",
            "athena:GetTableMetadata",
          ],
          "Resource" : [
            "*",
          ],
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "athena:GetWorkGroup",
            "athena:BatchGetQueryExecution",
            "athena:GetQueryExecution",
            "athena:ListQueryExecutions",
            "athena:StartQueryExecution",
            "athena:StopQueryExecution",
            "athena:GetQueryResults",
            "athena:GetQueryResultsStream",
            "athena:CreateNamedQuery",
            "athena:GetNamedQuery",
            "athena:BatchGetNamedQuery",
            "athena:ListNamedQueries",
            "athena:DeleteNamedQuery",
            "athena:CreatePreparedStatement",
            "athena:GetPreparedStatement",
            "athena:ListPreparedStatements",
            "athena:UpdatePreparedStatement",
            "athena:DeletePreparedStatement"
          ],
          "Resource" : [
            aws_athena_workgroup.dwh.arn,
          ],
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "glue:GetDatabase",
            "glue:GetDatabases",
            "glue:CreateDatabase",
            "glue:GetTable",
            "glue:GetTables",
            "glue:GetPartition",
            "glue:GetPartitions",
            "glue:CreateTable",
            "glue:UpdateTable",
            "glue:DeleteTable",
            "glue:DeletePartition",
          ],
          "Resource" : [
            "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
            "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/${aws_athena_database.dwh.name}",
            "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${aws_athena_database.dwh.name}/*",
          ],
        },
      ],
    },
  )
}

resource "aws_iam_role" "job_role" {
  name               = "${var.project_name}-dwh-batch-job-role"
  assume_role_policy = data.aws_iam_policy_document.job_assume_role.json
}

resource "aws_iam_instance_profile" "batch_instance_role" {
  name = "${var.project_name}-dwh-batch-instance-profile"
  role = aws_iam_role.batch_instance_role.name
}

data "aws_iam_policy_document" "instance_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "batch_instance_role" {
  name = "${var.project_name}-dwh-batch-instance-role"

  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.instance_assume_role.json
}

resource "aws_iam_role_policy_attachment" "batch_instance_role" {
  role       = aws_iam_role.batch_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy_document" "batch_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "batch.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "batch_service_role" {
  name                  = "${var.project_name}-dwh-batch-service-role"
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.batch_assume_role.json
}

resource "aws_iam_role_policy_attachment" "batch_service_role" {
  role       = aws_iam_role.batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}
