# Docker AWS Cli

#ENV (Environmental variable)
The environment variable timezone

| Variable | Zone |
| ------------- | ------------- |
| TZ  | America/Argentina/Buenos_Aires  |

* More information about timezone: https://wiki.alpinelinux.org/wiki/Setting_the_timezone

#VERSION
```bash
docker run --rm --name=aws-cli -ti --volume=`pwd`/aws:/root/.aws cnsoluciones/aws-cli:1.18.36 aws --version
```
#CONFIGURE
```bash
docker run --rm --name=aws-cli -ti --volume=`pwd`/aws:/root/.aws cnsoluciones/aws-cli:1.18.36 aws configure
```

