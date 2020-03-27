DOCKER ?= docker
TARGET ?= cnsoluciones/screenshare

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .

