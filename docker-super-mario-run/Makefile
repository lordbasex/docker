DOCKER ?= docker
TARGET ?= cnsoluciones/docker-super-mario-run

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
