CLASS zcl_test_random_number DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    " Include the interface for ADT Console execution
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_test_random_number IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    " 1. Create a random integer generator (e.g., between 1 and 100)
    " We use cl_abap_random=>seed( ) to ensure a different result every time you run it.
    DATA(lo_rand) = cl_abap_random_int=>create( seed = 111 " cl_abap_random=>seed( )
                                                min  = 1
                                                max  = 100 ).

    " 2. Get the next random number
    DATA(lv_random_number) = lo_rand->get_next( ).

    " 3. Output the result to the ADT Console
    out->write( '--- Random Number Generator Test ---' ).
    out->write( |Generated Number (1 to 100): { lv_random_number }| ).

    " Optional: Generate a few more to prove it works
    out->write( 'Generating 5 more random numbers:' ).
    DO 5 TIMES.
      out->write( |Number { sy-index }: { lo_rand->get_next( ) }| ).
    ENDDO.

    " TODO: variable is assigned but never used (ABAP cleaner)

    "PERFORM in_debug IN PROGRAM ('Z_XTT_DEBUG') IF FOUND USING 111.
    " CREATE OBJECT o_ref TYPE (`ZZZSJLK`).
    " cx_sy_create_object_error
    " out->write( |Object created| ).
  ENDMETHOD.
ENDCLASS.
