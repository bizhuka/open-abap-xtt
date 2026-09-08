CLASS zcl_test_rtti DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    DATA mv_test_attr TYPE string VALUE 'HELLO_RTTI'.

    METHODS test_method IMPORTING io_out TYPE REF TO if_oo_adt_classrun_out.
ENDCLASS.


CLASS zcl_test_rtti IMPLEMENTATION.
  METHOD test_method.
    io_out->write( |Just a dummy method for RTTI to find| ).
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA lo_object      TYPE REF TO object.
    DATA lo_class_descr TYPE REF TO cl_abap_classdescr.
    DATA lv_class_name  TYPE string VALUE 'ZCL_TEST_RTTI'.

    out->write( |--- RTTI Test---| ).
    out->write( |Creating object dynamically for class: { lv_class_name }| ).

    TRY.
        CREATE OBJECT lo_object TYPE (lv_class_name).

        " Get class descriptor
        lo_class_descr ?= cl_abap_typedescr=>describe_by_object_ref( lo_object ).

        out->write( |Class Name: { lo_class_descr->absolute_name }| ).

        out->write( |Attributes:| ).
        LOOP AT lo_class_descr->attributes INTO DATA(ls_attr).
          out->write( |- { ls_attr-name } (Visibility: { ls_attr-visibility }, Type Kind: { ls_attr-type_kind })| ).
        ENDLOOP.

        out->write( |Methods:| ).
        LOOP AT lo_class_descr->methods INTO DATA(ls_method).
          out->write( |- { ls_method-name } (Visibility: { ls_method-visibility })| ).
        ENDLOOP.

        out->write( |Invoking method 'TEST_METHOD' dynamically...| ).
        CALL METHOD lo_object->('TEST_METHOD')
          EXPORTING io_out   = out
                    iv_param = 1. " No exceptions!

        out->write( |Oops after 'TEST_METHOD'| ).
      CATCH cx_sy_dyn_call_error INTO DATA(lx_error). " cannot catch cx_root
        out->write( |Error!!!| ).
        out->write( |Error: { lx_error->get_text( ) }| ).
    ENDTRY.

    out->write( |--- End of RTTI Test ---| ).
  ENDMETHOD.
ENDCLASS.
