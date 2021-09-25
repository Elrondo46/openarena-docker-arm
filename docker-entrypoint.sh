#!/bin/bash

# Checks if external data config is present, and integrate
if [ ! -f /opt/openarena/baseoa/pak0.pak ]
then
	echo "[INFO] Openarena files not found downloading it..."
	wget "http://download.tuxfamily.org/openarena/rel/088/openarena-0.8.8.zip" && unzip openarena-0.8.8.zip && mv /openarena-0.8.8/baseoa/* /opt/openarena/baseoa/
        rm openarena-0.8.8.zip && rm -r /openarena-0.8.8 && apt -y clean && apt -y autoremove && mkdir data
fi

if [ -f /data/server1.cfg ]
then
	echo "[INFO] Found server configuration file, adding it to server"
	rm -f /opt/openarena/baseoa/server1.cfg
	ln -s /data/server1.cfg /opt/openarena/baseoa/server1.cfg
fi

if [ -f /data/maprotation1.cfg ]
then
	echo "[INFO] Found map rotation configuration file, adding it to server"
	rm -f /opt/openarena/baseoa/maprotation1.cfg
	ln -s /data/maprotation1.cfg /opt/openarena/baseoa/maprotation1.cfg
fi

if [ -f /data/motd.cfg ]
then
	echo "[INFO] Found motd configuration file, adding it to server"
	rm -f /opt/openarena/baseoa/motd.cfg
	ln -s /data/motd.cfg /opt/openarena/baseoa/motd.cfg
fi


# Checks if log file is present
if [ ! -f /data/server1.log ]
then
	echo "[INFO] There is no external log file, creating it and using it"
	touch /data/server1.log
	mkdir -p /root/.openarena/baseoa 2> /dev/null && ln -s /data/server1.log /root/.openarena/baseoa/server1.log
else
	echo "[INFO] A log file already exists, using it"
	rm -f /root/.openarena/baseoa/server1.log 2> /dev/null
	mkdir -p /root/.openarena/baseoa 2> /dev/null && ln -s /data/server1.log /root/.openarena/baseoa/server1.log
fi

# Lists external pk3 files and make symbolic links in the server's folder 
if [ -d /data ]
then
	cd /data && ls *.pk3 2> /dev/null 1> /tmp/list_pk3.txt

	while read i; do
		echo "[INFO] Found $i map file, adding it to server"
		ln -s /data/$i /opt/openarena/baseoa/$i
	done </tmp/list_pk3.txt
fi

# Starts the server
/opt/openarena/oa_ded.armv7l +set dedicated 1 +exec server1.cfg
