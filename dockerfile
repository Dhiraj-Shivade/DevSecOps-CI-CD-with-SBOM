# A minimal JDK 17 base image
FROM eclipse-temurin:17-jdk-alpine

# Environment variable for the application home directory
ENV APP_HOME=/usr/src/app

# Set the working directory
WORKDIR $APP_HOME

# Copy the application JAR file into the container
COPY target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]

