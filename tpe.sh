#!/bin/bash
verifParam(){
	if [[ $1 -ge 2013 ]] && [[ $1 -le 2024 ]] && [[ $2 == "sc" || $2 == "xf" || $2 == "cw" || $2 == "go" || $2 == "mc" ]]
	then
		return 1
	else
		return 2
	fi
}
year=$1
type=$2
SPORTRADAR_API=$3
verifParam $*
if [ $? -eq 1 ]
then
	error=0
	echo https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=${SPORTRADAR_API}
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=${SPORTRADAR_API} -o drivers_list.xml
	sleep 5s
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/standings/drivers.xml?api_key=${SPORTRADAR_API} -o drivers_standings.xml
else
	error=1
fi
	
	basex -byear=$1 -btype=$2  -berror=${error} extract_nascar_data.xq
	java -jar saxon-he-12.4.jar -s:nascar_data.xml -xsl:generate_fo.xsl -o:nascar_page.fo
	fop -fo nascar_page.fo -pdf nascar_page.pdf