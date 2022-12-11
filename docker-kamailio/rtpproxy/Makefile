DOCKER ?= docker
TARGET ?= cnsoluciones/rtpproxy

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
	#$(DOCKER) push $(TARGET)
