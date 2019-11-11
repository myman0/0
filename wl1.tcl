set val(chan)	Channel/WirelessChannel
set val(prop)	Propagation/TwoRayGround	
set val(netif)	Phy/WirelessPhy
set val(ifq)	Queue/DropTail/PriQueue  
#set val(ifq)	CMUPriQueue 
set val(ifqlen)	50
set val(mac)	Mac/802_11
set val(ll) 	LL	
set val(ant)	Antenna/OmniAntenna
set val(x) 	500
set val(y)	500
set val(nn)	2
set val(stop)	35.0
set val(rp)	DSR

set ns_ [new Simulator]

set tf [open wl1.tr w]
$ns_ trace-all $tf

set nf [open wl1.nam w]
$ns_ namtrace-all-wireless $nf $val(x) $val(y)

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

$ns_ node-config -adhocRouting $val(rp) \
                 -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen $val(ifqlen) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -phyType $val(netif) \
                 -channelType $val(chan) \
                 -topoInstance $topo \
                 -agentTrace ON \ 
#-routerTrace ON \
                 -macTrace ON

for {set i 0} {$i<$val(nn)} {incr i} {
set node_($i) [$ns_ node]
#$node_($i) random_motion 0
}

for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ initial_node_pos $node_($i) 40
}
 
$ns_ at 1.1 "$node_(0) setdest 310.0 10.0 20.0"
$ns_ at 1.1 "$node_(1) setdest 10.0 310.0 20.0"

set tcpo [new Agent/TCP]
set sinko [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcpo
$ns_ attach-agent $node_(1) $sinko
$ns_ connect $tcpo $sinko
set ftpo [new Application/FTP]
$ftpo attach-agent $tcpo
$ns_ at 1.5 "$ftpo start"
$ns_ at 30.0 "$ftpo stop"
$ns_ at 30.1 "finish"

proc finish {} {
global ns_ tf nf
$ns_ flush-trace

close $tf
close $nf
puts "running nam"
exec nam wl1.nam &
exit 0
}
$ns_ run

 
 
 
 
 
 
 
