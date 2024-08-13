#################################################
# First step: Build the application
#################################################
# Base image to use, this must be set as the first line
FROM maven:3.6.3-jdk-11 as builder

# The working directory inside the image to run commands
WORKDIR /app

# Copy the pom.xml and install dependencies
COPY pom.xml /app/

# Install dependencies
RUN mvn clean verify --fail-never

# Copy the source code
COPY src /app/src

# Build the application
RUN mvn clean package

#################################################
# Second step: Run the application
#################################################
FROM openjdk:11-jre-slim

# Working directory with jar file
WORKDIR /usr/app/

# Install wait-for-it.sh script
RUN apt-get update \ 
    && apt-get install -y curl \
    && curl -LJO https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    && chmod +x /usr/app/wait-for-it.sh

# Copy the jar file from the first stage
COPY --from=builder /app/target/*.jar /usr/app/

# Expose the port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "planner-v0.1.jar"]
