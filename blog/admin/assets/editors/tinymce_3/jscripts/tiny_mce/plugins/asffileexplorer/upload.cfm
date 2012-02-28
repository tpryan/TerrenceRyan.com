<!--- 
 * File Explorer plugin cannot be used outside MangoBlog. Please visit asfusion.com 
 * to get a commercial version
 *
 * @author AsFusion
 * @copyright Copyright ©2008, AsFusion, All rights reserved.
 * --->
<cfif structkeyexists(form,"Filedata")>
    <cfset CreateObject("component", "MainFileExplorer").getInstance().getFileManager().uploadFile("Filedata", url.path, form.filename)/>
</cfif>
