setup: webapp-setup mysql-setup nginx-setup

webapp-setup:
	cp webapp/main.go /home/isucon/isuumo/webapp/go/
	cd /home/isucon/isuumo/webapp/go && make
	sudo systemctl restart isuumo.go

mysql-setup:
	sudo cp mysqld.cnf /etc/mysql/mysql.conf.d/
	sudo systemctl restart mysql

SLOW_LOG=/var/log/mysql/mysql-slow.log

slow-query-show:
	sudo mysqldumpslow -s t $(SLOW_LOG) | head -n 20


nginx-setup:
	sudo cp nginx.conf /etc/nginx/
	sudo systemctl restart nginx

ALPSORT=sum
ALPM="/api/estate/low_priced,/api/chair/low_priced,/api/chair/search,/api/chair/search/condition,/api/chair/[0-9]+,/api/chair/buy/[0-9]+,/api/estate/search,/api/estate/search/condition,/api/estate/req_doc/[0-9]+,/api/estate/nazotte,/api/estate/[0-9]+,/api/recommended_estate/[0-9]+,/api/chair,/api/estate,/_next/static/.*,/images/chair/.*,/images/estate/.*,/b2f8c04104ceb75c948a76385678065a50b55f52/.*"
OUTFORMAT=count,method,1xx,2xx,3xx,4xx,5xx,uri,min,max,sum,avg,p99

.PHONY: alp
alp:
	sudo alp ltsv --file=/var/log/nginx/access.log --nosave-pos --pos /tmp/alp.pos --sort $(ALPSORT) --reverse -o $(OUTFORMAT) -m $(ALPM) -q

.PHONY: alpsave
alpsave:
	sudo alp ltsv --file=/var/log/nginx/access.log --pos /tmp/alp.pos --dump /tmp/alp.dump --sort $(ALPSORT) --reverse -o $(OUTFORMAT) -m $(ALPM) -q

.PHONY: alpload
alpload:
	sudo alp ltsv --load /tmp/alp.dump --sort $(ALPSORT) --reverse -o count,method,uri,min,max,sum,avg,p99 -q


