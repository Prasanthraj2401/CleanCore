REPORT zr_s4_fi_acdoca_bkpf NO STANDARD PAGE HEADING LINE-SIZE 200.

*&---------------------------------------------------------------------*
*& Report  ZR_S4_FI_ACDOCA_BKPF                                       *
*& S/4HANA modernization of ZR_OLD_FI_BSEG_BKPF                       *
*& Reads BKPF + ACDOCA (Universal Journal), calculates ZTAX / ZNET    *
*& Displays result via CL_SALV_TABLE (modern ALV)                      *
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
*  Output structure                                                    *
*  BSEG field mapping to ACDOCA:                                      *
*    BUKRS  -> ACDOCA-RBUKRS                                          *
*    HKONT  -> ACDOCA-RACCT                                           *
*    DMBTR  -> ACDOCA-HSL  (local-currency amount)                    *
*    BUZEI  -> ACDOCA-DOCLN (6-digit line; display as 3-digit item)   *
*    SHKZG  -> ACDOCA-DRCRK                                           *
*---------------------------------------------------------------------*
TYPES: BEGIN OF ty_out,
         bukrs TYPE bkpf-bukrs,
         belnr TYPE bkpf-belnr,
         gjahr TYPE bkpf-gjahr,
         bldat TYPE bkpf-bldat,
         budat TYPE bkpf-budat,
         blart TYPE bkpf-blart,
         waers TYPE bkpf-waers,
         buzei TYPE bseg-buzei,
         hkont TYPE bseg-hkont,
         shkzg TYPE bseg-shkzg,
         dmbtr TYPE bseg-dmbtr,
         ztax  TYPE bseg-dmbtr,
         znet  TYPE bseg-dmbtr,
       END OF ty_out.

DATA gt_out TYPE STANDARD TABLE OF ty_out WITH EMPTY KEY.

*---------------------------------------------------------------------*
*  Tax rate constant                                                   *
*---------------------------------------------------------------------*
CONSTANTS lc_tax_rate TYPE p LENGTH 8 DECIMALS 2 VALUE '18.00'.
CONSTANTS lc_hundred  TYPE p LENGTH 8 DECIMALS 2 VALUE '100.00'.

*---------------------------------------------------------------------*
*  Selection screen                                                   *
*---------------------------------------------------------------------*
SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs OBLIGATORY,
                s_belnr FOR bkpf-belnr,
                s_gjahr FOR bkpf-gjahr DEFAULT sy-datum+0(4),
                s_budat FOR bkpf-budat.

*---------------------------------------------------------------------*
*  Local class — all processing logic                                 *
*---------------------------------------------------------------------*
CLASS lcl_report DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      get_data
        IMPORTING
          it_bukrs TYPE s_bukrs[]
          it_belnr TYPE s_belnr[]
          it_gjahr TYPE s_gjahr[]
          it_budat TYPE s_budat[]
        CHANGING
          ct_out   TYPE STANDARD TABLE,
      configure_alv_columns
        IMPORTING
          io_columns TYPE REF TO cl_salv_columns_table,
      show_alv
        IMPORTING
          it_out TYPE STANDARD TABLE.
ENDCLASS.

CLASS lcl_report IMPLEMENTATION.

  METHOD get_data.
*   ----------------------------------------------------------------
*   Single JOIN: BKPF + ACDOCA pushed entirely to HANA              *
*   ACDOCA field mapping applied:                                   *
*     ACDOCA-RBUKRS  = company code  (was BSEG-BUKRS)              *
*     ACDOCA-RACCT   = G/L account   (was BSEG-HKONT)              *
*     ACDOCA-HSL     = local amount  (was BSEG-DMBTR)              *
*     ACDOCA-DRCRK   = debit/credit  (was BSEG-SHKZG)              *
*     ACDOCA-DOCLN   = line (6-digit)(was BSEG-BUZEI 3-digit)      *
*   ----------------------------------------------------------------
    SELECT
        bkpf~bukrs,
        bkpf~belnr,
        bkpf~gjahr,
        bkpf~bldat,
        bkpf~budat,
        bkpf~blart,
        bkpf~waers,
        CAST( acdoca~docln AS NUMC LENGTH 3 ) AS buzei,
        acdoca~racct  AS hkont,
        acdoca~drcrk  AS shkzg,
        acdoca~hsl    AS dmbtr
      INTO TABLE @DATA(lt_raw)
      FROM bkpf
      INNER JOIN acdoca
        ON  acdoca~rbukrs = bkpf~bukrs
        AND acdoca~belnr  = bkpf~belnr
        AND acdoca~gjahr  = bkpf~gjahr
      WHERE bkpf~bukrs IN @it_bukrs
        AND bkpf~belnr IN @it_belnr
        AND bkpf~gjahr IN @it_gjahr
        AND bkpf~budat IN @it_budat.

    IF sy-subrc <> 0 OR lt_raw IS INITIAL.
      MESSAGE 'No FI documents found for the selection criteria.' TYPE 'I'.
      RETURN.
    ENDIF.

*   ----------------------------------------------------------------
*   Inline calculation of ZTAX and ZNET                            *
*   ZTAX  = DMBTR * 18 / 100                                       *
*   ZNET  = DMBTR - ZTAX                                           *
*   ----------------------------------------------------------------
    ct_out = VALUE #(
      FOR ls_raw IN lt_raw
      LET lv_tax = ls_raw-dmbtr * lc_tax_rate / lc_hundred
          lv_net = ls_raw-dmbtr - ( ls_raw-dmbtr * lc_tax_rate / lc_hundred )
      IN (
        bukrs = ls_raw-bukrs
        belnr = ls_raw-belnr
        gjahr = ls_raw-gjahr
        bldat = ls_raw-bldat
        budat = ls_raw-budat
        blart = ls_raw-blart
        waers = ls_raw-waers
        buzei = ls_raw-buzei
        hkont = ls_raw-hkont
        shkzg = ls_raw-shkzg
        dmbtr = ls_raw-dmbtr
        ztax  = lv_tax
        znet  = lv_net
      ) ) ).
  ENDMETHOD.

  METHOD configure_alv_columns.
*   ----------------------------------------------------------------
*   Set column headers and output lengths via CL_SALV_COLUMNS_TABLE *
*   ----------------------------------------------------------------
    DATA(lo_col_table) = io_columns.

    TRY.
        DATA(lo_col) = lo_col_table->get_column( 'BUKRS' ).
        lo_col->set_medium_text( 'CoCode' ).
        lo_col->set_output_length( 6 ).

        lo_col = lo_col_table->get_column( 'BELNR' ).
        lo_col->set_medium_text( 'Document No.' ).
        lo_col->set_output_length( 12 ).

        lo_col = lo_col_table->get_column( 'GJAHR' ).
        lo_col->set_medium_text( 'Year' ).
        lo_col->set_output_length( 6 ).

        lo_col = lo_col_table->get_column( 'BLDAT' ).
        lo_col->set_medium_text( 'Doc.Date' ).
        lo_col->set_output_length( 12 ).

        lo_col = lo_col_table->get_column( 'BUDAT' ).
        lo_col->set_medium_text( 'Post.Date' ).
        lo_col->set_output_length( 12 ).

        lo_col = lo_col_table->get_column( 'BLART' ).
        lo_col->set_medium_text( 'Type' ).
        lo_col->set_output_length( 4 ).

        lo_col = lo_col_table->get_column( 'BUZEI' ).
        lo_col->set_medium_text( 'Item' ).
        lo_col->set_output_length( 5 ).

        lo_col = lo_col_table->get_column( 'HKONT' ).
        lo_col->set_medium_text( 'G/L Acct' ).
        lo_col->set_output_length( 12 ).

        lo_col = lo_col_table->get_column( 'SHKZG' ).
        lo_col->set_medium_text( 'D/C' ).
        lo_col->set_output_length( 3 ).

        lo_col = lo_col_table->get_column( 'DMBTR' ).
        lo_col->set_medium_text( 'Amount (LC)' ).
        lo_col->set_output_length( 17 ).

        lo_col = lo_col_table->get_column( 'ZTAX' ).
        lo_col->set_medium_text( 'Tax 18% (Z)' ).
        lo_col->set_output_length( 17 ).

        lo_col = lo_col_table->get_column( 'ZNET' ).
        lo_col->set_medium_text( 'Net Amt (Z)' ).
        lo_col->set_output_length( 17 ).

        lo_col = lo_col_table->get_column( 'WAERS' ).
        lo_col->set_medium_text( 'Curr.' ).
        lo_col->set_output_length( 7 ).

      CATCH cx_salv_not_found INTO DATA(lx_col).
        MESSAGE lx_col->get_text( ) TYPE 'W'.
    ENDTRY.
  ENDMETHOD.

  METHOD show_alv.
*   ----------------------------------------------------------------
*   CL_SALV_TABLE replaces REUSE_ALV_GRID_DISPLAY                  *
*   RULE-A1: factory pattern only — constructor is private          *
*   ----------------------------------------------------------------
    DATA lo_salv TYPE REF TO cl_salv_table.

    TRY.
        cl_salv_table=>factory(
          IMPORTING r_salv_table = lo_salv
          CHANGING  t_table      = it_out ).

*       ALV display settings
        DATA(lo_display) = lo_salv->get_display_settings( ).
        lo_display->set_striped_pattern( abap_true ).
        lo_display->set_fit_column_to_table_size( abap_true ).

*       Column configuration
        lcl_report=>configure_alv_columns(
          io_columns = lo_salv->get_columns( ) ).

*       Functions — enable sort, filter, export
        DATA(lo_funcs) = lo_salv->get_functions( ).
        lo_funcs->set_all( abap_true ).

*       Display
        lo_salv->display( ).

      CATCH cx_salv_msg INTO DATA(lx_salv).
        MESSAGE lx_salv->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*
*  START-OF-SELECTION                                                 *
*---------------------------------------------------------------------*
START-OF-SELECTION.

  lcl_report=>get_data(
    EXPORTING
      it_bukrs = s_bukrs[]
      it_belnr = s_belnr[]
      it_gjahr = s_gjahr[]
      it_budat = s_budat[]
    CHANGING
      ct_out   = gt_out ).

  IF gt_out IS NOT INITIAL.
    lcl_report=>show_alv( it_out = gt_out ).
  ENDIF.