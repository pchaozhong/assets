FROM ubuntu
ARG CINC_VERSION
ARG CINC_MINOR_VERSION
COPY cinc-auditor_4.24.8-1_amd64.deb /tmp
RUN dpkg -i /tmp/cinc-auditor_4.24.8-1_amd64.deb
ENTRYPOINT ["/usr/bin/cinc-auditor"]
