#How to excecute
requirements: basex, saxon and fop

1) fetch driver list:
   curl https://api.sportradar.com/nascar-ot3/[type]/[year]/drivers/list.xml?api_key=[SPORTRADAR_API_KEY] -o drivers_list.xml
   
3) fetch driver standings:
   curl https://api.sportradar.com/nascar-ot3/[type]/[year]/standings/drivers.xml?api_key=[SPORTRADAR_API_KEY] -o drivers_standings.xml
   
4) create nascar_data.xml
   basex -byear=[year] -btype='[type]' C:\path\to\extract_data_nascar.xq

6) create nascar_page.fo:
   java -jar saxon-he-12.4.jar -s:C:\path\to\nascar_data.xml -xsl:C:\path\to\generate_fo.xsl -o:C:\path\to\nascar_page.fo
   
7) create nascar_page.pdf
   fop -fo C:\path\to\nascar_page.fo -pdf C:\path\to\nascar_page.pdf
   
