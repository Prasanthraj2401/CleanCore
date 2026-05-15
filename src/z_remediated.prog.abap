*&---------------------------------------------------------------------*
*& Report  ZR_S4_FI_ACDOCA_BKPF                                       *
*& S/4HANA modernized — reads BKPF + ACDOCA (Universal Journal),       *
*& calculates ZTAX (18%) and ZNET, displays via CL_SALV_TABLE.         *
*&---------------------------------------------------------------------*
REPORT zr_s4_fi_acdoca_bkpf NO STANDARD PAGE HEADING LINE-SIZE 200.

**********************************************************************
*  Output structure                                                   *
**********************************************************************
TYPES: BEGIN OF ty_out,
         bukrs TYPE bkpf-bukrs,       " Company Code
         belnr TYPE bkpf-belnr,       " Document Number
         gjahr TYPE bkpf-gjahr,       " Fiscal Year
         bldat TYPE bkpf-bldat,       " Document Date
         budat TYPE bkpf-budat,       " Posting Date
         blart TYPE bkpf-blart,       " Document Type
         waers TYPE bkpf-waers,       " Currency
         docln TYPE acdoca-docln,     " Line Item (6-digit, was BUZEI in BSEG)
         racct TYPE acdoca-racct,     " G/L Account (was HKONT in BSEG)
         drcrk TYPE acdoca-drcrk,     " Debit/Credit Indicator (was SHKZG)
         hsl   TYPE acdoca-hsl,       " Amount Local Currency (was DMBTR)
         ztax  TYPE acdoca-hsl,       " Custom: 18% tax on HSL
         znet  TYPE acdoca-hsl,       " Custom: HSL minus ZTAX
       END OF ty_out.

**********************************************************************
*  BKPF helper structure for FOR ALL ENTRIES guard (header fields)   *
**********************************************************************
TYPES: BEGIN OF ty_bkpf_key,
         bukrs TYPE bkpf-bukrs,
         belnr TYPE bkpf-belnr,
         gjahr TYPE bkpf-gjahr,
         bldat TYPE bkpf-bldat,
         budat TYPE bkpf-budat,
         blart TYPE bkpf-blart,
         waers TYPE bkpf-waers,
       END OF ty_bkpf_key.

**********************************************************************
*  Global data                                                        *
**********************************************************************
DATA: gt_out  TYPE STANDARD TABLE OF ty_out  WITH EMPTY KEY.

*--- Tax rate constant (18%) ---
CONSTANTS: gc_tax_rate TYPE p LENGTH 8 DECIMALS 2 VALUE '18.00',
           gc_hundred  TYPE p LENGTH 8 DECIMALS 2 VALUE '100.00'.

**********************************************************************
*  Selection screen                                                   *
**********************************************************************
SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs OBLIGATORY,
                s_belnr FOR bkpf-belnr,
                s_gjahr FOR bkpf-gjahr DEFAULT sy-datum(4),
                s_budat FOR bkpf-budat.

**********************************************************************
*  Local class definition                                             *
**********************************************************************
CLASS lcl_report DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS: run.
  PRIVATE SECTION.
    CLASS-METHODS:
      get_data
        RETURNING VALUE(rt_out) TYPE STANDARD TABLE,
      calc_tax_fields
        CHANGING  ct_out        TYPE STANDARD TABLE,
      show_alv
        IMPORTING it_out        TYPE STANDARD TABLE.
ENDCLASS.

**********************************************************************
*  START-OF-SELECTION                                                 *
**********************************************************************
START-OF-SELECTION.
  lcl_report=>run( ).

**********************************************************************
*  Class implementation                                               *
**********************************************************************
CLASS lcl_report IMPLEMENTATION.

  METHOD run.
    DATA(lt_out) = get_data( ).
    IF lt_out IS INITIAL.
      MESSAGE 'No FI documents found for the selection criteria.' TYPE 'I'.
      RETURN.
    ENDIF.
    calc_tax_fields( CHANGING ct_out = lt_out ).
    show_alv( it_out = lt_out ).
  ENDMETHOD.

  METHOD get_data.
    "--------------------------------------------------------------------
    " Step 1: Read matching BKPF header keys first (guard for ACDOCA FAE)
    "--------------------------------------------------------------------
    DATA lt_bkpf TYPE STANDARD TABLE OF ty_bkpf_key WITH EMPTY KEY.

    SELECT bukrs,
           belnr,
           gjahr,
           bldat,
           budat,
           blart,
           waers
      FROM bkpf
      INTO TABLE @lt_bkpf
     WHERE bukrs IN @s_bukrs
       AND belnr IN @s_belnr
       AND gjahr IN @s_gjahr
       AND budat IN @s_budat.

    IF sy-subrc <> 0 OR lt_bkpf IS INITIAL.
      RETURN.
    ENDIF.

    "--------------------------------------------------------------------
    " Step 2: JOIN BKPF + ACDOCA — single round trip, explicit fields.
    " ACDOCA field mapping vs BSEG:
    "   BSEG-BUKRS  → ACDOCA-RBUKRS
    "   BSEG-HKONT  → ACDOCA-RACCT
    "   BSEG-BUZEI  → ACDOCA-DOCLN  (6-digit in ACDOCA)
    "   BSEG-DMBTR  → ACDOCA-HSL    (local-currency amount)
    "   BSEG-SHKZG  → ACDOCA-DRCRK  (H=credit, S=debit)
    "--------------------------------------------------------------------
    SELECT b~bukrs,
           b~belnr,
           b~gjahr,
           b~bldat,
           b~budat,
           b~blart,
           b~waers,
           a~docln,
           a~racct,
           a~drcrk,
           a~hsl,
           @( CONV acdoca-hsl( '0' ) ) AS ztax,
           @( CONV acdoca-hsl( '0' ) ) AS znet
      FROM bkpf AS b
      INNER JOIN acdoca AS a
        ON  a~rbukrs = b~bukrs
        AND a~belnr  = b~belnr
        AND a~gjahr  = b~gjahr
      INTO TABLE @rt_out
     WHERE b~bukrs IN @s_bukrs
       AND b~belnr IN @s_belnr
       AND b~gjahr IN @s_gjahr
       AND b~budat IN @s_budat.
  ENDMETHOD.

  METHOD calc_tax_fields.
    "--------------------------------------------------------------------
    " Calculate ZTAX = HSL * 18 / 100
    "          ZNET  = HSL - ZTAX
    " All old-style MULTIPLY/DIVIDE/SUBTRACT/ADD/COMPUTE replaced by
    " modern direct arithmetic expressions.
    "--------------------------------------------------------------------
    LOOP AT ct_out ASSIGNING FIELD-SYMBOL(<ls_out>).
      " ZTAX = DMBTR * 18 / 100  (replaces MOVE+MULTIPLY+DIVIDE+MOVE)
      <ls_out>-ztax = <ls_out>-hsl * gc_tax_rate / gc_hundred.

      " ZNET = DMBTR - ZTAX  (replaces MOVE+SUBTRACT+MOVE)
      <ls_out>-znet = <ls_out>-hsl - <ls_out>-ztax.

      " V_TOTAL demo preserved as local variable (ADD / COMPUTE equivalents):
      " v_total = hsl + ztax  →  kept as informational; not written to output
      DATA(lv_total) = <ls_out>-hsl + <ls_out>-ztax.
      " COMPUTE v_total = v_net + ztax  (direct assignment replaces COMPUTE):
      lv_total = <ls_out>-znet + <ls_out>-ztax.
      " lv_total not added to output — matches original program intent
      UNASSIGN <ls_out>.   " explicit cleanup
    ENDLOOP.
  ENDMETHOD.

  METHOD show_alv.
    "--------------------------------------------------------------------
    " Display via CL_SALV_TABLE (replaces REUSE_ALV_GRID_DISPLAY + SLIS)
    " Per RULE-A1: NEVER use NEW cl_salv_table(); use factory() only.
    "--------------------------------------------------------------------
    DATA: lo_salv    TYPE REF TO cl_salv_table,
          lo_columns TYPE REF TO cl_salv_columns_table,
          lo_column  TYPE REF TO cl_salv_column_table,
          lo_display TYPE REF TO cl_salv_display_settings,
          lo_funcs   TYPE REF TO cl_salv_functions_list.

    " We need a local copy typed to our concrete table type for FACTORY
    DATA lt_display TYPE STANDARD TABLE OF ty_out WITH EMPTY KEY.
    lt_display = CORRESPONDING #( it_out ).

    TRY.
        cl_salv_table=>factory(
          IMPORTING r_salv_table = lo_salv
          CHANGING  t_table      = lt_display ).

        " Activate standard toolbar functions (sort, filter, export)
        lo_funcs = lo_salv->get_functions( ).
        lo_funcs->set_all( abap_true ).

        " Display settings: zebra striping + column width optimization
        lo_display = lo_salv->get_display_settings( ).
        lo_display->set_striped_pattern( cl_salv_display_settings=>true ).
        lo_display->set_fit_column_to_table_size( cl_salv_display_settings=>true ).

        " Column labels (replaces IT_FCAT / M_ADD_FCAT macro)
        lo_columns = lo_salv->get_columns( ).
        lo_columns->set_optimize( abap_true ).

        DEFINE m_set_col_lbl.
          TRY.
              lo_column ?= lo_columns->get_column( &1 ).
              lo_column->set_medium_text( &2 ).
              lo_column->set_short_text(  &3 ).
              lo_column->set_long_text(   &4 ).
            CATCH cx_salv_not_found. "#EC NO_HANDLER
          ENDTRY.
        END-OF-DEFINITION.

        m_set_col_lbl 'BUKRS' 'CoCode'        'CoC'  'Company Code'.
        m_set_col_lbl 'BELNR' 'Document No.'  'DocNo''Document Number'.
        m_set_col_lbl 'GJAHR' 'Fisc.Year'     'Year' 'Fiscal Year'.
        m_set_col_lbl 'BLDAT' 'Doc.Date'      'DtDt' 'Document Date'.
        m_set_col_lbl 'BUDAT' 'Post.Date'     'PtDt' 'Posting Date'.
        m_set_col_lbl 'BLART' 'Doc.Type'      'Tp'   'Document Type'.
        m_set_col_lbl 'WAERS' 'Currency'      'Cur'  'Currency Key'.
        m_set_col_lbl 'DOCLN' 'Line Item'     'Itm'  'Journal Line Item'.
        m_set_col_lbl 'RACCT' 'G/L Account'   'G/LA' 'G/L Account (RACCT)'.
        m_set_col_lbl 'DRCRK' 'D/C Ind.'      'D/C'  'Debit/Credit Indicator'.
        m_set_col_lbl 'HSL'   'Amount (LC)'   'Amt'  'Amount Local Currency'.
        m_set_col_lbl 'ZTAX'  'Tax 18% (Z)'   'Tax'  'Custom Tax 18%'.
        m_set_col_lbl 'ZNET'  'Net Amt (Z)'   'Net'  'Custom Net Amount'.

        lo_salv->display( ).

      CATCH cx_salv_msg INTO DATA(lx_salv).
        MESSAGE lx_salv->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.