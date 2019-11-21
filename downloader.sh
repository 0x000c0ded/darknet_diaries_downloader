#!/bin/bash
n=`curl -s https://darknetdiaries.com/ | grep "https://darknetdiaries.com/episode/[0-9]\+/" | cut -d '/' -f5`
echo "[*] There are $n episodes available"
for i in $(seq 1 $n); do
	response=`curl -s "https://darknetdiaries.com/episode/$i/" | grep '"mp3"\|"title"' | cut -d '"' -f4 | tr '\n' ';'`
	url=`echo "$response" | cut -d ';' -f1`
	ep_name=`echo "$response" | cut -d ';' -f2`
	echo "[+] Downloading episode \"$ep_name\" from \"$url\""
	wget "$url" -O "${ep_name}.mp3"
done
