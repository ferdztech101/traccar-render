# FerdzTech — Render-compatible Traccar build
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

# Download and install Traccar
RUN apt-get update && apt-get install -y wget unzip && \
    wget -O traccar.zip https://github.com/traccar/traccar/releases/download/v6.10.0/traccar-linux-64-6.10.0.zip && \
    unzip traccar.zip && rm traccar.zip && \
    chmod +x traccar.run && \
    ./traccar.run --target /opt/traccar/install --noexec && \
    mv /opt/traccar/install/* . && rm -rf /opt/traccar/install && \
    mkdir -p /opt/traccar/data /opt/traccar/logs && chmod -R 777 /opt/traccar/data /opt/traccar/logs

# Document ports for clarity (Render auto-detects the one you actually use)
EXPOSE 8082
EXPOSE 5055

# --- Run-time command ---
CMD ["bash", "-c", "\
CONF=/opt/traccar/conf/traccar.xml; \
mkdir -p /opt/traccar/data /opt/traccar/logs; chmod -R 777 /opt/traccar/data /opt/traccar/logs; \
if [ ! -f $CONF ]; then echo '<properties></properties>' > $CONF; fi; \
sed -i '/<entry key=\"web.port\">/d' $CONF; \
sed -i '/<properties>/a <entry key=\"web.port\">'${PORT:-8080}'</entry>' $CONF; \
sed -i '/<entry key=\"web.address\">/d' $CONF; \
sed -i '/<properties>/a <entry key=\"web.address\">0.0.0.0</entry>' $CONF; \
echo '🌍 Starting Traccar on port:' ${PORT:-8080}; \
java -Djava.net.preferIPv4Stack=true -jar tracker-server.jar $CONF"]


