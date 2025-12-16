// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(googlesheets4)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var url = getValue("get_url");

    if(url == "") {
        echo("stop(\"Please provide a URL or ID.\")\n");
    } else {
        echo("cals <- gs4_get(\"" + url + "\")\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Get Metadata from URL results")).print();

    var save_name = getValue("get_save_obj.objectname");
    echo("rk.header(\"Metadata retrieved: " + save_name + "\", level=3);\n");
  
	//// save result object
	// read in saveobject variables
	var getSaveObj = getValue("get_save_obj");
	var getSaveObjActive = getValue("get_save_obj.active");
	var getSaveObjParent = getValue("get_save_obj.parent");
	// assign object to chosen environment
	if(getSaveObjActive) {
		echo(".GlobalEnv$" + getSaveObj + " <- cals\n");
	}

}

