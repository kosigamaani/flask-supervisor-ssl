FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get install -y python3 && apt install python3-pip -y && \
    apt-get install -y --no-install-recommends --no-install-suggests supervisor && \
    apt-get install nginx -y

ENV PYTHONDONTWRITEBYTECODE 1

RUN pwd

RUN ls -lrt

WORKDIR /app

RUN pwd

COPY . .

RUN mkdir -p /etc/nginx/ssl

RUN cp cert.key /etc/nginx/ssl/cert.key
RUN cp cert.crt /etc/nginx/ssl/cert.crt

RUN chmod -R 700 /etc/nginx/ssl

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN cp nginx.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

RUN rm /etc/nginx/sites-enabled/default

COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN whoami

RUN nginx -t

RUN ls -lrt

RUN pip install -r requirements.txt

RUN chmod 755 *.sh

EXPOSE 80
EXPOSE 8000
EXPOSE 443

CMD [ "sh", "run.sh"]
