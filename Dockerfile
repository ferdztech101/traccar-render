# FerdzTech Auto-Fix Dockerfile for Traccar v6.10.0
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

# Install dependencies and download Traccar
RUN apt-get update && apt-get install -y wget unzip && \
    wget https://github.com/traccar/traccar/releases/download/v6.10.0/traccar-linux-64-6.10.0.zip && \
    unzip traccar-linux-64-6.10.0.zip && \
    rm traccar-linux-64-6.10.0.zip && \
    # Move contents dynamically from extracted folder (wherever the .jar resides)
    JAR_PATH=$(find . -type f -name "tracker-server.jar" | head -n 1) && \
    JAR_DIR=$(dirname "$JAR_PATH") && \
    mv "$JAR_DIR"/* . && rm -rf "$JAR_DIR"

EXPOSE 8082
EXPOSE 5055

# Run Traccar with explicit absolute path
CMD ["bash", "-c", "java -jar /opt/traccar/tracker-server.jar /opt/traccar/conf/traccar.xml"]
