# Makefile
# fastHTTP server "npulse-watcher"

include .env
export

VERSION_APP_FILE := "VERSION"

VERSION_APP_START := "0.1.0"

VERSION_APP := $(shell cat $(VERSION_APP_FILE))
VERSION_APP_NEW := $(shell echo $(VERSION_APP) | awk -F. '{print $$1"."$$2"."$$3+1}')

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

git-push-tag-version: ## Создание тега в git для актуальной версии
	-git tag v$(VERSION_APP)
	git push --tags

version-app-create: ## Создание файла с номер версии программы
	echo -n $(VERSION_APP_START) > $(VERSION_APP_FILE)

version-app-inc: ## Увеличение номера версии программы и сохранение в файл
	echo -n $(VERSION_APP_NEW) > $(VERSION_APP_FILE)

secrets-create: ## Создание secrets
	docker secret create seqllm_telegram_token ./secrets/seqllm_telegram_token
	docker secret create seqllm_wolfram_appid ./secrets/seqllm_wolfram_appid

secrets-rm: ## Удаление secrets
	docker secret rm seqllm_telegram_token
	docker secret rm seqllm_wolfram_appid

stack-deploy: ## Развертывание контейнеров
	@docker stack deploy -c docker-compose.yml --detach=true $(STACK_NAME)

stack-rm: ## Удаление контейнеров
	@docker stack rm $(STACK_NAME)

install: stack-deploy ## Развертывание контейнеров

uninstall: stack-rm ## Удаление контейнеров
