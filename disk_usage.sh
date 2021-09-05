dev_sda1=`df -h | sed -n '4p' | awk '{print $5}' | cut -f 1 -d '%'`
if ((dev_sda1 > 85));
then echo "磁盘使用率超过阈值"
docker run --rm  -v $PWD/.data/registry:/var/lib/registry -v $PWD/garbage-collection.yml:/config.yml findsec/registry-proxy:latest bin/registry garbage-collect /config.yml
fi