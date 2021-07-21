terraform destroy  \
  -target 'module.compute.aws_spot_instance_request.spot_instance' \
  -target 'module.iam.aws_iam_access_key.jenkins_node_user_key'
