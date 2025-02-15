/*-- JavaScript method for Print command --*/
function PrintDoc() {
  var toPrint = document.getElementById('printarea');
  var popupWin = window.open('', '_blank', 'width=800,height=800,location=no,left=200px');
  popupWin.document.open();
  popupWin.document.write('<html><title>::Preview::</title><link rel="stylesheet" type="text/css" href="style/print.css" /></head><body>');
  popupWin.document.write('<input type="button" class="printButton" aria-current="page" value="Print" onclick="window.print()">');
  popupWin.document.write(toPrint.innerHTML);
  popupWin.document.write('</body&gt;');
  popupWin.document.write('</html&gt;');
  popupWin.document.close();
}

var printbtn = document.getElementById("imom-print-button");
printbtn.addEventListener("click", PrintDoc, false);