FROM fedora

USER root
ENV SDK_VERSION 1.20.1

RUN \
  dnf update -y && \
  dnf install -y \
  wget \
  git \
  unzip \
  tar \
  && \
  dnf autoremove && \
  dnf clean all

#RUN /usr/bin/Xvfb :1.0 -screen 0 1280x1024x24 &

#--- Installing Rethinkdb ---
RUN wget https://download.rethinkdb.com/centos/6/`uname -m`/rethinkdb.repo \
    -O /etc/yum.repos.d/rethinkdb.repo

RUN dnf install -y rethinkdb

#--- Installing Dart SDK ---
RUN \
  cd /root && wget \
  https://storage.googleapis.com/dart-archive/channels/stable/release/$SDK_VERSION/sdk/dartsdk-linux-x64-release.zip \
  && unzip dartsdk-linux-x64-release.zip \
  && rm dartsdk-linux-x64-release.zip

ENV PATH "$PATH:/root/dart-sdk/bin"

RUN \
  dart --version && \
  pub --version

#--- Prepare application ---
WORKDIR /root/application

ADD . /root/application/

RUN pub get

RUN pub run test

RUN pub build

#--- Installing Codecov report script ---
RUN \
  curl -o /root/application/codecov_report https://codecov.io/bash \
  && chmod +x /root/application/codecov_report

EXPOSE 8000 8080 8181 8182

ENTRYPOINT ["rethinkdb","--bind","all"]
CMD ["dart", "bin/server.dart"]
