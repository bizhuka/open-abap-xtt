CLASS cl_gui_toolbar DEFINITION PUBLIC.
  PUBLIC SECTION.

    EVENTS function_selected
      EXPORTING
        VALUE(fcode) TYPE any.
    CONSTANTS m_id_function_selected TYPE i VALUE 1.
    METHODS constructor IMPORTING parent TYPE any OPTIONAL display_mode TYPE any OPTIONAL.
    METHODS delete_all_buttons.
    METHODS set_registered_events IMPORTING events TYPE any.
    METHODS add_button
      IMPORTING
        fcode TYPE any
        icon TYPE any
        is_disabled TYPE any OPTIONAL
        butn_type TYPE any OPTIONAL
        text TYPE any OPTIONAL
        quickinfo TYPE any OPTIONAL
        is_checked TYPE any OPTIONAL.
    METHODS set_static_ctxmenu IMPORTING fcode TYPE any ctxmenu TYPE any.

ENDCLASS.
CLASS cl_gui_toolbar IMPLEMENTATION.

    METHOD constructor. ENDMETHOD.
    METHOD delete_all_buttons. ENDMETHOD.
    METHOD set_registered_events. ENDMETHOD.
    METHOD add_button. ENDMETHOD.
    METHOD set_static_ctxmenu. ENDMETHOD.

ENDCLASS.