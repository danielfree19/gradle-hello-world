# Using Gradle 7.4.2 with JDK 17 same as the gradle wrapper has
FROM gradle:7.4.2-jdk17 AS builder 

WORKDIR /app

COPY . .

RUN gradle build --no-daemon

FROM openjdk:25-ea-17-jdk as runtime

WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/build/libs/*-all.jar app.jar

RUN chmod o+x app.jar

RUN groupadd --system daniel && \
    adduser --system -g daniel daniel && \
    chown -R daniel:daniel /app

user daniel

ENTRYPOINT ["java", "-jar", "app.jar"]