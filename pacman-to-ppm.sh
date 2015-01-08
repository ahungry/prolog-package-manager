#!/bin/sh

# Grab results to make a giant package dependency database
pacman -Ss|grep -E '(core|extra|community)/'|cut -f2 -d'/'|cut -f1 -d' ' > ./packages.db
TOTAL=$(wc -l ./packages.db|awk '{print $1}')
Z=0

touch ./allpackages.db
touch ./allpackagesR.db
touch ./tmpAP.db
touch ./tmpAPR.db

for f in $(cat ./packages.db); do
	$((++Z))
	clear
	printf "On item [%d] of [%d] - [%f] done\n" $Z $TOTAL $(echo "scale=4;100*$Z/$TOTAL"|bc)

	pactree -sug -d1 $f | sort | uniq > ./tmp.db
	cp ./allpackages.db ./tmpAP.db
	cat ./tmpAP.db ./tmp.db | sort | uniq > ./allpackages.db

	pactree -rugs -d1 $f | sort | uniq > ./tmpR.db
	cp ./allpackagesR.db ./tmpAPR.db
	cat ./tmpAPR.db ./tmpR.db | sort | uniq > ./allpackagesR.db
done
