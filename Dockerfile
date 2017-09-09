FROM anapsix/alpine-java:8u121b13_jdk
# Alpine uses busybox
MAINTAINER Niklaus Giger "niklaus.giger@member.fsf.org"
ENV HOME=/root \
  DEBIAN_FRONTEND=noninteractive \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8 \
  LC_ALL=C.UTF-8
RUN apk --update --upgrade add  bash  fluxbox  git  socat  supervisor  libxtst xvfb
# http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/ netbeans
RUN apk --update --upgrade add libxext-dev libxrender-dev libxtst-dev
RUN apk --update --upgrade add xdg-utils elinks
ADD HINClient_unix_1_5_3-50.tar.gz /usr/local
ADD entrypoint.sh /usr/local/bin/
ADD start_hin.sh  /usr/local/bin/
CMD /usr/local/bin/entrypoint.sh
RUN adduser -u 1002 -s /bin/bash -h /home/user_hin/ -D user_hin && chown -R user_hin /home/user_hin
ENV HOME=/home/user_hin
USER user_hin
ENV  DISPLAY=:0.0
