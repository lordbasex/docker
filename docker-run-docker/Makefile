DOCKER ?= docker
TARGET ?= cnsoluciones/docker-run-docker
VERSION ?= latest

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build --build-arg VERSION=$(VERSION) -t $(TARGET):$(VERSION) -f Dockerfile .

