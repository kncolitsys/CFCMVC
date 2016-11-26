<!--- we can reset the application by adding appclear to the url variables --->
<!--- TODO: Make this configurable with a password like in Model-Glue --->
<cfif StructKeyExists(url,"appclear")>
	<cfset StructDelete(application,"config")>
	<cfset StructDelete(application,"newbee")>
	<cfset StructClear(session)>
</cfif>
 
<cfif not StructKeyExists(application,"config")>
<!--- get xmldata into application scope--->
	<!--- config data --->
	<cfinvoke component="newbee" method="config" returnvariable="configXML">
	<cfset application.config = configXML>
</cfif>

<cfif not StructKeyExists(application,"newbee")>
<!--- get xmldata into application scope--->
	<!--- event data  --->
	<cfinvoke component="newbee" method="newbee" returnvariable="newbeeXML">
	<cfset application.newbee = newbeeXML>
</cfif>

<!--- Combine gets and posts into the request scope (by Christian Cantrell : http://weblogs.macromedia.com/cantrell/archives/2005/05/why_distinguish.cfm--->

<!--- 
<cfset StructDelete(session.request,"event")> 
--->

<cfif isDefined("form")>
    <cfset structAppend(request, form, true)>
</cfif>
<cfif isDefined("url")>
    <cfset structAppend(request, url, true)>
</cfif>

<!--- dump() --->
<cfif StructKeyExists(url,"dump")>
	<cfdump var="#request#" label="Pre Controller: Request variables">
	<cfdump var="#application#" label="Pre Controller: Application variables">
</cfif>

<!--- set the event to default if not specified --->
<cfparam name="request.event" default="#application.config.defaultEvent#">

<!--- find "escape plugins" points --->
<cfif isDefined("application.newbee.events.#request.event#.escape")>
	<cfset escapepoints = application.newbee.events[request.event].escape.escape1["plugins"]>
</cfif>
<cfparam name="escapepoints" default="">

<!--- check for model.start plugins --->
<cfif isDefined("application.newbee.plugins.model.start") and not (ListFind(escapepoints,"all") or ListFind(escapepoints,"model-start"))>
	<cfset plugin_me_array = application.newbee.plugins.model.start>
	<cfloop list="#ListSort(StructKeyList(plugin_me_array),"text")#" index="name">
		<cfset model_path=ListDeleteAt(plugin_me_array[name].path,ListLen(plugin_me_array[name].path,"/"),"/")>
		<cfset model_component=ListFirst(ListLast(plugin_me_array[name].path,"/"),".")>
		<cfset model_method=plugin_me_array[name].method>
		<cfif StructKeyExists(plugin_me_array[name],"returnvariable")>
			<cfset model_return=plugin_me_array[name].returnvariable>
		<cfelse>
			<cfset model_return="void">
		</cfif>		
		<cfif Len(model_path)>
			<cfset messenger="../model/#model_path#/messenger.cfm">
			<cfif not FileExists(ExpandPath(messenger))>
				<cfset new_messenger="model/#model_path#/messenger.cfm">
				<cfset new_messenger= ExpandPath(new_messenger)>
				<cffile action="read" file="#ExpandPath("model/messenger.cfm")#" variable="messenger_txt">
				<cffile action="write" file="#new_messenger#" output="#messenger_txt#">
			</cfif>
		<cfelse>
			<cfset messenger="../model/messenger.cfm">
		</cfif>
		<cfinclude template="#messenger#">
	</cfloop>
</cfif>

<!--- call the model for current event --->
<cfif isDefined("application.newbee.events.#request.event#.model")>
	<cfset model_array = application.newbee.events[request.event].model>
	<cfloop list="#ListSort(StructKeyList(model_array),"text")#" index="model">
		<cfset model_path=ListDeleteAt(model_array[model].path,ListLen(model_array[model].path,"/"),"/")>
		<cfset model_component=ListFirst(ListLast(model_array[model].path,"/"),".")>
		<cfset model_method=model_array[model].method>
		<cfif StructKeyExists(model_array[model],"returnvariable")>
			<cfset model_return=model_array[model].returnvariable>
		<cfelse>
			<cfset model_return="void">
		</cfif>
		<cfif Len(model_path)>
			<cfset messenger="../model/#model_path#/messenger.cfm">
			<cfif not FileExists(ExpandPath(messenger))>
				<cfset new_messenger="model/#model_path#/messenger.cfm">
				<cfset new_messenger= ExpandPath(new_messenger)>
				<cffile action="read" file="#ExpandPath("model/messenger.cfm")#" variable="messenger_txt">
				<cffile action="write" file="#new_messenger#" output="#messenger_txt#">
			</cfif>
		<cfelse>
			<cfset messenger="../model/messenger.cfm">
		</cfif>
		<cfinclude template="#messenger#">
	</cfloop>
</cfif>

<!--- check for model.end plugins --->
<cfif isDefined("application.newbee.plugins.model.end") and not (ListFind(escapepoints,"all") or ListFind(escapepoints,"model-end"))>
	<cfset plugin_me_array = application.newbee.plugins.model.end>
	<cfloop list="#ListSort(StructKeyList(plugin_me_array),"text")#" index="name">
		<cfset model_path=ListDeleteAt(plugin_me_array[name].path,ListLen(plugin_me_array[name].path,"/"),"/")>
		<cfset model_component=ListFirst(ListLast(plugin_me_array[name].path,"/"),".")>
		<cfset model_method=plugin_me_array[name].method>
		<cfif StructKeyExists(plugin_me_array[name],"returnvariable")>
			<cfset model_return=plugin_me_array[name].returnvariable>
		<cfelse>
			<cfset model_return="void">
		</cfif>		
		<cfif Len(model_path)>
			<cfset messenger="../model/#model_path#/messenger.cfm">
			<cfif not FileExists(ExpandPath(messenger))>
				<cfset new_messenger="model/#model_path#/messenger.cfm">
				<cfset new_messenger= ExpandPath(new_messenger)>
				<cffile action="read" file="#ExpandPath("model/messenger.cfm")#" variable="messenger_txt">
				<cffile action="write" file="#new_messenger#" output="#messenger_txt#">
			</cfif>
		<cfelse>
			<cfset messenger="../model/messenger.cfm">
		</cfif>
		<cfinclude template="#messenger#">
	</cfloop>
</cfif>

<!--- check for, and execute event redirect --->
<cfif isDefined("application.newbee.events.#request.event#.redirect")>
	<cfset redirect_array = application.newbee.events[request.event].redirect>
	<cfloop list="#ListSort(StructKeyList(redirect_array),"text")#" index="redirect">
		<cflocation url="index.cfm?event=#redirect_array[redirect].event#" addtoken="false">
		<cfbreak>
	</cfloop>
	<cfabort>
</cfif>

<cfset structAppend(variables, request, true)>

<!--- check for view.start plugins --->
<cfif isDefined("application.newbee.plugins.view.start") and not (ListFind(escapepoints,"all") or ListFind(escapepoints,"view-start"))>
	<cfset plugin_vs_array = application.newbee.plugins.view.start>
	<cfloop list="#ListSort(StructKeyList(plugin_vs_array),"text")#" index="name">
		<cfinclude template="../view/#plugin_vs_array[name].path#">
	</cfloop>
</cfif>

<!--- call the view for the current event --->
<cfif isDefined("application.newbee.events.#request.event#.view")>
	<cfset view_array = application.newbee.events[request.event].view>
	<cfloop list="#ListSort(StructKeyList(view_array),"text")#" index="view">
		<cfinclude template="../view/#view_array[view].path#">
	</cfloop>
</cfif>

<!--- check for view.end plugins --->
<cfif isDefined("application.newbee.plugins.view.end") and not (ListFind(escapepoints,"all") or ListFind(escapepoints,"view-end"))>
	<cfset plugin_ve_array = application.newbee.plugins.view.end>
	<cfloop list="#ListSort(StructKeyList(plugin_ve_array),"text")#" index="name">
		<cfinclude template="../view/#plugin_ve_array[name].path#">
	</cfloop>
</cfif>

<!--- dump() --->
<cfif StructKeyExists(url,"dump")>
	<cfdump var="#request#" label="Post Controller: Request variables">
	<cfdump var="#application#" label="Post Controller: Application variables">
</cfif>