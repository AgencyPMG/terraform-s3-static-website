resource "aws_iam_user" "this" {
  name = var.name
}

resource "aws_iam_access_key" "this" {
  user    = aws_iam_user.this.name
  pgp_key = file("${path.module}/tech-pgpkey-public.pem")
}

resource "aws_iam_user_policy" "this" {
  name   = "s3@${var.name}"
  user   = aws_iam_user.this.name
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

  statement {
    sid    = "dwhS3ObjectRW"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListObject",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::dynamicbannercodes/*"
    ]
  }

  statement {
    sid    = "dwhS3BucketList"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::dynamicbannercodes"
    ]
  }
}
