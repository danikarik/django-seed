PACKAGE = api-togle

V = 0
Q = $(if $(filter 1,$V),,@)
M = $(shell printf "\033[34;1m▶\033[0m")

all: install migrate new-super-user done

done:
	$(info $(M) done.)

.PHONY: install
install: ## Install dependicies
	$(info $(M) installing dependencies...)
	$Q pip install -r web/requirements.txt

.PHONY: new-migration
verify: ## Create migrations
	$(info $(M) creating migrations...)
	$Q python web/manage.py makemigrations

.PHONY: flush
flush: ## Flush database
	$(info $(M) flushing database...)
	$Q python web/manage.py flush

.PHONY: migrate
migrate: ## Run migrations
	$(info $(M) running migrations...)
	$Q python web/manage.py migrate

.PHONY: run
run: ## Run in debug mode
	$(info $(M) running server...)
	$Q python web/manage.py runserver 127.0.0.1:8088

.PHONY: test
test: ## Run test
	$(info $(M) running test...)
	$Q python web/manage.py test

.PHONY: static
static: ## Collect static
	$(info $(M) collecting static...)
	$Q python web/manage.py collectstatic --noinput

.PHONY: new-super-user
new-super-user: ## Create admin user
	$(info $(M) adding super user...)
	$Q python web/manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'adminpass')"

.PHONY: docker-build
docker-build: ## Build docker image
	$(info $(M) building docker image...)
	docker-compose build

.PHONY: docker-up
docker-up: ## Run docker container
	$(info $(M) running docker container...)
	docker-compose up -d

.PHONY: docker-start
docker-start: ## Start docker container
	$(info $(M) starting docker container...)
	docker-compose start

.PHONY: docker-stop
docker-stop: ## Stop docker container
	$(info $(M) stopping docker container...)
	docker-compose stop

.PHONY: docker-down
docker-down: ## Remove docker container
	$(info $(M) removing docker image...)
	docker-compose down --rmi all

.PHONY: help
help: ## Show usage
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
