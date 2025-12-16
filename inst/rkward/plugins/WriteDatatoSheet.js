// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(googlesheets4)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var df = getValue("write_df");
    var ss = getValue("write_ss");
    var sheet = getValue("write_sheet_name");

    if(sheet == "") {
        echo("write_sheet(" + df + ", ss = " + ss + ")\n");
    } else {
        echo("write_sheet(" + df + ", ss = " + ss + ", sheet = \"" + sheet + "\")\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Write Data to Sheet results")).print();

    echo("rk.header(\"Data written to Google Sheet\", level=3);\n");
  

}

