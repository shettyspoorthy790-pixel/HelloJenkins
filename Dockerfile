FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

COPY target/helloJenkins-1.0-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]
