#!/bin/bash

url="https://darknetdiaries.com/episode"
n=`curl --compressed -s https://darknetdiaries.com/ | grep "$url/[0-9]\+/" | cut -d'/' -f5`
echo "[*] There are $n episodes available"

for i in $(seq 1 $n); do
    response=`curl --compressed -s "$url/$i/" | grep '"mp3"\|"title"' | cut -d'"' -f4 | tr '\n' ';'`

    ep_url=`echo "$response" | cut -d';' -f1`
    ep_name=`echo "$response" | cut -d';' -f2`
    ep_file="${ep_name}.mp3"
    ep_size=`curl -sIL "$ep_url" | grep -i content-length | tail -n1 | cut -d' ' -f2 | tr -d '\r\n'`

    if [[ -f "$ep_file" && `wc -c < "$ep_file"` -eq "$ep_size" ]]; then
        echo "[+] \"${ep_file}\" already exists, skipping."
    else
        wget -q --show-progress "$ep_url" -O "${ep_file}"
    fi
done