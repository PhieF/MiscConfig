<?php
$f = file_get_contents("https://raw.githubusercontent.com/ai-robots-txt/ai.robots.txt/refs/heads/main/robots.json");
$arr = array();
foreach(json_decode($f) as $k => $v){
array_push($arr, addslashes($k));
}
file_put_contents("/etc/nginx/block.conf", "if (\$http_user_agent ~* \"(".implode('|', $arr).")\"){\nreturn 403;\n}");
?>
