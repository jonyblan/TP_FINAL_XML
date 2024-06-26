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

if [[ $(($error % 2)) -eq 1 ]]
then
	echo "Removing namespaces"
	sed -i -e 's/ xmlns=".*\.xsd"//' drivers_list.xml
	sed -i -e 's/ xmlns=".*\.xsd"//' drivers_standings.xml
fi
echo "Processing Query"
if [[ "$WSL_DISTRO_NAME" == "Ubuntu" || "$CLASSPATH" == "" ]]
then
	java -cp Saxon-HE-12.4/saxon-he-12.4.jar net.sf.saxon.Query -q:extract_nascar_data.xq error="$error" year="$year" type="$type" -o:nascar_data.xml
	echo "Query processed, .xml created. Validating"
	java -cp xerces-2_12_1/xercesImpl.jar:xerces-2_12_1/xercesSamples.jar:xerces-2_12_1/xml-apis.jar dom.Writer -v -n -s -f nascar_data.xml > /dev/null
	echo "Validated. Generating .fo"
	java -cp Saxon-HE-12.4/saxon-he-12.4.jar net.sf.saxon.Transform -s:nascar_data.xml -xsl:generate_fo.xsl -o:nascar_page.fo
else
	java net.sf.saxon.Query -q:extract_nascar_data.xq error="$error" year="$year" type="$type" -o:nascar_data.xml
	echo "Query processed, .xml created. Validating"
	java dom.Writer -v -n -s -f nascar_data.xml > /dev/null
	echo "Validated. Generating .fo"
	java net.sf.saxon.Transform -s:nascar_data.xml -xsl:generate_fo.xsl -o:nascar_page.fo
fi
echo ".fo generated. Creating .pdf"
./fop-2.9/fop/fop -fo nascar_page.fo -pdf nascar_page.pdf
echo ".pdf created. Script finished. Thank you!"