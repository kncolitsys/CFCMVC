<cfcomponent name="newbee_config" displayname="newBee config cfc" hint="I initiate the application variables">

	<!--- config() method - for setting application variables from the config.xml - change with each instance off an application --->
	<cffunction name="config" access="public" returntype="any">
		
		<!--- let's var scope some variables --->
		<cfset var configXmlDoc = "">
		<cfset var configXml = "">
		<cfset var config_array = "">
		<cfset var config_name = "">
		
		<!--- find the path to the config.xml file --->
		<cfset var tempPath = "#ListDeleteAt(GetCurrentTemplatePath(),ListLen(GetCurrentTemplatePath(),"\"),"\")#">
		<cfset var configXmlPath = "#ListDeleteAt(tempPath,ListLen(tempPath,"\"),"\")#\config\config.xml">
		
		<!--- read the config.xml file into string variable called configXmlDoc --->
		<cffile action="read" file="#configXmlPath#" variable="configXmlDoc" />
		
		<!--- parse configXmlDoc into an XML "object" called configXml --->
		<cfset configXml = XmlParse(configXmlDoc)>
		
		<cfset config_array = "#configXml.newbee_config.xmlchildren#"> 
		
		<cfloop from="1" to="#arraylen(config_array)#" index="i">
			<cfset config_name = config_array[i].xmlattributes["name"]>
			<cfset "arr_config.vars.#config_name#" = #config_array[i].xmlattributes["value"]#> 
		</cfloop>
	
		<cfreturn arr_config.vars>
		
	</cffunction>
	
	<!--- newbee() method - the controller that handles the interaction between view and model - does not change with each instance off an application --->
	<cffunction name="newbee" access="public" returntype="any">
		
		<!--- let's var scope some variables --->
		<cfset var newbeeXml = "">
		<cfset var event_array = "">
		<cfset var event_name = "">
		<cfset var event_name_array = "">
		<cfset var plugin_array = "">
		<cfset var plugin_name = "">
		
		<!--- find the path to the config.xml file --->
		<cfset var newbeeXmlPath = "#ListDeleteAt(GetCurrentTemplatePath(),ListLen(GetCurrentTemplatePath(),"\"),"\")#\newbee.xml">
		
		<!--- read the newbee.xml file into string variable called newbeeXmlDoc --->
		<cffile action="read" file="#newbeeXmlPath#" variable="newbeeXmlDoc" />
		
		<!--- parse newbeeXmlDoc into an XML "object" called newbeeXml --->
		<cfset newbeeXml = XmlParse(newbeeXmlDoc)>
		
		<!--- create an array to hold events --->
		<cfset event_array="#newbeeXml.newbee_controller.events.xmlchildren#"> 
		
		<!--- loop through all events --->
		<cfloop from="1" to="#arraylen(event_array)#" index="i">
		<cfset event_name = event_array[i].xmlattributes["event"]>
		<cfset event_name_array = "#newbeeXml.newbee_controller.events.event[i].xmlchildren#">
			<cfloop from="1" to="#arraylen(event_name_array)#" index="j">
				<cfset "arr_config.vars.events.#event_name#.#event_name_array[j].xmlname#.#event_name_array[j].xmlname##j#" = #event_name_array[j].xmlattributes#> 
			</cfloop>	
		</cfloop>
		
		<!--- create an array to hold plugins --->
		<cfset plugin_array="#newbeeXml.newbee_controller.plugins.xmlchildren#"> 
		
		<!--- loop through all plugins --->
		<cfloop from="1" to="#arraylen(plugin_array)#" index="i">
			<cfset plugin_name = plugin_array[i].xmlattributes["name"]>
			<cfset "arr_config.vars.plugins.#plugin_array[i].xmlattributes["type"]#.#plugin_array[i].xmlattributes["point"]#.#plugin_name#" = #plugin_array[i].xmlattributes#> 
		</cfloop>
	
		<cfreturn arr_config.vars>
	
	</cffunction>
</cfcomponent>