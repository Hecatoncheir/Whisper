FROM ubuntu:trusty
ENV SDK_VERSION 1.19.1

USER root
WORKDIR /root

#--- Installing fonts ---
RUN \
  echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list && \
  echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
  # echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y -q chromium-browser libgconf2-4 \
  ttf-mscorefonts-installer ttf-kochi-gothic ttf-kochi-mincho ttf-mscorefonts-installer \
  ttf-indic-fonts ttf-dejavu-core ttf-indic-fonts-core fonts-thai-tlwg \
  xvfb wget unzip git

#--- Installing Dart SDK ---
RUN \
  wget --no-check-certificate \
  "https://storage.googleapis.com/dart-archive/channels/stable/release/$SDK_VERSION/sdk/dartsdk-linux-x64-release.zip" \
  && unzip dartsdk-linux-x64-release.zip \
  && rm dartsdk-linux-x64-release.zip
ENV PATH "$PATH:/root/dart-sdk/bin/"

#--- Installing dartium ---
RUN \
  wget --no-check-certificate \
  "https://storage.googleapis.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/dartium-linux-x64-release.zip" \
  && unzip dartium-linux-x64-release.zip \
  && rm dartium-linux-x64-release.zip \
  && mv dartium-lucid64-full-stable-$SDK_VERSION.0 dartium \
  && mv dartium/chrome dartium/dartium
ENV PATH "$PATH:/root/dartium/"

#--- Installing content shell ---
RUN \
  wget --no-check-certificate \
  "http://gsdview.appspot.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/content_shell-linux-x64-release.zip" \
  && unzip content_shell-linux-x64-release.zip \
  && rm content_shell-linux-x64-release.zip \
  && mv drt-lucid64-full-stable-$SDK_VERSION.0 content_shell
ENV PATH "$PATH:/root/content_shell/"

RUN \
  dart --version && \
  pub --version && \
  dartium --version

WORKDIR /root/application/

ADD pubspec.yaml /root/application/
RUN pub get

ADD . /root/application/
RUN pub get --offline

RUN pub build

EXPOSE 3000 8181
CMD ["dart", "bin/server.dart"]