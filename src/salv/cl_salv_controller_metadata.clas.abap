CLASS cl_salv_controller_metadata DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS get_lvc_fieldcatalog IMPORTING r_columns      TYPE any OPTIONAL
                                                 r_aggregations TYPE any OPTIONAL
                                       RETURNING VALUE(rt_fcat) TYPE lvc_t_fcat.
ENDCLASS.


CLASS cl_salv_controller_metadata IMPLEMENTATION.
  METHOD get_lvc_fieldcatalog.
  ENDMETHOD.
ENDCLASS.
