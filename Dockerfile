FROM debian:bullseye-slim

#Install packages
RUN apt update && apt -y dist-upgrade && apt install -y make \
git \
libsdl1.2-dev \
libxmp-dev \
libsdl2-dev \
libgl1-mesa-dev \
build-essential \
libvorbis-dev \
zip \
unzip \
wget

RUN git clone https://github.com/OpenArena/engine.git && make -j4 -C ./engine
RUN mkdir -p /opt/openarena && mv /engine/build/release-linux-armv7l/* /opt/openarena/
RUN rm -r /engine

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY ./conf/server1.cfg /data/server1.cfg
COPY ./conf/maprotation1.cfg /data/maprotation1.cfg
COPY ./conf/motd.cfg /data/motd.cfg

RUN chmod +x /docker-entrypoint.sh && mv /opt/openarena/oa_ded.armv7l /opt/openarena/oa_ded.arm && chmod +x /opt/openarena/oa_ded.arm

EXPOSE 27950/udp
EXPOSE 27960/udp

ENTRYPOINT ["/docker-entrypoint.sh"]
