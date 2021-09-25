#to run the code use -->  awk -f exp3.awk exp3.tr
BEGIN{
datatcp=0
starttimetcp=5000
endtimetcp=0
dataudp=0
starttimeudp=5000
endtimeudp=0
dropped=0
}
{
if($1=="d")
	{
	dropped=dropped+1
	}
if($1=="r" && $5=="tcp" && ($4=="7"||$4=="5"))
	{
	if($2<starttimetcp)
	{
	starttimetcp=$2
	}
	datatcp=datatcp+$6
	endtimetcp=$2
	}

if($1=="r" && $5=="cbr" && $4=="4")
	{
	if($2<starttimeudp)
	{
	starttimeudp=$2
	}
	dataudp=dataudp+$6
	endtimeudp=$2
	}
}

END{
throughputtcp=datatcp*8/((endtimetcp-starttimetcp)*1024)
throughputudp=dataudp*8/((endtimeudp-starttimeudp)*1024)
printf("TCP Throughput :: %f kbps\n",throughputtcp) 
printf("UDP Throughput ::%f kbps\n",throughputudp)
printf("TCP Start time: %f\n",starttimetcp)
printf("TCP End time: %f\n",endtimetcp)
printf("UDP Start time: %f\n",starttimeudp)
printf("TCP Start time: %f\n",endtimeudp)
printf("Number of packets dropped: %f\n",dropped)
}


