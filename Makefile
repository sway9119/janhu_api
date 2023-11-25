.DEFAULT_GOAL := help

help: ## ヘルプを表示します
  @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[33m%-10s\033[0m %s\n", $$1, $$2}'

up: ## コンテナを起動します
	@docker-compose up -d

stop: ## 起動中のコンテナを停止します
	@docker-compose stop

down: ## コンテナを修了します
	@docker-compose down

ps: ## コンテナを修了します
	@docker-compose ps

runner: ## コンテナを修了します
	@docker-compose exec web bash
