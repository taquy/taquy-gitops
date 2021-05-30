resource "aws_secretsmanager_secret" "secret" {
  name = "example"
  descriptions = ""
  tags = {
    project = "taquy"
  }
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = "example-string-to-protect"
}

resource "aws_secretsmanager_secret_policy" "secret_policy" {
  secret_arn = aws_secretsmanager_secret.secret.arn
  policy = <<POLICY
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": [
              "arn:aws:iam::397818416365:role/taquy-jenkins",
              "arn:aws:iam::397818416365:user/admin"
            ]
          },
          "Action": "secretsmanager:GetSecretValue",
          "Resource": "*",
           "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                      "113.161.105.75",
                      "118.71.244.146"
                    ]
                }
            }
        }
      ]
    }
  POLICY
}
