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
    NAME       			VARCHAR(100) NOT NULL UNIQUE,
	COST				NUMBER(6),
	THEATER_PROD		VARCHAR(100),
    
        /* Constraints */

    CONSTRAINT PK_SHOWS             PRIMARY KEY (ID),
    FOREIGN KEY (THEATER_PROD)      REFERENCES THEATERS(NAME),
    CONSTRAINT NN_SHOWS_COST        CHECK(COST IS NOT NULL)
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

        /* Constraintes */

    CONSTRAINT PK_TICKETING         	PRIMARY KEY(ID),
    FOREIGN KEY(REPRESENTATION_ID)      REFERENCES REPRESENTATIONS(ID),
    CONSTRAINT NN_TICKETING_TARIF   	CHECK(TARIF IS NOT NULL)

    
    
);

/*==================================================================================
                            |   TRIGGERS   | 
 ==================================================================================*/


/* --- Theaters --- */


/*==================================================================================
                            |     DATA     | 
 ==================================================================================*/


/* --- Theaters --- */

INSERT INTO THEATERS (NAME) VALUES ('Grand Rex');
INSERT INTO THEATERS (NAME) VALUES ('Point virgule');