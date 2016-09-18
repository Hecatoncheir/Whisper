FROM google/dart

WORKDIR /application

ADD pubspec.* /application/
RUN pub get
ADD . /application
RUN pub get --offline

ENTRYPOINT ["pub", "run", "test"]
