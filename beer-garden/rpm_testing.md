Notes for testing the RPM install of beer-garden. Use these to note to automate
the testing (or at least simplify it).

- Start beer-garden using dev utils, then shutdown bg-parent1 so that just the
  dependency services are running:

  ```
  beer up
  docker stop bg-parent1
  ```

- Start a centos7 container attached to the bg network

  ```
  docker run --rm -it --network bg-network -v  centos:centos7
  docker run --rm -it \
  --network bg-network \
  -p 2337:2337 \
  -v /home/sataubm/dev/dev-utils/beer-garden/conf/bg-parent1.yaml:/tmp/config.yaml \
  centos:centos7
  ```

The following occur inside the centos container

- Download and install the beer-garden rpm

  ```
  cd /tmp

  # update version number accordingly
  curl -L https://github.com/beer-garden/beer-garden/releases/download/3.8.0/beer-garden-3.8.0-1.el7.x86_64.rpm > bg-3.8.0.rpm
  yum install -y ./bg-3.8.0.rpm
  ```

- Insert our mounted config file

  ```
  mv /opt/beer-garden/conf/config.yaml /opt/beer-garden/conf/config.yaml.bak
  cp /tmp/config.yaml /opt/beer-garden/conf/config.yaml
  chown beer-garden:beer-garden /opt/beer-garden/conf/config.yaml
  ```

- Start beer-garden

  ```
  su -s /bin/sh beer-garden
  /opt/beer-garden/bin/beergarden -c /opt/beer-garden/conf/config.yaml -l /opt/beer-garden/conf/app-logging.yaml
  ```

- Do some rudimentary tests

  ```
  curl http://localhost:2337/api/v1/gardens/
  curl http://localhost:2337/api/v1/requests/
  ```
