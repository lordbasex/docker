DOCKER ?= docker
TARGET ?= cnsoluciones/winbox64:3.41 

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
