// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(googlesheets4)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var name = getValue("create_name");

    if(name == "") {
        echo("stop(\"Please provide a name for the new sheet.\")\n");
    } else {
        echo("ss_new <- gs4_create(\"" + name + "\")\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Create New Sheet results")).print();

    var save_name = getValue("create_save_obj.objectname");
    echo("rk.header(\"New Google Sheet Created: " + save_name + "\", level=3);\n");
  
	//// save result object
	// read in saveobject variables
	var createSaveObj = getValue("create_save_obj");
	var createSaveObjActive = getValue("create_save_obj.active");
	var createSaveObjParent = getValue("create_save_obj.parent");
	// assign object to chosen environment
	if(createSaveObjActive) {
		echo(".GlobalEnv$" + createSaveObj + " <- ss_new\n");
	}

}

