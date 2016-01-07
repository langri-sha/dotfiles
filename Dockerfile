FROM langrisha/room

ENV USER root
WORKDIR /root

RUN \
    rcdn && \
    easy_install pip && \
    pip install cram

COPY rcrc /usr/local/lib/rcrc
