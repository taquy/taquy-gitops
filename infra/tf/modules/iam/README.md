<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.27 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 1.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.27 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | git::https://github.com/cloudposse/terraform-null-label.git?ref=master |  |
| <a name="module_policy"></a> [policy](#module\_policy) | ./policies |  |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.jenkins_node_user_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.jenkins_job_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_user.jenkins_node_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [random_id.sid](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/id) | resource |
| [random_string.name](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of resources | `string` | n/a | yes |
| <a name="input_pgp_key"></a> [pgp\_key](#input\_pgp\_key) | PGP base64 encoded public key | `string` | n/a | yes |
| <a name="input_source_ip"></a> [source\_ip](#input\_source\_ip) | Source IPs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resources tags | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_profile"></a> [instance\_profile](#output\_instance\_profile) | Instance profile |
| <a name="output_instance_role_arn"></a> [instance\_role\_arn](#output\_instance\_role\_arn) | Instance role arn |
| <a name="output_jenkins_job_role_arn"></a> [jenkins\_job\_role\_arn](#output\_jenkins\_job\_role\_arn) | Jenkins job role arn |
| <a name="output_jenkins_node_user_key"></a> [jenkins\_node\_user\_key](#output\_jenkins\_node\_user\_key) | Jenkins node user access key |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
