#/bin/bash
lineapikey=Your_LINE_API_token
cd /path/to/Scripts
curl -H "Content-Type: application/json" -o "test.xml" -u trac:trac http://www.shoutcasturl.com:<PORT>/statistics
xmllint --format test.xml > current.xml
count=$(cat current.xml | wc -l)
current=$(awk '{if(NR==6) print $0}' "current.xml")
echo $current > willcut.txt
sed 's/<//g' willcut.txt | sed 's/>//g' | sed 's/\///g' | sed 's/CURRENTLISTENERS//g' > value.txt
txtlisten=$(cat value.txt)
if [[ $count == "0" ]];then
echo "Found Error !! Please Restart!" > .msgError.txt
txtError=$(cat .msgError.txt)
curl -X POST -H 'Authorization: Bearer '"$lineapikey"'' -F message=''"$txtError"'' https://notify-api.line.me/api/notify
elif [[ $count -gt "0" ]];then
txtlisten=$(cat value.txt)
#curl -X POST -H 'Authorization: Bearer '"$lineapikey"'' -F message=''"$txtlisten"'' https://notify-api.line.me/api/notify
else
echo "error enexpected" > stat.txt
fi

rm value.txt willcut.txt current.xml test.xml
printf `date "+%d.%m.%Y-%H:%M"` >> stat.txt
printf " " >> stat.txt
echo "$txt" >> stat.txt
