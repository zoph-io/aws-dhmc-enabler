# :computer: Default Host Management Configuration (DHMC) Enabler

## 🧠 Rationale

The [Default Host Management Configuration](https://docs.aws.amazon.com/systems-manager/latest/userguide/managed-instances-default-host-management.html) (DHMC) is an AWS configuration at regional level and a best practices for managing Amazon EC2 instances using AWS Systems Manager. It helps you streamline the management of your EC2 instances and maintain security compliance across your AWS resources.

DHMC provides a standard configuration for AWS Account, making it easier to implement and maintain systems management tasks, such as patching, software installation, sessions management, and configuration management.

This project aims to simplify the implementation of DHMC, ensuring efficient and secure management by setting the default IAM Role needed by SSM to work properly.

## :hammer_and_wrench: How-to

To implement Default Host Management Configuration on your AWS Account, follow these steps:

Clone this repository to your local environment:

    $ git clone <repository_url>

Modify the configuration files as needed to align with your organization's requirements. (`Makefile`)

Execute the provided command to apply DHMC settings to all available AWS Regions:

    $ make enable

Monitor the progress and verify that DHMC has been successfully applied to all AWS Regions.

    $ make status

## 🖐️ Cleanup (rollback)

    $ make desactivate
    $ make delete-role

## :information_source: More Info

For more information about Default Host Management Configuration and how to enable it for your AWS Account, refer to the official AWS [blog post](https://aws.amazon.com/blogs/mt/enable-management-of-your-amazon-ec2-instances-in-aws-systems-manager-using-default-host-management-configuration/)

If you need more default security settings and alerting on your AWS Account, you can check my other initiative at: [AWS Security Survival Kit](https://github.com/zoph-io/aws-security-survival-kit)

## :man_technologist: Credits

- :pirate_flag: AWS Security Boutique: [zoph.io](https://zoph.io?utm_source=dhmc)
- 💌 [AWS Security Digest Newsletter](https://awssecuritydigest.com?utm_source=dhmc)
- :bird: X/Twitter: [zoph](https://twitter.com/zoph)
