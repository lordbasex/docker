DOCKER ?= docker
TARGET ?= cnsoluciones/fop2_server:2.31.30

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
