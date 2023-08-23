:log info "====== start database maintenance =====";
/system scheduler disable 3,4,16;
:delay 60s;
:foreach dx in=[/tool user-manager session find] do={
:log warning "delete session user $[/tool user-manager session get $dx user]"
/tool user-manager session remove $dx
}
:log info "====== delete log session users hotspot completed =====";

/tool user-manager database rebuild
/tool user-manager database rebuild-log
/tool user-manager database clear-log
/system scheduler enable 3;
:delay 60s;
/system scheduler enable 4;
:delay 10s;
/system scheduler enable 16;
:global size
:set $size [/file get value-name=size [find name=user-manager/sqldb]];
:set $z ($size/1024);
/tool e-mail send to=my@mail.ru from=S-MikroTik_CHR subject="S-MikroTik_CHR database maintenance" body="Database maintenance completed, sqldb size $z Kb"
:log info "====== database maintenance completed =====";
