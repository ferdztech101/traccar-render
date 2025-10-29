# === FerdzTech Safe Auto-Build for Traccar v6.10.0 (Render-Safe) ===
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

RUN set -eux; \
    apt-get update && apt-get install -y wget unzip && \
    wget -O traccar.zip https://github.com/traccar/traccar/releases/download/v6.10.0/traccar-linux-64-6.10.0.zip && \
    unzip traccar.zip && rm traccar.zip && \
    echo "🔍 Checking for tracker-server.jar..." && \
    if [ -f tracker-server.jar ]; then \
        echo "✅ tracker-server.jar found in current directory"; \
    else \
        SUBDIR=$(find . -maxdepth 1 -type d -name "traccar*" | head -n 1 || true); \
        if [ -n "$SUBDIR" ] && [ -d "$SUBDIR" ]; then \
            echo "📦 Moving contents from $SUBDIR"; \
            mv "$SUBDIR"/* . && rm -rf "$SUBDIR"; \
        else \
            echo "❌ tracker-server.jar not found after extraction" && ls -R && exit 1; \
        fi; \
    fi; \
    echo "✅ Traccar setup completed successfully"

EXPOSE 8082
EXPOSE 5055

CMD ["bash", "-c", "ls -la /opt/traccar && java -jar /opt/traccar/tracker-server.jar /opt/traccar/conf/traccar.xml"]
