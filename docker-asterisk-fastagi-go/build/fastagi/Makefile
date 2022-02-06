DOCKER ?= docker
TARGET ?= cnsoluciones/fastagi

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .

push:
	$(DOCKER) push $(TARGET)
