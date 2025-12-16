local({
  # =========================================================================================
  # 1. Package Definition and Metadata
  # =========================================================================================
  require(rkwarddev)
  rkwarddev.required("0.10-3")

  package_about <- rk.XML.about(
    name = "rk.googlesheets4",
    author = person(
      given = "Alfonso",
      family = "Cano",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "An RKWard plugin package for google sheet manipulation using the 'googlesheets4' library.",
      version = "0.0.1",
      url = "https://github.com/AlfCano/rk.googlesheets4",
      license = "GPL (>= 3)"
    )
  )

  common_hierarchy <- list("data", "Google Sheets (googlesheets4)")

  # =========================================================================================
  # MAIN PLUGIN: Authenticate
  # =========================================================================================

  help_auth <- rk.rkh.doc(
    title = rk.rkh.title(text = "Google Sheets Authentication"),
    summary = rk.rkh.summary(text = "Authenticates the R session with Google Drive and Google Sheets services."),
    usage = rk.rkh.usage(text = "Click Submit to load libraries and trigger the authentication flow in your web browser.")
  )

  auth_text <- rk.XML.text("This plugin will load 'googledrive' and 'googlesheets4' libraries and initiate authentication.<br><br><b>Note:</b> A browser window may open to request permissions.")

  dialog_auth <- rk.XML.dialog(
    label = "Authenticate Google Services",
    child = rk.XML.col(auth_text)
  )

  js_calc_auth <- '
    echo("library(googledrive)\\n");
    echo("library(googlesheets4)\\n");
    echo("drive_auth()\\n");
    echo("gs4_auth(token = drive_token())\\n");
  '

  js_print_auth <- '
    echo("rk.header(\\"Google Services Authenticated\\", level=3);\\n");
  '

  # =========================================================================================
  # COMPONENT 1: Find Sheet
  # =========================================================================================

  find_input <- rk.XML.input(label = "Search pattern (Sheet Name)", id.name = "find_pattern")
  find_save <- rk.XML.saveobj(label = "Save found metadata as", chk = TRUE, initial = "ss", id.name = "find_save_obj")

  dialog_find <- rk.XML.dialog(
    label = "Find Google Sheet",
    child = rk.XML.col(find_input, find_save)
  )

  js_calc_find <- '
    var pattern = getValue("find_pattern");

    if(pattern == "") {
        echo("stop(\\\"Please provide a name to search for.\\\")\\n");
    } else {
        echo("ss <- gs4_find(\\\"" + pattern + "\\\")\\n");
    }
  '

  js_print_find <- '
    var save_name = getValue("find_save_obj.objectname");
    echo("rk.header(\\"Google Sheet Found: " + save_name + "\\", level=3);\\n");
  '

  component_find <- rk.plugin.component(
    "Find Sheet by Name",
    xml = list(dialog = dialog_find),
    js = list(require="googlesheets4", calculate = js_calc_find, printout = js_print_find),
    hierarchy = common_hierarchy
  )

  # =========================================================================================
  # COMPONENT 2: Get Info
  # =========================================================================================

  get_input <- rk.XML.input(label = "Sheet URL or ID", id.name = "get_url")
  get_save <- rk.XML.saveobj(label = "Save sheet metadata as", chk = TRUE, initial = "cals", id.name = "get_save_obj")

  dialog_get <- rk.XML.dialog(
    label = "Get Sheet Metadata",
    child = rk.XML.col(get_input, get_save)
  )

  js_calc_get <- '
    var url = getValue("get_url");

    if(url == "") {
        echo("stop(\\\"Please provide a URL or ID.\\\")\\n");
    } else {
        echo("cals <- gs4_get(\\\"" + url + "\\\")\\n");
    }
  '

  js_print_get <- '
    var save_name = getValue("get_save_obj.objectname");
    echo("rk.header(\\"Metadata retrieved: " + save_name + "\\", level=3);\\n");
  '

  component_get <- rk.plugin.component(
    "Get Metadata from URL",
    xml = list(dialog = dialog_get),
    js = list(require="googlesheets4", calculate = js_calc_get, printout = js_print_get),
    hierarchy = common_hierarchy
  )

  # =========================================================================================
  # COMPONENT 3: Write Sheet
  # =========================================================================================

  write_selector <- rk.XML.varselector(id.name = "write_selector")

  write_df <- rk.XML.varslot(label = "Dataframe to write", source = "write_selector", required = TRUE, id.name = "write_df")
  write_ss <- rk.XML.varslot(label = "Target Sheet Object (ss)", source = "write_selector", required = TRUE, id.name = "write_ss")
  write_sheet_name <- rk.XML.input(label = "Name of the sheet (tab)", id.name = "write_sheet_name")

  dialog_write <- rk.XML.dialog(
    label = "Write Data to Sheet",
    child = rk.XML.row(
        write_selector,
        rk.XML.col(write_df, write_ss, write_sheet_name)
    )
  )

  js_calc_write <- '
    var df = getValue("write_df");
    var ss = getValue("write_ss");
    var sheet = getValue("write_sheet_name");

    if(sheet == "") {
        echo("write_sheet(" + df + ", ss = " + ss + ")\\n");
    } else {
        echo("write_sheet(" + df + ", ss = " + ss + ", sheet = \\\"" + sheet + "\\\")\\n");
    }
  '

  js_print_write <- '
    echo("rk.header(\\"Data written to Google Sheet\\", level=3);\\n");
  '

  component_write <- rk.plugin.component(
    "Write Data to Sheet",
    xml = list(dialog = dialog_write),
    js = list(require="googlesheets4", calculate = js_calc_write, printout = js_print_write),
    hierarchy = common_hierarchy
  )

  # =========================================================================================
  # COMPONENT 4: Read Sheet (Updated with Smart Fix)
  # =========================================================================================

  read_selector <- rk.XML.varselector(id.name = "read_selector")

  read_source_radio <- rk.XML.radio(label = "Source Type", options = list(
      "Sheet Object (ss)" = list(val = "obj", chk = TRUE),
      "URL or ID (String)" = list(val = "url")
  ), id.name = "read_source_type")

  read_ss_obj <- rk.XML.varslot(label = "Select 'ss' Object", source = "read_selector", id.name = "read_ss_obj")
  read_url_txt <- rk.XML.input(label = "Paste URL or ID", id.name = "read_url_text")

  read_sheet_arg <- rk.XML.input(label = "Sheet (Name or Index)", id.name = "read_sheet_arg")
  read_range_arg <- rk.XML.input(label = "Range (e.g., 'A1:B4')", id.name = "read_range_arg")

  # CHANGED: Checkbox for Smart Fix
  read_fix_lists <- rk.XML.cbox(label = "Convert mixed 'List' columns to Text (keep others as is)", value = "1", id.name = "read_fix_lists")

  read_func_drop <- rk.XML.dropdown(label = "Function", options = list(
      "read_sheet()" = list(val = "read_sheet", chk = TRUE),
      "range_read()" = list(val = "range_read")
  ), id.name = "read_func")

  read_save <- rk.XML.saveobj(label = "Save data to R", chk = TRUE, initial = "my_sheet_data", id.name = "read_save_obj")

  dialog_read <- rk.XML.dialog(
    label = "Read Google Sheet",
    child = rk.XML.row(
        read_selector,
        rk.XML.col(
            read_source_radio,
            read_ss_obj,
            read_url_txt,
            rk.XML.stretch(),
            read_func_drop,
            read_sheet_arg,
            read_range_arg,
            read_fix_lists,
            read_save
        )
    )
  )

  js_calc_read <- '
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
        ss_arg = "\\\"" + url + "\\\"";
    }

    var args = ss_arg;
    if (sheet != "") args += ", sheet = \\\"" + sheet + "\\\"";
    if (range != "") args += ", range = \\\"" + range + "\\\"";

    // 1. Perform the read
    echo("my_sheet_data <- " + func + "(" + args + ")\\n");

    // 2. Post-processing if requested
    if (fix_lists == "1") {
        echo("# Fix list-columns (mixed types) by forcing them to character vectors\\n");
        echo("my_sheet_data[] <- lapply(my_sheet_data, function(x) {\\n");
        echo("  if (is.list(x)) {\\n");
        echo("    vapply(x, function(y) if (is.null(y)) NA_character_ else as.character(y), character(1))\\n");
        echo("  } else {\\n");
        echo("    x\\n");
        echo("  }\\n");
        echo("})\\n");
    }
  '

  js_print_read <- '
    var save_name = getValue("read_save_obj.objectname");
    echo("rk.header(\\"Google Sheet Data Loaded: " + save_name + "\\", level=3);\\n");
  '

  component_read <- rk.plugin.component(
    "Read Google Sheet",
    xml = list(dialog = dialog_read),
    js = list(require="googlesheets4", calculate = js_calc_read, printout = js_print_read),
    hierarchy = common_hierarchy
  )

  # =========================================================================================
  # COMPONENT 5: Create Sheet
  # =========================================================================================

  create_input <- rk.XML.input(label = "Name for new Sheet", id.name = "create_name")
  create_save <- rk.XML.saveobj(label = "Save sheet metadata as", chk = TRUE, initial = "ss_new", id.name = "create_save_obj")

  dialog_create <- rk.XML.dialog(
    label = "Create New Google Sheet",
    child = rk.XML.col(create_input, create_save)
  )

  js_calc_create <- '
    var name = getValue("create_name");

    if(name == "") {
        echo("stop(\\\"Please provide a name for the new sheet.\\\")\\n");
    } else {
        echo("ss_new <- gs4_create(\\\"" + name + "\\\")\\n");
    }
  '

  js_print_create <- '
    var save_name = getValue("create_save_obj.objectname");
    echo("rk.header(\\"New Google Sheet Created: " + save_name + "\\", level=3);\\n");
  '

  component_create <- rk.plugin.component(
    "Create New Sheet",
    xml = list(dialog = dialog_create),
    js = list(require="googlesheets4", calculate = js_calc_create, printout = js_print_create),
    hierarchy = common_hierarchy
  )

  # =========================================================================================
  # COMPONENT 6: Advanced Operations
  # =========================================================================================

  adv_selector <- rk.XML.varselector(id.name = "adv_selector")

  adv_df <- rk.XML.varslot(label = "Data (for append/write)", source = "adv_selector", id.name = "adv_df")
  adv_ss <- rk.XML.varslot(label = "Sheet Object (ss)", source = "adv_selector", required = TRUE, id.name = "adv_ss")

  adv_action <- rk.XML.dropdown(label = "Action", options = list(
      "Append Data (sheet_append)" = list(val = "sheet_append", chk = TRUE),
      "Range Write (range_write)" = list(val = "range_write"),
      "Range Flood (range_flood)" = list(val = "range_flood"),
      "Range Clear (range_clear)" = list(val = "range_clear")
  ), id.name = "adv_action")

  adv_sheet <- rk.XML.input(label = "Sheet Name (optional)", id.name = "adv_sheet")
  adv_range <- rk.XML.input(label = "Range (optional)", id.name = "adv_range")

  dialog_adv <- rk.XML.dialog(
    label = "Advanced Sheet Operations",
    child = rk.XML.row(
        adv_selector,
        rk.XML.col(adv_ss, adv_action, adv_df, adv_sheet, adv_range)
    )
  )

  js_calc_adv <- '
    var func = getValue("adv_action");
    var ss = getValue("adv_ss");
    var df = getValue("adv_df");
    var sheet = getValue("adv_sheet");
    var range = getValue("adv_range");

    var args = "ss = " + ss;

    if ((func != "range_clear") && (df != "")) {
        args += ", data = " + df;
    }

    if (sheet != "") args += ", sheet = \\\"" + sheet + "\\\"";
    if (range != "") args += ", range = \\\"" + range + "\\\"";

    echo(func + "(" + args + ")\\n");
  '

  js_print_adv <- '
    var func = getValue("adv_action");
    echo("rk.header(\\"Operation Complete: " + func + "\\", level=3);\\n");
  '

  component_adv <- rk.plugin.component(
    "Advanced Operations",
    xml = list(dialog = dialog_adv),
    js = list(require="googlesheets4", calculate = js_calc_adv, printout = js_print_adv),
    hierarchy = common_hierarchy
  )

  # =========================================================================================
  # BUILD SKELETON
  # =========================================================================================

  rk.plugin.skeleton(
    about = package_about,
    path = ".",
    xml = list(dialog = dialog_auth),
    js = list(
        require = "googlesheets4",
        calculate = js_calc_auth,
        printout = js_print_auth
    ),
    rkh = list(help = help_auth),
    components = list(
        component_find,
        component_get,
        component_write,
        component_read,
        component_create,
        component_adv
    ),
    pluginmap = list(
        name = "Authenticate",
        hierarchy = common_hierarchy
    ),
    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  cat("\nPlugin package 'rk.googlesheets4' generated successfully.\n")
  cat("To complete installation:\n")
  cat("  1. rk.updatePluginMessages(path=\".\")\n")
  cat("  2. devtools::install(\".\")\n")
})
