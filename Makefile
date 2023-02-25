
mysql-setup:
	sudo cp mysqld.cnf /etc/mysql/mysql.conf.d/
	sudo systemctl restart mysql

SLOW_LOG=/var/log/mysql/mysql-slow.log

slow-query-show:
	sudo mysqldumpslow -s t $(SLOW_LOG) | head -n 20
