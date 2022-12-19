#!/usr/bin/bash

# FILENAME="dummy_input.txt"
# SPACE_SIZE=10
FILENAME="input.txt"
SPACE_SIZE=25

# Set up

BASE_PATH="./tmp"

if [ -d $BASE_PATH ]; then
    rm -rf $BASE_PATH
fi

mkdir $BASE_PATH

create_space() ( # subshell
    local TARGET_PATH=$1
    local NUM=$2
    local LEVEL=$3

    if [ $LEVEL -le 0 ]; then
        exit
    fi

    cd $TARGET_PATH

    for (( i=0; i < $NUM; ++i )) do
        mkdir $i
        create_space $i $NUM "$((LEVEL-1))"
    done
)

create_space $BASE_PATH $SPACE_SIZE 3

# End set up

# Queue

QUEUE="${BASE_PATH}/queue.txt"

rm -f $QUEUE
touch $QUEUE

num_in_queue() {
    local res=$(wc -l < $QUEUE)
    echo $res
}

enqueue() {
    local X=$1
    local Y=$2
    local Z=$3

    echo "${X} ${Y} ${Z}" >> $QUEUE
}

dequeue() {
    res=$(head -n 1 $QUEUE)
    sed -i '1d' $QUEUE
    echo $res
}

# End queue

# Point helpers

add_point() {
    local X=$1
    local Y=$2
    local Z=$3

    local TARGET_PATH="${BASE_PATH}/${X}/${Y}/${Z}"

    rm "${TARGET_PATH}/POINT" 2> /dev/null
    rm "${TARGET_PATH}/AIR" 2> /dev/null
    touch "${TARGET_PATH}/POINT"
}

add_air() {
    local X=$1
    local Y=$2
    local Z=$3

    local TARGET_PATH="${BASE_PATH}/${X}/${Y}/${Z}"

    rm "${TARGET_PATH}/AIR" 2> /dev/null
    rm "${TARGET_PATH}/POINT" 2> /dev/null
    touch "${TARGET_PATH}/AIR"
}

remove_point() {
    local X=$1
    local Y=$2
    local Z=$3

    local TARGET_PATH="${BASE_PATH}/${X}/${Y}/${Z}"

    rm "${TARGET_PATH}/POINT" 2> /dev/null
}

remove_air() {
    local X=$1
    local Y=$2
    local Z=$3

    local TARGET_PATH="${BASE_PATH}/${X}/${Y}/${Z}"

    rm "${TARGET_PATH}/AIR" 2> /dev/null
}

has_point()  {
    local X=$1
    local Y=$2
    local Z=$3

    if [ $X -le -1 ] || [ $X -ge $SPACE_SIZE ]; then
        return 0 # true
    fi

    if [ $Y -le -1 ] || [ $Y -ge $SPACE_SIZE ]; then
        return 0 # true
    fi

    if [ $Z -le -1 ] || [ $Z -ge $SPACE_SIZE ]; then
        return 0 # true
    fi

    local TARGET_PATH="${BASE_PATH}/${X}/${Y}/${Z}"

    if [ -f "${TARGET_PATH}/POINT" ]; then
        return 0 # true
    else
        return 1 # false
    fi
}

has_air()  {
    local X=$1
    local Y=$2
    local Z=$3

    if [ $X -le -1 ] || [ $X -ge $SPACE_SIZE ]; then
        return 1 # false
    fi

    if [ $Y -le -1 ] || [ $Y -ge $SPACE_SIZE ]; then
        return 1 # false
    fi

    if [ $Z -le -1 ] || [ $Z -ge $SPACE_SIZE ]; then
        return 1 # false
    fi

    local TARGET_PATH="${BASE_PATH}/${X}/${Y}/${Z}"

    if [ -f "${TARGET_PATH}/AIR" ]; then
        return 0 # true
    else
        return 1 # false
    fi
}

remove_air_bulk() {
    enqueue $1 $2 $3

    local NUM=$(num_in_queue)

    while [ $NUM -gt 0 ]
    do
        local LINE=$(dequeue)

        read -r -a arr <<< $LINE

        local X=${arr[0]}
        local Y=${arr[1]}
        local Z=${arr[2]}

        NUM=$(num_in_queue)

        if ! has_air $X $Y $Z; then continue; fi
        remove_air $X $Y $Z

        enqueue $((X-1)) $Y $Z
        enqueue $((X+1)) $Y $Z
        enqueue $X $((Y-1)) $Z
        enqueue $X $((Y+1)) $Z
        enqueue $X $Y $((Z-1))
        enqueue $X $Y $((Z+1))

        NUM=$(num_in_queue)
    done
}

invert_point() {
    local X=$1
    local Y=$2
    local Z=$3

    if has_point $X $Y $Z; then
        remove_point $X $Y $Z
    else
        add_point $X $Y $Z
    fi
}

find_surface_area_at() {
    local X=$1
    local Y=$2
    local Z=$3

    local res=6
    if has_point $((X-1)) $Y $Z; then ((res-=1)); fi
    if has_point $((X+1)) $Y $Z; then ((res-=1)); fi
    if has_point $X $((Y-1)) $Z; then ((res-=1)); fi
    if has_point $X $((Y+1)) $Z; then ((res-=1)); fi
    if has_point $X $Y $((Z-1)); then ((res-=1)); fi
    if has_point $X $Y $((Z+1)); then ((res-=1)); fi

    echo $res
}

# End point helpers

TEMP_INPUT="${BASE_PATH}/temp_input.txt"
PARSED_INPUT="${BASE_PATH}/parsed_input.txt"

# Convert commas to spaces
sed 's/,/ /g' $FILENAME > $TEMP_INPUT

# Reset parsed input
rm -f $PARSED_INPUT
touch $PARSED_INPUT

# Lift every point 1 unit up all dimensions
while read -r LINE; do
    COORDS=($LINE)
    x=${COORDS[0]}
    y=${COORDS[1]}
    z=${COORDS[2]}
    echo "$((x+1)) $((y+1)) $((z+1))" >> $PARSED_INPUT
done < $TEMP_INPUT

while read -r LINE; do
    COORDS=($LINE)
    add_point ${COORDS[0]} ${COORDS[1]} ${COORDS[2]}
done < $PARSED_INPUT

TOTAL_SURFACE_AREA=0
while read -r LINE; do
    COORDS=($LINE)
    res=$(find_surface_area_at ${COORDS[0]} ${COORDS[1]} ${COORDS[2]})
    ((TOTAL_SURFACE_AREA+=res))
done < $PARSED_INPUT
echo Part 1: $TOTAL_SURFACE_AREA

# Fill all the air particles
for (( x=0; x < $SPACE_SIZE; ++x )) do
    for (( y=0; y < $SPACE_SIZE; ++y )) do
        for (( z=0; z < $SPACE_SIZE; ++z )) do
            if ! has_point $x $y $z ; then
                add_air $x $y $z
            fi
        done
    done
done

# Remove outmost air starting from origin
remove_air_bulk 0 0 0

# Replace all remaining air with points
for (( x=0; x < $SPACE_SIZE; ++x )) do
    for (( y=0; y < $SPACE_SIZE; ++y )) do
        for (( z=0; z < $SPACE_SIZE; ++z )) do
            if has_air $x $y $z ; then
                add_point $x $y $z
            fi
        done
    done
done

# Find total surface area
TOTAL_SURFACE_AREA=0
while read -r LINE; do
    COORDS=($LINE)
    res=$(find_surface_area_at ${COORDS[0]} ${COORDS[1]} ${COORDS[2]})
    ((TOTAL_SURFACE_AREA+=res))
done < $PARSED_INPUT
echo Part 2: $TOTAL_SURFACE_AREA
