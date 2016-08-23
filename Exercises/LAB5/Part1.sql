USE [FUH_UNIVERSITY];

/* Question 1: */
IF OBJECT_ID('tr_DepMan_Ins', 'TR') IS NOT NULL
	DROP TRIGGER tr_DepMan_Ins
GO

CREATE TRIGGER tr_DepMan_Ins
ON [dbo].[tblDepartment]
AFTER INSERT, UPDATE
AS
	DECLARE @mgrSSN INT, @depCode INT, @depCodeIns INT

	SELECT @mgrSSN = mgrSSN, @depCode = depCode
	FROM inserted

	IF (@mgrSSN IS NOT NULL) 
		BEGIN
			SELECT @depCodeIns = depCode
			FROM [dbo].[tblInstructor]
			WHERE insSSN = @mgrSSN

			IF (@depCodeIns <> @depCode)
				BEGIN
					RAISERROR('Manager of department must be an instructor of this department', 16, 1)					
					ROLLBACK
				END
		END
GO

/* Question 2: */
IF OBJECT_ID('tr_Ins_Course_Expertise_tblSection', 'TR') IS NOT NULL
	DROP TRIGGER tr_Ins_Course_Expertise_tblSection
GO

CREATE TRIGGER tr_Ins_Course_Expertise_tblSection
ON [dbo].[tblSection]
AFTER UPDATE, INSERT
AS
	DECLARE @subCode INT, @insSSN INT
	SELECT @subCode=subCode, @insSSN=insSSN
	FROM inserted

	IF NOT EXISTS (SELECT * FROM [dbo].[tblTeaching]
				WHERE insSSN = @insSSN AND subCode = @subCode)
		BEGIN
			RAISERROR ('Instructor can only be assigned to courses corresponding to his/her expertise', 16,1)
			ROLLBACK
		END
GO

IF OBJECT_ID('tr_Ins_Course_Expertise_tblTeaching', 'TR') IS NOT NULL
	DROP TRIGGER tr_Ins_Course_Expertise_tblTeaching
GO

CREATE TRIGGER tr_Ins_Course_Expertise_tblTeaching
ON [dbo].[tblTeaching]
AFTER UPDATE, DELETE
AS
	DECLARE @subCode INT, @insSSN INT
	SELECT @subCode=subCode, @insSSN=insSSN
	FROM deleted

	IF EXISTS (SELECT * FROM [dbo].[tblSection]
				WHERE insSSN = @insSSN AND subCode = @subCode)
		BEGIN
			RAISERROR ('Instructor can only be assigned to courses corresponding to his/her expertise', 16,1)
			ROLLBACK
		END
GO

/* Question 3: */
IF OBJECT_ID('tr_Number_of_Students', 'TR') IS NOT NULL
	DROP TRIGGER tr_Number_of_Students
GO

CREATE TRIGGER tr_Number_of_Students
ON [dbo].[tblStudent]
AFTER INSERT, UPDATE
AS 
	DECLARE @claCode INT, @countStudents INT

	SELECT @claCode=claCode
	FROM inserted

	SELECT @countStudents = COUNT(*)
	FROM [dbo].[tblStudent]
	WHERE claCode = @claCode

	IF (@countStudents >= 25)
		BEGIN
			RAISERROR('The number of students per class must be less then 25.', 16, 1)
			ROLLBACK
		END	
GO

/* Question 4 */
IF OBJECT_ID('tr_Student_Enroll_Pass_Prequisites', 'TR') IS NOT NULL
	DROP TRIGGER tr_Student_Enroll_Pass_Prequisites
GO

CREATE TRIGGER tr_Student_Enroll_Pass_Prequisites
ON [dbo].[tblReport]
AFTER INSERT, UPDATE
AS
	DECLARE @stuCode INT, @secCode INT
	SELECT @stuCode = stuCode, @secCode = secCode
	FROM inserted

	DECLARE @subCode INT
	SELECT @subCode=subCode
	FROM [dbo].[tblSection]
	WHERE secCode = @secCode

	IF EXISTS (SELECT *	FROM [dbo].[tblReport] A
				WHERE A.stuCode = @stuCode
					AND A.repStatus = 'R'
					AND A.secCode IN 
						(SELECT secCode 
						FROM [dbo].[tblSection]
						WHERE subCode IN 
							(SELECT A.subPreCode
							FROM [dbo].[tblPrequisites] A
							WHERE A.subPosCode = @subCode)))
		BEGIN
			RAISERROR('Student can only enroll to a course if he/she passed all prerequisites for this course', 16,1)
			ROLLBACK
		END
GO

/* Question 5 */
IF OBJECT_ID('tr_Minimum_Ins_In_Course_tblSection', 'TR') IS NOT NULL
	DROP TRIGGER tr_Minimum_Ins_In_Course_tblSection
GO

CREATE TRIGGER tr_Minimum_Ins_In_Course_tblSection
ON [dbo].[tblSection]
AFTER UPDATE, DELETE
AS
	DECLARE @subCodeDel INT, @insSSNDel INT
	SELECT @subCodeDel=subCode, @insSSNDel=insSSN
	FROM deleted
	
	IF ((SELECT COUNT(A.subCode) 
		FROM [dbo].[tblSection] A
		WHERE A.subCode = @subCodeDel) < 3)
	BEGIN
		RAISERROR('There are minimum three instructors who are already for each course', 16, 1)
		ROLLBACK
	END
GO

IF OBJECT_ID('tr_Minimum_Ins_In_Course_tblTeaching', 'TR') IS NOT NULL
	DROP TRIGGER tr_Minimum_Ins_In_Course_tblTeaching
GO

CREATE TRIGGER tr_Minimum_Ins_In_Course_tblTeaching
ON [dbo].[tblTeaching]
AFTER UPDATE, DELETE
AS
	DECLARE @insSSNDel INT, @subCodeDel INT
	SELECT @insSSNDel=insSSN, @subCodeDel=subCode	
	FROM deleted

	IF EXISTS (SELECT * FROM [dbo].[tblSection] A
	WHERE A.subCode = @subCodeDel AND A.insSSN = @insSSNDel)
		BEGIN
			IF ((SELECT COUNT(A.subCode) 
					FROM [dbo].[tblSection] A
					WHERE A.subCode = @subCodeDel) < 3)			
				BEGIN
					RAISERROR('There are minimum three instructors who are already for each course', 16, 1)
					ROLLBACK
				END
		END
GO
