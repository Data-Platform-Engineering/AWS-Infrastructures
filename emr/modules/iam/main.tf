
# IAM role for EMR Service
data "aws_iam_policy_document" "emr_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_emr_service_role" {
  name               = "${var.RESOURCE_PREFIX}_iam_emr_service_role"
  assume_role_policy = data.aws_iam_policy_document.emr_assume_role.json
}



resource "aws_iam_role_policy" "iam_emr_service_policy" {
  name   = "${var.RESOURCE_PREFIX}_iam_emr_service_policy"
  role   = aws_iam_role.iam_emr_service_role.id
  policy = data.aws_iam_policy_document.iam_emr_service_policy.json
}

# IAM Role for EC2 Instance Profile

resource "aws_iam_role" "iam_emr_profile_role" {
  name               = "iam_emr_profile_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "emr_profile" {
  name = "${var.RESOURCE_PREFIX}_emr_profile"
  role = aws_iam_role.iam_emr_profile_role.name
}

resource "aws_iam_role_policy" "iam_emr_profile_policy" {
  name   = "${var.RESOURCE_PREFIX}_iam_emr_profile_policy"
  role   = aws_iam_role.iam_emr_profile_role.id
  policy = data.aws_iam_policy_document.iam_emr_profile_policy.json
}

# autoscaling role
resource "aws_iam_role" "auto_scaling_role" {
  name = "${var.RESOURCE_PREFIX}_EMR-AutoScaling-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        }
      }
    ]
  })
}