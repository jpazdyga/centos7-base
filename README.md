## centos7-base
#Docker CentOS 7.1.1503 Base

This is an image to be used as the base for my other builds.

The [Dockerfile](https://github.com/jpazdyga/centos7-base/blob/master/Dockerfile) contains EPEL repository, vim, sudo, python-pip, python-setuptools and [supervisor](http://supervisord.org/) daemon.

Local time is set to UTC here, there's no openssh, as you really do not need this.
This container has two ```volumes``` set, one is for log files ```/var/log``` and the other for ```/etc``` directory to review configuration files.

#To test:

```docker run -i -t --name apache-test jpazdyga/centos7-base:latest /bin/bash```
```
-i, --interactive=false    Keep STDIN open even if not attached
-t, --tty=false            Allocate a pseudo-TTY
--name=                    Assign a name to the container
```
You can monitor it's state by ```docker ps -a```. After work finished in container, press Ctrl+D to logout.
At this point container will indicate ```Exited``` state. You can clean this up by ```docker rm```



