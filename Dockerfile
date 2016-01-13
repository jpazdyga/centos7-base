FROM centos:centos7

MAINTAINER Jakub Pazdyga <admin@lascalia.com>

# Set up identifier
RUN echo '[ CentOS 7 Base ]' > /etc/motd

# Import the Centos-6 RPM GPG key to prevent warnings 
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7

# Add EPEL Repository
RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
RUN yum -y install epel-release

ENV container docker

RUN yum -y update

RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
CMD ["/usr/sbin/init"]
ENV DATE_TIMEZONE UTC

RUN yum -y update

RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs

RUN yum -y update; \
yum clean all; \
yum -y install \
    vim-minimal \
    sudo \
    python-setuptools \
    net-tools \
    screen \
    syslog; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*
CMD ["/usr/sbin/init"]

RUN yum check
# Install supervisor daemon using pip
RUN easy_install supervisor
RUN mkdir -p /etc/supervisor.d/
RUN mkdir -p /var/log/supervisor/
# pre-configure supervisor daemon ADD supervisord.conf /etc/supervisor.d/supervisord.conf
ADD supervisord.conf /etc/supervisor.d/supervisord.conf
ADD screenrc /etc/screenrc

# Set the timezone
RUN rm -f /etc/localtime; ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Connect to network
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Clean up everything
RUN yum clean all
RUN rm -rf /etc/ld.so.cache
RUN rm -rf /sbin/sln
RUN rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,gnome/help,cracklib,il8n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive}
RUN rm -rf /var/cache/ldconfig/*
RUN rpmdb --rebuilddb; rpmdb --initdb

CMD ["/usr/bin/supervisord", "--configuration=/etc/supervisor.d/supervisord.conf"]
