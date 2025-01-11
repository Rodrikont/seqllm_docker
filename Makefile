# Makefile
# fastHTTP server "npulse-watcher"

include .env
export

.DEFAULT_GOAL := help

################## help ##################
help: ## List of commands
	@awk 'BEGIN { \
		FS = ":.*##"; \
		printf "Usage: make <commands> \033[36m\033[0m\n" \
	} /^[$$()% 0-9a-zA-Z_-]+:.*?##/ { \
		printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 \
	} \
	/^##@/ { \
		printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	} ' $(MAKEFILE_LIST)

stack-deploy: ## Развертывание контейнеров
	@docker stack deploy -c docker-compose.yml --detach=true $(STACK_NAME)

stack-rm: ## Удаление контейнеров
	@docker stack rm $(STACK_NAME)

install: stack-deploy ## Развертывание контейнеров

uninstall: stack-rm ## Удаление контейнеров
