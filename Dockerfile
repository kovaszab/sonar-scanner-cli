FROM arm64v8/alpine

ARG VERSION=4.6.2
ARG REL=2472
ARG FULL_VER=${VERSION}.${REL}

RUN apk update && apk update

RUN apk add maven openjdk11

WORKDIR /sonar-scanner-cli

RUN wget https://github.com/SonarSource/sonar-scanner-cli/archive/refs/tags/${FULL_VER}.tar.gz

RUN tar -xvzf ${FULL_VER}.tar.gz

WORKDIR sonar-scanner-cli-${FULL_VER}/

RUN mvn package 


FROM arm64v8/alpine
ARG VERSION=4.6.2
ARG REL=2472
ARG FULL_VER=${VERSION}.${REL}

RUN apk update && apk update

RUN apk add openjdk11

WORKDIR /sonar-scanner-cli

COPY --from=0 /sonar-scanner-cli/sonar-scanner-cli-${FULL_VER}/target/sonar-scanner-${VERSION}-SNAPSHOT.zip /opt

WORKDIR /opt

RUN unzip sonar-scanner-${VERSION}-SNAPSHOT.zip -d /opt/

RUN rm sonar-scanner-${VERSION}-SNAPSHOT.zip 

RUN mv /opt/sonar-scanner-${VERSION}-SNAPSHOT /opt/sonar-scanner/

RUN chmod 755 /opt/sonar-scanner/lib/*

ENTRYPOINT ["/opt/sonar-scanner/bin/sonar-scanner"]