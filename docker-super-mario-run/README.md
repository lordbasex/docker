# Docker Super Mario Run
Hola Mundo

## Build
```bash
docker build --no-cache -t docker-super-mario-run https://raw.githubusercontent.com/lordbasex/Docker/master/docker-super-mario-run/Dockerfile
docker run --rm docker-super-mario-run
```
## Run 
```
docker run --rm lordbasex/docker-super-mario-run
```

## Logo Coca Cola
```
 docker run --rm -it lordbasex/docker-super-mario-run jp2a --width=200 https://www.marketingregistrado.com/img/noticias/coca-cola.jpg
```

## Logo Google
```
docker run --rm -it lordbasex/docker-super-mario-run convert http://www.google.com/intl/en/images/logo.gif jpg:- | jp2a -
```

## Logo Google

## DOC:
* https://manpages.ubuntu.com/manpages/precise/en/man1/jp2a.1.html
* https://csl.name/jp2a/
