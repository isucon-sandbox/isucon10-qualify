mysql-setup:
	cp mysqld.cnf /etc/mysql/mysql.conf.d/
	systemctl restart mysql
