DOCKER ?= docker
TARGET ?= cnsoluciones/fop2:2.31.29

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
