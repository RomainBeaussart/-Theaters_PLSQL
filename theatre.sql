/*==================================================================================
                            |   SETTINGS   |
 ==================================================================================*/


 ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY' ;


 /*==================================================================================
                            |     TYPE     |
 ==================================================================================*/


CREATE TYPE DATES AS OBJECT(
    DATE_START                  DATE,
    NUMBER_OF_RECCURENCES       NUMBER(2),
    RECCURENCY                  VARCHAR2(100)
)
/


/*==================================================================================
                            |  DATA BASES  | 
 ==================================================================================*/


/* --- Theaters --- */

CREATE TABLE THEATERS
(
    NAME		        VARCHAR2(100) NOT NULL,
    CAPACITY		    NUMBER(6),	
    BUDGET              NUMBER(12) NOT NULL,
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
    REPRESENTATION_DATES           	DATES,
	ACTOR_FEES						NUMBER(5),
	STAGING_COST					NUMBER(5),
	LIGHTING_COST					NUMBER(5),
	TRAVEL_COST						NUMBER(5),
    DISPONIBILITY                   NUMBER(5),
    SELLING_PRICE                   NUMBER(5),

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
    REPRESENTATION_ID		NUMBER(6),
    PURCHASING_DATE         DATE,
    NAME_SPECTATOR          VARCHAR2(100),

        /* Constraints */

    CONSTRAINT PK_TICKETING         	PRIMARY KEY(ID),

        /* Foreign Key */

    FOREIGN KEY(REPRESENTATION_ID)      REFERENCES REPRESENTATIONS(ID)
);


/* --- Grants --- */

CREATE TABLE GRANTS
(
    AMOUNT				    NUMBER(9),
    DATE_GRANTED            DATES,
	THEATER				    VARCHAR2(100),
    SPONSOR                 VARCHAR2(100),
	
        /* Constraints */

	CONSTRAINT	NN_DATE_GRANTS		    CHECK(DATE_GRANTED IS NOT NULL),
    CONSTRAINT	NN_SPONSOR_GRANTS		CHECK(SPONSOR IS NOT NULL),
    CONSTRAINT	NN_THEATER_GRANTS		CHECK(THEATER IS NOT NULL),
    CONSTRAINT  POS_AMOUNT              CHECK(AMOUNT>0),

        /* Foreign Key */

    FOREIGN KEY(THEATER)                REFERENCES THEATERS(NAME)
);


/* --- Donations --- */

CREATE TABLE DONATIONS
(	
	THEATER			    VARCHAR2(100),
	DONATION_DATE		DATE,
	AMOUNT		        NUMBER(8),
    DONATOR             VARCHAR2(100),

        /* Foreign Key */

    FOREIGN KEY(THEATER)        REFERENCES THEATERS(NAME)
);


/*==================================================================================
                            |   TRIGGERS   | 
 ==================================================================================*/


/* --- Theaters --- */



/* --- Shows --- */

CREATE TRIGGER TRIGG_BI_SHOWS BEFORE INSERT
    ON SHOWS FOR EACH ROW
DECLARE
    BUDGET_THEATER NUMBER(12);
BEGIN
    SELECT BUDGET INTO BUDGET_THEATER FROM THEATERS WHERE NAME = :OLD.THEATER_PROD;
    IF BUDGET_THEATER < :OLD.COST THEN
        RAISE_APPLICATION_ERROR(-20002, 'No budget !');
    END IF;
END;
/

/* --- Representations --- */


/* --- Tickets --- */

CREATE TRIGGER TRIGG_BI_TICKETS BEFORE INSERT
    ON TICKETS FOR EACH ROW
DECLARE
    DISPO NUMBER(5);
BEGIN
    SELECT DISPONIBILITY INTO DISPO FROM REPRESENTATIONS WHERE ID = :OLD.REPRESENTATION_ID;
    IF DISPO > 0 THEN
        UPDATE REPRESENTATIONS SET DISPONIBILITY = DISPO-1 WHERE ID = :OLD.REPRESENTATION_ID;
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Theater is full !');
    END IF;
END;
/


/* --- Grants --- */




/* --- Donations --- */

CREATE TRIGGER TRIGG_AI_DONATIONS AFTER INSERT 
    ON DONATIONS FOR EACH ROW
BEGIN
    UPDATE THEATERS SET BUDGET = BUDGET + :OLD.AMOUNT WHERE NAME = :OLD.THEATER;
END;
/

/*==================================================================================
                            |   Functions   | 
 ==================================================================================*/

 /* DATES */
CREATE FUNCTION EVERY_DAYS(DATES DATES)
    RETURN BOOLEAN
IS
    I INT(2) := 0;
BEGIN
    IF DATES.DATE_START BETWEEN SYSDATE AND (SYSDATE + DATES.NUMBER_OF_RECCURENCES) THEN
        RETURN TRUE;
    END IF;

    RETURN FALSE;
END;
/
/*==================================================================================
                            |     DATA     | 
 ==================================================================================*/


/* --- Theaters --- */

INSERT INTO THEATERS (NAME, CAPACITY, BUDGET, CITY) 
VALUES ('Grand Rex',2800,10000,'Paris');

INSERT INTO THEATERS (NAME, CAPACITY, BUDGET, CITY) 
VALUES ('Le Grand Point-Virgule',650,5000,'Paris');

INSERT INTO THEATERS (NAME, CAPACITY, BUDGET, CITY) 
VALUES ('Bobino',904,7000,'Paris');

INSERT INTO THEATERS (NAME, CAPACITY, BUDGET, CITY) 
VALUES ('Olympia',1996,10000,'Paris');

INSERT INTO THEATERS (NAME, CAPACITY, BUDGET, CITY) 
VALUES ('Casino de Paris',1500,9000,'Paris');

INSERT INTO THEATERS (NAME, CAPACITY, BUDGET, CITY) 
VALUES ('Théâtre Mogador',1600,9000,'Paris');


/* --- Shows --- */

INSERT INTO SHOWS (NAME, COST, THEATER_PROD) 
VALUES ('Le tartuffe',1600,'Bobino');
