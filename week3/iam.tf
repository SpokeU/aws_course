data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_policy" "s3policy" {
  name        = "s3FullAccess"
  description = "s3FullAccess policy"
  policy      = "${file("files/policies.json")}"
}

resource "aws_iam_policy_attachment" "s3PolicyAttach" {
  name       = "s3-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.s3policy.arn}"
}

resource "aws_iam_instance_profile" "s3_profile" {
  name  = "s3_profile"
  role = "${aws_iam_role.ec2_s3_access_role.name}"
}