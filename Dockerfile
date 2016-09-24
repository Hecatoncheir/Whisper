FROM fedora

USER root
ENV SDK_VERSION 1.19.1

RUN \
  dnf update -y && \
  dnf install -y \
      'dnf-command(copr)' \
      wget \
      git \
      unzip \
      tar \
      xorg-x11-server-Xvfb \
      libgconf-2.so.4 \
      && \
  dnf autoremove && \
  dnf clean all

#--- Installing chromium ---
RUN \
  dnf copr enable -y spot/chromium && \
  dnf install -y chromium

#--- Installing fonts ---
RUN \
  dnf install -y \
      cabextract \
      xorg-x11-font-utils \
      fontconfig \
      && \
  rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

#--- Installing content shell ---
RUN \
  cd /root && wget \
  http://gsdview.appspot.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/content_shell-linux-x64-release.zip \
  && unzip content_shell-linux-x64-release.zip \
  && rm content_shell-linux-x64-release.zip \
  && mv drt-lucid64-full-stable-$SDK_VERSION.0 content_shell
ENV PATH "$PATH:/root/content_shell"
ENV DISPLAY=:99.0

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

ADD pubspec.* /root/application/
RUN pub get

ADD . /root/application/
RUN pub get --offline

RUN \
  pub run dart_codecov_generator:generate_coverage \
  --report-on=lib/ --no-html --verbose test/engine

RUN pub build

EXPOSE 3000 8181
CMD ["dart", "bin/server.dart"]