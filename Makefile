# The NFT Story - Foundry Backend Makefile
# =====================================

# Project configuration
PROJECT_NAME := the-nft-story
DOCKER_USER ?=
DOCKER_COMPOSE := docker compose -f compose.yaml -p $(PROJECT_NAME)
DOCKER := docker

# Docker user configuration for CI/CD
ifdef DOCKER_USER
    DOCKER_USER_FLAG := --user $(DOCKER_USER)
else
    DOCKER_USER_FLAG :=
endif

# Default target
.DEFAULT_GOAL := help

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

##@ Help
help: ## Display this help message
	@echo "$(BLUE)Help $(NC)"
	@echo "================================"
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Environment Setup
setup: ## Initialize the foundry project and install dependencies
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge install"

install: setup ## Alias for setup

deps: ## Install/update foundry dependencies
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge install"
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge update"

clean: ## Clean build artifacts
	@echo "$(YELLOW)Cleaning dev environment...$(NC)"
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge clean"
	$(DOCKER_COMPOSE) down --volumes --remove-orphans
	$(DOCKER_COMPOSE) down --rmi all
	$(DOCKER) system prune -f
	@echo "$(GREEN)Clean complete!$(NC)"

##@ Development Environment
shell: ## Open development shell
	$(DOCKER_COMPOSE) up -d dev
	$(DOCKER_COMPOSE) exec dev /bin/bash

dev: shell ## Alias for shell

logs: ## Show container logs
	$(DOCKER_COMPOSE) logs

##@ Building & Compilation
build: ## Compile smart contracts
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge build"

watch: ## Watch for changes and rebuild/test
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge test --watch"

##@ Testing
test: build ## Run all tests
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge test"

gas-report: build ## Run tests with gas reporting
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge test --gas-report > gas-report.txt"

test-coverage: build ## Run tests with coverage
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge coverage"

test-cov: test-coverage ## Alias for test-coverage

##@ Static Analysis & Security
lint: ## Run solhint linter
	$(DOCKER_COMPOSE) --profile tools run --rm solhint

format: ## Format Solidity code
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge fmt"

fmt: format ## Alias for format

format-check: ## Check code formatting
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge fmt --check"

fmt-check: format-check ## Alias for format-check

slither: ## Run Slither security analysis (full output)
	@echo "$(YELLOW)Running Slither security analysis...$(NC)"
	$(DOCKER_COMPOSE) run --rm dev /bin/bash -c "slither . --json - | jq '.' > slither.json"
	@echo "$(GREEN)Report generated at slither.json$(NC)"

security: slither lint ## Run all security analysis tools

##@ Documentation & Inspection
docs: ## Generate contract documentation
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge doc --build"
	@echo "$(GREEN)Docs built at ./contracts/docs/book/index.html $(NC)"

inspect: ## Inspect contract (usage: make inspect CONTRACT=ContractName)
ifndef CONTRACT
	@echo "$(RED)Error: CONTRACT parameter required. Usage: make inspect CONTRACT=ContractName$(NC)"
	@exit 1
endif
	@echo "$(CONTRACT)" | grep -E '^[a-zA-Z][a-zA-Z0-9_]*$$' > /dev/null || { echo "$(RED)Error: CONTRACT must be a valid contract name (alphanumeric + underscore, starting with letter)$(NC)"; exit 1; }
	@echo "$(YELLOW)::: Inspecting contract: $(CONTRACT) ABI...$(NC)"
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge inspect $(CONTRACT) abi"
	@echo "$(YELLOW)::: Inspecting contract: $(CONTRACT) Bytecode...$(NC)"
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge inspect $(CONTRACT) bytecode"
	@echo "$(YELLOW)::: Inspecting contract: $(CONTRACT) Gas Estimate...$(NC)"
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge inspect $(CONTRACT) gasEstimates"
	@echo "$(YELLOW)::: Inspecting contract: $(CONTRACT) Storage Layout...$(NC)"
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge inspect $(CONTRACT) storage-layout"

##@ Debugging
trace: ## Trace a specific transaction (usage: make trace TX=0x...)
ifndef TX
	@echo "$(RED)Error: TX parameter required. Usage: make trace TX=0x...$(NC)"
	@exit 1
endif
	@echo "$(YELLOW)Tracing transaction: $(TX)...$(NC)"
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "cast run $(TX) --rpc-url http://localhost:8545"

##@ Utilities
status: ## Show development environment status
	@echo "==============================="
	@$(DOCKER_COMPOSE) ps
	@echo ""

version: ## Show tool versions
	@echo "$(BLUE)Version Info$(NC)"
	@echo "============="
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "forge --version"
	@echo ""
	$(DOCKER_COMPOSE) run --rm $(DOCKER_USER_FLAG) foundry "cast --version"

.PHONY: help setup install deps clean shell dev logs build watch test test-gas test-coverage test-cov lint format fmt format-check fmt-check slither security docs inspect trace status version