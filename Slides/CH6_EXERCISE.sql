USE [FUH_COMPANY];

/*1*/
SELECT A.* 
FROM [dbo].[tblDependent] A, [dbo].[tblEmployee] B
WHERE B.empName = N'Mai Duy An' 
		AND A.empSSN = B.empSSN;

/*2*/
SELECT A.*
FROM [dbo].[tblDependent] A, [dbo].[tblEmployee]
WHERE A.empSSN IN (
	SELECT B.empSSN
	FROM [dbo].[tblEmployee] B
	WHERE B.depNum = (
		SELECT C.depNum
		FROM [dbo].[tblDepartment] C
		WHERE C.depName = N'Phòng Phần mềm trong nước'
	)
);
/*Or*/
SELECT B.depName, B.depRelationship, C.empName
FROM [dbo].[tblDepartment] A, [dbo].[tblDependent] B, [dbo].[tblEmployee] C
WHERE A.depName = N'Phòng Phần mềm trong nước'
	AND A.depNum = C.depNum AND B.empSSN = C.empSSN;

/*3*/
SELECT B.*
FROM [dbo].[tblDepartment] A, [dbo].[tblEmployee] B, [dbo].[tblProject] C, [dbo].[tblWorksOn] D
WHERE A.depName = N'Phòng Phần mềm trong nước' 
	AND A.depNum = B.depNum -- AND B.depNum = C.depNum 
	AND C.proName = N'ProjectA'
	AND D.empSSN = B.empSSN
	AND D.proNum = C.proNum;

/*4*/
SELECT B.*
FROM [dbo].[tblLocation] A, [dbo].[tblEmployee] B, [dbo].[tblWorksOn] C, [dbo].[tblProject] D
WHERE A.locName = N'TP Hồ Chí Minh' 
		AND A.locNum = D.locNum
		AND B.empSSN = C.empSSN
		AND D.proNum = C.proNum;