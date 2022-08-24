# data "http" "github_actions_openid_configuration" {
#   url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
# }

# data "tls_certificate" "github_actions" {
#   url = jsondecode(data.http.github_actions_openid_configuration.body).jwks_uri
# }


# resource "aws_iam_openid_connect_provider" "github" {
#   url             = "https://token.actions.githubusercontent.com"
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
# }

# data "aws_iam_policy_document" "github_actions_assume_role" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     principals {
#       type        = "Federated"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
#     }
#     sid = ""
#     condition {
#       test     = "StringLike"
#       variable = "token.actions.githubusercontent.com:sub"
#       values   = ["repo:YOUR_ORGANIZATION/YOUR_REPOSITORY:*"]
#     }
#   }
# }

# resource "aws_iam_role" "github_actions" {
#   name               = "${var.project_name}-githubactions"
#   assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
# }

# data "aws_iam_policy_document" "github_actions" {
#   statement {
#     actions = [
#       "ecr:BatchGetImage",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:CompleteLayerUpload",
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:InitiateLayerUpload",
#       "ecr:PutImage",
#       "ecr:UploadLayerPart",
#     ]
#     resources = [
#       aws_ecr_repository.dbt.arn,
#     ]
#   }

#   statement {
#     actions = [
#       "ecr:GetAuthorizationToken",
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "github_actions" {
#   name        = "${var.project_name}-githubactions"
#   description = "Grant Github Actions the ability to push"
#   policy      = data.aws_iam_policy_document.github_actions.json
# }

# resource "aws_iam_role_policy_attachment" "github_actions" {
#   role = aws_iam_role.github_actions.name
#   # "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
#   policy_arn = aws_iam_policy.github_actions.arn
# }
