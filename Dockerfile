FROM centos:centos7.1.1503

MAINTAINER Jakub Pazdyga <jakub.pazdyga@ft.com>

# Set up identifier
RUN echo '[ CentOS 7 Base ]' > /etc/motd

# Import the Centos-6 RPM GPG key to prevent warnings 
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7

# Add EPEL Repository
RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
	RUN yum -y install epel-release

RUN yum -y update

RUN yum -y install \
    vim-minimal \
    sudo \
    python-pip \
    python-setuptools 

# Install supervisor daemon using pip
RUN pip install supervisor
RUN mkdir -p /etc/supervisor.d/
RUN mkdir -p /var/log/supervisor/
# pre-configure supervisor daemon ADD supervisord.conf /etc/supervisor.d/supervisord.conf
ADD supervisord.conf /etc/supervisor.d/supervisord.conf

# Set the timezone
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Connect to network
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Enable access to logs and configuration files
VOLUME /var/log /etc

# Clean up everything
RUN yum clean all
RUN rm -rf /etc/ld.so.cache
RUN rm -rf /sbin/sln
RUN rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,gnome/help,cracklib,il8n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive}
RUN rm -rf /var/cache/ldconfig/*

#CMD ["/usr/bin/supervisord", "--configuration=/etc/supervisor.d/supervisord.conf"]
