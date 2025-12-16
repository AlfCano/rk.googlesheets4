// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(googlesheets4)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var pattern = getValue("find_pattern");

    if(pattern == "") {
        echo("stop(\"Please provide a name to search for.\")\n");
    } else {
        echo("ss <- gs4_find(\"" + pattern + "\")\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Find Sheet by Name results")).print();

    var save_name = getValue("find_save_obj.objectname");
    echo("rk.header(\"Google Sheet Found: " + save_name + "\", level=3);\n");
  
	//// save result object
	// read in saveobject variables
	var findSaveObj = getValue("find_save_obj");
	var findSaveObjActive = getValue("find_save_obj.active");
	var findSaveObjParent = getValue("find_save_obj.parent");
	// assign object to chosen environment
	if(findSaveObjActive) {
		echo(".GlobalEnv$" + findSaveObj + " <- ss\n");
	}

}

