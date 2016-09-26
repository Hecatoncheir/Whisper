FROM ubuntu:latest
MAINTAINER Vostrikov Vitaliy

USER root
ENV SDK_VERSION 1.19.1
ENV CONTENT_SHELL_VERSION 1.14.2

RUN \
  apt update -y \
  && apt install -y \
      wget \
      curl \
      git \
      unzip \
      tar

#--- Installing Xvfb ---
RUN \
  apt install -y xvfb \
      libglib2.0-0 \
      libnss3-dev \
      libgconf-2-4 \
      libfontconfig1 \
      libpangocairo-1.0 \
      libxi6 \
      libatk1.0-0 \
      libxcursor1 \
      libxcomposite1 \
      libasound2 \
      libxtst6 \
      libxrandr2 \
  && ln -sf /lib/$(arch)-linux-gnu/libudev.so.1 /lib/$(arch)-linux-gnu/libudev.so.0 \
  && cd /etc/init.d/ \
  && wget -O /etc/init.d/xvfb https://gist.githubusercontent.com/dloman/8303932/raw/a9534ba144388014aab20776e84db2c720a366bf/xvfb \
  && chmod -R 777 xvfb \
  && echo 'DISPLAY=\":1\"' >> /etc/environment \
  && /etc/init.d/xvfb start

#--- Installing content shell ---
RUN \
  cd /root && \
  wget http://gsdview.appspot.com/dart-archive/channels/stable/release/$CONTENT_SHELL_VERSION/dartium/content_shell-linux-x64-release.zip \
  && unzip content_shell-linux-x64-release.zip \
  && rm content_shell-linux-x64-release.zip \
  && mv drt-lucid64-full-stable-$CONTENT_SHELL_VERSION.0 content_shell
ENV PATH "$PATH:/root/content_shell"

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

#--- Installing Codecov report script ---
RUN \
  wget -O /root/application/codecov https://codecov.io/bash \
  && chmod +x /root/application/codecov

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

EXPOSE 3000 8181
CMD ["dart", "bin/server.dart"]