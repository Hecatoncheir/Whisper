FROM fedora
ENV SDK_VERSION 1.19.1
ENV PUB_CACHE .pub-cache

RUN dnf install -y unzip wget chromedriver libgconf-2.so.4

RUN wget http://gsdview.appspot.com/dart-archive/channels/stable/release/$SDK_VERSION/dartium/content_shell-linux-x64-release.zip && unzip content_shell-linux-x64-release.zip && rm content_shell-linux-x64-release.zip && mv drt-lucid64-full-stable-$SDK_VERSION.0 content_shell
ENV PATH "$PATH:/content_shell"

RUN wget https://storage.googleapis.com/dart-archive/channels/stable/release/$SDK_VERSION/sdk/dartsdk-linux-x64-release.zip && unzip dartsdk-linux-x64-release.zip && rm dartsdk-linux-x64-release.zip
ENV PATH "$PATH:/dart-sdk/bin"

RUN dart --version && pub --version

WORKDIR /application

ADD . /application
RUN pub get

RUN pub run test && pub run test -p content-shell
RUN pub build

EXPOSE 3000/tcp, 8181
ENTRYPOINT ["dart-sdk/bin"]
CMD ["dart", "bin/server.dart"]
