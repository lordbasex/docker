DOCKER ?= docker
TARGET ?= cnsoluciones/asterisk-iax2

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .

push:
	$(DOCKER) push $(TARGET)
