DOCKER ?= docker
TARGET ?= cnsoluciones/wordpress:7.3

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
