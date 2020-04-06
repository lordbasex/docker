# Docker Super Mario Run
Hola Mundo

* Build
```bash
docker build --no-cache -t docker-super-mario-run https://raw.githubusercontent.com/lordbasex/Docker/master/docker-super-mario-run/Dockerfile
docker run --rm docker-super-mario-run
```
* Run (Download run and remove)
```bash
docker run --rm lordbasex/docker-super-mario-run
```

* Coca Cola
````
 docker run --rm -it lordbasex/docker-super-mario-run jp2a --width=200 https://www.marketingregistrado.com/img/noticias/coca-cola.jpg
 ```

```
docker run --rm -it lordbasex/docker-super-mario-run convert http://www.google.com/intl/en/images/logo.gif jpg:- | jp2a -
```
