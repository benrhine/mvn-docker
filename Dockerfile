# Download java 11 based maven instance from dockerhub and give it a label
FROM maven:3.8.1-openjdk-11-slim AS MAVEN_TOOL_CHAIN
# Copy the local project pom to a temp location
COPY pom.xml /tmp/
# its a bit unclear how maven is now available here
# but use maven from the downloaded image and point it at the project pom in the temp location
# what does -s do?
RUN mvn -B dependency:go-offline -f /tmp/pom.xml -s /usr/share/maven/ref/settings-docker.xml
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package

# Download java 11 based image to run the application instance
FROM azul/zulu-openjdk-alpine:11

# Set the port we want available to docker to be exposed
# Note this does not mean 8080 is available from the browser without specifying extra arguments from the command line.
EXPOSE 8080

RUN mkdir /app
COPY --from=MAVEN_TOOL_CHAIN /tmp/target/*.jar /app/spring-boot-application.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]