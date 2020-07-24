Create or replace table users(
    UserID int(10) AUTO_INCREMENT PRIMARY KEY,
    UserName varchar(30) UNIQUE,
    UserEmail varchar(30) NOT Null UNIQUE,
    UserPassword varchar(30) NOT Null,
	SchoolID int(5));
	
Create table questions(
    QuestionID int(5) AUTO_INCREMENT PRIMARY KEY,
    QuestionGroup varchar(8),
    QuestionMaxPoint int(3));
	
Create table users_results(
   	UserID int(10),
    AttemptNumber int(3),
    QuestionID int(5),
    PointResult int(3));
	
Create table schools(
    SchoolID int(5) AUTO_INCREMENT PRIMARY KEY,
    SchoolName varchar(50),
    REGON varchar(14) UNIQUE);
	
Create table teachers(
    TeacherID int(5) AUTO_INCREMENT PRIMARY KEY,
    TeacherFirstName varchar(20) NOT Null UNIQUE,
    TeacherLastName varchar(30) NOT Null UNIQUE,
    SchoolID varchar(30),
    MainTeacher BOOLEAN,
    TeacherEmail varchar(30) NOT Null UNIQUE,
    TeacherPassword varchar(30) NOT Null);
	
Create table groups(
    TeacherID int(5),
   	UserID int(10));

	
ALTER TABLE users_results
ADD FOREIGN KEY (UserID) REFERENCES Users(UserID);

ALTER TABLE users_results
ADD FOREIGN KEY (QuestionID) REFERENCES questions(QuestionID);

ALTER TABLE teachers
ADD FOREIGN KEY (TeacherID) REFERENCES schools(SchoolID);

ALTER TABLE users
ADD FOREIGN KEY (SchoolID) REFERENCES schools(SchoolID)

ALTER TABLE groups
ADD FOREIGN KEY (TeacherID) REFERENCES teachers(TeacherID);

ALTER TABLE groups
ADD FOREIGN KEY (UserID) REFERENCES users(UserID);

INSERT into Users(UserName, UserEmail, UserPassword) VALUES ("Marek", "Marek@gmail.com", "Marek");
INSERT into Users(UserName, UserEmail, UserPassword) VALUES ("Pawel", "Pawel@gmail.com", "Pawel123");

INSERT into questions(QuestionID, QuestionGroup, QuestionMaxPoint) VALUES (1, "EE.08", 40);
INSERT into questions(QuestionID, QuestionGroup, QuestionMaxPoint) VALUES (2, "EE.08", 60);

INSERT into users_results(UserID, AttemptNumber, QuestionID, PointResult) VALUES (1, 1, 1, 40);
INSERT into users_results(UserID, AttemptNumber, QuestionID, PointResult) VALUES (2, 1, 2, 59);
INSERT into users_results(UserID, AttemptNumber, QuestionID, PointResult) VALUES (1, 1, 2, 60);
INSERT into users_results(UserID, AttemptNumber, QuestionID, PointResult) VALUES (2, 1, 1, 39);


-- FUNCTIONS --

DELIMITER //
CREATE or REPLACE FUNCTION fCheckPointCompatibility(LocalQuestionID int(5), Point int(3))
	RETURNS varchar(100)
	BEGIN
    	IF not EXISTS (SELECT * FROM questions WHERE QuestionID = LocalQuestionID) then
        	RETURN CONCAT("MAIN ERROR [ ] Brak pytania QuestionID = ", LocalQuestionID ," w tabeli questions");
        END IF;
        
        if (SELECT QuestionMaxPoint FROM questions WHERE QuestionID = LocalQuestionID)>= Point THEN
        	return true;	
        ELSE
        	return "Blad zgodnosci wartosci punktow";
        END IF;
	END//
DELIMITER ;



DELIMITER $$
CREATE or REPLACE FUNCTION fInsertResult(LocalUserID int(10), LocalQuestionID int(5), LocalPointResult int(3))
    RETURNS varchar(300)
	BEGIN
    
        DECLARE LocalAttemptNumber int(5);
        DECLARE CheckPointCompatibility varchar(300);
        declare exit handler for sqlexception

        -- 
        -- error value  
        -- 
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
            SET @full_error = CONCAT("MAIN ERROR [", @errno, "] ", @text);
            return @full_error;
        END;
        
        set CheckPointCompatibility = (select fCheckPointCompatibility(LocalQuestionID, LocalPointResult));
        
        if not (CheckPointCompatibility = "1") THEN
        	RETURN CheckPointCompatibility;
       	end if;
        
            -- 
            -- check AttemptNumber in INSERT INTO  
            -- 
            set LocalAttemptNumber = (SELECT max(AttemptNumber) FROM users_results WHERE UserID = LocalUserID and QuestionID =LocalQuestionID);

            IF EXISTS (SELECT * FROM users_results WHERE UserID = LocalUserID and QuestionID =LocalQuestionID) then 
                INSERT INTO users_results(UserID, AttemptNumber, QuestionID, PointResult) VALUES(LocalUserID, LocalAttemptNumber+1, LocalQuestionID, LocalPointResult);
                return 'Zapis udany';

            ELSEIF not EXISTS (SELECT * FROM users_results WHERE UserID = LocalUserID and QuestionID =LocalQuestionID) then 
                INSERT INTO users_results(UserID, AttemptNumber, QuestionID, PointResult) VALUES(LocalUserID, 1, LocalQuestionID, LocalPointResult);
                return 'Zapis udany';

            else
                return 'Blad zapisu';

            END IF;


	END$$
DELIMITER ;

