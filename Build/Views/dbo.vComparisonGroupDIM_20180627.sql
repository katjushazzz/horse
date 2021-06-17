SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vComparisonGroupDIM_20180627]
AS
SELECT ComparisonGroupKey
      ,ProductID
      ,ComparisonGroupName
      ,ComparisonGroupDesc
      ,ClientGroupKey
      ,ComparisonGroupType
      ,LowerRange
      ,UpperRange
      ,RowIsCurrent
      ,RowStartDate
      ,RowEndDate
FROM dbo.ComparisonGroupDIM
WHERE
(ComparisonGroupType = 'Volume Group' OR ComparisonGroupType IS NULL)
GO
