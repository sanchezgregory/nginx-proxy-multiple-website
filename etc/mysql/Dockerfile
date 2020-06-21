FROM mysql/mysql-server:5.7

RUN rm -rvf /var/lib/mysql/ib_logfile*; chown -R mysql:mysql /var/lib/mysql; chmod 0755 /var/lib/mysql

COPY my.cnf /etc/my.cnf.d/
COPY my.cnf /etc/