CLASS zbp_i_ekko DEFINITION PUBLIC ABSTRACT FINAL
  FOR BEHAVIOR OF zi_ekko.
ENDCLASS.

CLASS zbp_i_ekko IMPLEMENTATION.
ENDCLASS.


CLASS lhc_ekko DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS validateMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR EKKO~validateMandatoryFields.
ENDCLASS.


CLASS lhc_ekko IMPLEMENTATION.

  METHOD validateMandatoryFields.
    READ ENTITIES OF zi_ekko IN LOCAL MODE
      ENTITY EKKO
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_entities).

    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      IF <ls_entity>-Ebeln IS INITIAL.
        APPEND VALUE #( %tky = <ls_entity>-%tky ) TO failed-EKKO.
        APPEND VALUE #(
          %tky = <ls_entity>-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = |Ebeln must not be empty| )
        ) TO reported-EKKO.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
