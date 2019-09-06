<?php
$url="https://exode.me";
$cont = true;
$start=0;
$f = array();

while($cont){
	$followingsstr= file_get_contents($url."/api/v1/server/following?start=".$start);
	$followings = json_decode($followingsstr, true);
	foreach($followings['data'] as $follower){
			array_push($f,$follower['following']['url']);
	}
	$start+=15;
	if(sizeof($followings['data'])<15)
	 $cont=false;
}
echo "<h2>Following ".sizeof($f)." instances"."</h2>";
echo "<b>videos from these instances will be available in exode.me</b> <br /> <br/>";
foreach($f as $follower){
	echo $follower."<br />";
}

echo "<br /><br />";

$start=0;
$f = array();
$cont=true;
while($cont){
	$followersstr= file_get_contents($url."/api/v1/server/followers?start=".$start);
	$followers = json_decode($followersstr, true);
	foreach($followers['data'] as $follower){
		if (strpos($follower['follower']['url'], 'accounts/') !== false)
			array_push($f,$follower['follower']['url']);
	}
	$start+=15;
	if(sizeof($followers['data'])<15)
	 $cont=false;
}

echo "<h2>Followed by ".sizeof($f)." instances"."</h2>";
echo "<b>videos of exode.me will be available in these instances</b><br /> <br/>";
foreach($f as $follower){
	echo $follower."<br />";
}


echo "<br /><br /> <br />Ugly code available at : <a href=\"https://github.com/PhieF/MiscConfig/blob/master/Peertube/transparency.php\">https://github.com/PhieF/MiscConfig/blob/master/Peertube/transparency.php</a>";
?>
