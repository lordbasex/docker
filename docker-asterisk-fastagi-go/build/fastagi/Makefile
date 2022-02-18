DOCKER ?= docker
TARGET ?= cnsoluciones/fastagi

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
dev:	
	@echo "Building deb ${TARGET}"
	$(DOCKER) build -t $(TARGET)-dev -f Dockerfile-dev .

push:
	$(DOCKER) push $(TARGET)
