# === FerdzTech Traccar v6.10.0 (Stable & Verified) ===
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

RUN apt-get update && apt-get install -y wget unzip && \
    wget https://github.com/traccar/traccar/releases/download/v6.10.0/traccar-linux-64-6.10.0.zip && \
    unzip traccar-linux-64-6.10.0.zip && \
    rm traccar-linux-64-6.10.0.zip && \
    mv traccar-linux-64-6.10.0/* . && \
    rm -rf traccar-linux-64-6.10.0

EXPOSE 8082
EXPOSE 5055

CMD ["bash", "-c", "ls -la /opt/traccar && java -jar /opt/traccar/tracker-server.jar /opt/traccar/conf/traccar.xml"]
