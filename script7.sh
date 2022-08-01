#!/bin/bash

# $1: data file
# $2: update file

output=""

while read updateLine
do
    if [ "$updateLine" == "\"MachineID\",\"Item\",\"Operation\"" ]
    then
        continue
    else
        upLineArr=(`echo $updateLine | tr ',' ' '`)
        # upLineArr[0] is MachineID
        # upLineArr[1] is Item
        # upLineArr[2] is Operation
        echo "----------------------------------------------------"
        echo "MachineID: ${upLineArr[0]}"
        echo "Item: ${upLineArr[1]}"
        echo "Operation: ${upLineArr[2]}"
        echo ""
        # print the data file header
        head -n1 $1
        # get the header of the data file
        dataHeaderArr=(`head -n1 $1 | tr ',' ' '`)
        # echo "dataHeaderArr: ${dataHeaderArr[@]}"
        
        # get the data file line with the same MachineID
        # can get multiple matches if there are multiple lines with the same MachineID
        dataLineArr=(`sed -n "/${upLineArr[0]}/p" $1 | xargs -I {} -n 1 echo {} | tr ',' ' '`)

        # check if MachineID is in the data file
        if cat "$1" | grep -q "${upLineArr[0]}"
        then
            # check if the item is in the data file
            #if not, add it to the data file
            index=0
            for i in "${dataHeaderArr[@]}"; do
                if [ "$i" == "${upLineArr[1]}" ]
                then
                    
                    # echo "found at index $index"
                    
                    echo "Before:" ${dataLineArr[@]}
                    
                    if echo "${upLineArr[2]}" | grep -q "^[+-]"
                    then
                        # if the operation is + or -, then it is a increment operation
                        # increment the value by the value in the update file
                        dataLineArr[$index]=$((${dataLineArr[$index]}+${upLineArr[2]}))
                    
                    else
                        # if the operation is not + or -, then it is a set operation
                        # set the value to the value in the update file
                        dataLineArr[$index]=${upLineArr[2]}
                    fi
                    echo "After: " ${dataLineArr[@]}
                    # line=$(echo ${dataLineArr[@]} | tr ' ' ',')
                    # output=$output$line":"
                    
                fi
                index=$((index+1))
                
            done
        else 
            # if the MachineID is not in the data file, add it to the data file
            # add the item to the data file
            index=0
            for i in "${dataHeaderArr[@]}"; do
                if [ "$i" == "${upLineArr[1]}" ]
                then 
                
                break
                fi
                index=$((index+1))
            done
            
            echo "Before:" ${dataLineArr[@]} 
            # add the MachineID to the data file
            dataLineArr="${upLineArr[0]}"" ""${upLineArr[2]}"
            echo "After: " ${dataLineArr[@]}
            # line=$(echo ${dataLineArr[@]} | tr ' ' ',')
            # output=$output$line":"
            echo $dataLineArr | tr ' ' ',' >> $1
        fi
      fi
    # exit
done < $2
