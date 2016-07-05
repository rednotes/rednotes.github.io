#!/bin/bash
# echo $1
newname=`date +%Y-%m-%d-`$1.markdown
echo "Created: " $newname
cp ./template.markdown ./$newname
