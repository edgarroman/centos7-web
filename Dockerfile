FROM centos/python-35-centos7:latest

MAINTAINER Edgar Roman <edgar+dockerhub@edgarroman.com>
EXPOSE 8000

ADD . /image_build

USER 0

RUN /image_build/setup.sh

USER 1001

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

#CMD ["/sbin/my_init"]


