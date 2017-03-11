FROM    eb-base
MAINTAINER dev@zelf.com
#
#RUN apt-get -y update
#RUN apt-get -y install python3
#RUN apt-get -y install python3-pip
#RUN apt-get -y install nginx

WORKDIR /srv
RUN mkdir app
WORKDIR /srv/app


