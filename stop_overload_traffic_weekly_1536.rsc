:foreach sf in=[/tool user-manager user find] do={
:global uname [/tool user-manager user get $sf username];
:global dused [/tool user-manager user get $sf download-used];
:global loc  [/tool user-manager user get $sf location];
:global uip   [/tool user-manager user get $sf ip-address];
:global prof  [/tool user-manager user get $sf actual-profile];
:if ($dused > 1610612736 and $loc=1536) do={   
/ip hotspot active remove [find where user=$uname];
/tool user-manager user clear-profiles $sf
}
}
