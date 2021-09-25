FROM armpits/raspbian-buster-lite-armhf:latest

MAINTAINER Baba Orhum

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

RUN git clone git://github.com/OpenArena/engine.git && cd engine && make -j4
RUN mkdir -p /opt/openarena && mv /engine/build/release-linux-armv7l/* /opt/openarena/
RUN rm -r /engine
RUN wget "http://download.tuxfamily.org/openarena/rel/088/openarena-0.8.8.zip" && unzip baseoa.zip && mv /baseoa/* /opt/openarena/baseoa/
RUN rm baseoa.zip && rm -r /baseoa && apt -y clean && apt -y autoremove && mkdir data

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY ./conf/server1.cfg /data/server1.cfg
COPY ./conf/maprotation1.cfg /data/maprotation1.cfg
COPY ./conf/motd.cfg /data/motd.cfg

RUN chmod +x /docker-entrypoint.sh && chmod +x /opt/openarena/oa_ded.armv7l

EXPOSE 27950/udp
EXPOSE 27960/udp

ENTRYPOINT ["/docker-entrypoint.sh"]
