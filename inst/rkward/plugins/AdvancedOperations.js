// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(googlesheets4)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var func = getValue("adv_action");
    var ss = getValue("adv_ss");
    var df = getValue("adv_df");
    var sheet = getValue("adv_sheet");
    var range = getValue("adv_range");

    var args = "ss = " + ss;

    if ((func != "range_clear") && (df != "")) {
        args += ", data = " + df;
    }

    if (sheet != "") args += ", sheet = \"" + sheet + "\"";
    if (range != "") args += ", range = \"" + range + "\"";

    echo(func + "(" + args + ")\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Advanced Operations results")).print();

    var func = getValue("adv_action");
    echo("rk.header(\"Operation Complete: " + func + "\", level=3);\n");
  

}

