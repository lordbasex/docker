# Docker Super Mario Run
Hola Mundo

## Build
```bash
make all
```
## Run Super Mario Run
```
docker run --rm cnsoluciones/docker-super-mario-run
```

## Logo Coca Cola
```
docker run --rm -it cnsoluciones/docker-super-mario-run jp2a --width=200  https://www.marketingregistrado.com/img/noticias/coca-cola.jpg
```
Or
```
docker run --rm -it cnsoluciones/docker-super-mario-run jp2a --width=200 --color https://www.marketingregistrado.com/img/noticias/coca-cola.jpg
```

## Logo Google
```
docker run --rm -it cnsoluciones/docker-super-mario-run bash
convert http://www.google.com/intl/en/images/logo.gif jpg:- | jp2a --color -
```

## Logo Google

## DOC:
* https://manpages.ubuntu.com/manpages/precise/en/man1/jp2a.1.html
* https://csl.name/jp2a/
