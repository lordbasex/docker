DOCKER ?= docker
TARGET ?= cnsoluciones/kamailio

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
	#$(DOCKER) push $(TARGET)
