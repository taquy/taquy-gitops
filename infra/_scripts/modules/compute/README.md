<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.27 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 1.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.27 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | git::https://github.com/cloudposse/terraform-null-label.git?ref=master |  |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_spot_instance_request.spot_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance"></a> [instance](#input\_instance) | Spot instance configuration | <pre>object({<br>    spot_price = string<br>    ami        = string<br>    type       = string<br>    user_data  = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | Path to ssh public key at local machine | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of ec2 stacks | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of resources | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | n/a | yes |
| <a name="input_vm_profile_arn"></a> [vm\_profile\_arn](#input\_vm\_profile\_arn) | Instance profile role arn | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
