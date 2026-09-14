FUNCTION bal_log_msg_add_free_text.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_LOG_HANDLE) TYPE  BALLOGHNDL OPTIONAL
*"     REFERENCE(I_MSGTY) TYPE  SYMSGTY
*"     REFERENCE(I_PROBCLASS) TYPE  BALPROBCL DEFAULT '4'
*"     REFERENCE(I_TEXT) TYPE  C
*"     REFERENCE(I_S_CONTEXT) TYPE  BAL_S_CONT OPTIONAL
*"     REFERENCE(I_S_PARAMS) TYPE  BAL_S_PARM OPTIONAL
*"     REFERENCE(I_DETLEVEL) TYPE  BALLEVEL DEFAULT '1'
*"  EXPORTING
*"     VALUE(E_S_MSG_HANDLE) TYPE  BALMSGHNDL
*"     VALUE(E_MSG_WAS_LOGGED) TYPE  BOOLEAN
*"     VALUE(E_MSG_WAS_DISPLAYED) TYPE  BOOLEAN
*"  EXCEPTIONS
*"      LOG_NOT_FOUND
*"      MSG_INCONSISTENT
*"      LOG_IS_FULL
*"----------------------------------------------------------------------

  DATA ls_msg TYPE bal_s_msg.
  DATA lv_text TYPE c LENGTH 200.

  lv_text = i_text.

  ls_msg-msgty     = i_msgty.
  ls_msg-msgid     = 'BL'.
  ls_msg-msgno     = '001'.
  ls_msg-msgv1     = lv_text+0(50).
  ls_msg-msgv2     = lv_text+50(50).
  ls_msg-msgv3     = lv_text+100(50).
  ls_msg-msgv4     = lv_text+150(50).
  ls_msg-probclass = i_probclass.
  ls_msg-context   = i_s_context.
  ls_msg-params    = i_s_params.
  "ls_msg-detlevel  = i_detlevel.

  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle        = i_log_handle
      i_s_msg             = ls_msg
    IMPORTING
      e_s_msg_handle      = e_s_msg_handle
      e_msg_was_logged    = e_msg_was_logged
      e_msg_was_displayed = e_msg_was_displayed
    EXCEPTIONS
      log_not_found       = 1
      msg_inconsistent    = 2
      log_is_full         = 3.

  CASE sy-subrc.
    WHEN 1.
      RAISE log_not_found.
    WHEN 2.
      RAISE msg_inconsistent.
    WHEN 3.
      RAISE log_is_full.
  ENDCASE.

ENDFUNCTION.
