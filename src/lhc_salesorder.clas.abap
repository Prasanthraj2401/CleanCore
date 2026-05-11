CLASS lhc_SalesOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
        IMPORTING REQUEST requested_authorizations FOR SalesOrder
        RESULT result.
    METHODS validate_mandatory_fields
      FOR VALIDATE ON SAVE
        IMPORTING keys FOR SalesOrder~validateMandatoryFields.
ENDCLASS.

CLASS lhc_SalesOrder IMPLEMENTATION.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
    IF requested_authorizations-%update = if_abap_behv=>mk-on.
      result-%update = if_abap_behv=>auth-allowed.
    ENDIF.
    IF requested_authorizations-%delete = if_abap_behv=>mk-on.
      result-%delete = if_abap_behv=>auth-allowed.
    ENDIF.
  ENDMETHOD.

  METHOD validate_mandatory_fields.
    READ ENTITIES OF ZI_SalesOrder IN LOCAL MODE
      ENTITY SalesOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity).
      IF entity-Vbeln IS INITIAL.
        APPEND VALUE #(
          %key        = entity-%key
          %state_area = 'VALIDATE_MANDATORY'
          %msg        = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Sales Document (Vbeln) is mandatory'
          )
        ) TO reported-salesorder.
        APPEND VALUE #( %key = entity-%key ) TO failed-salesorder.
      ENDIF.

      IF entity-Vkorg IS INITIAL.
        APPEND VALUE #(
          %key        = entity-%key
          %state_area = 'VALIDATE_MANDATORY'
          %msg        = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Sales Organization (Vkorg) is mandatory'
          )
        ) TO reported-salesorder.
        APPEND VALUE #( %key = entity-%key ) TO failed-salesorder.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.