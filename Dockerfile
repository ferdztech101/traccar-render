# === FerdzTech Traccar v6.10.0 Universal Auto-Fix Dockerfile ===
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

RUN apt-get update && apt-get install -y wget unzip && \
    wget -O traccar.zip https://github.com/traccar/traccar/releases/download/v6.10.0/traccar-linux-64-6.10.0.zip && \
    unzip traccar.zip && \
    rm traccar.zip && \
    # Move tracker-server.jar up if it's inside a subdirectory
    if [ -f tracker-server.jar ]; then echo "Traccar jar found in root"; \
    else \
        JAR_DIR=$(find . -type f -name "tracker-server.jar" -exec dirname {} \; | head -n 1) && \
        echo "Moving files from $JAR_DIR" && \
        mv "$JAR_DIR"/* . && rm -rf "$JAR_DIR"; \
    fi

EXPOSE 8082
EXPOSE 5055

CMD ["bash", "-c", "ls -la /opt/traccar && java -jar /opt/traccar/tracker-server.jar /opt/traccar/conf/traccar.xml"]
