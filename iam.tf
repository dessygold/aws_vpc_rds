# Creating the IAM role for the ec2 to have access to s3 bucket
# The assume role policy will grant an entity permission to assume the role
resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = file("assumerolepolicy.json")
}

# Creating EC2 instance Profile, this will link the role to the AWS instance. but no permissions yet
# when creating an EC2, to assign the role, it expects (aws_iam_instance_profile) as a parameter
resource "aws_iam_instance_profile" "test_profile" {
  name  = "test_profile"
  role = aws_iam_role.ec2_s3_access_role.name
}

# Next step is to add IAM Policies which will allow EC2 Instance to execute specific commands , e.g access to s3 bucket
# Adding the policy that will allow full access to s3( policys3bucket.json). Then after attach the role to EC2 Instance
resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = file("policys3bucket.json")
}

# Here, attaching the policy to the role
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = aws_iam_policy.policy.arn
}

