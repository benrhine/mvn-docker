# Maven Docker Example

This is an extremely simple app created with https://start.spring.io that includes the Spring Web and Spring Boot Actuator
dependency. Once you have the project downloaded update the `MvnDcokerApplication` so it appears as follows...

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class MvnDockerApplication {

	public static void main(String[] args) {
		SpringApplication.run(MvnDockerApplication.class, args);
	}

	@GetMapping("/hello")
	public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
		return String.format("Hello %s!", name);
	}
}
```
It is now possible to run the app from terminal in the home directory using `mvn spring-boot:run`. Once the application
starts up 2 pages will be available. The actuator health check at `localhost:8080/actuator/health` and the hello page at
`localhost:8080/hello`.

The purpose of this repo is get a better understanding of how docker works and how to do multi-stage builds in order to
minimize the attack surface of your applications. The original article this is based on https://codefresh.io/docker-tutorial/java_docker_pipeline/
(Which links to this article: https://codefresh.io/docs/docs/learn-by-example/java/spring-boot-2/ and
https://github.com/codefresh-contrib/spring-boot-2-sample-app) originally only leverages Java 8 which is now well past
end of life. For experimental purposes there are two Java 8 based dockerfiles included. The only-package one requires
that you have previously run `mvn clean package` to build your jar. If you havent already built your jar then docker
will not be able to import your application. The second Java 8 dockerfile will do a multi-stage build using a docker
image that contains maven and Java 8 to build the application.

### Upgrade from Java 8 to 11
With a little bit of research and this article https://medium.com/@daniel.panagio18/first-steps-of-migrating-from-java-8-to-java-11-98ea9a5eafff
I have upgraded the default dockerfile to compile the application with a Java 11 based maven docker image and then execute
the app with a Java 11 based image.

To build the docker image
`docker build --no-cache -t mvn-docker-example-1 .`

To run the docker image
`docker run -p 8080:8080 mvn-docker-example-1`

If there are problems with the build you may need to tag the image first

`docker build -t mvn-docker-example-1 .`

##### Useful links
https://spring.io/quickstart

