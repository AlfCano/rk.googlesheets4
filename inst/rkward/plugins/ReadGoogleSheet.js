// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(googlesheets4)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var src_type = getValue("read_source_type");
    var ss_obj = getValue("read_ss_obj");
    var url = getValue("read_url_text");
    var func = getValue("read_func");
    var sheet = getValue("read_sheet_arg");
    var range = getValue("read_range_arg");
    var fix_lists = getValue("read_fix_lists");

    var ss_arg = "";
    if (src_type == "obj") {
        ss_arg = ss_obj;
    } else {
        ss_arg = "\"" + url + "\"";
    }

    var args = ss_arg;
    if (sheet != "") args += ", sheet = \"" + sheet + "\"";
    if (range != "") args += ", range = \"" + range + "\"";

    // 1. Perform the read
    echo("my_sheet_data <- " + func + "(" + args + ")\n");

    // 2. Post-processing if requested
    if (fix_lists == "1") {
        echo("# Fix list-columns (mixed types) by forcing them to character vectors\n");
        echo("my_sheet_data[] <- lapply(my_sheet_data, function(x) {\n");
        echo("  if (is.list(x)) {\n");
        echo("    vapply(x, function(y) if (is.null(y)) NA_character_ else as.character(y), character(1))\n");
        echo("  } else {\n");
        echo("    x\n");
        echo("  }\n");
        echo("})\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Read Google Sheet results")).print();

    var save_name = getValue("read_save_obj.objectname");
    echo("rk.header(\"Google Sheet Data Loaded: " + save_name + "\", level=3);\n");
  
	//// save result object
	// read in saveobject variables
	var readSaveObj = getValue("read_save_obj");
	var readSaveObjActive = getValue("read_save_obj.active");
	var readSaveObjParent = getValue("read_save_obj.parent");
	// assign object to chosen environment
	if(readSaveObjActive) {
		echo(".GlobalEnv$" + readSaveObj + " <- my_sheet_data\n");
	}

}

