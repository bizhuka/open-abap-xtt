CLASS cl_bds_document_set DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_info IMPORTING classname TYPE any OPTIONAL classtype TYPE any OPTIONAL object_key TYPE any OPTIONAL EXPORTING extended_components TYPE any CHANGING signature TYPE any.

    METHODS get_with_table IMPORTING classname TYPE any OPTIONAL classtype TYPE any OPTIONAL object_key TYPE any OPTIONAL CHANGING content TYPE any OPTIONAL components TYPE any OPTIONAL EXCEPTIONS error.
ENDCLASS.
CLASS cl_bds_document_set IMPLEMENTATION.
  METHOD get_info.
  ENDMETHOD.
  METHOD get_with_table.
  ENDMETHOD.
ENDCLASS.
