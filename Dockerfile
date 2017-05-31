FROM centos:7

MAINTAINER Joshua T. Pyle <Jpyle@woodmen.org>

ENV SERVER_PORT=8080 \
    MANAGEMENT_PORT=8081

EXPOSE $SERVER_PORT
EXPOSE $MANAGEMENT_PORT

LABEL io.k8s.description="Platform for building and running Spring Boot applications" \
      io.k8s.display-name="Spring Boot Gradle 3" \
      io.openshift.expose-services="8080:server,8081:actuator" \
      io.openshift.tags="builder,java,java8,gradle,gradle3,springboot" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

RUN yum update -y && \
  yum install -y wget && \
  yum install -y unzip

# Java Install
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=131 \
    JAVA_VERSION_BUILD=11 \
    JAVA_URL_HASH=d54c1d3a095b4ff2b6607d096fa80163

RUN yum update -y && \
    yum install -y wget && \
    yum install -y bash && \
    wget --no-cookies --no-check-certificate \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_URL_HASH}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm && \
    yum localinstall -y /tmp/jdk-8-linux-x64.rpm && \
    alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000 && \
    alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000 && \
    alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000 && \
    rm -f /tmp/jdk-8-linux-x64.rpm && \
    yum clean all

# Gradle Install
ENV GRADLE_VERSION 3.4
RUN wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -O gradle.zip \
  && unzip gradle.zip -d /usr/share \
  && rm gradle.zip \
  && mv /usr/share/gradle-$GRADLE_VERSION /usr/share/gradle \
  && ln -s /usr/share/gradle/bin/gradle /usr/bin/gradle

# TODO test using $S2I_SCRIPTS_PATH instead of /usr/libexec/s2i
COPY ./.s2i/bin/ /usr/libexec/s2i

RUN mkdir -p /opt/app-root && \
    chown -R 1001:1001 /opt/app-root && \
    chown -R 1001:1001 /usr/libexec/s2i && \
    chmod +x /usr/libexec/s2i/* && \
    useradd -u 1001 dockuser

ENV JAVA_HOME=/usr/java/latest \
    GRADLE_HOME=/usr/share/gradle

USER 1001

# Set the default CMD to print the usage of the language image
# TODO test using $S2I_SCRIPTS_PATH instead of $STI_SCRIPTS_PATH
CMD $STI_SCRIPTS_PATH/usage
