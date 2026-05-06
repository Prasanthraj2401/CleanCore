CLASS zbp_i_vbak DEFINITION PUBLIC ABSTRACT FINAL
  FOR BEHAVIOR OF zi_vbak.
ENDCLASS.

CLASS zbp_i_vbak IMPLEMENTATION.
ENDCLASS.


CLASS lhc_vbak DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS validateMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR VBAK~validateMandatoryFields.
ENDCLASS.


CLASS lhc_vbak IMPLEMENTATION.

  METHOD validateMandatoryFields.
    READ ENTITIES OF zi_vbak IN LOCAL MODE
      ENTITY VBAK
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_entities).

    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      IF <ls_entity>-Vbeln IS INITIAL.
        APPEND VALUE #( %tky = <ls_entity>-%tky ) TO failed-VBAK.
        APPEND VALUE #(
          %tky = <ls_entity>-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = |Vbeln must not be empty| )
        ) TO reported-VBAK.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
