#!make

-include .env

TARGET := cnsoluciones/mikrotik:$(ROUTEROS_VERSION)

build:
	docker build -t $(TARGET) -f Dockerfile .

