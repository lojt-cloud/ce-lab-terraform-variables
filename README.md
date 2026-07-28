# Lab M4.02 - Variables & Parameterization

Terraform configuration made reusable across environments (`dev`, `staging`, `prod`) using input variables, validation rules, and `.tfvars` files.

## What this deploys (AWS)

- An **S3 bucket** (`aws_s3_bucket`) with optional versioning and server-side encryption

- A **security group** allowing SSH/HTTP from configurable CIDR ranges

- One or more **EC2 instances** (count controlled by a variable), running the latest Amazon Linux 2023 AMI

Everything that differs between environments, instance size, instance count, encryption, versioning, allowed CIDRs, tags. It is driven by variables rather than hardcoded.

## File structure

| File           |                       Purpose                                         |

| `main.tf`      | Provider config + resources, all parameterized via `var.*`            |
| `variables.tf` | Input variable declarations, types, defaults, and validation rules    |
| `outputs.tf`   | Values exported after apply (bucket name/ARN, instance IDs/IPs, etc.) |
| `dev.tfvars`   | Small, cheap, open footprint for development                          |
| `prod.tfvars`  | Larger, locked-down, durable footprint for production                 |

## Variables

|        Name           |     Type     |      Default    |              Validation                                        |

| `aws_region`          | string       | `us-east-1`     | must match AWS region pattern (e.g. `us-east-1`)               |
| `environment`         | string       | *(required)*    | must be one of `dev`, `staging`, `prod`                        |
| `project_name`        | string       | `ce-lab`        | 3-21 chars, lowercase/numbers/hyphens, starts with a letter    |
| `instance_type`       | string       | `t3.micro`      | must be one of `t3.micro`, `t3.small`, `t3.medium`, `t3.large` |
| `instance_count`      | number       | `1`             | must be between 1 and 5                                        |
| `enable_versioning`   | bool         | `false`         |                        —                                       |
| `enable_encryption`   | bool         | `true`          |                        —                                       |
| `allowed_cidr_blocks` | list(string) | `["0.0.0.0/0"]` | must contain at least one entry                                |
| `tags`                | map(string)  | `{}`            |                        —                                       |

Validation rules are enforced by Terraform at plan/apply time. Passing an invalid value (e.g. `instance_count = 10` or `environment = "test"`) fails immediately with a readable error instead of misconfiguring infrastructure.

## Outputs

- `environment` — which environment was deployed
- `s3_bucket_name`, `s3_bucket_arn`
- `security_group_id`
- `instance_ids`, `instance_public_ips`
- `instance_type_used`, `instance_count`

## Usage

Initialize once:

```bash
terraform init
```

### Deploy to dev

```bash
terraform plan  -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

### Deploy to prod

```bash
terraform plan  -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

> Because `dev` and `prod` share the same state file by default in this simple lab setup, prefer running them in **separate workspaces** or **separate state backends** in real usage:
>
> ```bash
> terraform workspace new dev
> terraform workspace new prod
>
> terraform workspace select dev
> terraform apply -var-file="dev.tfvars"
>
> terraform workspace select prod
> terraform apply -var-file="prod.tfvars"
> ```

### Tear down

```bash
terraform destroy -var-file="dev.tfvars"
# or
terraform destroy -var-file="prod.tfvars"
```

## Notes / design decisions

- `environment` has no default on purpose. It must be explicitly supplied via `-var-file` or `-var` so you can never accidentally apply without knowing which environment you're targeting.
- `dev.tfvars` uses a wide-open CIDR (`0.0.0.0/0`) for convenience; `prod.tfvars` restricts access to a private range. This is intentional to demonstrate environment-specific security posture, not a recommendation to leave prod open.
- Resource names are derived from `local.name_prefix = "${var.project_name}-${var.environment}"` so dev and prod resources never collide by name.
- The S3 bucket name also appends the AWS account ID (`data.aws_caller_identity.current.account_id`) to guarantee global uniqueness.

## Screenshots

See `screenshots/` for evidence of `terraform plan`/`apply` output for both `dev` and `prod` environments.