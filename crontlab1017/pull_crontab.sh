#!/bin/bash
crontab=($(awk '{print $1}' ./image_name/crontab))
bash=($(awk '{print $1}' ./image_name/bash))
backdoor=($(awk '{print $1}' ./image_name/backdoor))


function download_crontab(){
mkdir crontab
cd crontab	
	j=1
	for i in ${crontab[*]}; do
	echo $j
	echo [$(date '+%Y-%m-%d %H:%M:%S')]
	echo "pulling $i"
	echo $(docker pull $i)

	if [ $(docker images | grep $i | wc -l) -gt 0 ];then
	echo "pulled $i"
	name=$(echo $i | awk -F "/" '{print $1"__"$2}')
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
	name=$(echo $i | awk -F "/" '{print $1"__"$2}')
	docker run -itd --name ${name} $i 
	echo "running $i"	

	fi
	((j+=1))
	echo ""
	done

}

function logs_crontab(){
mkdir crontab_logs
cd crontab_logs
	j=1
	for i in ${crontab[*]}; do
	echo $j
	echo [$(date '+%Y-%m-%d %H:%M:%S')]
	
	if [ $(docker images | grep $i | wc -l) -gt 0 ];then
	name=$(echo $i | awk -F "/" '{print $1"__"$2}')
	docker logs -t --details ${name} > ${name} 	
	docker logs -t --details ${name} >> merge.txt 
	echo "logs $i"	

	fi
	((j+=1))
	echo ""
	done

cd ..

}


download_crontab
run_crontab
echo "sleep 10m"
sleep 10m
logs_crontab



