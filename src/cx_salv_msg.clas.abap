CLASS cx_salv_msg DEFINITION PUBLIC INHERITING FROM cx_static_check.
  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        previous TYPE REF TO cx_root OPTIONAL
        msgid TYPE any OPTIONAL
        msgno TYPE any OPTIONAL
        msgty TYPE any OPTIONAL
        msgv1 TYPE any OPTIONAL
        msgv2 TYPE any OPTIONAL
        msgv3 TYPE any OPTIONAL
        msgv4 TYPE any OPTIONAL.

ENDCLASS.
CLASS cx_salv_msg IMPLEMENTATION.

    METHOD constructor.
    ENDMETHOD.

ENDCLASS.