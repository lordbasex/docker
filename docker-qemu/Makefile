# Image name and version
NAME = cnsoluciones/docker-qemu
VERSION = 1.0.0

# Docker commands
DOCKER = docker

# Default target
.PHONY: all
all: build

# Build the Docker image
.PHONY: build
build:
	@echo "Building $(NAME):$(VERSION)..."
	$(DOCKER) build -t $(NAME):$(VERSION) .
	$(DOCKER) tag $(NAME):$(VERSION) $(NAME):latest

# Push the Docker image to registry
.PHONY: push
push:
	@echo "Pushing $(NAME):$(VERSION) to registry..."
	$(DOCKER) push $(NAME):$(VERSION)
	$(DOCKER) push $(NAME):latest

# Remove local Docker images
.PHONY: clean
clean:
	@echo "Cleaning up local images..."
	-$(DOCKER) rmi $(NAME):$(VERSION)
	-$(DOCKER) rmi $(NAME):latest

# Build and push in one command
.PHONY: release
release: build push

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build   - Build Docker image"
	@echo "  push    - Push image to registry"
	@echo "  clean   - Remove local images"
	@echo "  release - Build and push image"
	@echo "  help    - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  VERSION - Image version (default: $(VERSION))"
	@echo ""
	@echo "Example:"
	@echo "  make release VERSION=1.0.1" 