// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(googlesheets4)\n");
}

function calculate(is_preview){
	// the R code to be evaluated

    echo("library(googledrive)\n");
    echo("library(googlesheets4)\n");
    echo("drive_auth()\n");
    echo("gs4_auth(token = drive_token())\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Authenticate results")).print();

    echo("rk.header(\"Google Services Authenticated\", level=3);\n");
  

}

