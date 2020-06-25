DOCKER ?= docker
TARGET ?= cnsoluciones/wordpress:5.4.2

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
