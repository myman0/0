set val(chan)	Channel/WirelessChannel
set val(prop)	Propagation/TwoRayGround	
set val(netif)	Phy/WirelessPhy
set val(ifq)	Queue/DropTail/PriQueue
#set val(ifq)	CMUPriQueue
set val(ifqlen)	50
set val(mac)	Mac/802_11 #😎️
set val(ll) 	LL	
set val(ant)	Antenna/OmniAntenna
set val(x) 	500
set val(y)	500
set val(nn)	3
set val(stop)	20.0
set val(rp)	DSDV

set ns_ [new Simulator]

set tf [open wl2.tr w]
$ns_ trace-all $tf

set nf [open wl2.nam w]
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

$node_(0) set X_ 25.0
$node_(0) set Y_ 25.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 455.0
$node_(1) set Y_ 255.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 155.0
$node_(2) set Y_ 240.0
$node_(2) set Z_ 0.0

for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ initial_node_pos $node_($i) 40
}
 
$ns_ at 0.0 "$node_(0) setdest 450.0 285.0 30.0"
$ns_ at 0.0 "$node_(1) setdest 200.0 285.0 30.0"
$ns_ at 0.0 "$node_(2) setdest 1.0 285.0 30.0"

$ns_ at 25.0 "$node_(0) setdest 300.0 285.0 10.0"
$ns_ at 25.0 "$node_(2) setdest 100.0 285.0 10.0"

$ns_ at 40.0 "$node_(0) setdest 490.0 285.0 5.0"
$ns_ at 40.0 "$node_(2) setdest 1.0 285.0 5.0"

set tcpo [new Agent/TCP]
set sinko [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcpo
$ns_ attach-agent $node_(2) $sinko
$ns_ connect $tcpo $sinko
set ftpo [new Application/FTP]
$ftpo attach-agent $tcpo
$ns_ at 1.0 "$ftpo start"
$ns_ at 18.0 "$ftpo stop"

for {set i 0} {$i<$val(nn)} {incr i} {
$ns_ at $val(stop) "$node_($i) reset"
}

$ns_ at $val(stop) "puts \"NS EXITING.....\"; $ns_ halt"
puts "Starting Simulation..."
 $ns_ run
