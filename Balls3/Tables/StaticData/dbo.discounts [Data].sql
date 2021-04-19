INSERT INTO [dbo].[discounts] ([discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES ('Customer Discount', '8042', NULL, NULL, CONVERT([decimal](4, 2),5.00))
INSERT INTO [dbo].[discounts] ([discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES ('Initial Customer', NULL, NULL, NULL, CONVERT([decimal](4, 2),10.50))
INSERT INTO [dbo].[discounts] ([discounttype], [stor_id], [lowqty], [highqty], [discount]) VALUES ('Volume Discount', NULL, 100, 1000, CONVERT([decimal](4, 2),6.70))
