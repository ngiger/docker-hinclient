FROM anapsix/alpine-java:8u121b13_jdk
# Alpine uses busybox
MAINTAINER Niklaus Giger "niklaus.giger@member.fsf.org"

ADD HINClient_unix_1_5_3-50.tar.gz /root
ADD entrypoint.sh /root/
ADD start_hin.sh /root/
CMD /root/entrypoint.sh
