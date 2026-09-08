CLASS lcl_report DEFINITION INHERITING FROM zcl_xtt_report.
  PUBLIC SECTION.
    METHODS:
      start_of_selection
        IMPORTING
          iv_r_cnt TYPE int4
          iv_c_cnt TYPE numc2
          iv_b_cnt TYPE int4.

    CLASS-METHODS get_classes
      IMPORTING
        iv_prefix TYPE string
      RETURNING VALUE(rt_class_names) TYPE string_table.

    CLASS-METHODS pretty_print
      IMPORTING
        iv_xml         TYPE string
        iv_indent_size TYPE i DEFAULT 2
      RETURNING
        VALUE(rv_xml)  TYPE string.
ENDCLASS.

CLASS lcl_report IMPLEMENTATION.
  METHOD start_of_selection.
    mv_r_cnt = iv_r_cnt.
    mv_c_cnt = iv_c_cnt.
    mv_b_cnt = iv_b_cnt.

    " Data for report & ALV items
    CLEAR: o_demo, t_merge. ", t_merge_alv.

    " DATA lr_demo TYPE REF TO ts_demo.
    " READ TABLE t_demo REFERENCE INTO lr_demo WITH TABLE KEY ind = p_exa.
    " CHECK sy-subrc = 0.

    " " Current demo
    " o_demo = lr_demo->inst.
    " lv_exit = o_demo->set_merge_info( ).
  ENDMETHOD.

  METHOD get_classes.
    DATA(lv_mask) = to_upper( iv_prefix ).

    " We embed your JS loop here. It pushes matches directly into the ABAP internal table.
    WRITE '@KERNEL const mask = lv_mask.get();'.
    WRITE '@KERNEL for (const className of Object.keys(globalThis.abap.Classes)) {'.    
    WRITE '@KERNEL   if (className.startsWith(mask)) {'.
    WRITE '@KERNEL     let abapName = new abap.types.String();'.
    WRITE '@KERNEL     abapName.set(className);'.
    WRITE '@KERNEL     rt_class_names.append(abapName);'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL }'.

    SORT rt_class_names BY table_line.
  ENDMETHOD.

  METHOD pretty_print.
    WRITE '@KERNEL let xml = iv_xml.get();'.
    WRITE '@KERNEL let indentSize = iv_indent_size.get();'.
    WRITE '@KERNEL let indent = " ".repeat(indentSize);'.
    WRITE '@KERNEL let depth = 0;'.
    
    WRITE '@KERNEL let tokens = xml'.
    WRITE '@KERNEL   .replace(/>\s+</g, "><")'.
    WRITE '@KERNEL   .trim()'.
    WRITE '@KERNEL   .match(/(<\[CDATA\[.*?\]\]>|<!--.*?-->|<[^>]+>|[^<]+)/gs) || [];'.

    WRITE '@KERNEL let formatted = tokens.map(token => {'.
    WRITE '@KERNEL   if (!token.trim()) return "";'.
    WRITE '@KERNEL   if (token.startsWith("<!--") || token.startsWith("<![CDATA[")) {'.
    WRITE '@KERNEL     return indent.repeat(depth) + token.trim();'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL   if (token.match(/^<[^>]+?\/>$/) || token.startsWith("<?")) {'.
    WRITE '@KERNEL     return indent.repeat(depth) + token;'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL   if (token.startsWith("</")) {'.
    WRITE '@KERNEL     depth = Math.max(0, depth - 1);'.
    WRITE '@KERNEL     return indent.repeat(depth) + token;'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL   if (token.startsWith("<")) {'.
    WRITE '@KERNEL     let line = indent.repeat(depth) + token;'.
    WRITE '@KERNEL     depth++;'.
    WRITE '@KERNEL     return line;'.
    WRITE '@KERNEL   }'.
    WRITE '@KERNEL   return indent.repeat(depth) + token.trim();'.
    WRITE '@KERNEL }).filter(line => line.length > 0).join("\n");'.

    WRITE '@KERNEL rv_xml.set(formatted);'.
  ENDMETHOD.
ENDCLASS.
