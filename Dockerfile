# Update local apt-get repo
FROM openjdk:9-jdk-slim as basecerts
RUN apt-get update

# Install Pre-req
FROM basecerts as updatecertstore
RUN apt-get install --no-install-recommends -y -qq ca-certificates-java && update-ca-certificates 

# Import Certificate
FROM updatecertstore as importcert
WORKDIR /home/java
COPY certificates /usr/local/share/ca-certificates/certificates
RUN groupadd --gid 1000 java

# Setup user id
FROM importcert as setupuid
RUN  useradd --uid 1000 --gid java --shell /bin/bash --create-home java

# Implement Read/write permissions
FROM setupuid
RUN chmod -R a+w /home/java
