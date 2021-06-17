SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



/*
Ticket:- https://support.acc.org/browse/EDW-1303
Revised By:- Madhu
Revision:- Clientgroup filter added for CPMI

*/

CREATE  VIEW [dbo].[vComparisonGroupDIM]
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
	  ,ComparisonGroupLabel
FROM dbo.ComparisonGroupDIM
WHERE
ComparisonGroupType IN ('Volume Group','Client Group')  OR ComparisonGroupType IS NULL


GO
