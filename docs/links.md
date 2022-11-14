# Useful links

## AWS

- [Elastic IP addresses](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)
- [Run commands on your Linux instance at launch](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
- [How can I utilize user data to automatically run a script with every restart of my Amazon EC2 Linux instance?](https://aws.amazon.com/de/premiumsupport/knowledge-center/execute-user-data-ec2/)
- [Retrieve instance metadata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html)
- [Filtering AWS CLI output](https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-filter.html)
- [Copy files from EC2 to S3 Bucket in 4 steps](https://www.middlewareinventory.com/blog/ec2-s3-copy/)

## Terraform

- [Resource: aws_eip_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association)
- [AWS IAM EC2 Instance Role using Terraform](https://devopslearning.medium.com/aws-iam-ec2-instance-role-using-terraform-fa2b21488536)

## Other

- [Cloud-init](https://cloudinit.readthedocs.io)
- [Bash programming basics](https://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html)
- [How to Run a Linux Command When a File Set Changes](https://www.howtogeek.com/devops/how-to-run-a-linux-command-when-a-file-set-changes)
- [Watch filesystem changes](https://facebook.github.io/watchman/docs/install.html)

# Commands

## Get a sorted list of filtered AMIs

```bash
aws ec2 describe-images --filters "Name=architecture,Values=arm64" \
    "Name=name,Values=*ubuntu*22.04*minimal*" \
    --query 'sort_by(Images, &Name)[].Name' --owners amazon | jq
```
