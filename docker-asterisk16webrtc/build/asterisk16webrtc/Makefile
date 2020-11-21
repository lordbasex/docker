DOCKER ?= docker
TARGET ?= cnsoluciones/asterisk16webrtc:16.15.0

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
