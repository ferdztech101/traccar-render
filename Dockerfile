# === FerdzTech Traccar Render Build ===
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

RUN apt-get update && apt-get install -y wget unzip && \
    wget https://github.com/traccar/traccar/releases/latest/download/traccar-other-64.zip && \
    unzip traccar-other-64.zip && rm traccar-other-64.zip

EXPOSE 8082
EXPOSE 5055

CMD ["java", "-jar", "tracker-server.jar", "conf/traccar.xml"]
