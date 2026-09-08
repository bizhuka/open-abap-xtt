CLASS zcl_test_gui_frontend DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_test_gui_frontend IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    CONSTANTS lc_directory TYPE string VALUE `output/demo`.

    " @see runtime/fixtures
    SELECT * INTO TABLE @DATA(lt_users)
      FROM zusers.

    " Use open-abap-core's class
    DATA(lv_json) = /ui2/cl_json=>serialize( data        = lt_users
                                             pretty_name = /ui2/cl_json=>pretty_mode-low_case ).

    DATA(lv_create_rc) = 0.
    cl_gui_frontend_services=>directory_create( EXPORTING directory = lc_directory
                                                CHANGING  rc        = lv_create_rc ).

    DATA(lv_directory_exists) = cl_gui_frontend_services=>directory_exist( lc_directory ).
    DATA(lv_file_name) = |{ lc_directory }/zusers.json|.

    DATA(lt_download) = VALUE string_table( ( lv_json ) ).
    cl_gui_frontend_services=>gui_download( EXPORTING  filename = lv_file_name
                                            CHANGING   data_tab = lt_download
                                            EXCEPTIONS OTHERS   = 1 ).
    IF sy-subrc <> 0.
      out->write( |GUI_DOWNLOAD failed with sy-subrc { sy-subrc }| ).
      RETURN.
    ENDIF.

    DATA(lv_file_exists) = cl_gui_frontend_services=>file_exist( lv_file_name ).

    cl_gui_frontend_services=>file_get_size( EXPORTING  file_name = lv_file_name
                                             IMPORTING  file_size = DATA(lv_file_size)
                                             EXCEPTIONS OTHERS    = 1 ).
    IF sy-subrc <> 0.
      out->write( |FILE_GET_SIZE failed with sy-subrc { sy-subrc }| ).
      RETURN.
    ENDIF.

    DATA(lv_copy_file_name) = |{ lc_directory }/zusers-copy.json|.

    cl_gui_frontend_services=>file_copy( EXPORTING  source      = lv_file_name
                                                    destination = lv_copy_file_name
                                                    overwrite   = abap_true
                                         EXCEPTIONS OTHERS      = 1 ).
    IF sy-subrc <> 0.
      out->write( |FILE_COPY failed with sy-subrc { sy-subrc }| ).
      RETURN.
    ENDIF.

    DATA(lv_copy_exists) = cl_gui_frontend_services=>file_exist( lv_copy_file_name ).

    DATA(lv_delete_rc) = 0.
    cl_gui_frontend_services=>file_delete( EXPORTING filename = lv_copy_file_name
                                           CHANGING  rc       = lv_delete_rc ).
    DATA(lv_copy_deleted) = xsdbool( cl_gui_frontend_services=>file_exist( lv_copy_file_name ) <> abap_true ).

    DATA(lv_current_directory) = ``.
    cl_gui_frontend_services=>directory_get_current( CHANGING   current_directory = lv_current_directory
                                                     EXCEPTIONS OTHERS            = 1 ).
    IF sy-subrc <> 0.
      out->write( |DIRECTORY_GET_CURRENT failed with sy-subrc { sy-subrc }| ).
      RETURN.
    ENDIF.

    DATA(lv_temp_directory) = ``.
    cl_gui_frontend_services=>get_temp_directory( CHANGING temp_dir = lv_temp_directory ).

    out->write( |JSON: { lv_json }| ).
    out->write( |Directory created: { lv_create_rc }, exists: { lv_directory_exists }| ).
    out->write( |File exists: { lv_file_exists }, size: { lv_file_size } bytes| ).
    out->write( |Copy existed: { lv_copy_exists }, deleted: { lv_copy_deleted }, rc: { lv_delete_rc }| ).
    out->write( |Current directory: { lv_current_directory }| ).
    out->write( |System temp directory: { lv_temp_directory }| ).
  ENDMETHOD.
ENDCLASS.
