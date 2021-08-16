FROM arm64v8/alpine

ARG VERSION=4.6.2.2472
#ARG REL=2472
#ARG FULL_VER=${VERSION}.${REL}
#ARG SOURCE

RUN apk update && apk update

RUN apk add maven openjdk11

WORKDIR /sonar-scanner-cli

RUN wget https://github.com/SonarSource/sonar-scanner-cli/archive/refs/tags/${VERSION}.tar.gz

RUN tar -xvzf ${VERSION}.tar.gz

WORKDIR sonar-scanner-cli-${VERSION}/

RUN mvn package 

RUN pwd

RUN ls -ls

FROM arm64v8/alpine
ARG VERSION=4.6.2.2472

RUN apk update && apk update

RUN apk add openjdk11

WORKDIR /sonar-scanner-cli

COPY --from=0 /sonar-scanner-cli/sonar-scanner-cli-${VERSION}/target/sonar-scanner-4.6.2-SNAPSHOT.zip /opt

WORKDIR /opt

RUN unzip sonar-scanner-4.6.2-SNAPSHOT.zip -d /opt/

RUN mv /opt/sonar-scanner-4.6.2-SNAPSHOT /opt/sonar-scanner-4.6.2/

RUN chmod 755 /opt/sonar-scanner-4.6.2/lib/*
RUN ls -l /opt/sonar-scanner-4.6.2/lib/*

ENTRYPOINT ["/opt/sonar-scanner-4.6.2/bin/sonar-scanner"]