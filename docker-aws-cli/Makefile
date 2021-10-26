DOCKER ?= docker
TARGET ?= cnsoluciones/aws-cli

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .

