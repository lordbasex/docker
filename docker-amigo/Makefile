DOCKER ?= docker
TARGET ?= cnsoluciones/amigo
VERSION ?= latest

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET):$(VERSION) -f Dockerfile .
push:
	$(DOCKER) push $(TARGET):$(VERSION)
