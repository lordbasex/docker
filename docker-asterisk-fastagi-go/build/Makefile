DOCKER ?= docker


all:
    @echo "Building Multi-Arch Images"
  
    #docker manifest inspect node
    #docker buildx ls
    @echo "Building Multi-Arch Images"
    
    #init
    $(DOCKER) buildx create --name multiarchitecture
    $(DOCKER) buildx use multiarchitecture 
    
    #asterisk-iax2
    cd asterisk-iax2
    $(DOCKER) buildx build --platform linux/amd64,linux/arm64 -t cnsoluciones/asterisk-iax2:latest --push .
    cd ..
    
    #fastagi
    cd fastagi
    $(DOCKER) buildx build --platform linux/amd64,linux/arm64 -t cnsoluciones/fastagi:latest --push .
    cd ..
