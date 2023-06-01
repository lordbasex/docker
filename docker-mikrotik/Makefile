#!make

ROUTEROS_VERSION := 7.6
TARGET := cnsoluciones/mikrotik

all: build latest

build:
	docker buildx create --use
	docker buildx build --platform=linux/amd64,linux/arm64 -t $(TARGET):$(ROUTEROS_VERSION) --push .

latest:
	docker buildx create --use
	docker buildx build --platform=linux/amd64,linux/arm64 -t $(TARGET):latest --push .
