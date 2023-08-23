:local HOST "8.8.8.8"
:local PINGCOUNT "5"
:local INT "ether1-wan"
:local EHOST ([/ping x.x.x.x interface=$INT count=4])
:local EAHOST ([/ping x.x.x.x interface=$INT count=4])
:local EBHOST ([/ping x.x.x.x interface=$INT count=4])
:local ECHOST ([/ping x.x.x.x interface=$INT count=4])
:local OHOST ([/ping x.x.x.x interface=$INT count=4])
:local GHOST ([/ping x.x.x.x interface=$INT count=4])
:local GOHOST ([/ping 8.8.8.8 interface=$INT count=4])
:local sub1 ([/system identity get name])
:local sub2 ([/system clock get time])
:local sub3 ([/system clock get date])
:local ADMINMAIL1 "admin@mail.ru"
:if ([/ping $HOST interface=$INT  count=$PINGCOUNT] = 0) do={
:log error "HOST $HOST is not responding to ping request..."
/tool e-mail send to=$ADMINMAIL1 from=S-MikroTik_CHR subject="$HOST is not responding to ping request @ $sub3 $sub2 $sub1" body="interface = $INT, ping to 8.8.8.8 = $GOHOST, \n ping to x.x.x.x = $OHOST, ping to x.x.x.x = $ECHOST, ping to x.x.x.x = $EBHOST, ping to x.x.x.x = $EAHOST, ping to x.x.x.x = $EHOST, \n ping to x.x.x.x = $GHOST" start-tls=yes
} else {

}