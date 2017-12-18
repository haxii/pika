FROM debian:jessie-slim
MAINTAINER Zichao Li <zichao@haxii.com>

# install pika dependency
RUN apt-get -y update && \
    apt-get -y install libsnappy-dev libgoogle-glog-dev && \
    apt-get -y install libgoogle-perftools-dev &&\
    rm -rf /var/lib/apt/lists/*

#build pika
COPY . /pika
WORKDIR /pika
RUN makeDeps='make git gcc g++'&& \
    apt-get -y install -y --no-install-recommends $makeDeps&& \
    make&& \
    mv output ../&& \
    rm -rf ./*&& \
    mv ../output/* .&& \
    rm -r ../output/&& \
    apt-get purge -y --auto-remove $makeDeps

ENV PATH $/pika/bin:${PATH}

WORKDIR /pika/output

EXPOSE 9221
VOLUME /pika/log/
VOLUME /pika/db/
VOLUME /pika/dump/
VOLUME /pika/dbsync/
VOLUME /pika/conf/

CMD ["pika -c /pika/conf/pika.conf"]
