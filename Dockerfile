FROM fedora
ENV SDK_VERSION 1.19.1

RUN  dnf install -y \
         wget \
         git \
         unzip \
         xorg-x11-server-Xvfb \
         && dnf autoremove \
         && dnf clean all

#--- Installing chrome ---
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
&& dnf install -y google-chrome-stable_current_*.rpm \
&& rm google-chrome-stable_current_*.rpm \
&& dnf autoremove \
&& dnf clean all

#--- Installing dartium ---
RUN wget "https://storage.googleapis.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/dartium-linux-x64-release.zip" \
&& unzip dartium-linux-x64-release.zip \
&& rm dartium-linux-x64-release.zip \
&& mv dartium-lucid64-full-stable-$SDK_VERSION.0 dartium \
&& mv dartium/chrome dartium/dartium
ENV PATH "$PATH:/dartium"

#--- Installing content shell ---
RUN wget http://gsdview.appspot.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/content_shell-linux-x64-release.zip && unzip content_shell-linux-x64-release.zip && rm content_shell-linux-x64-release.zip && mv drt-lucid64-full-stable-$SDK_VERSION.0 content_shell
ENV PATH "$PATH:/content_shell"

#--- Installing Dart SDK ---
RUN wget https://storage.googleapis.com/dart-archive/channels/stable/release/$SDK_VERSION/sdk/dartsdk-linux-x64-release.zip && unzip dartsdk-linux-x64-release.zip && rm dartsdk-linux-x64-release.zip
ENV PATH "$PATH:/dart-sdk/bin"

RUN dart --version && pub --version && dartium --version

WORKDIR /application

ADD pubspec.yaml /application/
RUN pub get

ADD . /application/
RUN pub get --offline

RUN pub run test && pub run test -p content-shell
RUN pub build

EXPOSE 3000/tcp, 8181
CMD ["dart", "bin/server.dart"]
