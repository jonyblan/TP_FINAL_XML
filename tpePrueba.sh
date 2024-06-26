#!/bin/bash


#Delete old files
rm -rf drivers_list.xml
rm -rf drivers_standings.xml
rm -rf nascar_data.xml
rm -rf nascar_page.fo
rm -rf nascar_page.pdf
echo "Old files deleted"

#Input parameters
year=$1
type=$2

#Error check and logging
verifParam(){
	if [[ $1 == "clean" ]]
	then
		exit 0
	fi
	local error=1
	if [[ $SPORTRADAR_API == "" ]]
	then
		let error=$error*2
	fi
	if [[ $1 -lt 2013  ||  $1 -gt 2024 || $1 == "" ]]
	then
		let error=$error*3
	fi
	if ! [[ $2 == "sc" || $2 == "xf" || $2 == "cw" || $2 == "go" || $2 == "mc" || $2 == "" ]]
	then
		let error=$error*5
	fi
	return $error
}

verifParam $* 
error=$?

#Download data if parameters are valid
if [ $error -eq 1 ]
then	
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/drivers/list.xml?api_key=$SPORTRADAR_API -o drivers_list.xml
	echo "2 second wait time to avoid too many requests error"
	sleep 2s
	curl https://api.sportradar.com/nascar-ot3/${type}/${year}/standings/drivers.xml?api_key=$SPORTRADAR_API -o drivers_standings.xml
	echo "Files downloaded"
fi

echo "Processing Query"
java -cp $WSLENV net.sf.saxon.Query -q:extract_nascar_data.xq error="$error" year="$year" type="$type" -o:nascar_data.xml
echo "Query processed, .xml created. Validating"
java -cp $WSLENV dom.Writer -v -n -s -f nascar_data.xml > /dev/null
echo "Validated. Generating .fo"
java -cp $WSLENV net.sf.saxon.Transform -s:nascar_data.xml -xsl:generate_fo.xsl -o:nascar_page.fo
echo ".fo generated. Creating .pdf"
./fop-2.9/fop/fop -fo nascar_page.fo -pdf nascar_page.pdf
echo ".pdf created. Script finished. Thank you!"