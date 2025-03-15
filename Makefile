SHELL := /bin/bash
-include .env
export

export HOST_UID:=$(shell id --user)
export HOST_USER:=$(shell id --user --name)
export HOST_GID:=$(shell id --group)
export HOST_GROUP:=$(shell id --group --name)

COLOR_RESET := $(shell tput sgr0)
COLOR_ITEM := $(shell tput setaf 2)
COLOR_VAL := $(shell tput setaf 4)
COLOR_SESSION := $(shell tput setaf 208)
COLOR_DEFAULT_VAL := $(shell tput setaf 130)

CMAKE := $(MAKE) --no-print-directory
SPACE_CHAR=$(subst ,, )

DOCKER_COMPOSE_FILE=docker-compose.yaml

# General targets:
.PHONY: help build rebuild up down run exec bash shell log

help:	
	@echo '${COLOR_SESSION}Getting started to use the application:${COLOR_RESET}'
	@echo '  ${COLOR_ITEM}  Go to:${COLOR_RESET} the main branch'
	@echo '  ${COLOR_ITEM}Execute:${COLOR_RESET} make up'
	@echo ''
	@echo '${COLOR_SESSION}Using the targets:${COLOR_RESET}'
	@echo '  make TARGET [OPTIONS]'
	@echo ''
	@echo '${COLOR_SESSION}General targets:${COLOR_RESET}'
	@echo '  ${COLOR_ITEM}help${COLOR_RESET}                   Display this help message'
	@echo ''
	@echo '  ${COLOR_ITEM}build${COLOR_RESET}                  Build docker image'
	@echo '                           Options:'	
	@echo '                             ${COLOR_ITEM}service=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo '                             ${COLOR_ITEM}options=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo ''
	@echo '  ${COLOR_ITEM}rebuild${COLOR_RESET}                Rebuild docker image without cache'
	@echo '                           Options:'	
	@echo '                             ${COLOR_ITEM}service=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo '                             ${COLOR_ITEM}options=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo ''	
	@echo '  ${COLOR_ITEM}up${COLOR_RESET}                     Start the application'
	@echo ''
	@echo '  ${COLOR_ITEM}down${COLOR_RESET}                   Stop the application'
	@echo ''	
	@echo '  ${COLOR_ITEM}run${COLOR_RESET}                    Execute the command in a new service container'
	@echo '                           Options:'	
	@echo '                             ${COLOR_ITEM}service=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo '                             ${COLOR_ITEM}cmd=${COLOR_VAL}VAL${COLOR_RESET}     (mandatory)'
	@echo ''	
	@echo '  ${COLOR_ITEM}exec${COLOR_RESET}                   Execute the command in the current service container'
	@echo '                           Options:'	
	@echo '                             ${COLOR_ITEM}service=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo '                             ${COLOR_ITEM}cmd=${COLOR_VAL}VAL${COLOR_RESET}     (mandatory)'
	@echo ''		
	@echo '  ${COLOR_ITEM}bash${COLOR_RESET}                   Execute the command in a new service container using bash as command-line'
	@echo '                           Options:'	
	@echo '                             ${COLOR_ITEM}service=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo '                             ${COLOR_ITEM}cmd=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo ''		
	@echo '  ${COLOR_ITEM}shell${COLOR_RESET}                  Execute the command in a new service container using shell as command-line'
	@echo '                           Options:'	
	@echo '                             ${COLOR_ITEM}service=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo '                             ${COLOR_ITEM}cmd=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo ''	
	@echo "  ${COLOR_ITEM}log${COLOR_RESET}                    Display the service's logs"
	@echo '                           Options:'	
	@echo '                             ${COLOR_ITEM}service=${COLOR_VAL}VAL${COLOR_RESET} (optional)'
	@echo ''
	@echo '${COLOR_SESSION}Docker targets:${COLOR_RESET}'
	@echo '  ${COLOR_ITEM}prune${COLOR_RESET}                  Remove unused objects'
	@echo ''
	@echo '  ${COLOR_ITEM}prune-container${COLOR_RESET}        Remove unused containers'
	@echo ''
	@echo '  ${COLOR_ITEM}prune-dangling-image${COLOR_RESET}   Remove dangling images'
	@echo ''	
	@echo '  ${COLOR_ITEM}prune-image${COLOR_RESET}            Remove unused images'
	@echo ''
	@echo '  ${COLOR_ITEM}prune-network${COLOR_RESET}          Remove unused networks'
	@echo ''
	@echo '  ${COLOR_ITEM}prune-volume${COLOR_RESET}           Remove unused volumes'
	@echo ''
	@echo '${COLOR_SESSION}Variables:${COLOR_RESET}'
	@echo '  ${COLOR_ITEM}environment${COLOR_RESET}            $(ENVIRONMENT)'
	@echo '  ${COLOR_ITEM}user${COLOR_RESET}                   $(HOST_USER)(uid=$(HOST_UID))'
	@echo '  ${COLOR_ITEM}group${COLOR_RESET}                  $(HOST_GROUP)(gid=$(HOST_GID))'

build:
	DOCKER_BUILDKIT=1 docker compose --file $(DOCKER_COMPOSE_FILE) build $(options) $(service)

rebuild:
	$(CMAKE) build options="--no-cache $(options)"

prepare:
	envsubst < ./resources/alertmanager/templates/alertmanager.yaml.template > ./resources/alertmanager/alertmanager.yaml

deploy:
	$(CMAKE) prepare
	$(CMAKE) up

up:
	docker compose --file $(DOCKER_COMPOSE_FILE) up --detach

down:
	docker compose --file $(DOCKER_COMPOSE_FILE) down

run:
	docker compose --file $(DOCKER_COMPOSE_FILE) run --rm $(cmd)

exec:
	docker compose --file $(DOCKER_COMPOSE_FILE) exec $(cmd)

attach:
	docker compose --file $(DOCKER_COMPOSE_FILE) exec bash

bash:
	$(CMAKE) run cmd="/bin/bash $(cmd)"

shell:
	$(CMAKE) run cmd="/bin/sh $(cmd)"

log:
	docker compose --file $(DOCKER_COMPOSE_FILE) logs $(service)

# Docker targets:
.PHONY: prune prune-image prune-dangling-image

prune:
	docker system prune --all --force

prune-container:
	docker container prune

prune-dangling-image:
	docker image prune

prune-image:
	docker image prune --all

prune-network:
	docker network prune

prune-volume:
	docker volume prune	
