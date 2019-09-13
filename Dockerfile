FROM maven:3-alpine as builder
USER root
WORKDIR /app
COPY . .
COPY settings.xml /root/.m2/
RUN mvn package

FROM openjdk:8-alpine
COPY --from=builder /app/target/spring-petclinic-2.1.0.BUILD-SNAPSHOT.jar app.jar
CMD ["java", "-jar", "app.jar"]
