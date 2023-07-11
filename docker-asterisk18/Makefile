#!make

TARGET := cnsoluciones/asterisk18

all: build

build:
	docker buildx create --use
	docker buildx build --platform=linux/amd64,linux/arm64 -t $(TARGET):latest --push .
