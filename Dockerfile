FROM openjdk:21-jdk-slim

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# Includes wait-for-it.sh and entrypoint.sh
COPY . ./
RUN chmod +x ./wait-for-it.sh ./entrypoint.sh

# entrypoint will run wait-for-it
ENTRYPOINT ["./entrypoint.sh"]