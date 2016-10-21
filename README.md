# PCAPProc
Command line pcap file processor, produces elasticsearch compatible output.

## Requirements
* Ruby 2.3.x >
* BashShell
* Bro - https://www.bro.org/
* ElasticSearch 2.4

## Details
Uisng Bro Network Security Monitor a bash script produces .log files, a simple Ruby parser then formats this data for bulk loading into a local ElasticSearch instance, this can then optionaly be visualised in Kibana.

## Commands
    Run with:
    ./procPcap.sh /home/share/pcaps/devian.tubemate.home-2.2.5-636-minAPI4.pcap testing
    
    * arg1 The pcap file
    * arg2 The local temp file for logs

    
