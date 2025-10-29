# === FerdzTech Traccar Render Build (Stable 5.12) ===
FROM openjdk:17-jdk-slim

WORKDIR /opt/traccar

RUN apt-get update && apt-get install -y wget unzip curl && \
    curl -s https://api.github.com/repos/traccar/traccar/releases/latest \
    | grep "browser_download_url.*64.zip" \
    | cut -d '"' -f 4 \
    | xargs wget && \
    unzip *.zip && rm *.zip

EXPOSE 8082
EXPOSE 5055

CMD ["java", "-jar", "tracker-server.jar", "conf/traccar.xml"]

