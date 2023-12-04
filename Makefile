.DEFAULT_GOAL ?= help
.PHONY: help

# Project variables
PROJECT_NAME := "DHMC"
AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text)
AWS_REGION := "eu-west-1"
AWS_REGIONS := $(shell aws ec2 describe-regions --query "Regions[].RegionName" --output text)

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  deploy-role       to deploy the SSM role"
	@echo "  enable            to enable SSM on the account"
	@echo "  status            to check the status of SSM on the account"
	@echo "  desactivate       to desactivate SSM on the account"
	@echo "  delete-role       to delete the SSM role"

deploy-role:
	@aws cloudformation deploy \
		--template-file template.yml \
		--region ${AWS_REGION} \
		--stack-name "${PROJECT_NAME}-SSM" \
		--capabilities CAPABILITY_NAMED_IAM \
		--no-fail-on-empty-changeset

enable:
	@for region in $(AWS_REGIONS); do \
		echo "Enabling in region $$region"; \
		if aws ssm update-service-setting \
			--region $$region \
			--setting-id "arn:aws:ssm:$$region:${AWS_ACCOUNT_ID}:servicesetting/ssm/managed-instance/default-ec2-instance-management-role" \
			--setting-value "AWSSystemsManagerDefaultEC2InstanceManagementRole"; \
		then \
			echo "✅ Success in region $$region"; \
		else \
			echo "❌ Error in region $$region"; \
		fi; \
	done

status:
	@for region in $(AWS_REGIONS); do \
	echo "Checking status in region $$region"; \
	setting_status=$$(aws ssm get-service-setting \
		--region $$region \
		--setting-id "arn:aws:ssm:$$region:${AWS_ACCOUNT_ID}:servicesetting/ssm/managed-instance/default-ec2-instance-management-role" \
		--query "ServiceSetting.Status" \
		--output text); \
	echo "Status: $$setting_status"; \
	if [ "$$setting_status" = "Default" ]; then \
		echo "❌ Failure in region $$region"; \
	else \
		echo "✅ Success in region $$region"; \
	fi; \
	done


desactivate:
	@for region in $(AWS_REGIONS); do \
		echo "Desactivating in region $$region"; \
		if aws ssm reset-service-setting \
			--region $$region \
			--setting-id "arn:aws:ssm:$$region:${AWS_ACCOUNT_ID}:servicesetting/ssm/managed-instance/default-ec2-instance-management-role"; \
		then \
			echo "✅ Success in region $$region"; \
		else \
			echo "❌ Error in region $$region"; \
		fi; \
	done

delete-role:
	@read -p "Are you sure that you want to destroy stack '${PROJECT_NAME}-SSM'? [y/N]: " sure && [ $${sure:-N} = 'y' ]
	aws cloudformation delete-stack --stack-name "${PROJECT_NAME}-SSM"
