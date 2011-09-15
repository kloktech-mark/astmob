// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function print_center() {
//  wi = window.open('', 'p')
  
//  wi.document.open()

  //wi.document.style.fontFamily = "serif"
  
  //wi.document.style.fontSize = "10px"

  //var oLink = document.createElement("link")
  
  //oLink.href = "stylesheets/print.css"
  //oLink.rel = "stylesheet"
  //oLink.type = "text/css"
  
  //wi.document.write('<link rel=stylesheet href="stylesheets/ast.css">');
  
  //element=document.getElementById("center1")
  
//  wi.document.write(element.innerHTML)
  
  
  
  
  //wi.print()
  
  //wi.document.close()
  
  //wi.close()

 
}

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}



function printdiv(printpage)
{
  wi = window.open('', 'p')
  
  wi.document.open()
  
  var headstr = "<html><head><title>Print</title></head><body>";
  var footstr = "</body>";
  var newstr = document.getElementById(printpage).innerHTML;
  var oldstr = document.body.innerHTML;
  wi.document.write = headstr+newstr+footstr;
  //document.body.innerHTML = headstr+newstr+footstr;
  
  window.print(); 
  
  //document.body.innerHTML = oldstr;
  return false;
}

