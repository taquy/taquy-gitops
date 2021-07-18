bash plan.sh
bash apply.sh

ssh-keygen -f /home/qt/.ssh/taquy-vm -N "" -b 2048 -t rsa -q

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.27 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 1.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compute"></a> [compute](#module\_compute) | ./modules/compute |  |
| <a name="module_dns"></a> [dns](#module\_dns) | ./modules/dns |  |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam |  |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network |  |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | ./modules/secrets |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compute"></a> [compute](#input\_compute) | compute module parameters | <pre>object({<br>    name      = string<br>    namespace = string<br>    region    = string<br>    key_path  = string<br>    tags      = optional(map(string))<br>    instance = object({<br>      spot_price = string<br>      ami        = string<br>      type       = string<br>      user_data = optional(object({<br>        bucket_name = string<br>        key         = string<br>      }))<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_dns"></a> [dns](#input\_dns) | dns module parameters | <pre>object({<br>    namespace   = string<br>    domain_name = string<br>    records = object({<br>      apps = list(string)<br>    })<br>    tags = optional(map(string))<br>  })</pre> | n/a | yes |
| <a name="input_iam"></a> [iam](#input\_iam) | iam module parameters | <pre>object({<br>    namespace = string<br>    source_ip = optional(map(string))<br>    tags      = optional(map(string))<br>  })</pre> | n/a | yes |
| <a name="input_my_ip"></a> [my\_ip](#input\_my\_ip) | Current deployer source IP | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Network module parameters | <pre>object({<br>    namespace      = string<br>    vpc_cidr_block = string<br>    tags           = optional(map(string))<br>  })</pre> | n/a | yes |
| <a name="input_pgp_key"></a> [pgp\_key](#input\_pgp\_key) | PGP base64 encoded public key | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secret manager module parameters | <pre>object({<br>    namespace = string<br>    secrets = map(object({<br>      description = optional(string)<br>      data_path   = optional(string)<br>      data_value  = optional(string)<br>      tags        = optional(map(string))<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jenkins_node_user_key"></a> [jenkins\_node\_user\_key](#output\_jenkins\_node\_user\_key) | n/a |
| <a name="output_secret"></a> [secret](#output\_secret) | n/a |
| <a name="output_secret_version"></a> [secret\_version](#output\_secret\_version) | n/a |
| <a name="output_vm_public_ip"></a> [vm\_public\_ip](#output\_vm\_public\_ip) | Elastic public IP of VM |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
