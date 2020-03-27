.PHONY: build

build:
	docker rmi -f lordbasex/docker-osx-kvm 1>/dev/null 2>/dev/null
	cd build && docker build -t lordbasex/docker-osx-kvm -f Dockerfile . && cd -
run:
	docker run -itd  --name macOS --device /dev/kvm:/dev/kvm -p 9922:2222 -p 5900:8080 -v `pwd`:/data lordbasex/docker-osx-kvm
rmi:
	docker rmi -f docker-osx-kvm
rm:
	docker rm -f macOS
pass:
	docker exec macOS cli randompasswordgenerator
exec:
	docker exec -it macOS bash
clean:
	docker rm -f macOS \
	docker rmi -f lordbasex/docker-osx-kvm
cleanall:
	docker rm -f macOS \
	docker rmi -f lordbasex/docker-osx-kvm \
	rm -fr mac_hdd.img
