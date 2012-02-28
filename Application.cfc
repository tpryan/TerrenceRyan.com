component{

	this.name="com.terrenceryan";
	this.clientmanagement="no";
	this.sessionmanagement="yes";
	this.setclientcookies="yes";
	this.sessionTimeout=CreateTimeSpan(0,0,20,0);
	this.mappings[this.name] = getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings['coldspring'] = "/coldspring1-2-final/";
	this.customtagpaths = "#getDirectoryFromPath(getCurrentTemplatePath())#customtags";
	this.dir = "#getDirectoryFromPath(getCurrentTemplatePath())#";
	
	

	public boolean function onApplicationStart(){
		include "config/createObjects.cfm";
		return TRUE;
	}

	public boolean function onRequestStart(string targetPage){
		
		if (structKeyExists(url,"reset_app")){
			applicationStop();
			location(url=cgi.script_name, addtoken="false");
		}
	
		return TRUE;
	}

	public boolean function onMissingTemplate(string targetPage){
		var redirect = new cfc.service.redirect(application.settings.geturl());
		var fileName = GetFileFromPath(arguments.targetPage);
		var redirectTarget = redirect.getRedirectURL(arguments.targetPage);

		location(redirectTarget, false,  "301");
	
		return TRUE;
	}
	
	public function onError(exception, eventName){
		if(structKeyExists(Application,"error")){
			local.report = application.error.generateErrorDebugging(exception,cgi,application,session,url,form);
			
			if (application.debug.getShow()){
				
				writeOutput(local.report);
			}
			else{
				application.error.email(local.report);
				include "error.cfm";
			}
			
			
			application.error.email(local.report);
				location("/error.cfm", false);
			
		
		}
	}
	
	
	

}
	