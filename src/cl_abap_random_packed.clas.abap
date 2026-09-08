CLASS cl_abap_random_packed DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES:
      p_num TYPE p LENGTH 15 DECIMALS 2
      " p_num TYPE decfloat34
      .

    CLASS-METHODS create
      IMPORTING
        seed          TYPE any OPTIONAL
        min           TYPE p_num
        max           TYPE p_num
      RETURNING
        VALUE(result) TYPE REF TO cl_abap_random_packed.

    METHODS get_next
      RETURNING
        VALUE(result) TYPE p_num.

  PRIVATE SECTION.
    " Standard CL_ABAP_RANDOM_PACKED uses length 8 (up to 15 digits)
    DATA mv_min TYPE p_num.
    DATA mv_max TYPE p_num.
ENDCLASS.

CLASS cl_abap_random_packed IMPLEMENTATION.
  METHOD create.
    CREATE OBJECT result.

    result->mv_min = COND #( WHEN min IS SUPPLIED THEN min
                              ELSE -99999999 ).
    result->mv_max = COND #( WHEN max IS SUPPLIED THEN max
                              ELSE 99999999 ).
  ENDMETHOD.

  METHOD get_next.
    DATA(lv_min) = mv_min.
    DATA(lv_max) = mv_max. 
    
    " Using @KERNEL to directly generate the number because packed bounds 
    " can exceed the standard cl_abap_random=>intinrange integer limit.
    WRITE '@KERNEL let min = lv_min.get();'.
    WRITE '@KERNEL let max = lv_max.get();'.
    WRITE '@KERNEL result.set(Number((Math.random() * (max - min) + min)).toFixed(2));'.
  ENDMETHOD.
ENDCLASS.