#!/bin/bash


#Delete old files
rm -rf ./*.{xml, fo}
rm -rf ./nascar_data.pdf

#Input parameters
year=$1
type=$2

#API Key
SPORTRADAR_API="CPREBHi9Is8DX6DeTxVWs9ibHEHjXzUYa4pBCepc"

#Error check and logging
verifParam(){
	if [[ $1 -lt 2013  ||  $1 -gt 2024 ]]
	then
		return 1
	fi
	if ! [[ $2 == "sc" || $2 == "xf" || $2 == "cw" || $2 == "go" || $2 == "mc" ]]
	then
		return 2
	fi
	return 0
}

verifParam $* 
error=$?

#Download data if parameters are valid
if [ $error -lt 1 ]
then	
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=${SPORTRADAR_API} -o drivers_list.xml
	echo "2 second wait time to avoid too many requests error"
	sleep 2s
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/standings/drivers.xml?api_key=${SPORTRADAR_API} -o drivers_standings.xml
fi
	
basex -byear=$1 -btype=$2  -berror=${error} extract_nascar_data.xq
java -jar ./Saxon-HE-12.4/saxon-he-12.4.jar -s:nascar_data.xml -xsl:generate_fo.xsl -o:nascar_page.fo
fop -fo nascar_page.fo -pdf nascar_page.pdf