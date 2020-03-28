FROM ubuntu
RUN   apt-get -y update && \
  apt-get -y install wget && \
  mkdir -p /opt/ && \
  cd /opt/ && \
  wget https://packages.chef.io/files/stable/inspec/4.18.100/ubuntu/18.04/inspec_4.18.100-1_amd64.deb &&\
  apt install /opt/inspec_4.18.100-1_amd64.deb && \
  rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/bin/inspec"]
