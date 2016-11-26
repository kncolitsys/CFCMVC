<cfset setEncoding("form","utf-8")>   
<cfset setEncoding("url","utf-8")>

<!--- the following way of dynamically naming the application is borrowed from BlogCFC written by Raymond Camden --->
<cfset appname = "Default"> 
<cfset prefix = hash(getCurrentTemplatePath())>   
<cfset prefix = reReplace(prefix, "[^a-zA-Z]","","all")>   
<cfset prefix = right(prefix, 64 - len("_newbee_#appname#"))>  

<cfapplication name="#prefix#_newbee_#appname#" applicationtimeout="#createTimeSpan(2,0,0,0)#" sessionmanagement="true" sessiontimeout="#createTimeSpan(0,0,20,0)#">

<cfinclude template="controller/newbee.cfm">