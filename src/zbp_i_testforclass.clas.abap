CLASS zbp_i_testforclass DEFINITION PUBLIC ABSTRACT FINAL
  FOR BEHAVIOR OF zi_testforclass.
ENDCLASS.

CLASS zbp_i_testforclass IMPLEMENTATION.
ENDCLASS.


CLASS lhc_testforclass DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS setDefaults FOR DETERMINE ON MODIFY
      IMPORTING keys FOR TESTFORCLASS~setDefaults.
    METHODS validateMandatoryFields FOR VALIDATE ON SAVE
      IMPORTING keys FOR TESTFORCLASS~validateMandatoryFields.
ENDCLASS.


CLASS lhc_testforclass IMPLEMENTATION.

  METHOD setDefaults.
    MODIFY ENTITIES OF zi_testforclass IN LOCAL MODE
      ENTITY TESTFORCLASS
      UPDATE FIELDS ( CreatedAt ChangedAt CreatedBy ChangedBy )
      WITH VALUE #( FOR key IN keys
        ( %tky      = key-%tky
          CreatedAt = utclong_current( )
          ChangedAt = utclong_current( )
          CreatedBy = cl_abap_context_info=>get_user_technical_name( )
          ChangedBy = cl_abap_context_info=>get_user_technical_name( ) ) ).
  ENDMETHOD.
  METHOD validateMandatoryFields.
    READ ENTITIES OF zi_testforclass IN LOCAL MODE
      ENTITY TESTFORCLASS
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_entities).

    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      IF <ls_entity>-BusinessKey IS INITIAL.
        APPEND VALUE #( %tky = <ls_entity>-%tky ) TO failed-TESTFORCLASS.
        APPEND VALUE #(
          %tky = <ls_entity>-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = |BusinessKey must not be empty| )
        ) TO reported-TESTFORCLASS.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
