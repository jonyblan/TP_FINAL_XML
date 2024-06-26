# How to run
## Requirements
- Java Runtime Environment: run ```sudo apt-get install default-jre``` on command line
- Java JDK: run ```sudo apt-get install default-jdk``` on command line
### Note
To run the script correctly you will need a parser, included in the file (xerces-2_12_1), an XSLT, XPath and XQuery processor,  also included (Saxon-HE-12.4), and a XSL-FO to PDF converter, included as well (fop-2.9).\
Both of these should be already installed in your system, but they are included nevertheless for compatibility.\
If they are installed and their classpaths set correctly, you can use tpe.sh to run.\
If not, use tpeWSL.sh.
## Command line
First you must set an environment variable with a valid SportRadar API key.\
```export SPORTRADAR_API="<valid_api_key>"```\
Then you can run the script.\
```./tpe.sh [year] [type]```\
```[year]``` must be an integer between 2013 and 2024\
```[type]``` must be one of sc, xf, cw, go, mc\
You can also delete the created files with the ```./tpe.sh clean``` command.
### Note
If using WSL, you must first run the command ```dos2unix ./tpeWSL.sh```. Otherwise, the script won't run.