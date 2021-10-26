# Docker AWS Cli

## ENV (Environmental variable)
The environment variable timezone. By default America/Argentina/Buenos_Aires

| Name | Variable |
| ------------- | ------------- |
| TZ  | America/Argentina/Buenos_Aires  |
| MYSQL_HOST | $MYSQL_HOST  |
| MYSQL_ROOT_PASSWORD | ${MYSQL_ROOT_PASSWORD}  |
| MYSQL_DATABASE | ${MYSQL_DATABASE}  |
| MYSQL_USER | ${MYSQL_USER}  |
| MYSQL_PASSWORD | ${MYSQL_PASSWORD}  |
| AWS_S3_SQL | ${AWS_S3_SQL}  |
| AWS_S3_FILE | ${AWS_S3_FILE}  |
| MSMTP | ${MSMTP}  |
| MSMTP_AUTH | ${MSMTP_AUTH}  |
| MSMTP_TTS | ${MSMTP_TTS}  |
| MSMTP_TTS_TRUST_FILE | /etc/ssl/cert.pem  |
| MSMTP_SYSLOG | ${MSMTP_SYSLOG}  |
| MSMTP_ACCOUNT | ${MSMTP_ACCOUNT}  |
| MSMTP_HOST | ${MSMTP_HOST}  |
| MSMTP_PORT | ${MSMTP_PORT}  |
| MSMTP_ACCOUNT_AUTH | ${MSMTP_ACCOUNT_AUTH}  |
| MSMTP_FROM | ${MSMTP_FROM}  |
| MSMTP_USER | ${MSMTP_USER}  |
| MSMTP_PASSWORD | ${MSMTP_PASSWORD}  |
| MAIL_NOTIFICATION | ${MAIL_NOTIFICATION}  |

* More information about timezone: https://wiki.alpinelinux.org/wiki/Setting_the_timezone


### shell

```bash
docker run --rm -it --name awscli cnsoluciones/aws-cli:latest bash
```

### aws --version

```bash
docker run --rm -it --name awscli cnsoluciones/aws-cli:latest aws --version
```

## VOLUME (OPTIONAL)

| VOLUME LOCAL | VOLUME DOCKER |
| ------------- | ------------- |
| $HOME/.aws  | /root/.aws |
| $HOME/Downloads | /Downloads |
| $HOME/Upload | /Upload |

## ALIAS (OPTIONAL) GNU/Linux and macOS

```bash
echo "alias aws='docker run --rm --name=awscli -ti --volume=$HOME/.aws:/root/.aws --volume=$HOME/Downloads:/Download  --volume=$HOME/Upload:/Upload cnsoluciones/aws-cli:latest aws'" > ~/.bash_profile
source ~/.bash_profile
```

### EXAMPLE: VOLUME .aws (To maintain persistence of settings)
```bash
docker run --rm --name=aws-cli -ti -e TZ="America/Montevideo" --volume=$HOME/.aws:/root/.aws --volume=$HOME/Downloads:/Download  --volume=$HOME/Upload:/Upload cnsoluciones/aws-cli:latest aws
```

## CONFIGURE
```bash
aws configure
```
Or
```bash
docker run --rm --name=aws-cli -ti --volume=$HOME/.aws:/root/.aws --volume=$HOME/Downloads:/Download  --volume=$HOME/Upload:/Upload cnsoluciones/aws-cli:latest aws configure
```

## ECR - Amazon Elastic Container Service
### Login
```bash
aws ecr get-login --no-include-email --region us-east-1
```
Or
```bash 
docker run --rm --name=aws-cli -ti --volume=$HOME/.aws:/root/.aws --volume=$HOME/Downloads:/Download  --volume=$HOME/Upload:/Upload cnsoluciones/aws-cli:latest aws ecr get-login --no-include-email --region us-east-1
```
### Create repository
```bash
aws ecr create-repository --repository-name aws/cli
```
Or
```bash
docker run --rm --name=aws-cli -ti --volume=$HOME/.aws:/root/.aws --volume=$HOME/Downloads:/Download  --volume=$HOME/Upload:/Upload cnsoluciones/aws-cli:latest aws ecr create-repository --repository-name aws/cli
```

#### OUT
```bash
{
    "repository": {
        "repositoryUri": "52012720584722.dkr.ecr.us-east-1.amazonaws.com/aws/cli",
        "imageScanningConfiguration": {
            "scanOnPush": false
        },
        "registryId": "52012720584722",
        "imageTagMutability": "MUTABLE",
        "repositoryArn": "arn:aws:ecr:us-east-1:52012720584722:repository/aws/cli",
        "repositoryName": "aws/cli",
        "createdAt": 1586206267.0
    }
}
```
### Push

```bash
docker tag cnsoluciones/aws-cli:1.18.36t 52012720584722.dkr.ecr.us-east-1.amazonaws.com/aws/cli
docker push 52012720584722.dkr.ecr.us-east-1.amazonaws.com/aws/cli
```
### Pull
```bash
docker pull 52012720584722.dkr.ecr.us-east-1.amazonaws.com/aws/cli
```

## S3

### Download

```
docker-compose down
mv user-data user-data.backup
aws s3 cp s3://XXXXXXX/user-data_07-10-2020_05_00_01.tar.gz.7z.001 .
aws s3 cp s3://XXXXXXX/user-data_07-10-2020_05_00_01.tar.gz.7z.002 .
7za e  user-data_07-10-2020_05_00_01.tar.gz.7z.001
tar -xzvf user-data_07-10-2020_05_00_01.tar.gz
docker-compose up -d
rm -fr user-data_*
```

### ECS exec test
```bash
CLUSTER_NAME=cluster-name
TASK_NAME=xxxxxxxxxxxxxxxxxxxxxxxxxxx
bash <( curl -Ls https://raw.githubusercontent.com/aws-containers/amazon-ecs-exec-checker/main/check-ecs-exec.sh ) $CLUSTER_NAME $TASK_NAME
```
