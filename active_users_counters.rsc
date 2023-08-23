:global au;
:set $au [/ip hotspot active print count where user > 000000 and user <999999];
if ($au > 89) do={
[/ip firewall filter print];
[/ip firewall filter enable number=35,33,37];
[/ip firewall mangle enable number=2,3,6,7,8,9,10,11];
[/queue tree print];
[/queue tree enable 0,1];
} else={
[/ip firewall filter print];
[/ip firewall filter disable number=35,33,37];
[/ip firewall mangle disable number=2,3,6,7,8,9,10,11];
[/queue tree print];
[/queue tree disable 0,1];
};
