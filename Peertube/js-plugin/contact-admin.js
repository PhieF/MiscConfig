/*
   adds a "contact admin" link in the left menu
*/
var mail = "your@mail.com";
var panels = document.getElementsByClassName("panel-block");
var panel = panels[panels.length-1];
panel.innerHTML = panel.innerHTML + '<a _ngcontent-c2=""  href="mailto://'+mail+'">\
      <span _ngcontent-c2="" class="icon icon-contact"></span>\
      Contact admin\
    </a>';
