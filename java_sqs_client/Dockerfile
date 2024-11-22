# Stage 1: Build stage
FROM maven:3.8.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven configuration and source code
COPY pom.xml ./
COPY src ./src

# Build the Java application using Maven
RUN mvn clean package -DskipTests

# Stage 2: Runtime stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/imagegenerator-0.0.1-SNAPSHOT.jar app.jar

# Set environment variable for SQS Queue URL
ENV SQS_QUEUE_URL=""

# Default command to run the Java application
ENTRYPOINT ["java", "-jar", "app.jar"]
