  
DOCKER ?= docker
TARGET ?= cnsoluciones/novnc-winbox
VERSION ?= 3.41

all:
	@echo "Building ${TARGET}:${VERSION}"
	$(DOCKER) build -t $(TARGET):${VERSION} -f Dockerfile .
	$(DOCKER) push $(TARGET):${VERSION}
	$(DOCKER) push $(TARGET)

