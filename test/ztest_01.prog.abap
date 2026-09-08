REPORT ztest_01.


CLASS lcl_friend_test DEFINITION DEFERRED.

* ----------------------------------------------------------------------
* Target Class: Contains private attributes and declares the friend
* ----------------------------------------------------------------------
CLASS lcl_target DEFINITION FRIENDS lcl_friend_test.
  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_secret TYPE string.

  PRIVATE SECTION.
    DATA mv_secret_data TYPE string.
ENDCLASS.

CLASS lcl_target IMPLEMENTATION.
  METHOD constructor.
    me->mv_secret_data = iv_secret.
  ENDMETHOD.
ENDCLASS.

* ----------------------------------------------------------------------
* Friend Class: Can read and modify lcl_target's private members
* ----------------------------------------------------------------------
CLASS lcl_friend_test DEFINITION.
  PUBLIC SECTION.
    METHODS read_private_attr.
ENDCLASS.

CLASS lcl_friend_test IMPLEMENTATION.
  METHOD read_private_attr.
    TYPES: BEGIN OF ts_struct,
            o_main TYPE REF TO lcl_target,
           END OF ts_struct.
    
    DATA(ls_struct) = VALUE ts_struct( o_main = NEW #( '123' ) ).

    DATA(lv_extracted) = ls_struct-o_main->mv_secret_data.

    WRITE: / 'Successfully read private attribute:', lv_extracted.
  ENDMETHOD.
ENDCLASS.

* ----------------------------------------------------------------------
* Execution Block
* ----------------------------------------------------------------------
START-OF-SELECTION.
  " NEW lcl_friend_test( )->read_private_attr( ).

  " DATA:
  "   lv_date TYPE d.
  " FIELD-SYMBOLS:
  "   <fs_date> TYPE d.

  " lv_date = sy-datum + 2.
  " ASSIGN lv_date TO <fs_date> CASTING. " TYPE d.

  " WRITE: / `Value of field symbol: `, <fs_date> - sy-datum.
  " ASSERT 2 = <fs_date> - sy-datum.