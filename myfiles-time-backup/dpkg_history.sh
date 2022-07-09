#!/bin/bash

DPKG_DIR="dpkg.list"
[ -d $REMOTEDIR/$DPKG_DIR ] || mkdir -p $REMOTEDIR/$DPKG_DIR

RemoveDuplicateFile() {
    FILES="$1"
    PREFILE=

    for tFile in $FILES
    do
        if [[ $PREFILE == "" ]]; then
            PREFILE=$tFile
            continue
        fi

        # echo "Check different $PREFILE with $tFile ..."
        if diff "$PREFILE" "$tFile" > /dev/null ; then
            # echo "Same."
            rm "$PREFILE"
        else
            echo "Different."
        fi

        PREFILE=$tFile
    done
}

dpkg -l > "$REMOTEDIR/$DPKG_DIR/dpkg.list_$DATE"
dpkg --get-selections > "$REMOTEDIR/$DPKG_DIR/apt-get.list_$DATE"
RemoveDuplicateFile "$REMOTEDIR/$DPKG_DIR/apt-get.list_*"
RemoveDuplicateFile "$REMOTEDIR/$DPKG_DIR/dpkg.list_*"
