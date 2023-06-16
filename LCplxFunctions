#functions

# function getSQLDateTime returned DateTime in fromat YYYY-MM-DD HH:MM:SS
# USE: $getSQLDateTime;
# function getSQLDate returned date in format YYYY-MM-DD
# USE: $getSQLDate;
# function getSQLTime returned time in format HH:MM:SS
# USE: $getSQLTime;
# function convert format datetime (YYYY-MM-DD HH:MM:SS) to UnixTime
# USE: $UNIXTime [datetime];
# DeleteFromArray index from begin 0
# USE: $DeleteFromArray <array> [index];


:if ([/system scheduler find name="LCplxFunctions"] = "") do={
    /system scheduler add name="LCplxFunctions" start-date="Jan/01/1970" start-time="startup" on-event="/system script run \"LCplxFunctions\";";
};

:global getSQLDateTime do={
:local CurTime ([/system clock get date] . " " . [/system clock get time]);
    :local montsarr ([:toarray "jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec"]);
    :local mon ([:pick $CurTime 0 3]); :local day ([:pick $CurTime 4 6]); :local year ([:pick $CurTime 7 11]);
:local hour ([:pick $CurTime 12 14]); :local min ([:pick $CurTime 15 17]);  :local sec ([:pick $CurTime 18 20]);
    :foreach c,a in=$montsarr do={:set c ($c + 1);:if ($a = $mon) do={:set mon $c; };};
    :while ([:len $mon] < 2) do={:set mon ("0" . $mon);};
    :while ([:len $day] < 2) do={:set day ("0" . $day);};
    :while ([:len $hour] < 2) do={:set hour ("0" . $hour);};
    :while ([:len $min] < 2) do={:set min ("0" . $min);};
    :while ([:len $sec] < 2) do={:set sec ("0" . $sec);};
    :return ($year . "-" . $mon . "-" . $day . " " . $hour . ":" . $min . ":" . $sec);
};

:global getSQLDate do={
:local CurTime ([/system clock get date]);
    :local montsarr ([:toarray "jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec"]);
    :local mon ([:pick $CurTime 0 3]); :local day ([:pick $CurTime 4 6]); :local year ([:pick $CurTime 7 11]);
    :foreach c,a in=$montsarr do={:set c ($c + 1);:if ($a = $mon) do={:set mon $c; };};
    :while ([:len $mon] < 2) do={:set mon ("0" . $mon);};
    :while ([:len $day] < 2) do={:set day ("0" . $day);};
    :return ($year . "-" . $mon . "-" . $day );
};

:global getSQLTime do={
:local CurTime ([/system clock get time]);
    :local hour ([:pick $CurTime 0 2]); :local min ([:pick $CurTime 3 5]);  :local sec ([:pick $CurTime 6 8]);
    :while ([:len $hour] < 2) do={:set hour ("0" . $hour);};
    :while ([:len $min] < 2) do={:set min ("0" . $min);};
    :while ([:len $sec] < 2) do={:set sec ("0" . $sec);};
    :return ($hour . ":" . $min . ":" . $sec);
};

:global UNIXTime do={
:local timef [$1];
    :global getSQLDateTime;
    :if ( [:typeof $timef]="nil" ) do={
        :set timef [$getSQLDateTime];
    };
    :local year 1970; :local mon 1; :local day 1; :local hour 0; :local min 0; :local sec 0;
    :local ZeroTime ( (($year * 360 + $mon * 30 + $day ) * 24 * 3600 ) + $hour * 3600 + $min * 60 + $sec );
    :local year [:tonum [:pick $timef 0 4]]; :local mon [:tonum [:pick $timef 5 7]];
:local day [:tonum [:pick $timef 8 10]]; :local hour [:tonum [:pick $timef 11 13]];
:local min [:tonum [:pick $timef 14 16]]; :local sec [:tonum [:pick $timef 17 19]];
    :local NowTime ( (($year * 360 + $mon * 30 + $day ) * 24 * 3600 ) + $hour * 3600 + $min * 60 + $sec );
    :local Ut ($NowTime - $ZeroTime);
    :return ($Ut);
};

:global DeleteFromArray do={     
:local ArrayM [$1];
:if ( [:typeof $ArrayM]="nil" ) do={
  :return false;
};
:local del [$2];
:if ( [:typeof $del]="nil" ) do={
  :set del 0;
};
:local ReturnArray "";
:foreach i,k in=$ArrayM do={
  :if ($i!=$del) do={
   :set ReturnArray ($ReturnArray ."," . $k);
  };
};
    :set ReturnArray [:toarray $ReturnArray];
:return $ReturnArray;
};
