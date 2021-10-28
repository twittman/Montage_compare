wait_for_jobs() {
    local JOBLIST=($(jobs -p))
    if [ "${#JOBLIST[@]}" -gt ${THREADS} ]; then
        for JOB in ${JOBLIST}; do
            wait ${JOB}
        done
    fi
}
read -e -p "Threads: " THREADS
#
# If Upscaled image name contains long iteration number, reduce length by 3 and add a K      
read -e -p "`echo $'\n>'`Rename the Upscaled images? `echo $'\n>(Y)es .(N)o .(M)aby .(Q)uit .(R)estart: '`" reUP
if [[ $reUP == [Yy]* ]]; then
    read -e -p "Iterations: " iter1
        intermain="`awk -v var="${iter1:0:${#inter1}-3}" 'BEGIN { print var "k" }'`"
            for file in *.png; do
                if [[ $file = *${iter1}.png ]]; then
                    rename ${iter1} ${intermain} *.png
                    interK="`awk -v var="${iter1:0:${#iter1}-3}" 'BEGIN { print var "k" }'`"
                fi
            done
    elif [[ $reUP == [Nn]* ]]; then
        read -e -p "Iterations: " iter1
        interK="`awk -v var="${iter1:0:${#iter1}-3}" 'BEGIN { print var "k" }'`"
    elif [[ $reUP == [Mm]* ]]; then
        echo "Okay Boss!"
        read -e -p "End of the edited filename: " endFname
        interK="${endFname}"
    elif [[ $reUP == [Qq]* ]]; then
        echo "Ok, quitting now"
        sleep 1
        exit
    elif [[ $reUP == [Rr]* ]]; then
        sleep 0.5
        printf "Restarting Script."
        sleep 0.6
        printf "...Done"
        sleep 0.4
        ./$(basename $0)
    else
        read -e -p "Iterations: " iter1
fi

read -e -p "LR or HR? " lrORhr

checkForPercent1(){
    if [[ $lrUP != *[%] ]]; then
        echo -e "You forgot a \e[1m%\e[0m symbol..."
    sleep 0.7
        echo "Restarting Script..."
    sleep 0.5
        echo "Restarting Script.."
    sleep 0.4
        echo "Restarting Script."
    sleep 1 && ./$(basename $0)
fi
}
checkForPercent2(){
    if [[ $gblUP != *[%] ]]; then
        echo -e "You forgot a \e[1m%\e[0m symbol..."
    sleep 0.7
        echo "Restarting Script..."
    sleep 0.5
        echo "Restarting Script.."
    sleep 0.4
        echo "Restarting Script."
    sleep 1 && ./$(basename $0)
fi
}
checkForPercent3(){
    if [[ $gblUP != *[%] ]]; then
        echo -e "You forgot a \e[1m%\e[0m symbol..."
    sleep 0.7
        echo "Restarting Script..."
    sleep 0.5
        echo "Restarting Script.."
    sleep 0.4
        echo "Restarting Script."
    sleep 1 && ./$(basename $0)
fi
}
#
# Ask what LR upscale and Overall upscale values should be      
read -e -p "Global Upscale: " gblUP
checkForPercent2
# Adds output of shortened iteration string      
#interK="`awk -v var="${iter1:0:${#iter1}-3}" 'BEGIN { print var "k" }'`"

#
# Calls the Montage script with Args      
MontG(){
    bash _Montage_text_2.sh -if="${file}" -is="${file2}" -io="${output}" -tf="${lrORhr}" -ts="${interK}" -td="2x1" -ug="${gblUP}"
    printf "\n\e[95m${file} \e[93mprocessed\e[0m\n"
}
#
# Asks if there are numbers ending the LR image filenames
read -p "Are there numbers at the end of the LR filenames? " yn
case $yn in
    [Yy]* ) input1="*[0-9]";;
    [Nn]* ) input1="*cropped";;
    * ) echo "Yes or No?";;
esac
for file in ${input1}.png
    do
        FILENAME=$(basename -- "$file")
        FL="${FILENAME%.*}"
        fWoSf="${FILENAME%_*}"
        fWoSf2="${fWoSf}.png"
        file2="${FL}_${interK}.png"
        output="${FL}_Montage_${interK}.png"
        
        printf "${fWoSf}\nPlease Wait..........\n" &&
        MontG &
        wait_for_jobs
        
    done
    wait
    rm -rf ".temp1"