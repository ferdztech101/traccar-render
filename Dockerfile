# === FerdzTech Traccar Render Build (v6.10.0 Stable) ===
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

RUN apt-get update && apt-get install -y wget unzip && \
    wget https://github.com/traccar/traccar/releases/download/v6.10.0/traccar-linux-64-6.10.0.zip && \
    unzip traccar-linux-64-6.10.0.zip && rm traccar-linux-64-6.10.0.zip

EXPOSE 8082
EXPOSE 5055

CMD ["java", "-jar", "tracker-server.jar", "conf/traccar.xml"]
