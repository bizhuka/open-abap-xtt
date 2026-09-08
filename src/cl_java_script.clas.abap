CLASS cl_java_script DEFINITION PUBLIC.
  PUBLIC SECTION.

    DATA last_error_message TYPE string.
    CLASS-METHODS create IMPORTING stacksize TYPE any OPTIONAL heapsize TYPE any OPTIONAL RETURNING VALUE(ro_js) TYPE REF TO cl_java_script.
    METHODS bind
      IMPORTING
        name TYPE any OPTIONAL
        name_obj TYPE any OPTIONAL
        name_prop TYPE any OPTIONAL
        export_to_abap TYPE any OPTIONAL
      CHANGING
        data TYPE any OPTIONAL.
    METHODS compile IMPORTING script_name TYPE any OPTIONAL script TYPE any.
    METHODS execute IMPORTING script_name TYPE any OPTIONAL script TYPE any OPTIONAL.
    METHODS get_properties_scope_global IMPORTING property_path TYPE any OPTIONAL RETURNING VALUE(result) TYPE js_property_tab.

ENDCLASS.
CLASS cl_java_script IMPLEMENTATION.

    METHOD create. ENDMETHOD.
    METHOD bind. ENDMETHOD.
    METHOD compile. ENDMETHOD.
    METHOD execute. ENDMETHOD.
    METHOD get_properties_scope_global. ENDMETHOD.

ENDCLASS.