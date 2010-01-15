DROP TABLE SCHEMA_INFO;

CREATE TABLE SCHEMA_INFO
	(VERSION VARCHAR(40));

DROP SEQUENCE EVENT_SEQUENCE CASCADE;

CREATE SEQUENCE EVENT_SEQUENCE START WITH 1;

DROP TABLE EVENT;

CREATE TABLE EVENT
	(ID INTEGER DEFAULT nextval('EVENT_SEQUENCE') NOT NULL PRIMARY KEY,
	DATE_CREATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	EVENT TEXT NOT NULL,
	EVENT_LEVEL VARCHAR(40) NOT NULL,
	DESCRIPTION TEXT,
	ATTRIBUTES TEXT);
	
DROP TABLE CHANNEL CASCADE;

CREATE TABLE CHANNEL
	(ID VARCHAR(255) NOT NULL PRIMARY KEY,
	NAME VARCHAR(40) NOT NULL,
	DESCRIPTION TEXT,
	IS_ENABLED BOOLEAN NOT NULL,
	VERSION VARCHAR(40),
	REVISION INTEGER,
	LAST_MODIFIED TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	SOURCE_CONNECTOR TEXT,
	DESTINATION_CONNECTORS TEXT,
	PROPERTIES TEXT,
	PREPROCESSING_SCRIPT TEXT,
	POSTPROCESSING_SCRIPT TEXT,
	DEPLOY_SCRIPT TEXT,
	SHUTDOWN_SCRIPT TEXT);
	
DROP TABLE CHANNEL_STATISTICS;
	
CREATE TABLE CHANNEL_STATISTICS
	(SERVER_ID VARCHAR(255) NOT NULL,
	CHANNEL_ID VARCHAR(255) NOT NULL REFERENCES CHANNEL(ID) ON DELETE CASCADE,
	RECEIVED NUMERIC,
	FILTERED NUMERIC,
	SENT NUMERIC,
	ERROR NUMERIC,
	QUEUED NUMERIC,
	ALERTED NUMERIC,
	PRIMARY KEY(SERVER_ID, CHANNEL_ID));

DROP SEQUENCE MESSAGE_SEQUENCE CASCADE;

CREATE SEQUENCE MESSAGE_SEQUENCE START WITH 1;

DROP TABLE ATTACHMENT;

CREATE TABLE ATTACHMENT
    (ID VARCHAR(255) NOT NULL PRIMARY KEY,
     MESSAGE_ID VARCHAR(255) NOT NULL,
     ATTACHMENT_DATA BYTEA,
     ATTACHMENT_SIZE INTEGER,
     ATTACHMENT_TYPE VARCHAR(40));

CREATE INDEX ATTACHMENT_INDEX1 ON ATTACHMENT(MESSAGE_ID);

CREATE INDEX ATTACHMENT_INDEX2 ON ATTACHMENT(ID);     
     
DROP TABLE MESSAGE;

CREATE TABLE MESSAGE
	(SEQUENCE_ID INTEGER DEFAULT NEXTVAL('MESSAGE_SEQUENCE') NOT NULL PRIMARY KEY,
	ID VARCHAR(255) NOT NULL,
	SERVER_ID VARCHAR(255) NOT NULL,
	CHANNEL_ID VARCHAR(255) NOT NULL REFERENCES CHANNEL(ID) ON DELETE CASCADE,
	SOURCE VARCHAR(255),
	TYPE VARCHAR(255),
	DATE_CREATED TIMESTAMP NOT NULL,
	VERSION VARCHAR(40),
	IS_ENCRYPTED BOOLEAN NOT NULL,
	STATUS VARCHAR(40),
	RAW_DATA TEXT,
	RAW_DATA_PROTOCOL VARCHAR(40),
	TRANSFORMED_DATA TEXT,
	TRANSFORMED_DATA_PROTOCOL VARCHAR(40),
	ENCODED_DATA TEXT,
	ENCODED_DATA_PROTOCOL VARCHAR(40),
	CONNECTOR_MAP TEXT,
	CHANNEL_MAP TEXT,
	RESPONSE_MAP TEXT,
	CONNECTOR_NAME VARCHAR(255),
	ERRORS TEXT,
	CORRELATION_ID VARCHAR(255),
	ATTACHMENT BOOLEAN,	
	UNIQUE (ID));

CREATE INDEX MESSAGE_INDEX1 ON MESSAGE(CHANNEL_ID, DATE_CREATED);

CREATE INDEX MESSAGE_INDEX2 ON MESSAGE(CHANNEL_ID, DATE_CREATED, CONNECTOR_NAME);

CREATE INDEX MESSAGE_INDEX3 ON MESSAGE(CHANNEL_ID, DATE_CREATED, RAW_DATA_PROTOCOL);

CREATE INDEX MESSAGE_INDEX4 ON MESSAGE(CHANNEL_ID, DATE_CREATED, SOURCE);

CREATE INDEX MESSAGE_INDEX5 ON MESSAGE(CHANNEL_ID, DATE_CREATED, STATUS);

CREATE INDEX MESSAGE_INDEX6 ON MESSAGE(CHANNEL_ID, DATE_CREATED, TYPE);

CREATE INDEX MESSAGE_INDEX7 ON MESSAGE(CORRELATION_ID, CONNECTOR_NAME);

CREATE INDEX MESSAGE_INDEX8 ON MESSAGE(ATTACHMENT) WHERE (ATTACHMENT=TRUE);
	
DROP TABLE SCRIPT;

CREATE TABLE SCRIPT
	(ID VARCHAR(255) NOT NULL PRIMARY KEY,
	SCRIPT TEXT);

DROP TABLE TEMPLATE;

CREATE TABLE TEMPLATE
	(ID VARCHAR(255) NOT NULL PRIMARY KEY,
	TEMPLATE TEXT);

DROP SEQUENCE PERSON_SEQUENCE CASCADE;

CREATE SEQUENCE PERSON_SEQUENCE START WITH 1;

DROP TABLE PERSON;

CREATE TABLE PERSON
	(ID INTEGER DEFAULT nextval('PERSON_SEQUENCE') NOT NULL PRIMARY KEY,
	USERNAME VARCHAR(40) NOT NULL,
	PASSWORD VARCHAR(40) NOT NULL,
	SALT VARCHAR(40) NOT NULL,
	FIRSTNAME VARCHAR(40),
	LASTNAME VARCHAR(40),
	ORGANIZATION VARCHAR(255),
	EMAIL VARCHAR(255),
	PHONENUMBER VARCHAR(40),
	DESCRIPTION VARCHAR(255),
	LAST_LOGIN TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	LOGGED_IN BOOLEAN NOT NULL);

DROP TABLE ALERT CASCADE;

CREATE TABLE ALERT
	(ID VARCHAR(255) NOT NULL PRIMARY KEY,
	NAME VARCHAR(40) NOT NULL,
	IS_ENABLED BOOLEAN NOT NULL,
	EXPRESSION TEXT,
	TEMPLATE TEXT,
	SUBJECT VARCHAR(998));
	
DROP TABLE CODE_TEMPLATE;

CREATE TABLE CODE_TEMPLATE
	(ID VARCHAR(255) NOT NULL PRIMARY KEY,
	NAME VARCHAR(40) NOT NULL,
	CODE_SCOPE VARCHAR(40) NOT NULL,
	CODE_TYPE VARCHAR(40) NOT NULL,
	TOOLTIP VARCHAR(255) NOT NULL,
	CODE TEXT);		
	
DROP TABLE CHANNEL_ALERT;

CREATE TABLE CHANNEL_ALERT
	(CHANNEL_ID VARCHAR(255) NOT NULL,
	ALERT_ID VARCHAR(255) NOT NULL REFERENCES ALERT(ID) ON DELETE CASCADE);

DROP TABLE ALERT_EMAIL;

CREATE TABLE ALERT_EMAIL
	(ALERT_ID VARCHAR(255) NOT NULL REFERENCES ALERT(ID) ON DELETE CASCADE,
	EMAIL VARCHAR(255) NOT NULL);

DROP SEQUENCE CONFIGURATION_SEQUENCE CASCADE;

CREATE SEQUENCE CONFIGURATION_SEQUENCE START WITH 1;

DROP TABLE CONFIGURATION;

CREATE TABLE CONFIGURATION
	(ID INTEGER DEFAULT nextval('CONFIGURATION_SEQUENCE') NOT NULL PRIMARY KEY,
	DATE_CREATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	DATA TEXT NOT NULL);
	
DROP TABLE ENCRYPTION_KEY;

CREATE TABLE ENCRYPTION_KEY
	(DATA TEXT NOT NULL);

DROP TABLE PREFERENCES;

CREATE TABLE PREFERENCES
	(PERSON_ID INTEGER NOT NULL REFERENCES PERSON(ID),
	NAME VARCHAR(255) NOT NULL,
	VALUE TEXT);

INSERT INTO PERSON (USERNAME, PASSWORD, SALT, LOGGED_IN) VALUES('admin', 'NdgB6ojoGb/uFa5amMEyBNG16mE=', 'Np+FZYzu4M0=', FALSE);

INSERT INTO SCHEMA_INFO (VERSION) VALUES ('6');