SHELL := /bin/bash

ifndef BLOWFISH_SECRET
$(warning "Blowfish secret required.")
$(warning "See: https://www.question-defense.com/tools/phpmyadmin-blowfish-secret-generator")
BLOWFISH_SECRET ?= $(shell bash -c 'read -s -p "Enter blowfish secret string: " secret; echo $$secret')
$(warning "")
endif
export BLOWFISH_SECRET

DEV_INSTANCE ?= p4-develop-k8s
DEV_ZONE := us-central1
DEV_PROJECT := planet-4-151612

PROD_INSTANCE ?= planet4-prod
PROD_ZONE := us-central1
PROD_PROJECT := planet4-production

SUBST := '$${BLOWFISH_SECRET} $${CONNECTION_STRING}'

.PHONY: dev prod

dev:
	CONNECTION_STRING=$(DEV_PROJECT):$(DEV_ZONE):$(DEV_INSTANCE) \
	envsubst $(SUBST) < config.inc.php.in > $@/config.inc.php
	gcloud app deploy $@ --project=$(DEV_PROJECT)

prod:
	CONNECTION_STRING=$(PROD_PROJECT):$(PROD_ZONE):$(PROD_INSTANCE) \
	envsubst $(SUBST) < config.inc.php.in > $@/config.inc.php
	gcloud app deploy $@ --project=$(PROD_PROJECT)
