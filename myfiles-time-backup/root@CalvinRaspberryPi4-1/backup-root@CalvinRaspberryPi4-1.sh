#!/bin/bash
# Add syntax to crontab file.
# 10 * * * *       root   if grep -qs /home/calvin/HD2 /proc/mounts; then bash /home/calvin/Work/shell-script/myfiles-time-backup/root@CalvinRaspberryPi4-1/backup-root@CalvinRaspberryPi4-1.sh; fi

# keep track of how long script takes to run
bench_start=$SECONDS
echo -e  '\E[37;44m'"\033[1mStart Backup!\033[0m"

SCRIPT_PATH=$(readlink -f $0)
DIR_PATH=$(dirname $SCRIPT_PATH)

cd $DIR_PATH

DATE=$(date +"%Y-%m-%d")
RSYNC_TIME_BIN="../rsync-time-backup/rsync_tmbackup.sh"
BACKUPTORNAME="time_backup_root@$HOSTNAME"
REMOTEDIR="/home/calvin/HD2/$BACKUPTORNAME" # Backup to where

[ -d $REMOTEDIR ] || mkdir -p $REMOTEDIR
[ -f "../dpkg_history.sh" ] && . ../dpkg_history.sh

shopt -s nullglob
FILES="$DIR_PATH/*.list"
for file in $FILES; do
    . $file
    if [ ! -d $SOURCE_DIR ]; then
        rm $TMP_FILE
        continue; 
    fi
    mkdir -p -- $REMOTEDIR/$TARGET_DIR
    touch "$REMOTEDIR/$TARGET_DIR/backup.marker"
    $RSYNC_TIME_BIN $SOURCE_DIR $REMOTEDIR/$TARGET_DIR $TMP_FILE
    rm $TMP_FILE
    echo "--- Backup next path ---"
done
shopt -u nullglob

bench_end=$SECONDS
total_time=$(expr $bench_end - $bench_start)
echo "Backup finished successfully [total time in seconds: $total_time]"
