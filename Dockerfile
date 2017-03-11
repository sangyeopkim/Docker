FROM    eb-base2
MAINTAINER dev@zelf.com

#RUN apt-get -y update
#RUN apt-get -y install python3
#RUN apt-get -y install python3-pip
#RUN apt-get -y install nginx

COPY . /srv/app
WORKDIR /srv/app

RUN pip3 install -r requirements.txt
RUN pip3 install uwsgi
WORKDIR /srv/app/django_app
CMD ["python3", "manage.py", "runserver", "0:8080"]
