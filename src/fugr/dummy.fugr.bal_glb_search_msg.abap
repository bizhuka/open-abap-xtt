FUNCTION bal_glb_search_msg.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_T_LOG_HANDLE) TYPE  BAL_T_LOGH OPTIONAL
*"     REFERENCE(I_S_MSG_FILTER) TYPE  BAL_S_MFIL OPTIONAL
*"     REFERENCE(I_T_MSG_HANDLE) TYPE  BAL_T_MSGH OPTIONAL
*"  EXPORTING
*"     REFERENCE(E_T_LOG_HANDLE) TYPE  BAL_T_LOGH
*"     REFERENCE(E_T_MSG_HANDLE) TYPE  BAL_T_MSGH
*"  EXCEPTIONS
*"      MSG_NOT_FOUND
*"----------------------------------------------------------------------

  DATA ls_msg_handle TYPE bal_s_msgh.
  DATA lv_log_ok TYPE abap_bool.
  DATA lv_msgty_ok TYPE abap_bool.

  LOOP AT gt_message ASSIGNING FIELD-SYMBOL(<ls_message>).
    lv_log_ok = COND #( WHEN i_t_log_handle IS INITIAL THEN abap_true ).
    LOOP AT i_t_log_handle ASSIGNING FIELD-SYMBOL(<lv_log_handle>).
      CHECK <lv_log_handle> = <ls_message>-log_handle.
      lv_log_ok = abap_true.
      EXIT.
    ENDLOOP.
    CHECK lv_log_ok = abap_true.

    lv_msgty_ok = COND #( WHEN i_s_msg_filter-msgty IS INITIAL THEN abap_true ).
    LOOP AT i_s_msg_filter-msgty ASSIGNING FIELD-SYMBOL(<ls_msty>).
      CHECK <ls_msty>-low = <ls_message>-msg-msgty.
      lv_msgty_ok = abap_true.
      EXIT.
    ENDLOOP.
    CHECK lv_msgty_ok = abap_true.

    CLEAR ls_msg_handle.
    ls_msg_handle-msg_handle = <ls_message>-msg_handle.
    APPEND ls_msg_handle TO e_t_msg_handle.
    APPEND <ls_message>-log_handle TO e_t_log_handle.
  ENDLOOP.

  IF e_t_msg_handle IS INITIAL.
    RAISE msg_not_found.
  ENDIF.

ENDFUNCTION.
