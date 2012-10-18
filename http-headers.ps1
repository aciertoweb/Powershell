## zie: http://scriptolog.blogspot.nl/2007/08/query-http-status-codes-and-headers.html

clear
write-host "Method 1: Xml Http (com object)"
$url = "http://www.nu.nl"
$xHTTP = new-object -com msxml2.xmlhttp;
$xHTTP.open("HEAD",$url,$false);
$xHTTP.send();
$xHTTP.status # returns the status code
$xHTTP.statusText
# $xHTTP.getAllResponseHeaders()
$xHTTP.getResponseHeader("Content-Length")
# $xHTTP.ResponseText; # returns the html doc like downloadstring

Write-Host "Method 2: System.Net.HttpWebRequest"
$url = "http://www.nu.nl"
$req=[system.Net.HttpWebRequest]::Create($url);
$res = $req.getresponse();
$stat = $res.statuscode;
$res.Close();
$res.GetResponseHeader("Content-Length") 
$res.StatusCode
$res.CharacterSet 	

Write-Host "Method 3: System.Net.WebClient"
$url="http://www.nu.nl"
$wc = new-object net.webclient
$html = $wc.DownloadString($url)
$wc.Encoding.BodyName

