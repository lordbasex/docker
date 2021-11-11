DOCKER ?= docker
TARGET ?= cnsoluciones/x11vnc-desktop
VERSION ?= 20.04

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET):$(VERSION) -f Dockerfile .
push:
	$(DOCKER) push $(TARGET):$(VERSION)
