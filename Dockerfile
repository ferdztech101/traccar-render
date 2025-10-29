# === FerdzTech Traccar Render Build (v6.10.0 Stable, fixed path) ===
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

RUN apt-get update && apt-get install -y wget unzip && \
    wget https://github.com/traccar/traccar/releases/download/v6.10.0/traccar-linux-64-6.10.0.zip && \
    unzip traccar-linux-64-6.10.0.zip && \
    find . -type f -name "tracker-server.jar" -exec dirname {} \; | head -n 1 | xargs -I {} mv {}/* . && \
    rm -rf traccar-linux-64-6.10.0* traccar-other* traccar-windows* traccar.run README.txt

EXPOSE 8082
EXPOSE 5055

CMD ["java", "-jar", "tracker-server.jar", "conf/traccar.xml"]

