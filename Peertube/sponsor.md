JS
```
document.getElementsByTagName("my-search-typeahead")[0].innerHTML = "<span id='sponsor-peertube'>Peertube is still needing your help to implement live features and continue developing. <a href='https://joinpeertube.org/roadmap'>Sponsor them</a></span> "+document.getElementsByTagName("my-search-typeahead")[0].innerHTML 
```

CSS
```
@media all and (max-width: 1300px) {
#sponsor-peertube{
display:none;
}
}
```
