<?php
require('routeros_api.class.php');

$API = new RouterosAPI();
$API->debug = false;
$API->connect('172.23.1.19', 'admin', 'admin') or die("не удалось соединиться с роутером");
// $API->connect('172.16.251.2', 'admin', '') or die("не удалось соединиться с роутером");

echo "connectted \n";

$fd = fopen("userMktk.txt", 'r') or die("не удалось открыть файл");
$ii=0;
while(!feof($fd))
{
    $u=""; $f=""; $i=""; $o=""; 
    $str = fgets($fd);
    $array = array();
    $array = preg_split("/[\s\t]+/", $str);
    if (isset($array[0])) { $u= $array[0]; }
    if (isset($array[1])) { $p= $array[1]; }
	if (isset($array[4])) { $l= $array[2]; }
    if (isset($array[2])) { $f= $array[3]; }
    if (isset($array[3])) { $i= $array[4]; }
    if (isset($array[4])) { $o= $array[5]; }
	

    if ($u and $u != "AuthCode" and $u != "aaa0") 
    { 
//      echo $u . "==" . $l . "==" . $f . "==" . $i . "==" . $o . "==\n" ; 

      $response = $API->comm("/tool/user-manager/customer/add",array(
        "login"             => $u,
        "password"          => $p,
		"access"            => "own-routers,own-users,own-profiles,own-limits,config-payment-gw,parent-routers,parent-payment-gw",
        "backup-allowed"    => "no",
        "time-zone"         => "+10:00",
        "permissions"       => "read-only",
        "parent"            => "admin",
        "signup-allowed"    => "no",
        "paypal-allowed"    => "no",
        "paypal-secure-response"  => "no",
        "paypal-accept-pending"   => "no"
        ));

       $response = $API->comm("/tool/user-manager/user/add",array(
        "customer"          => $u,
        "username"          => $u,
        "password"          => $p,
		"location"          => $l,
		"first-name"        => $i,
        "last-name"         => $f,
        "comment"           => $f . " " . $i . " " . $o,
		"shared-users"      => "2"
         ));

        $API->write('/tool/user-manager/user/create-and-activate-profile',false);
        $API->write('=numbers=' . $response,false);
        $API->write('=profile=1536Mb',false);
        $API->write('=customer=admin');

        $response=$API->read();
        $ii++;
      echo $ii . " " . $u . "\n"; 

//        break;
    }
}

    fclose($fd);
    $API->disconnect();
    
    echo $ii . "\n" ;

?>
