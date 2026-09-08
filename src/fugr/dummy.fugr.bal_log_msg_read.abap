FUNCTION bal_log_msg_read.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_S_MSG_HANDLE) TYPE  BAL_S_MSGH
*"  EXPORTING
*"     REFERENCE(E_S_MSG) TYPE  BAL_S_MSG
*"  EXCEPTIONS
*"      LOG_NOT_FOUND
*"      MSG_NOT_FOUND
*"----------------------------------------------------------------------

  ASSIGN gt_message[ msg_handle = i_s_msg_handle-msg_handle ] TO FIELD-SYMBOL(<ls_message>).
  IF sy-subrc <> 0.
    RAISE msg_not_found.
  ENDIF.

  e_s_msg = <ls_message>-msg.

ENDFUNCTION.
