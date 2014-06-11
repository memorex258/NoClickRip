#!/bin/bash

FINAL_DESTINATION="/media/sdc/movies"
OUTPUT_DIR="/tmp/ripdvd"
SOURCE_DRIVE="/dev/sr0"
HANDBRAKE_PRESET="Normal"
EXTENSION="mp4"

function rip_dvd() {

       # Grab the DVD title
        DVD_TITLE=$(blkid -o value -s LABEL $SOURCE_DRIVE)

        # Replace spaces with underscores
        DVD_TITLE=${DVD_TITLE// /_}

        if [  -z "$DVD_TITLE" ]
          then
            notify "ERROR" "No DVD found in drive $SOURCE_DRIVE."
            exit
        fi


      # CALCULATE EPISODES
      ####################
      TITLE_COUNT=$(lsdvd $SOURCE_DRIVE | grep ^'Title: ' | wc -l)
      EPISODE_COUNT=0

      for (( i=1; i<=$TITLE_COUNT; i++ ))
        do
          # Grab the title string
          TITLE_STRING=$(lsdvd $SOURCE_DRIVE -t $i )
          REGEX="Length: ([0-9]+):([0-9]+)"

          # find the length
          if [[ $TITLE_STRING =~ $REGEX  ]]
            then
            HOURS="${BASH_REMATCH[1]}"
			MINUTES="${BASH_REMATCH[2]}"

            # if it's between 15 & 59 minutes, its an episode
            if [ $MINUTES -gt 15 ] && [ $MINUTES -lt 59 ]
              then
                EPISODE_COUNT=$(($EPISODE_COUNT+1))
            fi
          fi
       done


       if [ $EPISODE_COUNT -gt 1 ]
       then
           # if it's a TV show, notify and eject the disk, then exit
           notify "DVD Rip" "Detected TV show, quitting"
           eject $SOURCE_DRIVE
           exit
       fi

	      notify "DVD Rip" "Started ripping $DVD_TITLE"

        # Backup the DVD to out hard drive
        dvdbackup -i $SOURCE_DRIVE -o $OUTPUT_DIR -M -n $DVD_TITLE

        # Once we're done, eject the disk
        eject $SOURCE_DRIVE

        notify "DVD Rip" "Finished ripping $DVD_TITLE to $OUTPUT_DIR."

        # grep for the HandBrakeCLI process and get the PID
        HANDBRAKE_PID=`ps aux|grep H\[a\]ndBrakeCLI`
        set -- $HANDBRAKE_PID
        HANDBRAKE_PID=$2

		 # Wait until our previous Handbrake job is done
        if [ -n "$HANDBRAKE_PID" ]
        then
                while [ -e /proc/$HANDBRAKE_PID ]; do sleep 1; done
        fi

        # And now we can start encoding
        HandBrakeCLI -i $OUTPUT_DIR/$DVD_TITLE -o $OUTPUT_DIR/$DVD_TITLE.$EXTENSION --preset=$HANDBRAKE_PRESET --main-feature

        if [ ! -f "$OUTPUT_DIR/$DVD_TITLE.$EXTENSION" ]
          then
            notify "ERROR" "HandBrake failed to encode $DVD_TITLE. Assumed copy protected."
            exit
        fi


        # Move into final destination
        mv $OUTPUT_DIR/$DVD_TITLE.$EXTENSION $FINAL_DESTINATION

        notify "DVD Rip" "Finished encoding $DVD_TITLE."

        # Clean up
        rm $OUTPUT_DIR/$DVD_TITLE
}

rip_dvd
