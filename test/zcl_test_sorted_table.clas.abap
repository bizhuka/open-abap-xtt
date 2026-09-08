CLASS zcl_test_sorted_table DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CONSTANTS c_run_count TYPE i VALUE 15000.

    TYPES:
      BEGIN OF ts_ex_column,
        min TYPE i,
        max TYPE i,
      END OF ts_ex_column,
      tt_ex_column_hashed   TYPE HASHED TABLE OF ts_ex_column WITH UNIQUE KEY min,
      tt_ex_column_sorted   TYPE SORTED TABLE OF ts_ex_column WITH UNIQUE KEY min,
      tt_ex_column_standard TYPE STANDARD TABLE OF ts_ex_column WITH EMPTY KEY.

  PRIVATE SECTION.
    METHODS measure_inserts
      CHANGING  ct_table       TYPE ANY TABLE
      RETURNING VALUE(rv_time) TYPE i.
ENDCLASS.


CLASS zcl_test_sorted_table IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(lt_standard) = VALUE tt_ex_column_standard( ).
    DATA(lt_hashed) = VALUE tt_ex_column_hashed( ).
    DATA(lt_sorted) = VALUE tt_ex_column_sorted( ).

    out->write( |Standard table time: { measure_inserts( CHANGING ct_table = lt_standard ) }| ).
    out->write( |Hashed table time: { measure_inserts( CHANGING ct_table = lt_hashed ) }| ).
    out->write( |Sorted table time: { measure_inserts( CHANGING ct_table = lt_sorted ) }| ).
  ENDMETHOD.

  METHOD measure_inserts.
    DATA lv_start TYPE i.
    DATA lv_end   TYPE i.

    GET RUN TIME FIELD lv_start.
    DO c_run_count TIMES.
      INSERT VALUE ts_ex_column( min = sy-index
                                 max = sy-index ) INTO TABLE ct_table.
    ENDDO.
    GET RUN TIME FIELD lv_end.

    rv_time = lv_end - lv_start.
  ENDMETHOD.
ENDCLASS.
