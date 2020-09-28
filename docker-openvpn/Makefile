DOCKER ?= docker
TARGET ?= cnsoluciones/openvpn-alpine

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
