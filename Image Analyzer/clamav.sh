#!/bin/bash
images=(
$(docker images | awk 'NR!=1{print $3}')
#$(docker images | awk 'NR!=1{print "["$1"]"$3}'|awk -F "/" '{print $1":"$2}' )
)


if [ ! -d "./imagesave" ]; then
  mkdir ./imagesave
fi

j=1
for i in ${images[*]}; do
echo $j
echo [$(date '+%Y-%m-%d %H:%M:%S')]
x=$(docker images|grep $i|awk '{print "["$1"]"$3}'|awk -F "/" '{print $1":"$2}')
echo "saving $x"
#x=$(docker images|grep $i|awk '{print "["$1"]"$3}'|awk -F "/" '{print $1":"$2}')
echo $(docker save $i > ./imagesave/$x.tar)
echo "remove $i"
docker rmi $i
((j+=1))


done

echo "clamscan!!!!!"
clamscan -r ./imagesave > clamscanresult


