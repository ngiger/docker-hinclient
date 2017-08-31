FROM anapsix/alpine-java:8u121b13_jdk
# Alpine uses busybox
MAINTAINER Niklaus Giger "niklaus.giger@member.fsf.org"

# Set correct environment variables.
ENV DEBIAN_FRONTEND noninteractive
ENV JRE_VERSION oracle-java8-jre_8u121_amd64.deb
# RUN useradd --uid 2000 --create-home --shell /bin/bash user_hin
# WORKDIR /home/user_hin
# ADD ${JRE_VERSION} .
# RUN apt-get update && apt-get install -y --no-install-recommends java-common
# RUN dpkg -i  ./${JRE_VERSION} ; pwd
# RUN apt --fix-broken install -y --no-install-recommends
# RUN chown -R user_hin /home/user_hin && ls -lR /home/user_hin
# RUN apt-get install -y --no-install-recommends wget
# USER user_hin
RUN cat /etc/passwd
# RUN wget https://download.hin.ch/download/distribution/install/1.5.3-50/HINClient_unix_1_5_3-50.tar.gz
# RUN chown -R user_hin:user_hin .
ADD HINClient_unix_1_5_3-50.tar.gz /root
# RUN ls -lrtq  /root/ && tar -xf HINClient_unix_1_5_3-50.tar.gz
ADD entrypoint.sh /root/
ADD start_hin.sh /root/
CMD /root/entrypoint.sh
