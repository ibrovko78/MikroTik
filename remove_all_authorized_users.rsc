:foreach aau in [ /ip hotspot host find where authorized=yes ] do={
/ip hotspot host remove $aau
}
