FROM ubuntu

RUN apt-get update && apt-get install -y ruby ruby-dev gcc g++ make && \
  gem install inspec-bin

ENTRYPOINT ["/usr/local/bin/inspec"]
