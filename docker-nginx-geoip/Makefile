DOCKER ?= docker
TARGET ?= cnsoluciones/nginx-geoip

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .
