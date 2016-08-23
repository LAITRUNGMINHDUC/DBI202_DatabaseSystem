USE [FUH_UNIVERSITY];

/*1*/
SELECT * FROM [tblStudent]
WHERE YEAR(stuBirthdate) = 1990;

/*2*/
SELECT [tblInstructor].* 
FROM [dbo].[tblSection], [dbo].[tblInstructor], [dbo].[tblSubject]
WHERE UPPER(RTRIM(LTRIM([tblSubject].subName))) = UPPER(RTRIM(LTRIM('Introduction to Databases')))
	AND [tblSection].secSemester = 3
	AND [tblSection].secYear = 2010
	AND [tblSection].subCode = [tblSubject].subCode
	AND [tblSection].insSSN = [tblInstructor].insSSN; 

/*3*/
SELECT *
FROM [dbo].[tblSubject] A
WHERE A.subCode IN (SELECT A.subCode
				FROM [dbo].[tblSection] A, [dbo].[tblReport] B
				WHERE 
					B.stuCode = (SELECT A.stuCode
								FROM [dbo].[tblStudent] A
								WHERE A.stuName = N'Lê Nguyễn Hoài An')
					AND A.secCode = B.secCode
					AND A.secYear = 2010)


	

/*4*/
SELECT claCode, COUNT(claCode) AS 'Numbers'
FROM [dbo].[tblStudent]
GROUP BY claCode;

/*5*/
-- Solution 1 --
	/*
		Làm tập hợp SV đăng ký môn
		Làm tập hợp SV đậu các môn
		JOIN/INTERSECT 2 cái
	*/
SELECT Student.*
FROM 
	(SELECT C.stuCode, COUNT(B.subCode) AS 'Subjects'
	FROM [dbo].[tblSection] B, [dbo].[tblReport] C
	WHERE 
		B.secCode = C.secCode
		AND B.secYear = 2010
	GROUP BY C.stuCode) stuSubject,
	(SELECT B.stuCode, COUNT (B.secCode) AS 'PassSubjects'
	FROM [dbo].[tblReport] B
	WHERE B.repStatus = 'P'		
	GROUP BY B.stuCode)	stuPass,
	[dbo].[tblStudent] Student
WHERE stuSubject.stuCode = stuPass.stuCode
	AND stuSubject.Subjects = stuPass.PassSubjects
	AND Student.stuCode = stuPass.stuCode

-- Solution 2 --
	/*
		Làm tập hợp SV đăng ký môn
		Làm tập hợp SV rớt các môn
		EXCEPT 2 cái
	*/
SELECT Student.*
FROM [dbo].[tblStudent] Student
WHERE Student.stuCode IN
	(SELECT A.stuCode
	FROM [dbo].[tblReport] A, [dbo].[tblSection] B
	WHERE A.secCode = B.secCode
	EXCEPT
	SELECT A.stuCode
	FROM [dbo].[tblReport] A
	WHERE A.repStatus = 'R')

/*6*/
SELECT R3.claCode, R3.stuCode, R3.stuName
FROM [dbo].[tblStudent] R3, 
	(SELECT B.stuCode, AVG ((B.repPracticle + B.repTheory)*0.5) AS 'Average'
	FROM  [dbo].[tblSection] A, [dbo].[tblReport] B
	WHERE A.secCode = B.secCode 
		AND A.secYear = 2010
	GROUP BY B.stuCode) R1,
	(SELECT A.claCode, MAX(B.Average) AS 'MaxAvg'
	FROM [dbo].[tblStudent] A,
		(
		SELECT B.stuCode, AVG ((B.repPracticle + B.repTheory)*0.5) AS 'Average'
		FROM  [dbo].[tblSection] A, [dbo].[tblReport] B
		WHERE A.secCode = B.secCode 
			AND A.secYear = 2010
		GROUP BY B.stuCode
		) B
	WHERE A.stuCode = B.stuCode
	GROUP BY A.claCode) R2
WHERE R1.stuCode = R3.stuCode
	AND R1.Average = R2.MaxAvg
	AND R3.claCode = R2.claCode

/*7*/
	SELECT C.subName, COUNT(C.subName) AS 'Retake students'
	FROM [dbo].[tblSection] A, [dbo].[tblReport] B, [dbo].[tblSubject] C
	WHERE A.secYear = 2010
		AND B.secCode = A.secCode
		AND C.subCode = A.subCode
		AND B.repStatus = 'R'
	GROUP BY C.subName
