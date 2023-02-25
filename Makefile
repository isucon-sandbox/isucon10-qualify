mysql-setup:
	sudo cp mysqld.cnf /etc/mysql/mysql.conf.d/
	sudo systemctl restart mysql
