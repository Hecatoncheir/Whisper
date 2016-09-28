FROM ubuntu
MAINTAINER Vostrikov Vitaliy

USER root

#--- Configuration ---
ENV CHANNEL stable
ENV SDK_VERSION 1.19.1
ENV CONTENT_SHELL_VERSION 1.19.1

#--- Install third-party dependencies ---
RUN \
  echo "deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse " >> /etc/apt/sources.list && \
  apt update
RUN \
  apt install -y \
      unzip \
      git \
      wget

#--- Installing content shell ---
RUN \
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
  apt install --no-install-recommends -y -q \
      chromium-browser \
      xvfb \
      libudev0 \
      libgconf-2-4 \
      ttf-kochi-gothic \
      ttf-kochi-mincho \
      ttf-mscorefonts-installer \
      ttf-indic-fonts \
      ttf-dejavu-core \
      ttf-indic-fonts-core \
      fonts-thai-tlwg \
      msttcorefonts
RUN \
  cd /root \
  && wget \
  http://gsdview.appspot.com/dart-archive/channels/$CHANNEL/release/$CONTENT_SHELL_VERSION/dartium/content_shell-linux-x64-release.zip \
  && unzip content_shell-linux-x64-release.zip \
  && rm content_shell-linux-x64-release.zip \
  && mv drt-lucid64-full-$CHANNEL-$CONTENT_SHELL_VERSION.0 content_shell
ENV PATH "$PATH:/root/content_shell"

ENV DISPLAY :99.0
RUN \
  cd /etc/init.d/ \
  && wget --no-check-certificate -O \
  /etc/init.d/xvfb https://gist.githubusercontent.com/dloman/8303932/raw/a9534ba144388014aab20776e84db2c720a366bf/xvfb \
  && chmod -R 777 xvfb \
  && /etc/init.d/xvfb start

#--- Installing Dart SDK ---
RUN \
 cd /root \
 && wget \
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

# RUN pub build

RUN \
  pub run dart_codecov_generator \
  --report-on=lib/ --no-html --verbose test/engine

#--- Installing Codecov report script ---
RUN \
  wget -O /root/application/codecov https://codecov.io/bash \
  && chmod +x /root/application/codecov

EXPOSE 3000 8181
CMD ["dart", "bin/server.dart"]