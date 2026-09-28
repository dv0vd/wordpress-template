include .env

.DEFAULT_GOAL := help
.ONESHELL:
MAKEFLAGS += --no-print-directory

include ./make/certbot.mk
include ./make/help.mk
include ./make/logs.mk
include ./make/restart.mk
include ./make/start.mk
include ./make/stop.mk
include ./make/enter.mk
include ./make/fail2ban.mk
include ./make/podman.mk
include ./make/hooks.mk
include ./make/common.mk
include ./make/iptables.mk
include ./make/easyappointments.mk
