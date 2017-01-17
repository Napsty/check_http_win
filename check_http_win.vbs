'################################################################################
'# Script:       check_http_win.vbs                                             #
'# Author:       Claudio Kuenzler www.claudiokuenzler.com                       #
'# Purpose:      Simple check_http alternative running on Windows hosts         #
'# Description:  This plugin can be executed on a Windows host to perform       #
'#               HTTP checks. It uses the ServerXMLHTTP object.                 #
'# History:                                                                     #
'# 20170105 0.1  First version released, url needed to be hardcoded             #
'# 20170117 0.2  Using arguments for dynamic usage of the plugin                #
'################################################################################

' Get the arguments and check for correct number of arguments 
Set args = WScript.Arguments
If Wscript.Arguments.Count = 0 Then
  wscript.echo "check_http_win UNKNOWN - Missing arguments. Usage is: check_http_win.vbs 'Method' 'URL' 'ExpectStatus' 'POSTData'"
  exitCode = 3
  WScript.Quit(exitCode) 
ElseIf Wscript.Arguments.Count < 4 Then
  wscript.echo "check_http_win UNKNOWN - Missing arguments. Usage is: check_http_win.vbs 'Method' 'URL' 'ExpectStatus' 'POSTData'"
  exitCode = 3
  WScript.Quit(exitCode) 
ElseIf Wscript.Arguments.Count > 4 Then
  wscript.echo "check_http_win UNKNOWN - Too many arguments. Usage is: check_http_win.vbs 'Method' 'URL' 'ExpectStatus' 'POSTData'"
  exitCode = 3
  WScript.Quit(exitCode) 
Else 
  ' All was correct, let's define the variables
  MyMethod = args.Item(0)
  MyUrl = args.Item(1)
  If args.Item(2) = "" Then
    MyExpectIgnore = 1
  Else 
	MyExpect = CInt(args.Item(2))
  End If
  MyData = args.Item(3)
End If

' Validate Method
If Not ((MyMethod = "HEAD") Or (MyMethod = "GET") Or (MyMethod = "POST")) Then
  wscript.echo "check_http_win UNKNOWN - Unknown HTTP method (only HEAD, GET, POST are allowed)"
  exitCode = 3
  WScript.Quit(exitCode) 
End If

' Validate ExpectStatus
If Not MyExpectIgnore = 1 Then 
	If Not MyExpect >= 200 And MyExpect < 600 Then
	  wscript.echo "check_http_win UNKNOWN - Unknown HTTP status expected (must be >=200 and <600)"
	  exitCode = 3
	  WScript.Quit(exitCode) 
	End If
End If

' Check for URL
If (MyUrl = "") Then
  wscript.echo "check_http_win UNKNOWN - No URL defined"
  exitCode = 3
  WScript.Quit(exitCode) 
End If

' Run the magic
Set http = CreateObject("MSXML2.ServerXMLHTTP")
http.open MyMethod,MyUrl,false
If (MyMethod = "POST") Then
  http.send MyData
Else
  http.send
End If

' Handle return status
' No expected status given, use default handling of http status codes
If MyExpectIgnore = 1 Then
	If http.Status = 200 Then
	  wscript.echo "HTTP OK - " & MyUrl & " returns " & http.Status
	  exitCode = 0
	ElseIf http.Status > 300 And http.Status < 500 Then
	  wscript.echo "HTTP WARNING - " & MyUrl & " returns " & http.Status
	  exitCode = 1
	Else
	  wscript.echo "HTTP CRITICAL - " & MyUrl & " returns " & http.Status
	  exitCode = 2
	End If
Else 
' User expects a certain http status
  If http.Status = MyExpect Then
	wscript.echo "HTTP OK - " & MyUrl & " returns " & http.Status & " (expected: " & MyExpect & ")"
	exitCode = 0
  Else 
    wscript.echo "HTTP CRITICAL - " & MyUrl & " returns " & http.Status & " but expected " & MyExpect
	exitCode = 2
  End If
End If

WScript.Quit(exitCode)
