DOCKER ?= docker
TARGET ?= cnsoluciones/aws-cli
VERSION ?= 1.18.36

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build --build-arg VERSION=$(VERSION) -t $(TARGET):$(VERSION) -f Dockerfile .

