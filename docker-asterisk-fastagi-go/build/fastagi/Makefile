DOCKER ?= docker
TARGET ?= cnsoluciones/fastagi

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .

raspberrypi4:

	@echo "Building ${TARGET}"
	$(DOCKER) build --build-arg architectures=arm64v8/ -t $(TARGET) -f Dockerfile .

push:
	$(DOCKER) push $(TARGET)
