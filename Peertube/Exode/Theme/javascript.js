document.getElementsByClassName("icon-logo")[0].style.display="none";
   var link = document.querySelector("link[rel*='icon']") || document.createElement('link');
    link.type = 'image/x-icon';
    link.rel = 'shortcut icon';
    link.href = 'https://blog.phie.fi/favicon.png';
    document.getElementsByTagName('head')[0].appendChild(link);


//searchbox
var searchBox = document.getElementById('search-video');
searchBox.parentNode.removeChild(searchBox)

document.getElementsByClassName("header")[0].insertBefore(searchBox, document.getElementsByClassName("header-right")[0])

//remove search icon

document.getElementsByClassName("icon-search")[0].style.display = "none";


/*
  add a warning before uploading videos
*/
setInterval(function(){
var vfile = document.getElementById("videofile");
if(vfile !== null){
 console.log("vfile ok");
   vfile.onclick=function(){
      alert("Please, be aware that videos must either be your own creation or cover of your own. For now user storage is limited. You can send an email to phie@phie.ovh to ask more space");

   }
}

},1000);

