FROM registry.access.redhat.com/rhel7.3

MAINTAINER Joshua T. Pyle <Jpyle@woodmen.org>

ENV SERVER_PORT 8080
ENV MANAGEMENT_PORT 8081
ENV JAVA_VERSON 1.8.0
ENV GRADLE_VERSION 3.4

EXPOSE $SERVER_PORT
EXPOSE $MANAGEMENT_PORT

LABEL io.k8s.description="Platform for building and running Spring Boot applications" \
      io.k8s.display-name="Spring Boot Gradle 3" \
      io.openshift.expose-services="8080:server,8081:actuator" \
      io.openshift.tags="builder,java,java8,gradle,gradle3,springboot" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

RUN yum update -y && \
  yum install -y wget && \
  yum install -y unzip && \
  yum install -y java-$JAVA_VERSON-openjdk.x86_64 java-$JAVA_VERSON-openjdk-devel.x86_64 && \
  yum clean all

RUN wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -O gradle.zip \
  && unzip gradle.zip -d /usr/share \
  && rm gradle.zip \
  && mv /usr/share/gradle-$GRADLE_VERSION /usr/share/gradle \
  && ln -s /usr/share/gradle/bin/gradle /usr/bin/gradle
# wget http://www.vim.org/scripts/download_script.php?src_id=11834 -O temp.zip; unzip temp.zip; rm temp.zip

# Add configuration files, bashrc and other tweaks
# TODO test using $S2I_SCRIPTS_PATH instead of /usr/libexec/s2i
COPY ./.s2i/bin/ /usr/libexec/s2i

ENV JAVA_HOME /usr/lib/jvm/java
ENV GRADLE_HOME /usr/share/gradle
ENV GRADLE_USER_HOME /opt/app-root

RUN mkdir -p /opt/app-root && \
    chown -R 1001:1001 /opt/app-root && \
    chown -R 1001:1001 /usr/libexec/s2i

USER 1001

# Set the default CMD to print the usage of the language image
# TODO test using $S2I_SCRIPTS_PATH instead of $STI_SCRIPTS_PATH
CMD $STI_SCRIPTS_PATH/usage
