FROM fedora
ENV SDK_VERSION 1.19.1

USER root
WORKDIR /root/application

RUN \
  dnf install -y epel-release && \
  wget git unzip xorg-x11-server-Xvfb fontconfig libfontenc fontconfig-devel \
  libXfont ghostscript-fonts xorg-x11-font-utils urw-fonts && \
  dnf autoremove && \
  dnf clean all

#--- Installing chrome ---
RUN \
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
  && dnf install -y google-chrome-stable_current_*.rpm \
  && rm google-chrome-stable_current_*.rpm \
  && dnf autoremove \
  && dnf clean all

#--- Installing dartium ---
RUN \
  wget "https://storage.googleapis.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/dartium-linux-x64-release.zip" \
  && unzip dartium-linux-x64-release.zip \
  && rm dartium-linux-x64-release.zip \
  && mv dartium-lucid64-full-stable-$SDK_VERSION.0 dartium \
  && mv dartium/chrome dartium/dartium
ENV PATH "$PATH:/dartium"

#--- Installing content shell ---
RUN \
  wget http://gsdview.appspot.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/content_shell-linux-x64-release.zip \
  && unzip content_shell-linux-x64-release.zip \
  && rm content_shell-linux-x64-release.zip \
  && mv drt-lucid64-full-stable-$SDK_VERSION.0 content_shell

#--- Fix content-shell fonts ---
RUN \
  mkdir /usr/share/fonts/truetype/ && \
  mkdir /usr/share/fonts/truetype/kochi && \
  cd /usr/share/fonts/truetype/kochi && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf kochi-gothic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf kochi-mincho.ttf && \
  mkdir /usr/share/fonts/truetype/ttf-dejavu && \
  cd /usr/share/fonts/truetype/ttf-dejavu && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf DejaVuSans.ttf && \
  mkdir /usr/share/fonts/truetype/ttf-indic-fonts-core && \
  cd /usr/share/fonts/truetype/ttf-indic-fonts-core && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf lohit_hi.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf lohit_ta.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf MuktiNarrow.ttf && \
  mkdir /usr/share/fonts/truetype/msttcorefonts && \
  cd /usr/share/fonts/truetype/msttcorefonts && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Arial.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Arial_Bold.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Arial_Bold_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Arial_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Comic_Sans_MS.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Comic_Sans_MS_Bold.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Courier_New.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Courier_New_Bold.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Courier_New_Bold_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Courier_New_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Georgia.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Georgia_Bold.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Georgia_Bold_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Georgia_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Impact.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Trebuchet_MS.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Trebuchet_MS_Bold.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Trebuchet_MS_Bold_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Trebuchet_MS_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Times_New_Roman.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Times_New_Roman_Bold.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Times_New_Roman_Bold_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Times_New_Roman_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Verdana.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Verdana_Bold.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Verdana_Bold_Italic.ttf && \
  ln -s /usr/share/fonts/LiberationMono-Regular.ttf Verdana_Italic.ttf

ENV PATH "$PATH:/content_shell"

#--- Installing Dart SDK ---
RUN \
 wget https://storage.googleapis.com/dart-archive/channels/stable/release/$SDK_VERSION/sdk/dartsdk-linux-x64-release.zip \
 && unzip dartsdk-linux-x64-release.zip \
 && rm dartsdk-linux-x64-release.zip
ENV PATH "$PATH:/dart-sdk/bin"

RUN \
  dart --version && \
  pub --version && \
  dartium --version

ADD pubspec.yaml /root/application/
RUN pub get

ADD . /root/application/
RUN pub get --offline

# RUN pub build

EXPOSE 3000 8181
CMD ["dart", "bin/server.dart"]