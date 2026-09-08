TYPE-POOL VRM .
TYPES:
  vrm_id TYPE c LENGTH 255 .
TYPES:
  BEGIN OF vrm_value,
    key  TYPE vrm_id,
    text TYPE c LENGTH 80,
  END OF vrm_value .
TYPES:
  vrm_values TYPE STANDARD TABLE OF vrm_value WITH DEFAULT KEY .