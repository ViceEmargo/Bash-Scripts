#!/bin/bash

if [ "$1" == "-h" -o "$1" == "--help" ]; then
	echo "Usage:"
	exit 0
fi

. /home/viceemargo/.bashrc
dir="/mnt/samba/share/TwitchVODs"
twitchDL="/home/viceemargo/.local/bin/twitch-dl"
currentdate=$(date +%Y-%m-%d)
date_dir=$(date +%m_%Y)
cd $dir
streamers=("pinballdude97")
if /home/viceemargo/.local/bin/twitch-dl -h &> /dev/null; then # Check if twitch-dl is installed by checking if command exits succesfully.
        echo "twitch-dl is installed"
else
        echo "twitch-dl is not installed"
        exit
fi >> /home/viceemargo/twitch-dl-logs/$currentdate-log.log
#videos=()
#videos=( $(twitch-dl videos $streamer | grep videos/ ) )
#echo ${streamers[@]}
for i in "${streamers[@]}"
        do
        cd $dir
                if [ -d ./$i ] # Checks if folder exists with name of streamer in this directory.
                then
                        echo "${directory}"/"${i} exists"
                        cd ./$i
                else
                        echo "${directory}"/"${i} does not exist, creating it now."
                        mkdir $i
                        cd ./$i
                fi

                if [ -d ./$date_dir ] # Check if folder exists for current month of the year.
                then
                        echo $date_dir
                        #cd ./$date_dir
                else
                        mkdir $date_dir
                        #cd ./$date_dir
                fi
        videos=( $(/home/viceemargo/.local/bin/twitch-dl videos --all $i | grep videos/ ) )
        printf "'%s'\n" "${videos[@]}" > /home/viceemargo/vodIDs.txt
        #cat /home/viceemargo/vodIDs.txt


        while read -u 9 v;
                do
                        numbers=$(echo $v | grep -o -E '[0-9]+' | grep "^1")
                        finds=$(find . -maxdepth 1 -name "*${numbers}*"| wc -l) # Find retrieves files with name matching the filter, wc -l counts the files?
                        echo $numbers
                        echo $finds
                        if [ $finds -eq 1 ]; then
                                echo "${numbers} was found"
                                pwd
                        else
                                /home/viceemargo/.local/bin/twitch-dl download $numbers --format mp4 --overwrite -q source -o "{date}_{title}_{id}.{format}"
                        fi
                done 9< /home/viceemargo/vodIDs.txt
done >> /home/viceemargo/twitch-dl-logs/$currentdate-log.log
