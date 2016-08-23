CREATE TABLE [dbo].[Admin](
	[UserID] [nchar](10) NOT NULL PRIMARY KEY,
	[Password] [nvarchar](60) NOT NULL)

CREATE TABLE [dbo].[Articles](
	[ID] [nchar](10) NOT NULL PRIMARY KEY,
	[Title] [nvarchar](max) NOT NULL UNIQUE,
	[Contents] [ntext] NOT NULL,
	[Author] [nvarchar](50) NOT NULL,
	[PublishedDate] [datetime] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[ArticleCategory] [int] NOT NULL,
	[Avatar] [nvarchar](max) NOT NULL)
ALTER TABLE [dbo].[Articles] ADD  CONSTRAINT [DF_Articles_Status]  DEFAULT ((1)) FOR [Status]
ALTER TABLE [dbo].[Articles]  ADD  CONSTRAINT [FK_Articles_ArticlesCategory] FOREIGN KEY([ArticleCategory])
REFERENCES [dbo].[ArticlesCategory] ([ID])

CREATE TABLE [dbo].[ArticlesCategory](
	[ID] [int] NOT NULL PRIMARY KEY,
	[Name] [nvarchar](50) NOT NULL UNIQUE)

CREATE TABLE [dbo].[Attributes](
	[ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](50) NOT NULL)

CREATE TABLE [dbo].[CategoryHasAttributes](
	[CategoryID] [int] NOT NULL,
	[AttributesID] [int] NOT NULL,
	PRIMARY KEY ([CategoryID], [AttributesID]))
ALTER TABLE [dbo].[CategoryHasAttributes]  ADD  CONSTRAINT [FK_CategoryHasAttributes_Attributes] FOREIGN KEY([AttributesID])
REFERENCES [dbo].[Attributes] ([ID])
ALTER TABLE [dbo].[CategoryHasAttributes]  ADD  CONSTRAINT [FK_CategoryHasAttributes_ProductCategory] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[ProductCategory] ([CategoryID])

CREATE TABLE [dbo].[CategoryHasFeatures](
	[CategoryID] [int] NOT NULL,
	[FeaturesID] [int] NOT NULL,
	PRIMARY KEY ([CategoryID], [FeaturesID]))
ALTER TABLE [dbo].[CategoryHasFeatures]  ADD  CONSTRAINT [FK_CategoryHasFeatures_Features] FOREIGN KEY([FeaturesID])
REFERENCES [dbo].[Features] ([ID])
ALTER TABLE [dbo].[CategoryHasFeatures]  ADD  CONSTRAINT [FK_CategoryHasFeatures_ProductCategory] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[ProductCategory] ([CategoryID])


CREATE TABLE [dbo].[Features](
	[ID] [int] NOT NULL PRIMARY KEY,
	[FeatureName] [nvarchar](50) NOT NULL,
	[FeatureContent] [ntext] NULL,
	[ImageURL] [text] NULL)



CREATE TABLE [dbo].[Footer](
	[ID] [int] NOT NULL PRIMARY KEY,
	[Name] [nvarchar](50) NOT NULL,
	[URL] [nvarchar](max) NOT NULL,
	[Position] [int](10) NOT NULL)


CREATE TABLE [dbo].[Menu](
	[ID] [int] NOT NULL PRIMARY KEY,
	[Name] [nvarchar](50) NOT NULL,
	[URL] [text] NOT NULL,
	[ParentID] [int] NULL)
ALTER TABLE [dbo].[Menu]  ADD  CONSTRAINT [FK_Menu_Menu] FOREIGN KEY([ParentID])
REFERENCES [dbo].[Menu] ([ID])




CREATE TABLE [dbo].[PartnersSeller](
	[PartnerID] [int] NOT NULL PRIMARY KEY,
	[Name] [nvarchar](50) NOT NULL,
	[Address] [ntext] NOT NULL,
	[PhoneNo] [nchar](20) NOT NULL)




CREATE TABLE [dbo].[Product](
	[Model] [nchar](10) NOT NULL PRIMARY KEY,
	[CategoryID] [int] NOT NULL,
	[SubCategoryID] [int] NULL,
	[ImageURL] [text] NOT NULL)
ALTER TABLE [dbo].[Product]  ADD  CONSTRAINT [FK_Product_ProductCategory] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[ProductCategory] ([CategoryID])

ALTER TABLE [dbo].[Product]  ADD  CONSTRAINT [FK_Product_ProductCategory1] FOREIGN KEY([SubCategoryID])
REFERENCES [dbo].[ProductCategory] ([CategoryID])




CREATE TABLE [dbo].[ProductCategory](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Name] [nvarchar](50) NOT NULL,
	[ParentID] [int] NULL)
ALTER TABLE [dbo].[ProductCategory]  ADD  CONSTRAINT [FK_ProductCategory_ProductCategory] FOREIGN KEY([ParentID])
REFERENCES [dbo].[ProductCategory] ([CategoryID])





CREATE TABLE [dbo].[ProductHasFeatures](
	[ID] [int] NOT NULL PRIMARY KEY,
	[ProductModel] [nchar](10) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[FeaturesID] [int] NOT NULL)
ALTER TABLE [dbo].[ProductHasFeatures]  ADD  CONSTRAINT [FK_ProductHasFeatures_CategoryHasFeatures] FOREIGN KEY([CategoryID], [FeaturesID])
REFERENCES [dbo].[CategoryHasFeatures] ([CategoryID], [FeaturesID])
ALTER TABLE [dbo].[ProductHasFeatures]  ADD  CONSTRAINT [FK_ProductHasFeatures_Product] FOREIGN KEY([ProductModel])
REFERENCES [dbo].[Product] ([Model])




CREATE TABLE [dbo].[ProductIsSoldBy](
	[ProductModel] [nchar](10) NOT NULL PRIMARY KEY,
	[PartnersID] [int] NOT NULL PRIMARY KEY)

ALTER TABLE [dbo].[ProductIsSoldBy]  ADD  CONSTRAINT [FK_ProductIsSold_PartnersSeller] FOREIGN KEY([PartnersID])
REFERENCES [dbo].[PartnersSeller] ([PartnerID])

ALTER TABLE [dbo].[ProductIsSoldBy]  ADD  CONSTRAINT [FK_ProductIsSoldBy_Product] FOREIGN KEY([ProductModel])
REFERENCES [dbo].[Product] ([Model])


CREATE TABLE [dbo].[ProductSpecification](
	[ID] [int] NOT NULL PRIMARY KEY,
	[ProductModel] [nchar](10) NOT NULL,
	[AttributeID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
	[Value] [ntext] NOT NULL)

ALTER TABLE [dbo].[ProductSpecification]  ADD  CONSTRAINT [FK_ProductSpecification_CategoryHasAttributes] FOREIGN KEY([CategoryID], [AttributeID])
REFERENCES [dbo].[CategoryHasAttributes] ([CategoryID], [AttributesID])

ALTER TABLE [dbo].[ProductSpecification]  ADD  CONSTRAINT [FK_ProductSpecification_Product] FOREIGN KEY([ProductModel])
REFERENCES [dbo].[Product] ([Model])





CREATE TABLE [dbo].[Reviews](
	[ID] [int] NOT NULL PRIMARY KEY,
	[Title] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Contents] [ntext] NOT NULL,
	[RevCategoryID] [int] NOT NULL,
	[Model] [nchar](10) NOT NULL,
	[TimeSubmitted] [datetime] NOT NULL,
	[Status] [int] NOT NULL)
ALTER TABLE [dbo].[Reviews]  ADD  CONSTRAINT [FK_Reviews_ReviewsCategory] FOREIGN KEY([RevCategoryID])
REFERENCES [dbo].[ReviewsCategory] ([ID])

CREATE TABLE [dbo].[ReviewsCategory](
	[ID] [int] NOT NULL PRIMARY KEY,
	[CategoryName] [nvarchar](50) NOT NULL UNIQUE,
	[Status] [tinyint] NOT NULL)
GO
ALTER TABLE [dbo].[ReviewsCategory] ADD CONSTRAINT [DF_ReviewsCategory_Status]  DEFAULT ((1)) FOR [Status]
GO

--------------------------------------------------------------

/*
	Trigger 1: Check CategoryID of Product Specification table with CategoryID of ProductTable
	(must be the same).
*/
-- Start Trigger 1 --
IF OBJECT_ID('CheckCategoryOfSpecification', 'TR') is not null
	DROP TRIGGER CheckCategoryOfSpecification
GO

CREATE TRIGGER CheckCategoryOfSpecification ON [dbo].[ProductSpecification]
AFTER INSERT, UPDATE
AS 
	DECLARE @CategoryID INT, @Model NCHAR(10), @CategoryIDFromProduct INT

	SELECT @CategoryID = CategoryID, @Model = ProductModel
	FROM inserted

	SET @CategoryIDFromProduct = 
		(SELECT [dbo].[Product].CategoryID
		FROM [dbo].[Product]
		WHERE [dbo].[Product].Model = @Model)

	IF (@CategoryID <> @CategoryIDFromProduct)
		BEGIN
		RAISERROR('The CategoryID in this table must be the same with Product table', 16, 1)
		ROLLBACK TRANSACTION
		END
GO
-- End Trigger 1 --


/* 
	Trigger 2: Check Model has valid length (9 characters) in Product table.
*/
-- Start Trigger 2 --
IF OBJECT_ID('CheckValidModel', 'TR') is not null
	DROP TRIGGER CheckValidModel
GO

CREATE TRIGGER CheckValidModel
ON [dbo].[Product]
AFTER INSERT, UPDATE
AS 
	DECLARE @Model NCHAR(10)

	SELECT @Model=Model
	FROM inserted

	IF (LEN(@Model) <> 9)
		BEGIN
			RAISERROR('The Model Length must be 9 characters', 16, 1)
			ROLLBACK TRANSACTION
		END
GO
-- End Trigger 2 --

/* 
	Trigger 3: Check CategoryID and SubCategoryID must be different in Product Table.
*/
-- Start Trigger 3 --
IF OBJECT_ID('CheckCategoryAndSubCategory', 'TR') is not null
	DROP TRIGGER CheckCategoryAndSubCategory
GO

CREATE TRIGGER CheckCategoryAndSubCategory
ON [dbo].[Product]
AFTER INSERT, UPDATE
AS 
	DECLARE @CategoryID INT, @SubCategoryID INT

	SELECT @CategoryID=CategoryID, @SubCategoryID=SubCategoryID
	FROM inserted

	IF (@CategoryID = @SubCategoryID)
		BEGIN
			RAISERROR('Category and SubCategory must be different.', 16, 1)
			ROLLBACK TRANSACTION
		END
GO
-- End Trigger 3 --

/* 
	Trigger 4: Ignore changing Status of Reviews from Read (1) to completely UnRead (0)
	It means that if Admin want to unread it, he/she need to change Status to Flag (2)
*/
-- Start Trigger 4 --
IF OBJECT_ID('CheckReviewStatusReadToUnread', 'TR') is not null
	DROP TRIGGER CheckReviewStatusReadToUnread
GO

CREATE TRIGGER CheckReviewStatusReadToUnread
ON [dbo].[Reviews]
AFTER UPDATE
AS
	DECLARE @Status INT
	SELECT @Status = [Status]
	FROM inserted

	IF (@Status = 0)
		BEGIN
			RAISERROR('Cannot change Status to UNREAD.', 16, 1)
			ROLLBACK
		END
GO
-- End Trigger 4 --

/* 
	Trigger 5: Check Model doesn't contain special characters  in Product table.
*/
-- Start Trigger 5 --
IF OBJECT_ID('CheckSpecialCharModel', 'TR') is not null
	DROP TRIGGER CheckSpecialCharModel
GO

CREATE TRIGGER CheckSpecialCharModel
ON [dbo].[Product]
AFTER INSERT, UPDATE
AS 
	DECLARE @Model NCHAR(10)

	SELECT @Model=Model
	FROM inserted

	IF (@Model NOT LIKE '%[^A-Z0-9]%')
		BEGIN
			RAISERROR('The Model must not contain special characters or lower case', 16, 1)
			ROLLBACK TRANSACTION
		END
GO
-- End Trigger 5 --

----------------------------------------------------------------------

 

/* View all Quattro frezer */
SELECT A.* 
FROM [dbo].[Product] A, [dbo].[ProductCategory] B
WHERE A.CategoryID = B.CategoryID
	AND B.Name = N'Tủ Quattro'

/* View the features of product with model: EQE6807SD */
SELECT B.*
FROM [dbo].[ProductHasFeatures] A, [dbo].[Features] B
WHERE A.FeaturesID = B.ID
	AND A.ProductModel = N'EQE6807SD'


/* View companies that sell product with model EQE6807SD */
SELECT B.*
FROM [dbo].[ProductIsSoldBy] A, [dbo].[PartnersSeller] B
WHERE A.ProductModel = N'EQE6807SD' 
	AND A.PartnersID = B.PartnerID

/*	View product specifications of EQE6807SD */
SELECT A.Name, B.Value
FROM [dbo].[Attributes] A, [dbo].[ProductSpecification] B
WHERE A.ID = B.AttributeID
	AND B.ProductModel = N'EQE6807SD'

/* View 30 latest articles */
SELECT TOP 30 *
FROM [dbo].[Articles]
ORDER BY [dbo].[Articles].PublishedDate DESC

/* Delete Article with Title: Máy giặt cửa trước Electrolux EWF14112 vận hành siêu êm */
DELETE FROM [dbo].[Articles]
WHERE Title = N'Máy giặt cửa trước Electrolux EWF14112 vận hành siêu êm'

/* Insert "Lò Vi Sóng" as children of "Sản phẩm nhà bếp" */
INSERT INTO [dbo].[ProductCategory] (Name) VALUES (N'Sản phẩm nhà bếp')

DECLARE @ParentID INT
SELECT @ParentID=CategoryID FROM [dbo].[ProductCategory]
WHERE Name = N'Sản phẩm nhà bếp'

INSERT INTO [dbo].[ProductCategory] (Name, ParentID) VALUES (N'Lò vi sóng', @ParentID)	

------------------------------------------------------------------

 

/* Set Available all articles of author */
-- @Status = 1 --> Available
-- @Status = 0 --> Hide
IF OBJECT_ID('psm_Update_Available_Of_Articles_By_Titles', 'P') IS NOT NULL
	DROP PROCEDURE psm_Update_Available_Of_Articles_By_Titles
GO

CREATE PROCEDURE psm_Update_Available_Of_Articles_By_Titles
	@Author NVARCHAR(50),
	@Status INT
AS
	UPDATE [dbo].[Articles]
	SET [Status] = @Status
	WHERE Author = @Author
GO

EXEC psm_Update_Available_Of_Articles_By_Titles N'Yoona', 1

/* Find SubMenu by ParentID */
IF OBJECT_ID('psm_Select_Menu', 'P') IS NOT NULL
	DROP PROCEDURE psm_Select_SubMenu
GO

CREATE PROCEDURE psm_Select_SubMenu	
	@SubMenu INT
AS
	SELECT *
	FROM [dbo].[Menu]
	WHERE ParentID = @SubMenu
GO

EXEC psm_Select_SubMenu	10

/* Find SubMenu by ParentID */
IF OBJECT_ID('psm_Select_Menu', 'P') IS NOT NULL
	DROP PROCEDURE psm_Select_SubMenu
GO

CREATE PROCEDURE psm_Select_SubMenu	
	@SubMenu INT
AS
	SELECT *
	FROM [dbo].[Menu]
	WHERE ParentID = @SubMenu
GO

EXEC psm_Select_SubMenu	10

/* Find Products Type that Company sell - Input Company ID */
IF OBJECT_ID('psm_Company_Sell_Product', 'P') IS NOT NULL
	DROP PROCEDURE psm_Company_Sell_Product
GO

CREATE PROCEDURE psm_Company_Sell_Product
	@CompanyID INT
AS
	SELECT DISTINCT B.Name
	FROM [dbo].[ProductIsSoldBy] A, [dbo].[ProductCategory] B, [dbo].[Product] C
	WHERE A.PartnersID = @CompanyID
		AND A.ProductModel = C.Model
		AND B.CategoryID = C.CategoryID
GO

EXEC psm_Company_Sell_Product 1
 
 /* Insert Data to Attributes table */
IF OBJECT_ID('psm_Insert_Attributes', 'P') IS NOT NULL
	DROP PROCEDURE psm_Insert_Attributes
GO

CREATE PROCEDURE psm_Insert_Attributes
	@Name NVARCHAR(50)
AS
	INSERT INTO [dbo].[Attributes] (Name)
	VALUES (@Name)
GO

EXEC psm_Insert_Attributes N'Width'
EXEC psm_Insert_Attributes N'Length'
EXEC psm_Insert_Attributes N'Height'




