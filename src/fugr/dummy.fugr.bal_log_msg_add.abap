FUNCTION bal_log_msg_add.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_LOG_HANDLE) TYPE  BALLOGHNDL OPTIONAL
*"     REFERENCE(I_S_MSG) TYPE  BAL_S_MSG
*"  EXPORTING
*"     VALUE(E_S_MSG_HANDLE) TYPE  BALMSGHNDL
*"     VALUE(E_MSG_WAS_LOGGED) TYPE  BOOLEAN
*"     VALUE(E_MSG_WAS_DISPLAYED) TYPE  BOOLEAN
*"  EXCEPTIONS
*"      LOG_NOT_FOUND
*"      MSG_INCONSISTENT
*"      LOG_IS_FULL
*"----------------------------------------------------------------------

  DATA ls_message TYPE ts_message.

  gv_msg_cnt = gv_msg_cnt + 1.

  ls_message-log_handle = i_log_handle.
  ls_message-msg_handle = gv_msg_cnt.
  ls_message-msg        = i_s_msg.
  APPEND ls_message TO gt_message.

  e_s_msg_handle-log_handle = i_log_handle.
  e_s_msg_handle-msgnumber = gv_msg_cnt.
  e_msg_was_logged = abap_true.
  e_msg_was_displayed = abap_false.

ENDFUNCTION.
