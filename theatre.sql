/*---------------
 |   SETTINGS   |
 ---------------*/

 ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY' ;

/*---------------
 |  DATA BASES  | 
 ---------------*/

/* --- Fake date --- */

CREATE TABLE FAKE_DATE
(
    DAY NUMBER(2) NOT NULL,
    MONTH NUMBER(2) NOT NULL,
    YEAR NUMBER(4) NOT NULL
);


/* --- Theaters --- */

CREATE TABLE THEATERS
(
    NAME		        VARCHAR2(100) NOT NULL UNIQUE,
    CAPACITY		    NUMBER(6),		
    BUDGET              NUMBER(6),
    CITY                VARCHAR2(100),
    
        /* Constraints */

    CONSTRAINT PK_THEATER           PRIMARY KEY(THEATER_ID),
    CONSTRAINT NN_THEATER_CAP       CHECK(CAPACITY IS NOT NULL),
    CONSTRAINT NN_THEATER_BUD       CHECK(BUDGET > 0)
);


/* --- Shows --- */

CREATE TABLE SHOWS
(
    ID                  NUMBER(6),
    NAME       			VARCHAR(100) NOT NULL UNIQUE,
	COST				NUMBER(6),
	THEATER_PROD		VARCHAR(100),
    
        /* Constraints */

    CONSTRAINT PK_SHOWS         PRIMARY KEY (ID),
    FOREIGN KEY (NAME)          REFERENCES THEATERS (NAME),
    CONSTRAINT NN_COUT          CHECK(COST IS NOT NULL)
);

/* --- Representations --- */

CREATE TABLE REPRESENTATIONS
(
    ID       		                NUMBER(6),
    SHOW      				        VARCHAR2(100),
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
    FOREIGN KEY (SHOW)                      REFERENCES SHOWS (NAME),
    FOREIGN KEY (THEATER)                   REFERENCES THEATERS (NAME),
);

/*---------------
 |     DATA     | 
 ---------------*/

/* --- Theaters --- */

INSERT INTO THEATERS (NAME) VALUES ('Grand Rex');
INSERT INTO THEATERS (NAME) VALUES ('Point virgule');