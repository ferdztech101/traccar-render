# === FerdzTech Verified Traccar v6.10.0 Dockerfile (Render Compatible) ===
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

RUN set -eux; \
    apt-get update && apt-get install -y wget unzip && \
    wget -O traccar.zip https://github.com/traccar/traccar/releases/download/v6.10.0/traccar-linux-64-6.10.0.zip && \
    unzip traccar.zip && rm traccar.zip && \
    chmod +x traccar.run && \
    echo "🚀 Running Traccar installer..." && \
    ./traccar.run --target /opt/traccar/install --noexec && \
    mv /opt/traccar/install/* . && rm -rf /opt/traccar/install && \
    echo "✅ Installation complete. Contents:" && ls -l && \
    if [ ! -f tracker-server.jar ]; then echo "❌ tracker-server.jar missing after install!" && exit 1; fi

# Document the ports for clarity
EXPOSE 8082    # Web UI
EXPOSE 5055    # Default device listener

# --- 🧠 Key Fix for Render: dynamically bind Traccar web.port to $PORT ---
CMD ["bash", "-c", "sed -i \"s|<entry key='web.port'>8082</entry>|<entry key='web.port'>${PORT:-8082}</entry>|\" /opt/traccar/conf/traccar.xml && echo '🌍 Starting Traccar on port' ${PORT:-8082} && java -jar tracker-server.jar /opt/traccar/conf/traccar.xml"]
