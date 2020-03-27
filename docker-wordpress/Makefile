DOCKER ?= docker-compose
MYSQL_ROOT_PASSWORD ?= `cat .env | grep MYSQL_ROOT_PASSWORD | cut -d "=" -f2`
MYSQL_DATABASE ?= `cat .env | grep MYSQL_DATABASE | cut -d "=" -f2`

mysqldump:
	@echo "MySQLDump $(MYSQL_DATABASE) $(MYSQL_ROOT_PASSWORD)"
	$(DOCKER) exec db mysqldump -uroot -p$(MYSQL_ROOT_PASSWORD) $(MYSQL_DATABASE) > db.sql
