source /home/netra/KSPL/COZY_RUN/environment.sh

cd /home/netra/KSPL/COZY_RUN && ./temp.sh
sleep 5
source /home/netra/KSPL/COZY_RUN/environment.sh

input="/home/netra/KSPL/COZY_RUN/adaptor.txt"

#cat head.html >> output.html

/bin/bash: indent: command not found
echo "<p style=font-weight:"bold"; font-style:"italic";color:"blue";>Note: Here NSE NFO CDS and BSE should be up</p>" > output.html
echo "<style>table, th, td {  border:1.25px solid black;align="left";}</style>" >> output.html
echo "<table align="left"; width="60%";"font-family:Sans-serif";><tr><th>Exch Segmet</th><th>User ID</th><th>Status</th></tr>" >> output.html

while IFS= read -r line
do
seg=$(echo $line |awk '{print $1}')
id=$(echo $line |awk '{print $2}')
status=$(echo $line |awk '{print $3" "$4}')


status1='SignOn successful,'

if [ "$status" = "$status1" ];then
        echo "<tr><td>"$seg"</td><td>"$id"</td><td style="color:green"><b style="font-style:italic">Up and Running</b></td></tr>" >> output.html
else
        echo "<tr><td>"$seg"</td><td>"$id"</td><td style="color:red"><b style="font-style:oblique">Not running</b></td></tr>" >> output.html
fi

#echo "$line"s
done < "$input"
echo "</table>" >> output.html
echo "</p></td></tr></table><div style="display: none;"></center></body></html>" >> output.html
uptime=$(uptime |awk -F, '{print}')
version=$(cat /etc/centos-release |awk -F, 'NR=1{print}')
ram=$(free -g | grep Mem | awk '{print "Total RAM: "$2"GB Used: "$3"GB Free: "$4"GB"}')
license=$(cozy_commandC cozy_license_server req show_license_info|grep Expi|awk '{print $4}')
rspc=$(df -h | grep /dev/mapper/centos-root | awk '{print $2" Used space: "$3" Available space: "$4" Use%: " $5}')
hspc=$(df -h | grep /dev/mapper/centos-home | awk '{print $2" Used space: "$3" Available space: "$4" Use%: " $5}')
span=$(cozy_commandC ROrd req show_risk_parameter_file | grep COZY_COMMON_FILES | awk '{print "<p>Span file loaded in RMS "$2" for Exchange "$1"</p>"}')
Mcxbhav=$(cat /home/netra/KSPL/COZY_COMMON_FILES/DailyDownloads/MCXBhavcopy.csv | head -1 | awk -F, '{print $1}')
Mcxmar=$(cat /home/netra/KSPL/COZY_COMMON_FILES/DailyDownloads/MCXDailyMargin.csv| grep -v "File ID" | head -1 | awk -F, '{print $1}')
Ban=$(cozy_filter /home/netra/KSPL/COZY_MEM_FILES/ROrd.Block.cjm stdout ' '| grep "Securities in Ban" | awk '{print $11" "$12" "$13" "$14" "$15" "$16" "$17" -> "$9}')
amo=$(cozy_commandC Ora REQ show_amo_mode | grep " Mode"|awk -F, 'NR>1{print "<p>"$1"</p>"}')

echo "<p><br><b><u>Server Details</u></b></p>" >>output.html
echo "<ur><li><b>Server UPTIME : $uptime</li>" >>output.html
echo "<ur><li><b>Server OS Version : $version</li>" >>output.html
echo "<ur><li><b>Total RAM: $ram</li>" >>output.html
echo "<ur><li><b>Total size root : $rspc</li>" >>output.html
echo "<ur><li><b>Total size home: $hspc</li>" >>output.html
echo "<ur><li><b>Kambala License Expiry Date : $license</li>" >>output.html

echo "<p><br><b><u>Exchange Files</u></b></p>" >>output.html
echo "<p>$span</p>" >>output.html
echo "<p>MCX Bhavcopy Date: $Mcxbhav</p>" >>output.html
echo "<p>MCX Margin file date: $Mcxmar</p>" >>output.html
echo "<p>$Ban</p>" >>output.html

echo "<p><br><b><u>AMO status</u></b></p>" >>output.html
echo "<p>$amo</p>" >>output.html

cd /home/netra/KSPL/COZY_COMMON_FILES/

echo "<style>table, th, td {  border:1.25px solid black;align=left;}</style>" >> /home/netra/KSPL/COZY_RUN/output.html
echo "<table align=left; width=60%;font-family:Sans-serif;><tr><th>Filename</th><th>Date</th><th>Month</th><th>Time</th><th>File Size</th><th>OLD File Size</th></tr>" >> /home/netra/KSPL/COZY_RUN/output.html
while IFS= read -r line && IFS= read -r line2 <&3
do
month=$(echo $line |awk -F \| '{print $1}')
day=$(echo $line |awk -F \| '{print $2}')
time=$(echo $line |awk -F \| '{print $3}')
filename=$(echo $line |awk -F \| '{print $4}')
filesize=$(echo $line |awk -F \| '{print $5}')
OLD_filesize=$(echo $line2 |awk -F \| '{print $5}')


echo "<tr><td>$filename</td><td>$day</td><td>$month</td><td>$time</td><td>$filesize</td><td>$OLD_filesize</td></tr>" >> /home/netra/KSPL/COZY_RUN/output.html


done < contract_size.txt  3< contract_size_OLD.txt


