FUNCTION-POOL dummy.

TYPES:
  BEGIN OF ts_message,
    log_handle TYPE balloghndl,
    msg_handle TYPE bal_s_msgh-msg_handle,
    msg        TYPE bal_s_msg,
  END OF ts_message.
TYPES tt_message TYPE STANDARD TABLE OF ts_message WITH EMPTY KEY.

DATA gt_message TYPE tt_message.
DATA gv_log_cnt TYPE i.
DATA gv_msg_cnt TYPE i.
