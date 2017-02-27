# registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift
FROM openshift/base-centos7
#FROM registry.access.redhat.com/rhel7

MAINTAINER Joshua T. Pyle <JPyle@woodmen.org>

ENV BUILDER_VERSION 0.9

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building WoodmenLife spring boot gradle applications" \
      io.k8s.display-name="builder 0.9.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,0.9.0"

# TODO: Install required packages here:
# java-1.8.0-openjdk-devel.x86_64
RUN yum install -y java-1.8.0-openjdk-devel.x86_64 && yum clean all -y

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./.s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["usage"]
