#!/bin/bash
verifParam(){
	if [[ $1 -ge 2013 ]] && [[ $1 -le 2024 ]] && [[ $2 == "sc" || $2 == "xf" || $2 == "cw" || $2 == "go" || $2 == "mc" ]]
	then
		return 1
	else
		return 2
	fi
}

SPORTRADAR_API="CPREBHi9Is8DX6DeTxVWs9ibHEHjXzUYa4pBCepc"
verifParam $*
if [ $? -eq 1 ]
then
	year=$1
	type=$2
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=${SPORTRADAR_API} -o drivers_list.xml
	sleep 10s
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/standings/drivers.xml?api_key=${SPORTRADAR_API} -o drivers_standings.xml
	basex -byear=$1 -btype=$2 extract_nascar_data.xq
	java -jar saxon-he-12.4.jar -s:nascar_data.xml -xsl:generate_fo.xsl -o:nascar_page.fo
	fop -fo nascar_page.fo -pdf nascar_page.pdf
else
	echo Argumentos invalidos
fi
