FUNCTION bal_log_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_S_LOG) TYPE  BAL_S_LOG
*"  EXPORTING
*"     VALUE(E_LOG_HANDLE) TYPE  BALLOGHNDL
*"  EXCEPTIONS
*"      LOG_HEADER_INCONSISTENT
*"----------------------------------------------------------------------

  DATA lv_handle TYPE c LENGTH 22.

  gv_log_cnt = gv_log_cnt + 1.
  lv_handle = gv_log_cnt.
  e_log_handle = lv_handle.

ENDFUNCTION.
