# collect Maven dependencies
FROM maven:3.9.3-eclipse-temurin-17 AS mvn
WORKDIR /olca-ipc
COPY pom.xml .
RUN mvn package

# native libraries
FROM ghcr.io/greendelta/gdt-server-native AS native

# final image
FROM eclipse-temurin:17-jre
COPY --from=mvn /olca-ipc/target/lib /app/lib
COPY --from=native /app/native /app/native
COPY run.sh /app
RUN chmod +x /app/run.sh
ENTRYPOINT ["/app/run.sh"]
