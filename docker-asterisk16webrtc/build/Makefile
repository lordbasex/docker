DOCKER ?= docker
TARGET ?= cnsoluciones/asterisk16webrtc

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
	#$(DOCKER) push $(TARGET)
