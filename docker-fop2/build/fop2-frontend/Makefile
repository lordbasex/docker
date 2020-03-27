DOCKER ?= docker
TARGET ?= cnsoluciones/fop2frontend:2.31.27

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
