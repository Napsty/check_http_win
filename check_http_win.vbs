url = "ENTER_FULL_URL_HERE"
Set http = CreateObject("MSXML2.ServerXMLHTTP")
http.open "GET",url,false
http.send
If http.Status = 200 Then
  wscript.echo "HTTP OK - " & url & " returns " & http.Status
  exitCode = 0
ElseIf http.Status > 400 And http.Status < 500 Then
  wscript.echo "HTTP WARNING - " & url & " returns " & http.Status
  exitCode = 1
Else
  wscript.echo "HTTP CRITICAL - " & url & " returns " & http.Status
  exitCode = 2
End If

WScript.Quit(exitCode)
