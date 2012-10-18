clear
function Execute-SOAPRequest 
( 
        [Xml]    $SOAPRequest, 
        [String] $URL 
) 
{ 
        write-host "Sending SOAP Request To Server: $URL" 
        $soapWebRequest = [System.Net.WebRequest]::Create($URL) 
        $soapWebRequest.Headers.Add("SOAPAction","`"http://www.webserviceX.NET/ChangeMetricWeightUnit`"")
        $soapWebRequest.ContentType = "text/xml;charset=`"utf-8`"" 
        $soapWebRequest.Method      = "POST" 
        
        write-host "Initiating Send." 
        $requestStream = $soapWebRequest.GetRequestStream() 
        $SOAPRequest.Save($requestStream) 
        $requestStream.Close() 
        
        write-host "Send Complete, Waiting For Response." 
        $resp = $soapWebRequest.GetResponse() 
        $responseStream = $resp.GetResponseStream() 
        $soapReader = [System.IO.StreamReader]($responseStream) 
        $ReturnXml = [Xml] $soapReader.ReadToEnd() 
        $responseStream.Close() 
        write-host "Response Received."
        return $ReturnXml 

}

$url = 'http://www.webservicex.net/convertMetricWeight.asmx'
$soap = [xml]@'
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ChangeMetricWeightUnit xmlns="http://www.webserviceX.NET/">
      <MetricWeightValue>1</MetricWeightValue>
      <fromMetricWeightUnit>kilogram</fromMetricWeightUnit>
      <toMetricWeightUnit>gram</toMetricWeightUnit>
    </ChangeMetricWeightUnit>
  </soap:Body>
</soap:Envelope>
'@
$ret = Execute-SOAPRequest $soap $url; $ret | Export-Clixml  "c:\tmp\response.xml";