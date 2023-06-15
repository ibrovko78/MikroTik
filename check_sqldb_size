:global sqlsize;
:set $sqlsize [/file get value-name=size [find name=user-manager/sqldb]];
if ($sqlsize > 9437184) do={/system script run database_maintenance} else={log info "==== database normal size ===="}
