CLASS zcl_test_xtt_01 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS:
      get_example_meta
        IMPORTING
          iv_example   TYPE string
        EXPORTING
          es_opt       TYPE zcl_xtt_demo=>ts_screen_opt
          et_templates TYPE zcl_xtt_demo=>tt_template
          ev_error     TYPE string,

      generate
        IMPORTING
          iv_example  TYPE string
          iv_template TYPE string
          iv_r_cnt    TYPE int4
          iv_c_cnt    TYPE numc2
          iv_b_cnt    TYPE int4
        EXPORTING
          ev_raw      TYPE xstring
          ev_filename TYPE string
          ev_mimetype TYPE string
          ev_error    TYPE string.

  PRIVATE SECTION.
    DATA mv_file_no_ext TYPE string.

    METHODS:
      map_example_to_class
        IMPORTING
          iv_example          TYPE string
        RETURNING
          VALUE(rv_classname) TYPE string,

      create_demo
        IMPORTING
          iv_example TYPE string
        EXPORTING
          eo_demo    TYPE REF TO zcl_xtt_demo
          ev_error   TYPE string,

      filter_templates
        CHANGING
          ct_templates TYPE zcl_xtt_demo=>tt_template,

      mime_type_for
        IMPORTING
          iv_ext             TYPE string
        RETURNING
          VALUE(rv_mimetype) TYPE string,

      prepare
        IMPORTING
          io_xtt TYPE REF TO zcl_xtt,

      on_prepare_raw FOR EVENT prepare_raw OF zcl_xtt
        IMPORTING
          iv_path
          ir_content.
ENDCLASS.

CLASS zcl_test_xtt_01 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    CONSTANTS lc_epoch TYPE p VALUE '19700101000000'.
    WRITE /  |{ lc_epoch TIMESTAMP = ISO }|.
    WRITE /  |{ sy-datum DATE = ENVIRONMENT } { sy-uzeit TIME = USER }|. " https://github.com/abaplint/transpiler/issues/1795
    WRITE / sy-datum.
    WRITE / sy-uzeit.

    DATA(lt_demo_classes) = lcl_report=>get_classes( iv_prefix = 'ZCL_XTT_DEMO_' ).
    "DELETE lt_demo_classes WHERE table_line <> 'ZCL_XTT_DEMO_130'. 

    DATA(lo_report) = NEW lcl_report( abap_true ).
    LOOP AT lt_demo_classes INTO DATA(lv_classname).
      CHECK strlen( lv_classname ) = 16.

      out->write( |Running { lv_classname }| ).

      DATA lo_demo TYPE REF TO zcl_xtt_demo.
      CREATE OBJECT lo_demo TYPE (lv_classname).      
      lo_demo->set_report( lo_report ).

      lo_report->start_of_selection(
        iv_r_cnt = 15
        iv_c_cnt = 36 
        iv_b_cnt = 3
      ).
      lo_demo->set_merge_info( ).      

      DATA(lt_templates) = lo_demo->get_templates( ).
      
      LOOP AT lt_templates INTO DATA(ls_template).
        DATA(lv_template) = ls_template-objid.
        check lv_template NP '*-PDF' AND lv_template NP '*-XDP'.

        SPLIT lv_template AT '-' INTO mv_file_no_ext
                                      DATA(lv_suffix) .
        DATA(lv_ext) = '.' && to_lower( condense( lv_suffix ) ).

        lo_demo->get_from_template(
            EXPORTING
              iv_template = lv_template
            IMPORTING
              ev_class    = DATA(lv_xtt_class) ).
        DATA(lv_template_path) = |./output/{ to_lower( lv_template ) }.w3mi.data{ lv_ext }|.
        out->write( |Loading template file '{ lv_template_path }'| ).

        DATA lv_file_template TYPE xstring.
        cl_gui_frontend_services=>gui_upload(
          EXPORTING filename = lv_template_path
                    filetype = 'BIN'
          CHANGING  data_tab = lv_file_template ).

        IF xstrlen( lv_file_template ) = 0.
          out->write( |Template file not loaded: { lv_template_path }| ).
          CONTINUE.
        ENDIF.

        DATA(lo_file_raw) = NEW zcl_xtt_file_raw( iv_name    = |template{ lv_ext }|
                                                  iv_xstring = lv_file_template ).

        DATA lo_xtt_obj TYPE REF TO object.
        CREATE OBJECT lo_xtt_obj TYPE (lv_xtt_class) EXPORTING io_file = lo_file_raw.
        
        DATA lo_xtt TYPE REF TO zcl_xtt.
        lo_xtt ?= lo_xtt_obj.
        
        "prepare( lo_xtt ).        
" data(lv_file_json) = zcl_eui_conv=>to_json( im_data = lo_report->t_merge iv_pure = abap_true ).
" WRITE: / lv_file_json.

        DATA(lv_file) = value xstring( ).
            lo_demo->merge( io_xtt   = lo_xtt
                            it_merge = lo_report->t_merge ).
            lv_file = lo_xtt->get_raw( ).

        DATA(lv_filepath) = |./output/result/{ to_lower( mv_file_no_ext ) }{ lv_ext }|.
        cl_gui_frontend_services=>gui_download(
          EXPORTING filename = lv_filepath
                    filetype = 'BIN'
          CHANGING  data_tab = lv_file ).
        out->write( |Saved { lv_filepath }| ).
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_example_meta.
    CLEAR: es_opt, et_templates, ev_error.

    create_demo( EXPORTING iv_example = iv_example
                 IMPORTING eo_demo    = DATA(lo_demo)
                           ev_error   = ev_error ).
    CHECK ev_error IS INITIAL.

    es_opt = lo_demo->get_screen_opt( ).
    et_templates = lo_demo->get_templates( ).
    filter_templates( CHANGING ct_templates = et_templates ).
  ENDMETHOD.


  METHOD generate.
    CLEAR: ev_raw, ev_filename, ev_mimetype, ev_error.

    IF iv_r_cnt < 1 OR iv_r_cnt > 25.
      ev_error = 'mv_r_cnt must be between 1 and 25'.
      RETURN.
    ENDIF.
    IF iv_c_cnt < 1 OR iv_c_cnt > 3.
      ev_error = 'mv_c_cnt must be between 1 and 3'.
      RETURN.
    ENDIF.
    IF iv_b_cnt < 1 OR iv_b_cnt > 3.
      ev_error = 'mv_b_cnt must be between 1 and 3'.
      RETURN.
    ENDIF.

    create_demo( EXPORTING iv_example = iv_example
                 IMPORTING eo_demo    = DATA(lo_demo)
                           ev_error   = ev_error ).
    CHECK ev_error IS INITIAL.

    DATA(lt_templates) = lo_demo->get_templates( ).
    filter_templates( CHANGING ct_templates = lt_templates ).

    DATA(lv_template) = to_upper( condense( iv_template ) ).
    DATA(lv_template_ok) = abap_false.
    LOOP AT lt_templates ASSIGNING FIELD-SYMBOL(<ls_template>).
      CHECK to_upper( condense( <ls_template>-objid ) ) = lv_template.
      lv_template_ok = abap_true.
      EXIT.
    ENDLOOP.
    IF lv_template IS INITIAL OR lv_template_ok = abap_false.
      ev_error = |Unknown template { iv_template }|.
      RETURN.
    ENDIF.

    DATA(lo_report) = NEW lcl_report( abap_true ).
    lo_demo->set_report( lo_report ).
    lo_report->start_of_selection(
      iv_r_cnt = iv_r_cnt
      iv_c_cnt = iv_c_cnt
      iv_b_cnt = iv_b_cnt ).
    lo_demo->set_merge_info( ).

    SPLIT lv_template AT '-' INTO mv_file_no_ext
                                  DATA(lv_suffix).
    DATA(lv_ext) = '.' && to_lower( condense( lv_suffix ) ).

    lo_demo->get_from_template(
      EXPORTING
        iv_template = lv_template
      IMPORTING
        ev_class    = DATA(lv_xtt_class) ).
    IF lv_xtt_class IS INITIAL.
      ev_error = |No XTT class for template { iv_template }|.
      RETURN.
    ENDIF.

    DATA(lv_template_path) = |./output/{ to_lower( lv_template ) }.w3mi.data{ lv_ext }|.

    DATA lv_file_template TYPE xstring.
    cl_gui_frontend_services=>gui_upload(
      EXPORTING
        filename = lv_template_path
        filetype = 'BIN'
      CHANGING
        data_tab = lv_file_template ).
    IF xstrlen( lv_file_template ) = 0.
      ev_error = |Template file not loaded: { lv_template_path }|.
      RETURN.
    ENDIF.

    DATA(lo_file_raw) = NEW zcl_xtt_file_raw( iv_name    = |template{ lv_ext }|
                                              iv_xstring = lv_file_template ).

    DATA lo_xtt_obj TYPE REF TO object.
    CREATE OBJECT lo_xtt_obj TYPE (lv_xtt_class) EXPORTING io_file = lo_file_raw.

    DATA lo_xtt TYPE REF TO zcl_xtt.
    lo_xtt ?= lo_xtt_obj.

    lo_demo->merge( io_xtt   = lo_xtt
                    it_merge = lo_report->t_merge ).
    ev_raw = lo_xtt->get_raw( ).
    IF xstrlen( ev_raw ) = 0.
      ev_error = 'Generated file is empty'.
      RETURN.
    ENDIF.

    ev_filename = |{ to_lower( mv_file_no_ext ) }{ lv_ext }|.
    ev_mimetype = mime_type_for( lv_ext ).
  ENDMETHOD.


  METHOD map_example_to_class.
    DATA(lv_example) = to_upper( condense( iv_example ) ).
    IF strlen( lv_example ) <> 15 OR lv_example NP 'Z_XTT_DEMO_N+++'.
      RETURN.
    ENDIF.

    DATA(lv_ind) = lv_example+12(3).
    DATA(lt_ok) = VALUE string_table(
      ( `010` ) ( `020` ) ( `021` ) ( `022` ) ( `030` )
      ( `040` ) ( `050` ) ( `051` ) ( `052` ) ( `060` )
      ( `070` ) ( `080` ) ( `090` ) ( `091` ) ( `092` )
      ( `100` ) ( `110` ) ( `120` ) ( `130` ) ( `140` ) ( `160` ) ).
    CHECK line_exists( lt_ok[ table_line = lv_ind ] ).

    rv_classname = |ZCL_XTT_DEMO_{ lv_ind }|.
  ENDMETHOD.


  METHOD create_demo.
    CLEAR: eo_demo, ev_error.

    DATA(lv_classname) = map_example_to_class( iv_example ).
    IF lv_classname IS INITIAL.
      ev_error = |Unknown example { iv_example }|.
      RETURN.
    ENDIF.

    CREATE OBJECT eo_demo TYPE (lv_classname).
    IF eo_demo IS INITIAL.
      ev_error = |Cannot create { lv_classname }|.
    ENDIF.
  ENDMETHOD.


  METHOD filter_templates.
    DELETE ct_templates WHERE objid CP '*-PDF' OR objid CP '*-XDP'.
  ENDMETHOD.


  METHOD mime_type_for.
    rv_mimetype = SWITCH string( iv_ext
      WHEN `.xlsx` THEN `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
      WHEN `.xlsm` THEN `application/vnd.ms-excel.sheet.macroEnabled.12`
      WHEN `.docx` THEN `application/vnd.openxmlformats-officedocument.wordprocessingml.document`
      WHEN `.docm` THEN `application/vnd.ms-word.document.macroEnabled.12`
      WHEN `.html` THEN `text/html`
      WHEN `.htm`  THEN `text/html`
      WHEN `.xml`  THEN `application/xml`
      ELSE `application/octet-stream` ).
  ENDMETHOD.


  METHOD prepare.
    SET HANDLER on_prepare_raw FOR io_xtt.

    DATA lo_class TYPE REF TO cl_abap_classdescr.
    lo_class ?= cl_abap_classdescr=>describe_by_object_ref( io_xtt ).

    " For data exporting
    CASE lo_class->absolute_name.
      WHEN '\CLASS=ZCL_XTT_WORD_DOCX'.
        " io_xtt->add_raw_event( 'word/document.xml' ).
        io_xtt->add_raw_event( 'word/header1.xml' ).
        io_xtt->add_raw_event( 'word/footer1.xml' ).

      WHEN '\CLASS=ZCL_XTT_EXCEL_XLSX'.
        io_xtt->add_raw_event( 'xl/workbook.xml' ).
        io_xtt->add_raw_event( 'xl/_rels/workbook.xml.rels' ).

        " Max number of sheets
        DO 12 TIMES.
          " Path to file
          DATA lv_path TYPE string.

          lv_path = sy-index.
          CONDENSE lv_path NO-GAPS.

          CONCATENATE `xl/worksheets/sheet` lv_path `.xml` INTO lv_path.

          io_xtt->add_raw_event( lv_path ).
        ENDDO.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD on_prepare_raw.
    " No need to export entire file
    CHECK iv_path IS NOT INITIAL.

    " Work with copy
    DATA lv_content TYPE xstring.
    lv_content = zcl_eui_conv=>string_to_xstring( lcl_report=>pretty_print( iv_xml = zcl_eui_conv=>xstring_to_string( ir_content->* ) ) ).

    DATA(lv_filepath) = |./output/result/{ to_lower( mv_file_no_ext ) }/{ iv_path }|.
    cl_gui_frontend_services=>gui_download(
      EXPORTING filename = lv_filepath
                filetype = 'BIN'
      CHANGING  data_tab = lv_content ).

  ENDMETHOD.
ENDCLASS.
