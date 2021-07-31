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
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | git::https://github.com/cloudposse/terraform-null-label.git?ref=master |  |

## Resources

| Name | Type |
|------|------|
| [aws_ami.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami) | resource |
| [aws_key_pair.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_spot_instance_request.spot_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/spot_instance_request) | resource |
| [aws_s3_bucket_object.user_data_obj](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object) | data source |
| [template_file.user_data_tpl](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | AMI configuration | <pre>object({<br>    snapshot_id = string<br>  })</pre> | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | Spot instance configuration | <pre>object({<br>    spot_price = string<br>    ami        = string<br>    type       = string<br>    user_data = optional(object({<br>      bucket_name = string<br>      key         = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | Instance profile | `map(string)` | n/a | yes |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | Path to ssh public key at local machine | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of ec2 stacks | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of resources | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | n/a | yes |
| <a name="input_vm_eni"></a> [vm\_eni](#input\_vm\_eni) | VM's elastic network interface id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
