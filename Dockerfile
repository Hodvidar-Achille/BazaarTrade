FROM openjdk:21-jdk-slim

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

 # ENTRYPOINT ["java", "-jar", "/app.jar"]

## Copy wait-for-it and entrypoint script into image and ensure they are executable
#COPY wait-for-it.sh entrypoint.sh /
#RUN chmod +x /wait-for-it.sh /entrypoint.sh

# Use our new entrypoint
# ENTRYPOINT ["./entrypoint.sh"]

# Includes wait-for-it.sh and entrypoint.sh
COPY . ./
RUN chmod +x ./wait-for-it.sh ./entrypoint.sh
EXPOSE 4555
# Add this line
# It _must_ use the JSON-array syntax
ENTRYPOINT ["./entrypoint.sh"]