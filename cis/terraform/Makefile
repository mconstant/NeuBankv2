.POSIX:
.PHONY: *
export ARM_SUBSCRIPTION_ID RESOURCE_GROUP STORAGE_ACCOUNT CONTAINER_NAME PAT_TOKEN_VALUE
export SUBSCRIPTION_NAME="Azure subscription 1"

define terraform_cmd
 terraform -chdir=$(1) $(2)
endef

TERRAFORM_ROOT_DIR := ./
CI_BOOTSTRAP_ROOT_DIR := ./bootstrap

BACKEND_CONFIG := -backend-config="storage_account_name=$(STORAGE_ACCOUNT)" -backend-config="container_name=$(CONTAINER_NAME)" -backend-config="resource_group_name=$(RESOURCE_GROUP)"
TERRAFORM_CMD := $(call terraform_cmd,$(TERRAFORM_ROOT_DIR))

bootstrap:
	touch .envrc
	az login
	$(call terraform_cmd,$(CI_BOOTSTRAP_ROOT_DIR),init $(BACKEND_CONFIG))

bootstrap_backout:
	$(call terraform_cmd,$(CI_BOOTSTRAP_ROOT_DIR),destroy -auto-approve) 

terraform:
	$(TERRAFORM_CMD) $(filter-out $@,$(MAKECMDGOALS))

terraform_init:
	$(TERRAFORM_CMD) init $(BACKEND_CONFIG)

terraform_init_reconfigure:
	$(TERRAFORM_CMD) init -reconfigure $(BACKEND_CONFIG)

terraform_init_migrate_state:
	$(TERRAFORM_CMD) init -migrate-state $(BACKEND_CONFIG)

terraform_destroy:
	$(TERRAFORM_CMD) destroy -auto-approve 

terraform_apply:
	$(TERRAFORM_CMD) apply -auto-approve

tools:
	nix --experimental-features 'nix-command flakes' develop
