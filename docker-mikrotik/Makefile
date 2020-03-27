  
DOCKER ?= docker
TARGET ?= cnsoluciones/mikrotik
IMAGE ?= `ls *.vdi`
VERSON ?= $(shell echo $(IMAGE) | sed -n 's/.*\([0-9]\.[0-9][0-99]\.[0-9]\).*/\1/p')

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build --build-arg VERSON=$(VERSON) -t $(TARGET):$(VERSON) -f Dockerfile .