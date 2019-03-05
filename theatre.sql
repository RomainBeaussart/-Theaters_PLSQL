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
    NAME		        VARCHAR2(100) NOT NULL UNIQUE,
    CAPACITY		    NUMBER(6),		
    BUDGET              NUMBER(6),
    CITY                VARCHAR2(100),
    
        /* Constraints */

    CONSTRAINT PK_THEATERS          PRIMARY KEY(THEATER_ID),
    CONSTRAINT NN_THEATERS_CAP      CHECK(CAPACITY IS NOT NULL),
    CONSTRAINT NN_THEATERS_BUD      CHECK(BUDGET > 0)
);


/* --- Shows --- */

CREATE TABLE SHOWS
(
    ID                  NUMBER(6),
    NAME                VARCHAR(100) NOT NULL UNIQUE,
	COST                NUMBER(6),
	THEATER_PROD        VARCHAR(100),
    
        /* Constraints */

    CONSTRAINT PK_SHOWS             PRIMARY KEY (ID),
    CONSTRAINT NN_SHOWS_COST        CHECK(COST IS NOT NULL),

        /* Foreign Key */

    FOREIGN KEY (THEATER_PROD)      REFERENCES THEATERS(NAME),
);


/* --- Representations --- */

CREATE TABLE REPRESENTATIONS
(
    ID       		                NUMBER(6),
    SHOW_ID      				    NUMBER(6),
	THEATER					        VARCHAR2(100),
    REPRESENTATION_DATE           	DATE,
	NUMB_OF_REPRESENTATION			NUMBER(5),
	ACTOR_FEES						NUMBER(5),
	STAGING_COST					NUMBER(5),
	LIGHTING_COST					NUMBER(5),
	TRAVEL_COST						NUMBER(5),
    DISPONIBILITY                   NUMBER(5),

        /* Constraints */

    CONSTRAINT PK_REPRESENTATIONS           PRIMARY KEY(ID),

        /* Foreign Key */

    FOREIGN KEY (SHOW_ID)                   REFERENCES SHOWS(ID),
    FOREIGN KEY (THEATER)                   REFERENCES THEATERS(NAME),
);


/* --- Tickets --- */

CREATE TABLE TICKETS
(	
	ID					    NUMBER(6),
    T_TYPE        			NUMBER(5),
    TARIF			  	    NUMBER(5),
    REPRESENTATION_ID		NUMBER(6),
    PURCHASING_DATE         DATE,

        /* Constraints */

    CONSTRAINT PK_TICKETING         	PRIMARY KEY(ID),
    CONSTRAINT NN_TICKETING_TARIF   	CHECK(TARIF IS NOT NULL),

        /* Foreign Key */

    FOREIGN KEY(REPRESENTATION_ID)      REFERENCES REPRESENTATIONS(ID),
);


/* --- Grants --- */

CREATE TABLE GRANTES
(
    ID                  NUMBER(5),
    AMOUNT				NUMBER(5),
    DATE_GRANTED        DATE,  
	THEATER				NUMBER(5),
	
        /* Constraints */

    CONSTRAINT PK_GRANTES            	PRIMARY KEY(ID),
	CONSTRAINT	NN_DATE_GRANTED		    CHECK(DATE_GRANTED IS NOT NULL),

        /* Foreign Key */

    FOREIGN KEY(THEATER)                REFERENCES THEATERS(ID)
);


/* --- Donations --- */

CREATE TABLE DONATIONS
(	
	
    ID			        NUMBER(5),
	THEATER			    NUMBER(5),
	DONATION_DATE		DATE,
	AMOUNT_DONATION		NUMBER(8),	

        /* Constraints */

    CONSTRAINT PK_DONATION      PRIMARY KEY(ID),

        /* Foreign Key */

    FOREIGN KEY(THEATER)        REFERENCES THEATERS(ID)
);


/* --- Dates --- */

CREATE TABLE DATES
(	
	CURENT_DATE						DATE,
	TICKET_ID						NUMBER(5),
	REPRESENTATION_ID				NUMBER(5),

        /* Foreign Key */

    FOREIGN KEY(TICKET_ID)              REFERENCES TICKETS(ID),
    FOREIGN KEY(REPRESENTATION_ID)      REFERENCES REPRESENTATIONS(ID)
);


/*==================================================================================
                            |   TRIGGERS   | 
 ==================================================================================*/


/* --- Theaters --- */


/*==================================================================================
                            |     DATA     | 
 ==================================================================================*/


/* --- Theaters --- */