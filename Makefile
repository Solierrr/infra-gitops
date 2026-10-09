ifeq ($(OS),Windows_NT)
ORG_SCRIPTS_DIR ?= $(USERPROFILE)/.local/share/solierrr-infra-scripts
ORG_SCRIPTS_POWERSHELL ?= powershell
else
ORG_SCRIPTS_DIR ?= $(HOME)/.local/share/solierrr-infra-scripts
ORG_SCRIPTS_POWERSHELL ?= pwsh
endif
ORG_SCRIPTS_REPO ?= https://github.com/Solierrr/infra-scripts.git
EXTRACT_ENV := $(ORG_SCRIPTS_DIR)/scripts/extract-env.ps1
SERVICE ?=
ENV ?=
OUT ?= .env

.DEFAULT_GOAL := help
.PHONY: help tools-check env vault-config vault-auth extract-env
help: ## Show the available commands
	@awk 'BEGIN {FS = ":.*## "; printf "Usage: make <target>\\n\\n"} /^[a-zA-Z_-]+:.*## / {printf "  %-16s %s\\n", $$1, $$2}' $(MAKEFILE_LIST)

vault-config: ## Clone or update the shared infra-scripts toolkit
	$(ORG_SCRIPTS_POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts/make-vault.ps1 -Action config -ScriptsDir "$(ORG_SCRIPTS_DIR)" -Repo "$(ORG_SCRIPTS_REPO)" -ExtractEnvPath "$(EXTRACT_ENV)"

vault-auth: vault-config ## Check that the Infisical CLI is installed and authenticated
	$(ORG_SCRIPTS_POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts/make-vault.ps1 -Action auth

extract-env: vault-auth ## Generate a local environment file; prompts for missing service/environment
	$(ORG_SCRIPTS_POWERSHELL) -NoProfile -ExecutionPolicy Bypass -File scripts/make-vault.ps1 -Action extract-env -ExtractEnvPath "$(EXTRACT_ENV)" -Service "$(SERVICE)" -Environment "$(ENV)" -OutputPath "$(OUT)"

tools-check: vault-config ## Alias for vault-config

env: extract-env ## Alias for extract-env

# Compose after base.mk. Runs a group of services and a local Kubernetes cluster
# with Argo CD. Requires Docker, `infisical login` and (for the cluster) kubectl.
# See helps/TRY-LOCAL.md.
LOCAL_SH ?= $(ORG_SCRIPTS_DIR)/scripts/local.sh
CLUSTER_SH ?= $(ORG_SCRIPTS_DIR)/scripts/cluster.sh
SECRETS_ENV ?= qa
PROFILE ?= core
DB ?= remote
OBS ?= 0
ALL ?= 0
APPS ?=
SERVICES ?=

.PHONY: up-stack down-stack cluster-up cluster-down cluster-status cluster-apps cluster-secrets cluster-password cluster-ui

up-stack: vault-config ## Run a group of services locally (PROFILE=core|rec|ai|all; DB=local, OBS=1)
	@PROFILE=$(PROFILE) ENV=$(SECRETS_ENV) DB=$(DB) OBS=$(OBS) sh $(LOCAL_SH) stack

down-stack: vault-config ## Stop the group of services (ALL=1 also stops databases and Grafana)
	@PROFILE=$(PROFILE) ALL=$(ALL) sh $(LOCAL_SH) unstack

cluster-up: vault-config ## Create the local k3d cluster and install Argo CD
	@sh $(CLUSTER_SH) up

cluster-down: vault-config ## Delete the local cluster
	@sh $(CLUSTER_SH) down

cluster-status: vault-config ## Show the Argo CD applications of the local cluster
	@sh $(CLUSTER_SH) status

cluster-apps: vault-config ## Apply Argo CD applications from infra-gitops (APPS="api-core api-auth" or APPS=root)
	@sh $(CLUSTER_SH) apps $(APPS)

cluster-secrets: vault-config ## Create the <service>-secrets from Infisical in the local cluster (SERVICES="api-core")
	@ENV=$(SECRETS_ENV) sh $(CLUSTER_SH) secrets $(SERVICES)

cluster-password: vault-config ## Print the Argo CD admin password
	@sh $(CLUSTER_SH) password

cluster-ui: vault-config ## Open the Argo CD UI on https://localhost:8085
	@sh $(CLUSTER_SH) ui
