FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Correct exact JAR name from Maven build
COPY target/hello-jenkins-1.0-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]
