FROM ubuntu
ENV SDK_VERSION 1.19.1

USER root
WORKDIR /root

#--- Installing fonts ---
RUN \
  echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list && \
  echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list && \
  echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse" /etc/apt/sources.list && \
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y -q chromium-browser ttf-mscorefonts-installer \
  fonts-thai-tlwg ttf-dejavu-core libgconf2-4 libnss3-1d libxss1 xvfb wget unzip git

RUN \
  wget http://launchpadlibrarian.net/107999832/ttf-kochi-gothic_20030809-15_all.deb \
  && apt-get install -y /root/ttf-kochi-gothic_20030809-15_all.deb \
  && rm /root/ttf-kochi-gothic_20030809-15_all.deb

RUN \
  wget http://launchpadlibrarian.net/107999831/ttf-kochi-mincho_20030809-15_all.deb \
  && apt-get install -y /root/ttf-kochi-mincho_20030809-15_all.deb \
  && rm /root/ttf-kochi-mincho_20030809-15_all.deb

RUN \
  wget http://launchpadlibrarian.net/162388639/ttf-indic-fonts-core_0.5.14ubuntu1_all.deb \
  && apt-get install -y /root/ttf-indic-fonts-core_0.5.14ubuntu1_all.deb \
  && rm /root/ttf-indic-fonts-core_0.5.14ubuntu1_all.deb

RUN \
  wget http://launchpadlibrarian.net/162388648/ttf-punjabi-fonts_0.5.14ubuntu1_all.deb \
  && apt-get install -y /root/ttf-punjabi-fonts_0.5.14ubuntu1_all.deb  \
  && rm /root/ttf-punjabi-fonts_0.5.14ubuntu1_all.deb

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