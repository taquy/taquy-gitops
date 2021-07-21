echo "Finding your IP to be whitelisted in IAM..."
MY_IP=$(curl checkip.amazonaws.com)
echo "Your current IP is $MY_IP"

export MAINTAINER_EMAIL='taquy.pb@gmail.com'
PGP_PUBLIC_KEY=$(gpg --export $MAINTAINER_EMAIL | base64)

echo "Start destroying resources..."
terraform destroy -auto-approve \
  -var-file=taquy.tfvars \
  -var "my_ip=$MY_IP" \
  -var "pgp_key=$PGP_PUBLIC_KEY" \
  -target 'module.compute.aws_spot_instance_request.spot_instance' \
  -target 'module.iam.aws_iam_access_key.jenkins_node_user_key' \
  -target 'module.network.module.eni.aws_eip.vm_eip'
