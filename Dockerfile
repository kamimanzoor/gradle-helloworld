FROM maerskao.azurecr.io/alcl/gradle-7-jdk-11:1d53c5698fdee9210b67edfce98ba0686b96754a as builder

ARG GITHUB_ACTOR
ARG GITHUB_TOKEN

WORKDIR /app
COPY build.gradle settings.gradle /app/

RUN gradle clean build --no-daemon > /dev/null 2>&1 || true
COPY ./ /app/
RUN gradle build -x test --no-daemon

FROM maerskao.azurecr.io/alcl/openjdk-11:a07f67b6891a5a00721dcba6f90da71fac2021b0

WORKDIR /app
COPY --from=builder /app/build/libs/alcl-java-spring-boot-template-0.0.1.jar /app/alcl-java-spring-boot-template.jar

LABEL org.opencontainers.image.authors="Air and LCL <aravind.muralitharakannan@maersk.com>"

EXPOSE 8080

ENTRYPOINT [ "java", \
             "-javaagent:/dd-java-agent.jar", \
             "-Ddd.profiling.enabled=true", \
             "-XX:FlightRecorderOptions=stackdepth=256", \
             "-Ddd.logs.injection=true", \
             "-Ddd.trace.sample.rate=1", \
             "-jar", "/app/alcl-java-spring-boot-template.jar" ]
