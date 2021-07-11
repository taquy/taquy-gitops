bash plan.sh
bash apply.sh

openssl genrsa -out /home/qt/.ssh/taquy-vm 2048
openssl rsa -in /home/qt/.ssh/taquy-vm -outform PEM -pubout -out /home/qt/.ssh/taquy-vm.pub

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.27 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 1.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compute"></a> [compute](#module\_compute) | ./modules/compute |  |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network |  |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | ./modules/secrets |  |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compute"></a> [compute](#input\_compute) | compute module parameters | <pre>object({<br>    name      = string<br>    namespace = string<br>    region    = string<br>    key_path  = string<br>    tags      = optional(map(string))<br>    instance = object({<br>      spot_price = string<br>      ami        = string<br>      type       = string<br>      user_data  = optional(string)<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Network module parameters | <pre>object({<br>    namespace      = string<br>    vpc_cidr_block = string<br>    tags           = optional(map(string))<br>  })</pre> | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Secret manager module parameters | <pre>object({<br>    namespace = string<br>    secrets = map(object({<br>      description = optional(string)<br>      data_path   = optional(string)<br>      data_value  = optional(string)<br>      tags        = optional(map(string))<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret"></a> [secret](#output\_secret) | n/a |
| <a name="output_secret_version"></a> [secret\_version](#output\_secret\_version) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
