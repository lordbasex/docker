DOCKER ?= docker
TARGET ?= cnsoluciones/easy-rsa:3.0.6-r0

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .

