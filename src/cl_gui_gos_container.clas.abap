class CL_GUI_GOS_CONTAINER definition
  public
  inheriting from CL_GUI_CONTAINER
  final
  create public .

*"* public components of class CL_GUI_GOS_CONTAINER
*"* do not include other source files here!!!
public section.

  methods CONSTRUCTOR
    importing
      value(WIDTH) type I default 60
      value(REPID) type SYREPID optional
      value(DYNNR) type SYDYNNR optional
      value(METRIC) type I default 0
      value(PARENT) type ref to CL_GUI_CONTAINER optional
      value(NO_AUTODEF_PROGID_DYNNR) type C optional
      value(NAME) type STRING optional
    exceptions
      CNTL_ERROR
      CNTL_SYSTEM_ERROR
      CREATE_ERROR
      LIFETIME_ERROR .
protected section.
*" protected components of class CL_GUI_GOS_CONTAINER
*" do not include other source files here!!!

private section.
*" private components of class CL_GUI_GOS_CONTAINER
*" do not include other source files here!!!

ENDCLASS.



CLASS CL_GUI_GOS_CONTAINER IMPLEMENTATION.


method CONSTRUCTOR.
endmethod.
ENDCLASS.