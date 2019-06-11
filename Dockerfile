# Setup pre-req java cert store requirements
FROM openjdk:9-jdk-slim as basecerts
RUN apt-get update

FROM basecerts as updatecertstore
RUN apt-get install --no-install-recommends -y -qq ca-certificates-java && update-ca-certificates 

FROM updatecertstore as importcert
WORKDIR /home/java
COPY certificates /usr/local/share/ca-certificates/certificates
RUN groupadd --gid 1000 java &&\    useradd --uid 1000 --gid java --shell /bin/bash --create-home java && \    chmod -R a+w /home/java
