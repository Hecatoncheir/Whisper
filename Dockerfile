FROM fedora

USER root
ENV SDK_VERSION 1.19.1

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

RUN /usr/bin/Xvfb :1.0 -screen 0 1280x1024x24 &

#--- Installing content shell ---
RUN \
  dnf install -y libfontconfig.so.1 \
      libpangocairo-1.0.so.0 \
      libXi.so.6 \
      libatk-1.0.so.0 \
      libXcursor.so.1 \
      libXcomposite.so.1 \
      libasound.so.2 \
      libXtst.so.6 \
      libXrandr.so.2 \
      xorg-x11-server-Xvfb \
      libgconf-2.so.4 \
  && dnf autoremove \
  && dnf clean all && \
  cd /root && wget \
  http://gsdview.appspot.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/content_shell-linux-x64-release.zip \
  && unzip content_shell-linux-x64-release.zip \
  && rm content_shell-linux-x64-release.zip \
  && mv drt-lucid64-full-stable-$SDK_VERSION.0 content_shell
ENV PATH "$PATH:/root/content_shell"

#--- Fix content-shell fonts ---
RUN \
  mkdir /usr/share/fonts/truetype/ && \
  mkdir /usr/share/fonts/truetype/kochi && \
  cd /usr/share/fonts/truetype/kochi && \
  ln -s /root/content_shell/GardinerModCat.ttf kochi-gothic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf kochi-mincho.ttf && \
  mkdir /usr/share/fonts/truetype/ttf-dejavu && \
  cd /usr/share/fonts/truetype/ttf-dejavu && \
  ln -s /root/content_shell/GardinerModCat.ttf DejaVuSans.ttf && \
  mkdir /usr/share/fonts/truetype/ttf-indic-fonts-core && \
  cd /usr/share/fonts/truetype/ttf-indic-fonts-core && \
  ln -s /root/content_shell/GardinerModCat.ttf lohit_hi.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf lohit_ta.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf MuktiNarrow.ttf && \
  mkdir /usr/share/fonts/truetype/msttcorefonts && \
  cd /usr/share/fonts/truetype/msttcorefonts && \
  ln -s /root/content_shell/GardinerModCat.ttf Arial.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Arial_Bold.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Arial_Bold_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Arial_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Comic_Sans_MS.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Comic_Sans_MS_Bold.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Courier_New.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Courier_New_Bold.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Courier_New_Bold_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Courier_New_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Georgia.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Georgia_Bold.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Georgia_Bold_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Georgia_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Impact.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Trebuchet_MS.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Trebuchet_MS_Bold.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Trebuchet_MS_Bold_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Trebuchet_MS_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Times_New_Roman.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Times_New_Roman_Bold.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Times_New_Roman_Bold_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Times_New_Roman_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Verdana.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Verdana_Bold.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Verdana_Bold_Italic.ttf && \
  ln -s /root/content_shell/GardinerModCat.ttf Verdana_Italic.ttf

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

RUN \
  mkdir /root/tools \
  && wget -O /root/tools/codecov https://codecov.io/bash \
  && chmod +x /root/tools/codecov

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