# Useful links

## AWS

- [Elastic IP addresses](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)
- [Run commands on your Linux instance at launch](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
- [How can I utilize user data to automatically run a script with every restart of my Amazon EC2 Linux instance?](https://aws.amazon.com/de/premiumsupport/knowledge-center/execute-user-data-ec2/)
- [Retrieve instance metadata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html)
- [Filtering AWS CLI output](https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-filter.html)

## Terraform

- [Resource: aws_eip_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association)

## Other

- [Cloud-init](https://cloudinit.readthedocs.io)
- [Bash programming basics](https://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html)

# Commands

## Get sorted list of filtered AMIs

```bash
aws ec2 describe-images --filters "Name=architecture,Values=arm64" "Name=name,Values=*ubuntu*22.04*minimal*" --query 'sort_by(Images, &Name)[].Name' --owners amazon | jq
```
