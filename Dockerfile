# === FerdzTech Traccar Render Build (Stable 5.12) ===
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

RUN apt-get update && apt-get install -y wget unzip && \
    wget https://github.com/traccar/traccar/releases/download/v5.12/traccar-linux-64.zip && \
    unzip traccar-linux-64.zip && rm traccar-linux-64.zip

EXPOSE 8082
EXPOSE 5055

CMD ["java", "-jar", "tracker-server.jar", "conf/traccar.xml"]
