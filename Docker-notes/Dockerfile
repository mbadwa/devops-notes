FROM ubuntu:latest
LABEL "Auther"="Mbadwa"
LABEL "Project"="Crispy Kitchen"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install wget git -y
RUN apt install apache2 -y
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80
WORKDIR /var/www/html
VOLUME /var/log/apache2
ADD crispy.tar.gz /var/www/html