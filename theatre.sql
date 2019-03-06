/*==================================================================================
                            |   SETTINGS   |
 ==================================================================================*/


 ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY' ;


/*==================================================================================
                            |  DATA BASES  | 
 ==================================================================================*/


/* --- Fake date --- */

CREATE TABLE FAKE_DATE
(
    DAY     NUMBER(2) NOT NULL,
    MONTH   NUMBER(2) NOT NULL,
    YEAR    NUMBER(4) NOT NULL
);


/* --- Theaters --- */

CREATE TABLE THEATERS
(
    NAME		        VARCHAR2(100) NOT NULL,
    CAPACITY		    NUMBER(6),	
    BUDGET              NUMBER(6) NOT NULL,
    CITY                VARCHAR2(100),
    
        /* Constraints */

    CONSTRAINT PK_THEATERS          PRIMARY KEY(NAME),
    CONSTRAINT NN_THEATERS_CAP      CHECK(CAPACITY IS NOT NULL),
    CONSTRAINT NN_THEATERS_BUD      CHECK(BUDGET > 0)
);


/* --- Shows --- */

CREATE TABLE SHOWS
(
    NAME                VARCHAR(100) NOT NULL,
	COST                NUMBER(6),
	THEATER_PROD        VARCHAR(100),
    
        /* Constraints */

    CONSTRAINT PK_SHOWS             PRIMARY KEY (NAME),
    CONSTRAINT NN_SHOWS_COST        CHECK(COST IS NOT NULL),

        /* Foreign Key */

    FOREIGN KEY (THEATER_PROD)      REFERENCES THEATERS(NAME)
);


/* --- Representations --- */

CREATE TABLE REPRESENTATIONS
(
    ID       		                NUMBER(6) NOT NULL,
    SHOW      				        VARCHAR2(100),
	THEATER					        VARCHAR2(100),
    REPRESENTATION_DATE           	DATE,
	ACTOR_FEES						NUMBER(5),
	STAGING_COST					NUMBER(5),
	LIGHTING_COST					NUMBER(5),
	TRAVEL_COST						NUMBER(5),
    DISPONIBILITY                   NUMBER(5),

        /* Constraints */

    CONSTRAINT PK_REPRESENTATIONS           PRIMARY KEY(ID),

        /* Foreign Key */

    FOREIGN KEY (SHOW)                      REFERENCES SHOWS(NAME),
    FOREIGN KEY (THEATER)                   REFERENCES THEATERS(NAME)
);


/* --- Tickets --- */

CREATE TABLE TICKETS
(	
	ID					    NUMBER(6) NOT NULL,
    TICKET_TYPE        		NUMBER(5),
    TARIF			  	    NUMBER(5),
    REPRESENTATION_ID		NUMBER(6),
    PURCHASING_DATE         DATE,

        /* Constraints */

    CONSTRAINT PK_TICKETING         	PRIMARY KEY(ID),
    CONSTRAINT NN_TICKETING_TARIF   	CHECK(TARIF IS NOT NULL),

        /* Foreign Key */

    FOREIGN KEY(REPRESENTATION_ID)      REFERENCES REPRESENTATIONS(ID)
);


/* --- Grants --- */

CREATE TABLE GRANTES
(
    ID                  NUMBER(5) NOT NULL,
    AMOUNT				NUMBER(5),
    DATE_GRANTED        DATE,  
	THEATER				VARCHAR2(100),
	
        /* Constraints */

    CONSTRAINT PK_GRANTES            	PRIMARY KEY(ID),
	CONSTRAINT	NN_DATE_GRANTED		    CHECK(DATE_GRANTED IS NOT NULL),

        /* Foreign Key */

    FOREIGN KEY(THEATER)                REFERENCES THEATERS(NAME)
);


/* --- Donations --- */

CREATE TABLE DONATIONS
(	
	
    ID			        VARCHAR2(100),
	THEATER			    VARCHAR2(100),
	DONATION_DATE		DATE,
	AMOUNT_DONATION		NUMBER(8),	

        /* Constraints */

    CONSTRAINT PK_DONATION      PRIMARY KEY(ID),

        /* Foreign Key */

    FOREIGN KEY(THEATER)        REFERENCES THEATERS(NAME)
);


/*==================================================================================
                            |   TRIGGERS   | 
 ==================================================================================*/


/* --- Representations --- */




/* --- Tickets --- */
CREATE TRIGGER TRIGG_BI_TICKETS BEFORE INSERT
    ON TICKETS FOR EACH ROW
DECLARE
    DISPO NUMBER(5);
BEGIN
    SELECT DISPONIBILITY INTO DISPO FROM REPRESENTATIONS
        WHERE ID = :OLD.REPRESENTATION_ID;
    IF DISPO > 0 THEN
        UPDATE REPRESENTATIONS SET DISPONIBILITY = DISPONIBILITY-1
            WHERE ID = :OLD.REPRESENTATION_ID;
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Theater is full!');
    END IF;
END;
/





/*==================================================================================
                            |     DATA     | 
 ==================================================================================*/


/* --- Theaters --- */