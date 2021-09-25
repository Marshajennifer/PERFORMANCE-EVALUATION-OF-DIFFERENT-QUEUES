set ns [new Simulator]
set tracefile [open exp5fq.tr w]
$ns trace-all $tracefile
set namfile [open exp5fq.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$ns duplex-link $n0 $n2 1Mb 10ms FQ
$ns duplex-link $n2 $n3 3Mb 10ms FQ
$ns duplex-link $n6 $n2 1Mb 10ms FQ
$ns duplex-link $n1 $n2 1Mb 10ms FQ
$ns duplex-link $n3 $n5 2Mb 10ms FQ
$ns duplex-link $n3 $n7 2Mb 10ms FQ
$ns duplex-link $n3 $n4 2Mb 10ms FQ

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n6 $n2 orient right
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n5 orient right-up
$ns duplex-link-op $n3 $n7 orient right
$ns duplex-link-op $n3 $n4 orient right-down


$ns queue-limit $n0 $n2 50
$ns queue-limit $n2 $n3 50
$ns queue-limit $n6 $n2 50
$ns queue-limit $n1 $n2 50
$ns queue-limit $n3 $n5 50
$ns queue-limit $n3 $n7 50
$ns queue-limit $n3 $n4 50


set tcp0 [new Agent/TCP]
set sink5 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp0
$ns attach-agent $n5 $sink5
$ns connect $tcp0 $sink5
$tcp0 set fid_ 1
$ns color 1 Green


set tcp6 [new Agent/TCP]
set sink7 [new Agent/TCPSink]
$ns attach-agent $n6 $tcp6
$ns attach-agent $n7 $sink7
$ns connect $tcp6 $sink7
$tcp6 set fid_ 2
$ns color 2 Red

set udp1 [new Agent/UDP]
set null4 [new Agent/Null]
$ns attach-agent $n1 $udp1
$ns attach-agent $n4 $null4
$ns connect $udp1 $null4
$udp1 set fid_ 4
$ns color 4 Blue

set ftp0 [new Application/FTP]
$ftp0 set packetSize_ 500
$ftp0 set interval_ 0.01
$ftp0 attach-agent $tcp0

set ftp6 [new Application/FTP]
$ftp6 set packetSize_ 500
$ftp6 set interval_ 0.01
$ftp6 attach-agent $tcp6

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.01
$cbr1 attach-agent $udp1

$ns at 0.5 "$cbr1 start"
$ns at 3.5 "$cbr1 stop"

$ns at 1.4 "$ftp0 start"
$ns at 4.1 "$ftp0 stop"

$ns at 1.9 "$ftp6 start"
$ns at 4.4 "$ftp6 stop"

#Detach tcp and sink agents (not really necessary)
$ns at 4.0 "$ns detach-agent $n0 $tcp0 ; $ns detach-agent $n5 $sink5"
$ns at 4.5 "$ns detach-agent $n6 $tcp6 ; $ns detach-agent $n7 $sink7"

$ns at 5.0 "finish"
proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam exp5fq.nam &
	exec awk -f exp5all.awk exp5fq.tr > outputfq.tr &
	exit 0
}
puts "Simulation is Starting..."
$ns run

