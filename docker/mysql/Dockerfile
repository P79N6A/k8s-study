ARG MYSQL_IMAGE_TAG

FROM $MYSQL_IMAGE_TAG

COPY all.sql /docker-entrypoint-initdb.d/all.sql

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld"]
