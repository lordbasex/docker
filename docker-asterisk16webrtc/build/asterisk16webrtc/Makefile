DOCKER ?= docker
TARGET ?= cnsoluciones/asterisk16webrtc:16.16.1

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
	$(DOCKER) push $(TARGET)
