Spring Boot with Gradle build - CentOS/RHEL Docker image
========================================================

This repository contains the s2i source for building a [Spring Boot](https://projects.spring.io/spring-boot/) application with [Gradle](https://gradle.org/) and then executing the resulting "fat" jar.  It sets a few environment variables that typical spring boot applications will make use of. 

The centos image is available on DockerHub
```
docker pull woodmenlife/springboot-gradle-s2i:latest
```

Important Environment Variables
-------------------------------

&#35; Used to set the port that the spring boot application will run on.

ENV SERVER_PORT 8080

&#35; Used to set the management port that things like actuator will be accessible through.

ENV MANAGEMENT_PORT 8081

Pushing to Docker Hub
-------------------------------
```
$ docker build -t woodmenlife/springboot-gradle-s2i .
$ docker push woodmenlife/springboot-gradle-s2i
```

Copyright
--------------------

Released under the Apache License 2.0. See the [LICENSE](LICENSE) file.
