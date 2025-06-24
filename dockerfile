# Using Gradle 7.4.2 with JDK 17 same as the gradle wrapper has
FROM gradle:7.4.2-jdk17 AS builder 
# Set the working directory
WORKDIR /app
# copy all the files
COPY . .
# build without the daemon
RUN gradle build --no-daemon
# Use a lighter image for the runtime
FROM openjdk:25-ea-17-jdk AS runtime
# Set the working directory
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/build/libs/*-all.jar app.jar
# Make the JAR file executable for owner
RUN chmod o+x app.jar
# Create a non-root user and group for running the application and set ownership
RUN groupadd --system daniel && \
    adduser --system -g daniel daniel && \
    chown -R daniel:daniel /app
# Switch to the non-root user
user daniel
# Launch the application entrypoint is fine because the JAR file isnt a process that needs to be run as a service
ENTRYPOINT ["java", "-jar", "app.jar"]