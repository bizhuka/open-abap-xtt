CLASS cl_ctmenu DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS add_separator.
    METHODS add_submenu
      IMPORTING
        menu TYPE any OPTIONAL
        icon TYPE any OPTIONAL
        disabled TYPE any OPTIONAL
        text TYPE any OPTIONAL
        hidden TYPE any OPTIONAL
        accelerator TYPE any OPTIONAL.
    METHODS add_function
      IMPORTING
        fcode TYPE any OPTIONAL
        icon TYPE any OPTIONAL
        disabled TYPE any OPTIONAL
        text TYPE any OPTIONAL
        checked TYPE any OPTIONAL
        ftype TYPE any OPTIONAL
        hidden TYPE any OPTIONAL
        accelerator TYPE any OPTIONAL.
ENDCLASS.

        CLASS cl_ctmenu IMPLEMENTATION.
  METHOD add_separator.
  ENDMETHOD.
  METHOD add_submenu.
  ENDMETHOD.
  METHOD add_function.
  ENDMETHOD.
ENDCLASS.