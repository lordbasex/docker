CREATE USER 'kamailio'@'%' IDENTIFIED BY 'kamailiorw';
CREATE USER 'kamailioro'@'%' IDENTIFIED BY 'kamailioro';
GRANT ALL ON kamailio.* TO 'kamailio'@'%';
GRANT ALL ON kamailio.* TO 'kamailioro'@'%';
