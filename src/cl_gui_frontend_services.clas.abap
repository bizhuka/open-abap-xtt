CLASS cl_gui_frontend_services DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES abap_encoding TYPE abap_encod.

    CONSTANTS hkey_classes_root  TYPE i      VALUE 0 ##NO_TEXT.

    CONSTANTS filetype_all       TYPE string VALUE 'abc'.
    CONSTANTS filetype_xml       TYPE string VALUE 'xml'.
    CONSTANTS filetype_text      TYPE string VALUE 'txt'.
    CONSTANTS filetype_excel     TYPE string VALUE 'xls'.

    class-data FILETYPE_HTML type STRING read-only .

    CONSTANTS action_cancel      TYPE i      VALUE 1.
    CONSTANTS action_ok          TYPE i      VALUE 1.

    CONSTANTS platform_nt351     TYPE i      VALUE 1.
    CONSTANTS platform_nt40      TYPE i      VALUE 2.
    CONSTANTS platform_nt50      TYPE i      VALUE 3.
    CONSTANTS platform_windows95 TYPE i      VALUE 4.
    CONSTANTS platform_windows98 TYPE i      VALUE 5.
    CONSTANTS platform_windowsxp TYPE i      VALUE 6.

    CONSTANTS hkey_current_user  TYPE i      VALUE 1.

    CLASS-METHODS get_temp_directory
      CHANGING temp_dir TYPE string.

    CLASS-METHODS get_computer_name
      CHANGING   computer_name TYPE string
      EXCEPTIONS cntl_error
                 error_no_gui
                 not_supported_by_gui.

    CLASS-METHODS get_drive_type
      IMPORTING  drive      TYPE string
      CHANGING   drive_type TYPE string
      EXCEPTIONS cntl_error
                 bad_parameter
                 error_no_gui
                 not_supported_by_gui.

    CLASS-METHODS file_copy
      IMPORTING  !source      TYPE string
                 !destination TYPE string
                 overwrite    TYPE abap_bool DEFAULT abap_false
      EXCEPTIONS cntl_error
                 error_no_gui
                 wrong_parameter
                 disk_full
                 access_denied
                 file_not_found
                 destination_exists
                 unknown_error
                 path_not_found
                 disk_write_protect
                 drive_not_ready
                 not_supported_by_gui.

    CLASS-METHODS registry_set_dword_value
      IMPORTING  !root       TYPE i
                 !key        TYPE string
                 !value      TYPE string OPTIONAL
                 dword_value TYPE i
      EXPORTING  !rc         TYPE i
      EXCEPTIONS cntl_error
                 error_no_gui
                 not_supported_by_gui.

    CLASS-METHODS
      gui_download
        IMPORTING  bin_filesize              TYPE i         OPTIONAL
                   filename                  TYPE string
                   filetype                  TYPE clike     OPTIONAL
                   write_lf                  TYPE abap_bool OPTIONAL
                   write_field_separator     TYPE char1     OPTIONAL
                   show_transfer_status      TYPE char1     OPTIONAL
                   confirm_overwrite         TYPE abap_bool OPTIONAL
                   trunc_trailing_blanks     TYPE abap_bool OPTIONAL
                   trunc_trailing_blanks_eol TYPE abap_bool OPTIONAL
                   !append                   TYPE abap_bool OPTIONAL
                   no_auth_check             TYPE abap_bool OPTIONAL
        CHANGING   data_tab                  TYPE any
        EXCEPTIONS file_write_error
                   access_denied
                   path_not_found
                   disk_full
                   unknown_error.

    CLASS-METHODS file_exist
      IMPORTING !file         TYPE string
      RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS file_get_size
      IMPORTING  file_name TYPE string
      EXPORTING  file_size TYPE i
      EXCEPTIONS file_get_size_failed
                 cntl_error
                 error_no_gui
                 not_supported_by_gui
                 invalid_default_file_name.

    CLASS-METHODS
      directory_list_files
        IMPORTING !directory       TYPE string
                  files_only       TYPE abap_bool OPTIONAL
                  directories_only TYPE abap_bool OPTIONAL
                  !filter          TYPE any       OPTIONAL
        CHANGING  file_table       TYPE any
                  !count           TYPE i.

    CLASS-METHODS
      gui_upload
        IMPORTING filename            TYPE string
                  filetype            TYPE char10        OPTIONAL
                  codepage            TYPE abap_encoding DEFAULT space
                  has_field_separator TYPE abap_bool     OPTIONAL
                  read_by_line        TYPE abap_bool     OPTIONAL
        EXPORTING filelength          TYPE i
                  header              TYPE xstring
        CHANGING  data_tab            TYPE any
        exceptions
                  FILE_OPEN_ERROR
                  FILE_READ_ERROR.

    CLASS-METHODS
      file_open_dialog
        IMPORTING window_title      TYPE string    OPTIONAL
                  default_filename  TYPE string    OPTIONAL
                  default_extension TYPE string    OPTIONAL
                  multiselection    TYPE abap_bool OPTIONAL
                  file_filter       TYPE string    OPTIONAL
                  initial_directory TYPE string    OPTIONAL
        CHANGING  file_table        TYPE filetable
                  !rc               TYPE i
                  user_action       TYPE i         OPTIONAL.

    CLASS-METHODS
      get_platform
        RETURNING VALUE(platform) TYPE i.

    CLASS-METHODS
      file_save_dialog
        IMPORTING window_title        TYPE string    OPTIONAL
                  default_extension   TYPE string    OPTIONAL
                  default_file_name   TYPE string    OPTIONAL
                  file_filter         TYPE string    OPTIONAL
                  initial_directory   TYPE string    OPTIONAL
                  prompt_on_overwrite TYPE abap_bool OPTIONAL
        CHANGING  filename            TYPE string
                  !path               TYPE string
                  fullpath            TYPE string
                  user_action         TYPE i         OPTIONAL.

    CLASS-METHODS
      directory_browse
        IMPORTING window_title    TYPE string OPTIONAL
                  initial_folder  TYPE string OPTIONAL
        CHANGING  selected_folder TYPE string.

    CLASS-METHODS
      execute
        IMPORTING document          TYPE string OPTIONAL
                  !application      TYPE string OPTIONAL
                  !parameter        TYPE string OPTIONAL
                  default_directory TYPE string OPTIONAL
                  maximized         TYPE string OPTIONAL
                  minimized         TYPE string OPTIONAL
                  synchronous       TYPE string OPTIONAL
                  operation         TYPE string DEFAULT 'OPEN'.

    CLASS-METHODS
      get_file_separator
        CHANGING file_separator TYPE clike.

    CLASS-METHODS
      directory_exist
        IMPORTING !directory    TYPE string
        RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS
      directory_create
        IMPORTING !directory TYPE string
        CHANGING  !rc        TYPE i.

    CLASS-METHODS
      clipboard_export
        IMPORTING no_auth_check TYPE abap_bool OPTIONAL
        EXPORTING !data         TYPE any
        CHANGING  !rc           TYPE i.

    CLASS-METHODS
      get_system_directory
        CHANGING system_directory TYPE string.

    CLASS-METHODS
      get_gui_version
        CHANGING version_table TYPE filetable
                 !rc           TYPE i.

    CLASS-METHODS get_desktop_directory
      CHANGING   desktop_directory TYPE string
      EXCEPTIONS cntl_error
                 error_no_gui
                 not_supported_by_gui.

    CLASS-METHODS clipboard_import
      EXPORTING !data   TYPE STANDARD TABLE
                !length TYPE i.

    CLASS-METHODS file_delete
      IMPORTING filename TYPE string
      CHANGING  !rc      TYPE i.

    CLASS-METHODS get_sapgui_workdir
      CHANGING sapworkdir TYPE string.

    CLASS-METHODS registry_get_value
      IMPORTING !root     TYPE i
                !key      TYPE string
                !value    TYPE string OPTIONAL
                no_flush  TYPE c      OPTIONAL
      EXPORTING reg_value TYPE string.

    CLASS-METHODS directory_delete
      IMPORTING  !directory TYPE string
      CHANGING   !rc        TYPE i
      EXCEPTIONS directory_delete_failed
                 cntl_error
                 error_no_gui
                 path_not_found
                 directory_access_denied
                 unknown_error
                 not_supported_by_gui
                 wrong_parameter.

    CLASS-METHODS directory_get_current
      CHANGING   current_directory TYPE string
      EXCEPTIONS directory_get_current_failed
                 cntl_error
                 error_no_gui
                 not_supported_by_gui.

    CLASS-METHODS get_upload_download_path
      CHANGING   upload_path   TYPE string
                 download_path TYPE string
      EXCEPTIONS cntl_error
                 error_no_gui
                 not_supported_by_gui
                 gui_upload_download_path
                 upload_download_path_failed.

ENDCLASS.


CLASS cl_gui_frontend_services IMPLEMENTATION.
  METHOD get_drive_type.
    " TODO: parameter DRIVE is never used (ABAP cleaner)
    " TODO: parameter DRIVE_TYPE is never used or assigned (ABAP cleaner)

    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD get_computer_name.
    " TODO: parameter COMPUTER_NAME is never used or assigned (ABAP cleaner)

    WRITE '@KERNEL const os = await import("node:os");'.
    WRITE '@KERNEL computer_name.set(os.hostname());'.
  ENDMETHOD.

  METHOD get_desktop_directory.
    " TODO: parameter DESKTOP_DIRECTORY is never used or assigned (ABAP cleaner)

    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD get_upload_download_path.
    " TODO: parameter UPLOAD_PATH is never used or assigned (ABAP cleaner)
    " TODO: parameter DOWNLOAD_PATH is never used or assigned (ABAP cleaner)

    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD directory_get_current.
    " TODO: parameter CURRENT_DIRECTORY is never used or assigned (ABAP cleaner)

    DATA lv_failed TYPE abap_bool.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL   current_directory.set(process.cwd());'.
    WRITE '@KERNEL } catch (error) {'.
    WRITE '@KERNEL   lv_failed.set("X");'.
    WRITE '@KERNEL }'.
    IF lv_failed = abap_true.
      RAISE directory_get_current_failed.
    ENDIF.
  ENDMETHOD.

  METHOD file_copy.
    " TODO: parameter SOURCE is never used (ABAP cleaner)
    " TODO: parameter DESTINATION is never used (ABAP cleaner)
    " TODO: parameter OVERWRITE is never used (ABAP cleaner)

    DATA lv_error_code TYPE string.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL const fs = await import("node:fs");'.
    WRITE '@KERNEL const path = await import("node:path");'.
    WRITE '@KERNEL fs.mkdirSync(path.dirname(destination.get()), { recursive: true });'.
    WRITE '@KERNEL fs.copyFileSync(source.get(), destination.get(), overwrite.get() === "X" ? 0 : fs.constants.COPYFILE_EXCL);'.
    WRITE '@KERNEL } catch (error) {'.
    WRITE '@KERNEL   lv_error_code.set(error.code || "");'.
    WRITE '@KERNEL }'.

    IF lv_error_code = `ENOENT`.
      RAISE file_not_found.
    ELSEIF lv_error_code = `EEXIST`.
      RAISE destination_exists.
    ELSEIF lv_error_code = `EACCES` OR lv_error_code = `EPERM`.
      RAISE access_denied.
    ELSEIF lv_error_code IS NOT INITIAL.
      RAISE unknown_error.
    ENDIF.
  ENDMETHOD.

  METHOD directory_delete.
    " TODO: parameter DIRECTORY is never used (ABAP cleaner)

    DATA lv_failed TYPE abap_bool.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL const fs = await import("node:fs");'.
    WRITE '@KERNEL fs.rmSync(directory.get(), { recursive: true, force: true });'.
    WRITE '@KERNEL } catch (error) {'.
    WRITE '@KERNEL   lv_failed.set("X");'.
    WRITE '@KERNEL }'.
    rc = COND #( WHEN lv_failed = abap_true THEN 4 ELSE 0 ).
  ENDMETHOD.

  METHOD file_get_size.
    " TODO: parameter FILE_NAME is never used (ABAP cleaner)
    " TODO: parameter FILE_SIZE is never cleared or assigned (ABAP cleaner)

    DATA lv_failed TYPE abap_bool.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL const fs = await import("node:fs");'.
    WRITE '@KERNEL file_size.set(fs.statSync(file_name.get()).size);'.
    WRITE '@KERNEL } catch (error) {'.
    WRITE '@KERNEL   lv_failed.set("X");'.
    WRITE '@KERNEL }'.
    IF lv_failed = abap_true.
      RAISE file_get_size_failed.
    ENDIF.
  ENDMETHOD.

  METHOD registry_get_value.
    " TODO: parameter ROOT is never used (ABAP cleaner)
    " TODO: parameter KEY is never used (ABAP cleaner)
    " TODO: parameter VALUE is never used (ABAP cleaner)
    " TODO: parameter NO_FLUSH is never used (ABAP cleaner)
    " TODO: parameter REG_VALUE is never cleared or assigned (ABAP cleaner)

    RETURN. " todo, implement method
  ENDMETHOD.

  METHOD get_temp_directory.
    " TODO: parameter TEMP_DIR is never used or assigned (ABAP cleaner)

    WRITE '@KERNEL const os = await import("node:os");'.
    WRITE '@KERNEL temp_dir.set(os.tmpdir());'.
  ENDMETHOD.

  METHOD directory_exist.
    " TODO: parameter DIRECTORY is never used (ABAP cleaner)

    WRITE '@KERNEL const fs = await import("node:fs");'.
    WRITE '@KERNEL result.set(fs.existsSync(directory.get()) && fs.statSync(directory.get()).isDirectory() ? "X" : "");'.
  ENDMETHOD.

  METHOD get_sapgui_workdir.
    ASSERT 1 = 'get_sapgui_workdir not supported'.
  ENDMETHOD.

  METHOD file_exist.
    " TODO: parameter FILE is never used (ABAP cleaner)

    WRITE '@KERNEL const fs = await import("node:fs");'.
    WRITE '@KERNEL result.set(fs.existsSync(file.get()) ? "X" : "");'.
  ENDMETHOD.

  METHOD file_delete.
    " TODO: parameter FILENAME is never used (ABAP cleaner)
    " TODO: parameter RC is never used or assigned (ABAP cleaner)

    WRITE '@KERNEL const fs = await import("node:fs");'.
    WRITE '@KERNEL fs.rmSync(filename.get(), { force: true });'.
    WRITE '@KERNEL rc.set(0);'.
  ENDMETHOD.

  METHOD clipboard_import.
    ASSERT 1 = 'clipboard_import not supported'.
  ENDMETHOD.

  METHOD directory_list_files.
    ASSERT 1 = 'directory_list_files not supported'.
  ENDMETHOD.

  METHOD directory_create.
    " TODO: parameter DIRECTORY is never used (ABAP cleaner)

    DATA lv_failed TYPE abap_bool.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL const fs = await import("node:fs");'.
    WRITE '@KERNEL fs.mkdirSync(directory.get(), { recursive: true });'.
    WRITE '@KERNEL } catch (error) {'.
    WRITE '@KERNEL   lv_failed.set("X");'.
    WRITE '@KERNEL }'.
    rc = COND #( WHEN lv_failed = abap_true THEN 4 ELSE 0 ).
  ENDMETHOD.

  METHOD registry_set_dword_value.
    ASSERT 1 = 'registry_set_dword_value not supported'.
  ENDMETHOD.

  METHOD gui_download.
    " TODO: parameter BIN_FILESIZE is never used (ABAP cleaner)
    " TODO: parameter FILENAME is never used (ABAP cleaner)
    " TODO: parameter FILETYPE is never used (ABAP cleaner)
    " TODO: parameter WRITE_LF is never used (ABAP cleaner)
    " TODO: parameter WRITE_FIELD_SEPARATOR is never used (ABAP cleaner)
    " TODO: parameter SHOW_TRANSFER_STATUS is never used (ABAP cleaner)
    " TODO: parameter CONFIRM_OVERWRITE is never used (ABAP cleaner)
    " TODO: parameter TRUNC_TRAILING_BLANKS is never used (ABAP cleaner)
    " TODO: parameter TRUNC_TRAILING_BLANKS_EOL is never used (ABAP cleaner)
    " TODO: parameter APPEND is never used (ABAP cleaner)
    " TODO: parameter NO_AUTH_CHECK is never used (ABAP cleaner)
    " TODO: parameter DATA_TAB is never used or assigned (ABAP cleaner)

    DATA lv_error_code TYPE string.
    DATA hex_content   TYPE xstring.
    
    " WRITE '@KERNEL debugger;'.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL const fs = await import("node:fs");'.
    WRITE '@KERNEL const path = await import("node:path");'.
    WRITE '@KERNEL fs.mkdirSync(path.dirname(filename.get()), { recursive: true });'.
    WRITE '@KERNEL if (filetype.get().substring(0, 3) === "BIN") {'.
    " WRITE '@KERNEL   const hexContent = data_tab.array().map(l => l.get()).join("");'.
               hex_content = zcl_eui_conv=>BINARY_TO_XSTRING( IT_TABLE  = data_tab[]
                                                             IV_LENGTH = bin_filesize ).

    WRITE '@KERNEL   fs.writeFileSync(filename.get(), Buffer.from(hex_content.get(), "hex"));'.
    WRITE '@KERNEL } else {'.
    WRITE '@KERNEL   const content = data_tab.array().map((line) => line.get()).join(write_lf.get() === "X" ? String.fromCharCode(10) : "");'.
    WRITE '@KERNEL   fs.writeFileSync(filename.get(), content, { encoding: "utf8", flag: append.get() === "X" ? "a" : "w" });'.
    WRITE '@KERNEL }'.
    WRITE '@KERNEL } catch (error) {'.
    WRITE '@KERNEL   lv_error_code.set(error.code || "");'.
    WRITE '@KERNEL }'.

    IF lv_error_code = `EACCES` OR lv_error_code = `EPERM`.
      RAISE access_denied.
    ELSEIF lv_error_code = `ENOENT`.
      RAISE path_not_found.
    ELSEIF lv_error_code = `ENOSPC`.
      RAISE disk_full.
    ELSEIF lv_error_code IS NOT INITIAL.
      RAISE file_write_error.
    ENDIF.
  ENDMETHOD.

  METHOD get_file_separator.
    " TODO: parameter FILE_SEPARATOR is never used or assigned (ABAP cleaner)

    WRITE '@KERNEL const path = await import("node:path");'.
    WRITE '@KERNEL file_separator.set(path.sep);'.
  ENDMETHOD.

  METHOD execute.
    " TODO: parameter DOCUMENT is never used (ABAP cleaner)
    " TODO: parameter APPLICATION is never used (ABAP cleaner)
    " TODO: parameter PARAMETER is never used (ABAP cleaner)
    " TODO: parameter DEFAULT_DIRECTORY is never used (ABAP cleaner)
    " TODO: parameter MAXIMIZED is never used (ABAP cleaner)
    " TODO: parameter MINIMIZED is never used (ABAP cleaner)
    " TODO: parameter SYNCHRONOUS is never used (ABAP cleaner)
    " TODO: parameter OPERATION is never used (ABAP cleaner)

    WRITE '@KERNEL const { exec } = await import("node:child_process");'.
    WRITE '@KERNEL exec(document.get() + " " + parameter.get());'.
  ENDMETHOD.

  METHOD directory_browse.
    ASSERT 1 = 'directory_browse not supported'.
  ENDMETHOD.

  METHOD gui_upload.
    " TODO: parameter FILENAME is never used (ABAP cleaner)
    " TODO: parameter CODEPAGE is never used (ABAP cleaner)
    " TODO: parameter HAS_FIELD_SEPARATOR is never used (ABAP cleaner)
    " TODO: parameter READ_BY_LINE is never used (ABAP cleaner)
    " TODO: parameter FILELENGTH is never cleared or assigned (ABAP cleaner)
    " TODO: parameter HEADER is never cleared or assigned (ABAP cleaner)

    DATA lv_error_code TYPE string.

    "WRITE '@KERNEL debugger;'.

    WRITE '@KERNEL try {'.
    WRITE '@KERNEL const fs = await import("node:fs");'.
    WRITE '@KERNEL if (filetype.get().substring(0, 3) === "BIN") {'.
    WRITE '@KERNEL   data_tab.set(fs.readFileSync(filename.get()).toString("hex").toUpperCase());'.
    WRITE '@KERNEL } else {'.
    WRITE '@KERNEL   data_tab.set(fs.readFileSync(filename.get(), "utf8"));'.
    WRITE '@KERNEL }'.
    WRITE '@KERNEL } catch (error) {'.
    WRITE '@KERNEL   lv_error_code.set(error.code || "");'.
    WRITE '@KERNEL }'.

    IF lv_error_code IS NOT INITIAL.
      RAISE FILE_READ_ERROR.
    ENDIF.
  ENDMETHOD.

  METHOD file_open_dialog.
    ASSERT 1 = 'file_open_dialog not supported'.
  ENDMETHOD.

  METHOD file_save_dialog.
    ASSERT 1 = 'file_save_dialog not supported'.
  ENDMETHOD.

  METHOD get_platform.
    platform = platform_windowsxp.
  ENDMETHOD.

  METHOD clipboard_export.
    ASSERT 1 = 'clipboard_export not supported'.
  ENDMETHOD.

  METHOD get_system_directory.
    ASSERT 1 = 'get_system_directory not supported'.
  ENDMETHOD.

  METHOD get_gui_version.
    " TODO: parameter VERSION_TABLE is never used or assigned (ABAP cleaner)
    " TODO: parameter RC is never used or assigned (ABAP cleaner)

    RETURN.
  ENDMETHOD.
ENDCLASS.
