FROM ubuntu:12.04
MAINTAINER Vostrikov Vitaliy

USER root

#--- Configuration ---
ENV CHANNEL stable
ENV SDK_VERSION 1.19.1
ENV CONTENT_SHELL_VERSION 1.19.1

#--- Install third-party dependencies ---
RUN echo "deb http://us.archive.ubuntu.com/ubuntu precise main multiverse" \
    >> /etc/apt/sources.list \
    && apt-get update
RUN \
  apt-get install -y --force-yes \
          lsb-release \
          sudo \
          unzip \
          wget \
          git
RUN git clone https://chromium.googlesource.com/chromium/src/build
RUN build/install-build-deps.sh --no-prompt

#--- Installing content shell ---
RUN \
  cd /root && \
  wget http://gsdview.appspot.com/dart-archive/channels/$CHANNEL/release/$CONTENT_SHELL_VERSION/dartium/content_shell-linux-x64-release.zip \
  && unzip content_shell-linux-x64-release.zip \
  && rm content_shell-linux-x64-release.zip \
  && mv drt-lucid64-full-$CHANNEL-$CONTENT_SHELL_VERSION.0 content_shell
ENV PATH "$PATH:/root/content_shell"

#--- Installing Dart SDK ---
RUN \
 cd /root && wget \
 https://storage.googleapis.com/dart-archive/channels/$CHANNEL/release/$SDK_VERSION/sdk/dartsdk-linux-x64-release.zip \
 && unzip dartsdk-linux-x64-release.zip \
 && rm dartsdk-linux-x64-release.zip
ENV PATH "$PATH:/root/dart-sdk/bin"

RUN \
  dart --version && \
  pub --version

#--- Prepare application ---
WORKDIR /root/application

ADD pubspec.* /root/application/
RUN pub get

ADD . /root/application/
RUN pub get --offline

RUN pub build

RUN \
  pub run dart_codecov_generator \
  --report-on=lib/ --no-html --verbose test/engine

#--- Installing Codecov report script ---
RUN \
  wget -O /root/application/codecov https://codecov.io/bash \
  && chmod +x /root/application/codecov

EXPOSE 3000 8181
CMD ["dart", "bin/server.dart"]