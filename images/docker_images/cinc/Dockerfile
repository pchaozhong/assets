FROM ubuntu

ARG CINC_VERSION
ARG CINC_MINOR_VERSION

COPY cinc-auditor_${CINC_VERSION}-${CINC_MINOR_VERSION}_amd64.deb /tmp
RUN dpkg -i /tmp/cinc-auditor_${CINC_VERSION}-${CINC_MINOR_VERSION}_amd64.deb
RUN rm -f /tmp/cinc-auditor_${CINC_VERSION}-${CINC_MINOR_VERSION}_amd64.deb
ENTRYPOINT ["/usr/bin/cinc-auditor"]
