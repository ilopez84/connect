DROP TABLE TEMPLATE

DROP SEQUENCE MESSAGE_SEQUENCE

ALTER TABLE CHANNEL_ALERT RENAME TO OLD_CHANNEL_ALERT

ALTER TABLE ALERT_EMAIL RENAME TO OLD_ALERT_EMAIL

ALTER TABLE ALERT RENAME TO OLD_ALERT

ALTER TABLE MESSAGE RENAME TO OLD_MESSAGE

ALTER TABLE ATTACHMENT RENAME TO OLD_ATTACHMENT

ALTER TABLE CHANNEL_STATISTICS RENAME TO OLD_CHANNEL_STATISTICS

ALTER TABLE CHANNEL RENAME TO OLD_CHANNEL

ALTER TABLE CODE_TEMPLATE RENAME TO OLD_CODE_TEMPLATE

CREATE TABLE CHANNEL (
	ID CHAR(36) NOT NULL PRIMARY KEY,
	NAME VARCHAR(40) NOT NULL,
	REVISION NUMBER(10),
	CHANNEL CLOB
)

CREATE TABLE ALERT (
	ID VARCHAR(36) NOT NULL PRIMARY KEY,
	NAME VARCHAR(255) NOT NULL UNIQUE,
	ALERT CLOB NOT NULL
)

CREATE TABLE CODE_TEMPLATE (
	ID VARCHAR(255) NOT NULL PRIMARY KEY,
	CODE_TEMPLATE CLOB
)

UPDATE SCRIPT SET GROUP_ID = 'Global' WHERE GROUP_ID = 'GLOBAL'

DELETE FROM CONFIGURATION WHERE CATEGORY = 'core' AND NAME = 'server.maxqueuesize'

INSERT INTO CONFIGURATION (CATEGORY, NAME, VALUE) VALUES ('core', 'server.queuebuffersize', '1000')

TRUNCATE TABLE EVENT

ALTER TABLE EVENT RENAME COLUMN DATE_CREATED TO OLD_DATE_CREATED

ALTER TABLE EVENT ADD (DATE_CREATED TIMESTAMP WITH LOCAL TIME ZONE DEFAULT CURRENT_TIMESTAMP)

UPDATE EVENT SET DATE_CREATED = CAST(OLD_DATE_CREATED AS TIMESTAMP WITH LOCAL TIME ZONE)

ALTER TABLE EVENT DROP COLUMN OLD_DATE_CREATED

ALTER TABLE PERSON RENAME COLUMN LAST_LOGIN TO OLD_LAST_LOGIN

ALTER TABLE PERSON ADD (LAST_LOGIN TIMESTAMP WITH LOCAL TIME ZONE DEFAULT CURRENT_TIMESTAMP)

UPDATE PERSON SET LAST_LOGIN = CAST(OLD_LAST_LOGIN AS TIMESTAMP WITH LOCAL TIME ZONE)

ALTER TABLE PERSON DROP COLUMN OLD_LAST_LOGIN

ALTER TABLE PERSON RENAME COLUMN GRACE_PERIOD_START TO OLD_GRACE_PERIOD_START

ALTER TABLE PERSON ADD (GRACE_PERIOD_START TIMESTAMP WITH LOCAL TIME ZONE DEFAULT NULL)

UPDATE PERSON SET GRACE_PERIOD_START = CAST(OLD_GRACE_PERIOD_START AS TIMESTAMP WITH LOCAL TIME ZONE)

ALTER TABLE PERSON DROP COLUMN OLD_GRACE_PERIOD_START

ALTER TABLE PERSON_PASSWORD RENAME COLUMN PASSWORD_DATE TO OLD_PASSWORD_DATE

ALTER TABLE PERSON_PASSWORD ADD (PASSWORD_DATE TIMESTAMP WITH LOCAL TIME ZONE DEFAULT CURRENT_TIMESTAMP)

UPDATE PERSON_PASSWORD SET PASSWORD_DATE = CAST(OLD_PASSWORD_DATE AS TIMESTAMP WITH LOCAL TIME ZONE)

ALTER TABLE PERSON_PASSWORD DROP COLUMN OLD_PASSWORD_DATE