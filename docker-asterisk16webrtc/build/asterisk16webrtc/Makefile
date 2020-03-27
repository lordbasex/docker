DOCKER ?= docker
TARGET ?= cnsoluciones/asterisk16webrtc:16.6.0-rc2

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
