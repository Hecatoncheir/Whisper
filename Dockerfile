FROM google/dart
MAINTAINER Vostrikov Vitaliy

USER root

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

#--- Installing Codecov report script ---
RUN \
  curl -o /root/application/codecov_report https://codecov.io/bash \
  && chmod +x /root/application/codecov_report

EXPOSE 3000 8181
CMD ["dart", "bin/server.dart"]