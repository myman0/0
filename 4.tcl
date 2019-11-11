set ns [new Simulator]

set tf [open ex4.tr w]
$ns trace-all $tf

set nf [open ex4.nam w]
$ns namtrace-all $nf

set cwind [open win4.tr w]

$ns color 1 Blue

set n0 [$ns node]
set n1 [$ns node]

$n0 label "server"
$n1 label "client"

$ns duplex-link $n0 $n1 10MB 2ms DropTail

$ns duplex-link-op $n0 $n1 orient right

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink 
$ns connect $tcp $sink

$tcp set packetSize_ 1500

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$tcp set fid_ 1

proc finish {} {
global ns tf nf
$ns flush-trace
close $tf
close $nf

exec nam ex4.nam &
exec awk -f ex4transfer.awk ex4.tr &
exec awk -f ex4convert.awk ex4.tr > convert.tr &
exec xgraph convert.tr &
exit 0
}
$ns at 0.1 "$ftp start"
$ns at 15.0 "$ftp stop"
$ns at 15.1 "finish"
$ns run

}
