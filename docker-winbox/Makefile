  
DOCKER ?= docker
TARGET ?= cnsoluciones/novnc-winbox

all:
	@echo "Building ${TARGET}"
	$(DOCKER) build -t $(TARGET) -f Dockerfile .

