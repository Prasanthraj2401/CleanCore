CLASS LCL_EKKO_HANDLER DEFINITION
  INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS validate_mandatory_fields
      FOR VALIDATE ON SAVE
        IMPORTING keys FOR Ekko~validateMandatoryFields.
ENDCLASS.

CLASS LCL_EKKO_HANDLER IMPLEMENTATION.

  METHOD validate_mandatory_fields.
    READ ENTITIES OF ZI_EKKO IN LOCAL MODE
      ENTITY Ekko
        FIELDS ( Ebeln ) WITH CORRESPONDING #( keys )
      RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity).
      IF entity-Ebeln IS INITIAL.
        APPEND VALUE #(
          %key        = entity-%key
          %state_area = 'VALIDATE_MANDATORY'
          %msg        = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Ebeln is mandatory'
          )
        ) TO reported-ekko.
        APPEND VALUE #( %key = entity-%key ) TO failed-ekko.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.