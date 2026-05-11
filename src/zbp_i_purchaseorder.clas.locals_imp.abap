"--------------------------------------------------------------------
" Local Handler Class
"--------------------------------------------------------------------
CLASS lhc_PurchaseOrder DEFINITION
  INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS validate_mandatory_fields
      FOR VALIDATE ON SAVE
        IMPORTING keys FOR PurchaseOrder~validateMandatoryFields.
ENDCLASS.

CLASS lhc_PurchaseOrder IMPLEMENTATION.

  METHOD validate_mandatory_fields.

    READ ENTITIES OF ZI_PurchaseOrder IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( Ebeln Bukrs Lifnr Bedat )
        WITH CORRESPONDING #( keys )
      RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity).

      IF entity-Ebeln IS INITIAL.
        APPEND VALUE #(
          %key        = entity-%key
          %state_area = 'VALIDATE_MANDATORY'
          %msg        = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Purchase Order number is mandatory'
          )
        ) TO reported-purchaseorder.
        APPEND VALUE #( %key = entity-%key ) TO failed-purchaseorder.
      ENDIF.

      IF entity-Bukrs IS INITIAL.
        APPEND VALUE #(
          %key        = entity-%key
          %state_area = 'VALIDATE_MANDATORY'
          %msg        = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Company Code is mandatory'
          )
        ) TO reported-purchaseorder.
        APPEND VALUE #( %key = entity-%key ) TO failed-purchaseorder.
      ENDIF.

      IF entity-Lifnr IS INITIAL.
        APPEND VALUE #(
          %key        = entity-%key
          %state_area = 'VALIDATE_MANDATORY'
          %msg        = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Vendor is mandatory'
          )
        ) TO reported-purchaseorder.
        APPEND VALUE #( %key = entity-%key ) TO failed-purchaseorder.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.