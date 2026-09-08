INTERFACE if_fp_pdf_object PUBLIC.
  METHODS set_template IMPORTING xftdata TYPE any OPTIONAL.
  METHODS set_task_renderpdf.
  METHODS execute.
  METHODS get_pdf EXPORTING pdfdata TYPE any.
ENDINTERFACE.
