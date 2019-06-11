# Update local apt-get repo
FROM openjdk:9-jdk-slim as basecerts
RUN apt-get update && apt-get install --no-install-recommends -y -qq ca-certificates-java && update-ca-certificates 

# Import Certificate
FROM basecerts as copycert
WORKDIR /home/java
COPY certificates /usr/local/share/ca-certificates/certificates
RUN groupadd --gid 1000 java

# Setup user iddocker imagte
FROM copycert as setupuid
RUN  useradd --uid 1000 --gid java --shell /bin/bash --create-home java && chmod -R a+w /home/java

# Import certificate
FROM setupuid
RUN keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias mycert -file /usr/local/share/ca-certificates/certificates