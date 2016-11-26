<cfset argumentcol = structNew()>
<cfset structAppend(argumentcol, request, true)>
<cfset structAppend(argumentcol, application.config, true)>
<cfinvoke component="#model_component#" method="#model_method#" argumentcollection="#argumentcol#"  returnvariable="#model_return#">