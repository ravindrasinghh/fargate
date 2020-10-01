resource "aws_iam_role" "role" {
  name = "${var.env}-taskexecutionrole"

  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
}
EOF
}

resource "aws_iam_role" "task_role" {
  name = "${var.env}-taskrole"

  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
}
EOF
}


resource "aws_iam_policy" "policy" {
  name        = "${var.env}-task-policy"
  description = "A task execution policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


# resource "aws_iam_policy" "task_policy" {
#   name        = "${var.env}-task-role-policy"
#   description = "A task role policy"

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#             "ssm:GetParameters",
#             "ssm:GetParameter"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# EOF
# }

resource "aws_iam_role_policy_attachment" "role-atachment" {
  role       = "${aws_iam_role.role.id}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

# resource "aws_iam_role_policy_attachment" "task-role-atachment" {
#   role       = "${aws_iam_role.task_role.id}"
#   policy_arn = "${aws_iam_policy.task_policy.arn}"
# }