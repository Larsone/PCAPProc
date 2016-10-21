file=$1
folder=$2

rm -rf $2
mkdir $2

rm -rf *.log
rm -rf .state

/usr/local/bro/bin/bro -r $1

mv *.log $2/.

ruby procPcap.rb $2 $1 > output

curl -s -XPOST localhost:9200/_bulk --data-binary @output; echo
