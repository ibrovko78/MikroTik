################################### SETTING ################################################
# topic log
:local needenter "hotspot";
# server name
:local needserver "hotspotVS";
# failed password
:local fPass 3;
#enables module UnBind
:local UBlocked true;
#period for blocked in second
:local TimeBlocked ( 6 * 3600 );
##############################################################################################



:global LCplxMacBrut;
:global LCplxMacBrutTime;
:global LCplxMacBlocked;
:global getSQLDate;
:global getSQLDateTime;
:global UNIXTime;
:local nowdate [$getSQLDate];
:if ([/system scheduler find name="LCplxAutoBlockMac"] = "") do={
    /system scheduler add name="LCplxAutoBlockMac" start-date="Jan/01/1970" start-time="00:00:00" interval="1m" on-event="/system script run \"LCplxAutoBlockMac\";";
};
:if ( [:typeof $LCplxMacBrut]!="array" ) do={
:set LCplxMacBrut [:toarray ("")];
};
:if ( [:typeof $LCplxMacBlocked]!="array" ) do={
:if ([:typeof $LCplxMacBlocked]="nothing") do={
  :set LCplxMacBlocked [:toarray ("")];
  :local tmpBlock [/system script get LCplxAutoBlockMac comment];
  :if ( $tmpBlock!="" ) do={
   :set tmpBlock [:toarray $tmpBlock];
   :foreach a,b in=$tmpBlock do={
    :local bpos [:find $b "="];
    :local c ([:pick $b 0 $bpos]);
    :local d ([:pick $b ($bpos+1) [:len $b]]);
    :set ($LCplxMacBlocked->"$c") $d;
   };  
  } else={
   :set LCplxMacBlocked [:toarray ("")];
  };
};
};
:local fs true;
:do {
:local fs [/ip hotspot get $needserver name];
} on-error={
  :set $fs false;
};
:if ($fs!=false) do={
:local msgLog  [/log find message~"login failed: user"];
:foreach i in=$msgLog do={
  :local mmsg [/log get $i message ];
  :local t [/log get $i time];
  :local DateTime ($nowdate . " " . $t);
  :local Utime [$UNIXTime [$DateTime]];
  :if ($LCplxMacBrutTime < $Utime ) do={
   :set LCplxMacBrutTime $Utime;
   :local topic ([:toarray [/log get $i topics]]);
   :foreach topi in=$topic do={
    :if ( $topi = $needenter) do={
     :local ip;
     :local tryIP false;
     :local Ipl;
     :for i from=0 to=[:len $mmsg] step=1 do={
      :if ($tryIP=false) do={
       :if ([:pick $mmsg $i]="(") do={
        :set tryIP true;
        :set Ipl ($i);
       };
      } else={
       :if ([:pick $mmsg $i]=")") do={
        :set tryIP false;
       };
      };
      :if ($tryIP) do={
       :if ($Ipl<$i) do={
        :set ip ($ip . [[:pick $mmsg $i]]);
       };
      };
     };
     :local Mac ([/ip hotspot host get [/ip hotspot host find address="$ip"] mac-address]);
     :local id ([/ip hotspot ip-binding find mac-address="$Mac"]);
     :local HotServer ([/ip hotspot host get [/ip hotspot host find address="$ip"] server]);
     :local typeRec;
     :do {
      :local typeRec [/ip hotspot ip-binding get number="$id" type];
     } on-error={
      :local typeRec "";
     };
     :local disRec;
     :do {
      :local disRec [/ip hotspot ip-binding get number="$id" disabled];
     } on-error={
      :local disRec "";
     };
     :if ($typeRec!="bypassed" || $typeRec!="blocked") do={
      :local iok [($LCplxMacBrut->"$Mac")];
      if ( [typeof $iok] ="nil" ) do={
       :set ($LCplxMacBrut->"$Mac") 1;
      } else={
       :local MBC ($LCplxMacBrut->"$Mac");
       :set $MBC ( $MBC + 1 );
       :set ($LCplxMacBrut->"$Mac") $MBC;
       :if ($MBC>$fPass) do={
        :if ($needserver=$HotServer) do={
         :if ($id!="") do={
          :if ($typeRec!="blocked" || $disRec=true) do={
           :local comm;
           :do {:set comm ([/ip hotspot ip-binding get number="$id" comment]);} on-error={:set comm "";};
           :local comm ($comm . " Auto Blocked " . $DateTime);
           /ip hotspot ip-binding set mac-address="$Mac" type=blocked comment="$comm" numbers="$id" disabled=no;
          };
         } else={
          :local comm ("Auto Bind Brutforce " . $DateTime);
          /ip hotspot ip-binding add mac-address="$Mac" comment="$comm" server="$HotServer" type=blocked disabled=no;
         };
         :local tmpArray [:toarray ("")];
         :foreach a,b in=$LCplxMacBrut do={
          :if ($a!=$Mac) do={
           :set ($tmpArray->"$a") $b;
          };
         };
         :set LCplxMacBrut $tmpArray;
         :if ( $UBlocked ) do={
          :local a ( $LCplxMacBrutTime + $TimeBlocked );
          :set ($LCplxMacBlocked->"$Mac") $a;
          /system script comment LCplxAutoBlockMac comment="$LCplxMacBlocked";
         };
        };
       };
      };
     };
    };
   };
  };
};
:if ( $UBlocked=true ) do={
  :local timef [$UNIXTime];
  :local delArray [:toarray ("")];
  :set LCplxMacBlocked [:toarray $LCplxMacBlocked];
  :foreach a,b in=$LCplxMacBlocked do={
   :local timelabel [:tonum $b];
   :if ( $timef > $timelabel ) do={
    :local Mac $a;
    :local id ([/ip hotspot ip-binding find mac-address="$Mac"]);
    :if ( $id!="" ) do={
     :local typeRec [/ip hotspot ip-binding get number="$id" type];
     :if ( $typeRec="blocked") do={
      /ip hotspot ip-binding remove numbers=$id;
     };
    };
    :set ($delArray->"$Mac") 999;
   };
  };
  :local tmpArray [:toarray ("")];
  :if ( [:len $delArray] > 0 ) do={
   :foreach a,b in=$delArray do={  
    :foreach c,d in=$LCplxMacBlocked do={
     :if ($a!=$c) do={
      :set ($tmpArray->"$c") $d;
     };
    };
   };
   :set LCplxMacBlocked $tmpArray;
   /system script comment LCplxAutoBlockMac comment="$LCplxMacBlocked";
  };
};
} else={
:log error ("ERROR: configure error LCplxAutoBlockMac. See variable \"needserver\".");
};
