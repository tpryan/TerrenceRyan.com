component{
	
	public function init(required string username, required string password){
    	variables.username = arguments.username;
    	variables.password = arguments.password;	
    	return This;
   	}
    
    public function clearCache(){
    	var admin= New CFIDE.adminapi.administrator();
    	admin.login(variables.password, variables.username);
    	
    	var runtime = new CFIDE.adminapi.runtime();
    	runtime.clearTrustedCache();
    }    

}