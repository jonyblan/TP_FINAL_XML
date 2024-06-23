#!/bin/bash
verifParam(){
	if [[ $1 -lt 2013  ||  $1 -gt 2024 ]]
	then
		return 1
	fi
	if ! [[ $2 == "sc" || $2 == "xf" || $2 == "cw" || $2 == "go" || $2 == "mc" ]]
	then
		return 2
	fi
	if [[ $# -lt 3 ]]
	then	
		return 3
	fi
	return 0
}

year=$1
type=$2
api_key=$3
verifParam $* 
error=$?
if [ $error -lt 1 ]
then
	
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=${api_key} -o drivers_list.xml
	sleep 5s
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/standings/drivers.xml?api_key=${api_key} -o drivers_standings.xml
fi
	
	basex -byear=$1 -btype=$2  -berror=${error} extract_nascar_data.xq
	java -jar saxon-he-12.4.jar -s:nascar_data.xml -xsl:generate_fo.xsl -o:nascar_page.fo
	fop -fo nascar_page.fo -pdf nascar_page.pdf