CLASS zcl_rap_eml_1234 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rap_eml_1234 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    " step 1 - READ
    READ ENTITIES OF ZI_RAP_Travel_1234
      ENTITY travel
        FROM VALUE #( ( TravelUUID = '9FC31A608CB2F2A217000E02C26AA5BD' ) )
      RESULT DATA(travels).

    out->write( travels ).

    " step 2 - READ with Fields
    READ ENTITIES OF ZI_RAP_Travel_1234
      ENTITY travel
        FIELDS ( AgencyID CustomerID )
      WITH VALUE #( ( TravelUUID = '9FC31A608CB2F2A217000E02C26AA5BD' ) )
      RESULT travels.

    out->write( travels ).

    " step 3 - READ with All Fields
    READ ENTITIES OF ZI_RAP_Travel_1234
      ENTITY travel
        ALL FIELDS
      WITH VALUE #( ( TravelUUID = '9FC31A608CB2F2A217000E02C26AA5BD' ) )
      RESULT travels.

    out->write( travels ).

    " step 4 - READ By Association
    READ ENTITIES OF ZI_RAP_Travel_1234
      ENTITY travel BY \_Booking
        ALL FIELDS WITH VALUE #( ( TravelUUID = '9FC31A608CB2F2A217000E02C26AA5BD' ) )
      RESULT DATA(bookings).

    out->write( bookings ).

     " step 5 - Unsuccessful READ
     READ ENTITIES OF ZI_RAP_Travel_1234
       ENTITY travel
         ALL FIELDS WITH VALUE #( ( TravelUUID = '11111111111111111111111111111111' ) )
       RESULT travels
       FAILED DATA(failed)
       REPORTED DATA(reported).

     out->write( travels ).
     out->write( failed ).    " complex structures not supported by the console output
     out->write( reported ).  " complex structures not supported by the console output

     " step 6 - MODIFY Update
     MODIFY ENTITIES OF ZI_RAP_Travel_1234
       ENTITY travel
         UPDATE
           SET FIELDS WITH VALUE
             #( ( TravelUUID  = '9FC31A608CB2F2A217000E02C26AA5BD'
                  Description = 'I like RAP@openSAP' ) )

      FAILED failed
      REPORTED reported.

     out->write( 'Update done' ).

     " step 6b - Commit Entities
     COMMIT ENTITIES
       RESPONSE OF ZI_RAP_Travel_1234
       FAILED     DATA(failed_commit)
       REPORTED   DATA(reported_commit).


    " step 7 - MODIFY Create
    MODIFY ENTITIES OF ZI_RAP_Travel_1234
      ENTITY travel
        CREATE
          SET FIELDS WITH VALUE
            #( ( %cid        = 'MyContentID_1'
                 AgencyID    = '70012'
                 CustomerID  = '14'
                 BeginDate   = cl_abap_context_info=>get_system_date( )
                 EndDate     = cl_abap_context_info=>get_system_date( ) + 10
                 Description = 'I like RAP@openSAP' ) )

     MAPPED DATA(mapped)
     FAILED failed
     REPORTED reported.

    out->write( mapped-travel ).

    COMMIT ENTITIES
      RESPONSE OF ZI_RAP_Travel_1234
      FAILED failed_commit
      REPORTED reported_commit.

    out->write( 'Create done' ).


    READ TABLE mapped-travel
    INDEX 1
    ASSIGNING FIELD-SYMBOL(<ls_mapped>).

    " step 8 - MODIFY Delete
    MODIFY ENTITIES OF ZI_RAP_Travel_1234
      ENTITY travel
        DELETE FROM
          VALUE
            #( ( TravelUUID  = <ls_mapped>-TravelUUID ) )

     FAILED failed
     REPORTED reported.

    COMMIT ENTITIES
      RESPONSE OF ZI_RAP_Travel_1234
      FAILED     failed_commit
      REPORTED   reported_commit.

    out->write( 'Delete done' ).

  ENDMETHOD.
ENDCLASS.
