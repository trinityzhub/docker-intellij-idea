#FROM ubuntu:18.04
FROM ubuntu:20.04


LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

ARG IDEA_VERSION=2023.1
ARG IDEA_BUILD=2023.1


RUN  \
  apt-get update && apt-get install --no-install-recommends -y

ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:17 $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt


RUN  \
  apt-get update && apt-get install --no-install-recommends -y 
RUN  apt-get install  gcc git openssh-client less ca-certificates curl -y
RUN  apt-get install  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev  --yes
RUN  apt-get install  libfontconfig1 --yes
# RUN  libgtk2.0-0  --yes
# RUN  libxslt1.1 --yes
# RUN  libxxf86vm1 -y
RUN rm -rf /var/lib/apt/lists/* \
  && useradd -ms /bin/bash developer


RUN echo "cacert=/etc/ssl/certs/ca-certificates.crt" >> ~/.curlrc


## https://download.jetbrains.com/idea/ideaIC-2023.1-aarch64.tar.gz
## https://download.jetbrains.com/idea/ideaIC-2023.1.tar.gz
ARG idea_source=https://download.jetbrains.com/idea/ideaIC-${IDEA_BUILD}.tar.gz
ARG idea_local_dir=.IdeaIC${IDEA_VERSION}

WORKDIR /opt/idea

RUN curl -fsSL $idea_source -o /opt/idea/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

USER developer
ENV HOME /home/developer

RUN mkdir /home/developer/.Idea \
  && ln -sf /home/developer/.Idea /home/developer/$idea_local_dir

CMD [ "/opt/idea/bin/idea.sh" ]
