FUNCTION month_names_get.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(LANGUAGE) DEFAULT SY-LANGU
*"  TABLES
*"      MONTH_NAMES STRUCTURE  WDR_DATE_NAV_MONTH_NAME
*"  EXCEPTIONS
*"      MONTH_NAMES_NOT_FOUND
*"----------------------------------------------------------------------

MONTH_NAMES[] = VALUE wdr_date_nav_month_name_tab(
      ( MNR = '01' LTX = `January` )
      ( MNR = '02' LTX = `February` )
      ( MNR = '03' LTX = `March` )
      ( MNR = '04' LTX = `April` )
      ( MNR = '05' LTX = `May` )
      ( MNR = '06' LTX = `June` )
      ( MNR = '07' LTX = `July` )
      ( MNR = '08' LTX = `August` )
      ( MNR = '09' LTX = `September` )
      ( MNR = '10' LTX = `October` )
      ( MNR = '11' LTX = `November` )
      ( MNR = '12' LTX = `December` ) ).

ENDFUNCTION.
