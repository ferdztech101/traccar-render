# === FerdzTech Verified Traccar v6.10.0 Dockerfile (Stable for Render) ===
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

EXPOSE 8082
EXPOSE 5055

# --- FIX: safe config creation + web binding ---
CMD ["bash", "-c", "\
if [ ! -f /opt/traccar/conf/traccar.xml ]; then \
  echo '<properties></properties>' > /opt/traccar/conf/traccar.xml; \
fi && \
grep -q 'web.port' /opt/traccar/conf/traccar.xml || \
  sed -i '/<properties>/a <entry key=\"web.port\">${PORT:-8082}</entry>' /opt/traccar/conf/traccar.xml && \
grep -q 'web.address' /opt/traccar/conf/traccar.xml || \
  sed -i '/<properties>/a <entry key=\"web.address\">0.0.0.0</entry>' /opt/traccar/conf/traccar.xml && \
echo '🌍 Starting Traccar on 0.0.0.0:' ${PORT:-8082} && \
java -jar tracker-server.jar /opt/traccar/conf/traccar.xml"]
