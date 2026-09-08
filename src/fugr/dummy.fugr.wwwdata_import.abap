FUNCTION wwwdata_import.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"     IMPORTING
*"          VALUE(KEY) LIKE  WWWDATATAB STRUCTURE  WWWDATATAB
*"     TABLES
*"           HTML STRUCTURE  W3HTML OPTIONAL
*"           MIME STRUCTURE  W3MIME OPTIONAL
*"     EXCEPTIONS
*"          WRONG_OBJECT_TYPE
*"          IMPORT_ERROR
*"----------------------------------------------------------------------

  RAISE IMPORT_ERROR.
ENDFUNCTION.
