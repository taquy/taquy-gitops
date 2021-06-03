tfenv use min-required &&
	terraform init --backend-config=taquy.backend &&
	terraform workspace select taquy &&
	terraform plan --out tf.plan --var-file=taquy.tfvars