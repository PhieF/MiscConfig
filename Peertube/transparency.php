<?php
$url="https://exode.me";
$followingsstr= file_get_contents($url."/api/v1/server/following");
$followings = json_decode($followingsstr, true);
echo "<h2>Following ".sizeof($followings['data'])." instances"."</h2>";
echo "videos from these instances will be available in exode.me <br /> <br/>";
foreach($followings['data'] as $follower){
		echo  $follower['following']['url']."<br />";
}


echo "<br /><br />";

$followersstr= file_get_contents($url."/api/v1/server/followers");
$followers = json_decode($followersstr, true);

echo "<h2>Followed by ".sizeof($followers['data'])." instances"."</h2>";
echo "videos of exode.me will be available in these instances<br /> <br/>";

foreach($followers['data'] as $follower){
		echo  $follower['follower']['url']."<br />";
}

?>
