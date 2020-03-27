DOCKER ?= docker
TARGET ?= cnsoluciones/winbox64:3.22 

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
