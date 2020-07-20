Create table users_login(
    UserID int(10) AUTO_INCREMENT PRIMARY KEY,
    UserName varchar(30) UNIQUE,
    UserEmail varchar(30) NOT Null UNIQUE,
    UserPassword varchar(30) NOT Null);
	
Create table questions(
    QuestionID int(5) AUTO_INCREMENT PRIMARY KEY,
    QuestionGroup varchar(8),
    QuestionMaxPoint int(3));
	
Create table users_results(
   	UserID int(10),
    AttemptNumber int(3),
    QuestionID int(5),
    PointResult int(3));
	
ALTER TABLE users_results
ADD FOREIGN KEY (UserID) REFERENCES users_login(UserID);

ALTER TABLE users_results
ADD FOREIGN KEY (QuestionID) REFERENCES questions(QuestionID);

INSERT into users_login(UserName, UserEmail, UserPassword) VALUES ("Marek", "Marek@gmail.com", "Marek");
INSERT into users_login(UserName, UserEmail, UserPassword) VALUES ("Pawel", "Pawel@gmail.com", "Pawel123");

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

