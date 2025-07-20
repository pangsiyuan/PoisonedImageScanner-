#!/bin/bash
images=($(awk '{print $1}' ./image_name/backdoor))
bash=($(awk '{print $1}' ./image_name/bash))
backdoor=($(awk '{print $1}' ./image_name/backdoor))


function download_images(){
mkdir dockerfile
cd dockerfile	
	j=1
	for i in ${images[*]}; do
	echo $j
	echo [$(date '+%Y-%m-%d %H:%M:%S')]
	echo "pulling $i"
	echo $(docker pull $i)

	if [ $(docker images | grep $i | wc -l) -gt 0 ];then
	echo "pulled $i"
	name=$(echo $i | awk -F "/" '{print $1":"$2}')
	docker history --no-trunc $i >  ./$name
	docker history --no-trunc $i >> ./merge.txt
	fi
	((j+=1))
	echo ""
	done

cd ..

}

function run_crontab(){
	j=1
	for i in ${crontab[*]}; do
	echo $j
	echo [$(date '+%Y-%m-%d %H:%M:%S')]
	
	if [ $(docker images | grep $i | wc -l) -gt 0 ];then
	name=$(echo $i | awk -F "/" '{print $1":"$2}')
	docker run -itd --name ${name} $i 
	echo "running $i"	

	fi
	((j+=1))
	echo ""
	done

}

function logs_crontab(){
mkdir logs
cd logs
	j=1
	for i in ${crontab[*]}; do
	echo $j
	echo [$(date '+%Y-%m-%d %H:%M:%S')]
	
	if [ $(docker images | grep $i | wc -l) -gt 0 ];then
	name=$(echo $i | awk -F "/" '{print $1":"$2}')
	docker logs -t --details ${name} > ${name} 	
	docker logs -t --details ${name} >> merge.txt 
	echo "logs $i"	

	fi
	((j+=1))
	echo ""
	done

cd ..

}

echo "setup.sh!!!!!"
sh setup.sh
echo "download_images!!!!!"
download_images
#run_crontab
#logs_crontab
echo "clamav.sh!!!!!"
sh clamav.sh



