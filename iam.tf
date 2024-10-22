resource "aws_iam_user" "this" {
  count = var.create_iam_resources == true ? 1 : 0
  name = var.name
}

resource "aws_iam_access_key" "this" {
  count = var.create_iam_resources == true ? 1 : 0
  user    = aws_iam_user.this[0].name
  pgp_key = file("${path.module}/tech-pgpkey-public.pem")
}

resource "aws_iam_user_policy" "this" {
  count = var.create_iam_resources == true ? 1 : 0
  name   = "s3@${var.name}"
  user   = aws_iam_user.this[0].name
  policy = data.aws_iam_policy_document.s3-rw.json
}

data "aws_iam_policy_document" "s3-rw" {
  statement {
    sid    = "S3ObjectRW"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListObject",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::${local.hostname}/*"
    ]
  }

  statement {
    sid    = "S3BucketList"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${local.hostname}"
    ]
  }
}

resource "aws_iam_user_policy_attachment" "additional" {
  count      = length(var.additional_policies)
  user       = aws_iam_user.this[0].name
  policy_arn = element(var.additional_policies, count.index)
}
