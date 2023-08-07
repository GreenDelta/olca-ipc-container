# Collect Maven dependencies
FROM maven:3.9.3-eclipse-temurin-17
WORKDIR /olca-ipc
COPY pom.xml .
RUN mvn package
