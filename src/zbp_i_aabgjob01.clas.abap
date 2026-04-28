CLASS zbp_i_aabgjob01 DEFINITION PUBLIC ABSTRACT FINAL
  FOR BEHAVIOR OF zi_aabgjob01.
ENDCLASS.

CLASS zbp_i_aabgjob01 IMPLEMENTATION.
ENDCLASS.


CLASS lhc_aabgjob01 DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS setDefaults FOR DETERMINE ON MODIFY
      IMPORTING keys FOR AABGJOB01~setDefaults.
    METHODS validateMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR AABGJOB01~validateMandatoryFields.
ENDCLASS.


CLASS lhc_aabgjob01 IMPLEMENTATION.

  METHOD setDefaults.
    MODIFY ENTITIES OF zi_aabgjob01 IN LOCAL MODE
      ENTITY AABGJOB01
      UPDATE FIELDS ( CreatedAt ChangedAt CreatedBy ChangedBy )
      WITH VALUE #( FOR key IN keys
        ( %tky      = key-%tky
          CreatedAt = utclong_current( )
          ChangedAt = utclong_current( )
          CreatedBy = cl_abap_context_info=>get_user_technical_name( )
          ChangedBy = cl_abap_context_info=>get_user_technical_name( ) ) ).
  ENDMETHOD.
  METHOD validateMandatoryFields.
    READ ENTITIES OF zi_aabgjob01 IN LOCAL MODE
      ENTITY AABGJOB01
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_entities).

    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      IF <ls_entity>-Jobname IS INITIAL.
        APPEND VALUE #( %tky = <ls_entity>-%tky ) TO failed-AABGJOB01.
        APPEND VALUE #(
          %tky = <ls_entity>-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = |Jobname must not be empty| )
        ) TO reported-AABGJOB01.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
