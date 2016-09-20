FROM fedora
ENV SDK_VERSION 1.19.1

RUN dnf install -y unzip \
                   tar \
                   wget \
                   chromedriver \
                   libgconf-2.so.4

RUN wget http://gsdview.appspot.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/content_shell-linux-x64-release.zip && unzip content_shell-linux-x64-release.zip && rm content_shell-linux-x64-release.zip && mv drt-lucid64-full-stable-$SDK_VERSION.0 content_shell
ENV PATH "$PATH:/content_shell"

RUN wget https://storage.googleapis.com/dart-archive/channels/stable/release/$SDK_VERSION/sdk/dartsdk-linux-x64-release.zip && unzip dartsdk-linux-x64-release.zip && rm dartsdk-linux-x64-release.zip
ENV PATH "$PATH:/dart-sdk/bin"

RUN dart --version && pub --version

RUN pub cache add watcher -v 0.9.7+3
WORKDIR /application

ADD pubspec.yaml /application/
RUN pub get

ADD . /application/
RUN pub get --offline

RUN pub run test && pub run test -p content-shell
RUN pub build

EXPOSE 3000/tcp, 8181
ENTRYPOINT ["dart-sdk/bin"]
CMD ["dart", "bin/server.dart"]
