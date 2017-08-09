FROM redhat-openjdk-18/openjdk18-openshift

MAINTAINER Joshua T. Pyle <JPyle@woodmen.org>

ENV SERVER_PORT=8080 \
    MANAGEMENT_PORT=8081 \
    PATH="$PATH:"/usr/local/s2i"" \
    JAVA_DATA_DIR="/deployments/data" \
    GRADLE_HOME=/usr/share/gradle \
    JAVA_TOOL_OPTIONS=''

EXPOSE $SERVER_PORT $MANAGEMENT_PORT

LABEL name="woodmenlife/springboot-gradle-s2i" \
      version="1.0" \
      release="10" \
      architecture="x86_64" \
      io.openshift.expose-services="8080:server,8081:managment" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.k8s.description="Platform for building and running Spring Boot applications" \
      io.k8s.display-name="Spring Boot Gradle 3" \
      io.openshift.tags="builder,java,java8,gradle,gradle3,springboot" \
      io.openshift.s2i.destination="/tmp"

# instead of using wget to download the garadle zip perhaps
# use ADD to add from a local file.  Then USER 0 would no
# longer be neccessary.
USER root

RUN yum install -y wget

# Gradle Install
ENV GRADLE_VERSION 3.4
RUN wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -O gradle.zip \
  && unzip gradle.zip -d /usr/share \
  && rm gradle.zip \
  && mv /usr/share/gradle-$GRADLE_VERSION /usr/share/gradle \
  && ln -s /usr/share/gradle/bin/gradle /usr/bin/gradle

COPY ./.s2i/bin/ /usr/local/s2i

RUN chmod +x /usr/local/s2i/*

USER 185
CMD ["/usr/local/s2i/run"]
