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
      io.openshift.tags="builder,java,java8,gradle,gradle3,springboot"

RUN yum update -y && \
  yum install -y curl && \
  yum install -y unzip && \
  yum install -y java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel && \
  yum clean all

RUN curl -fsSL https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip | unzip -v - -d /usr/share \
  && mv /usr/share/gradle-$GRADLE_VERSION /usr/share/gradle \
  && ln -s /usr/share/gradle/bin/gradle /usr/bin/gradle

# Add configuration files, bashrc and other tweaks
COPY ./.s2i/bin/ $STI_SCRIPTS_PATH

RUN chown -R 1001:0 /opt/app-root
USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage