SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_SwitchPartition]
(
	@AGGREGATIONKEY INT,
	@AGGREGATION_DATABASE SYSNAME,
	@AGGREGATION_OWNER SYSNAME,
	@AGGREGATION_TABLE SYSNAME,
	@INSERT BIT 
)
AS
DECLARE
	@UDFERRORMESSAGE VARCHAR(300),
	@EXEC VARCHAR(4000),
	@PARTITION_NO INT,
	@ROW_CNT BIGINT,
	@PARTITION_NO_SWITCH INT,
	@ROW_CNT_SWITCH BIGINT,
	@AGGREGATION_KEY_BASE SYSNAME,
	@AGGREGATION_KEY_NAME SYSNAME
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

/**************************************************************************************************
Project:		EDW2.0
JIRA:			N/A
Developer:		tkerlavage (Proximo)
Date:			2016-12-09
Description:	This stored procedure is used to either insert a partition into a target table
				or remove a partition from a target table via partition switiching.

				@AGGREGATION_DATABASE, @AGGREGATION_OWNER, @AGGREGATION_TABLE all correspond to the 
				Database name, schema and table name of the target table.

				@INSERT is used to tell the procedure to either insert or remove the partition.
				A value of 1 will perform an insert, a value of 0 will perform a removal
___________________________________________________________________________________________________
Example: EXEC dbo.pr_SwitchPartition 50, ClientMetricDM, dbo, ClientFCT, 1
This will perform a partition switch into ClientMetricDM.dbo.ClientFCT using data that is in ClientMetricDM.dbo.ClientFCT_SWITCH
The stored procedure will find which partition data for AggregationKey=50 lives, and it will switch that to the target table.

Example: EXEC dbo.pr_SwitchPartition 50, ClientMetricDM, dbo, ClientFCT, 0
This will perform a partition switch from ClientMetricDM.dbo.ClientFCT into ClientMetricDM.dbo.ClientFCT_SWITCH
as a means of quickly removing data. After the partition switch, ClientMetricDM.dbo.ClientFCT_SWITCH is truncated
The stored procedure will find which partition data for AggregationKey=50 lives, and it will switch that to the SWITCH table.
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/

	--Variables:
	DECLARE @ErrorMessage VARCHAR(2000) = ' '
		
	BEGIN TRY		
		-- SET THE BASE NAME OF THE PARTITION COLUMN
		SELECT
			@AGGREGATION_KEY_BASE = 'AGGREGATIONKEY'
				
		-- TABLE TO CONTAIN RESULTS FOR COLUMN NAME
		DECLARE @COLUMNS TABLE (COLNAME VARCHAR(255))
			
		-- GET THE CORRECT AGGREGATION COLUMN
		PRINT 'QUERYING FOR AGGREGATION KEY COLUMN NAME'
			
		SELECT
			@EXEC = '
				SELECT TOP 1
					[NAME]
				FROM
					(	
						SELECT
							1 AS PREF,
							[NAME]
						FROM
							[' + @AGGREGATION_DATABASE + '].DBO.SYSCOLUMNS
						WHERE
							[ID] = OBJECT_ID(''' + @AGGREGATION_DATABASE + '.' + @AGGREGATION_OWNER + '.' + @AGGREGATION_TABLE + ''') AND
							[NAME] = ''' + @AGGREGATION_KEY_BASE + '''

						UNION ALL

						SELECT
							2,
							[NAME]
						FROM
							[' + @AGGREGATION_DATABASE + '].DBO.SYSCOLUMNS
						WHERE
							[ID] = OBJECT_ID(''' + @AGGREGATION_DATABASE + '.' + @AGGREGATION_OWNER + '.' + @AGGREGATION_TABLE + ''') AND
							[NAME] LIKE ''%' + @AGGREGATION_KEY_BASE + '''
								
						UNION ALL

						SELECT
							3,
							[NAME]
						FROM
							[' + @AGGREGATION_DATABASE + '].DBO.SYSCOLUMNS
						WHERE
							[ID] = OBJECT_ID(''' + @AGGREGATION_DATABASE + '.' + @AGGREGATION_OWNER + '.' + @AGGREGATION_TABLE + ''') AND
							[NAME] LIKE ''%' + @AGGREGATION_KEY_BASE + '%''
					) A
				ORDER BY
					PREF
			'
			
		INSERT INTO @COLUMNS
		EXEC(@EXEC)
			
		-- GET THE RESULTS FROM THE TABLE
		SELECT
			@AGGREGATION_KEY_NAME = NULL
				
		SELECT
			@AGGREGATION_KEY_NAME = COLNAME
		FROM
			@COLUMNS
				
		PRINT 'FOUND: AGGREGATION KEY COLUMN = ' + @AGGREGATION_KEY_NAME
			
		-- ONLY RUN THE REST, IF WE HAVE AN AGGREGATIONKEY COLUMN
		IF (@AGGREGATION_KEY_NAME IS NOT NULL)
			BEGIN
				-- TABLE TO CONTAIN RESULTS FOR PARTITIONS
				DECLARE @PARTITIONS TABLE (PARTITION_NO INT, ROW_CNT BIGINT)
					
				-- GET PARTITION/ROWS
				PRINT 'QUERYING FOR THE PARTITION NUMBER AND NUMBER OF ROWS IN MAIN TABLE'
					
				SELECT
					@EXEC = '
						SELECT 
							[' + @AGGREGATION_DATABASE + '].$PARTITION.PF_AGGREGATIONKEY(' + @AGGREGATION_KEY_NAME + ') AS PARTITION_NO, 
							COUNT_BIG(*) AS ROW_CNT
						FROM 
							[' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '] 
						WHERE
							' + @AGGREGATION_KEY_NAME + ' = ' + CONVERT(VARCHAR, @AGGREGATIONKEY) + '
						GROUP BY 
							[' + @AGGREGATION_DATABASE + '].$PARTITION.PF_AGGREGATIONKEY(' + @AGGREGATION_KEY_NAME + ')
						'
					
				INSERT INTO @PARTITIONS
				EXEC(@EXEC)

				--SELECT @EXEC

				-- GET THE RESULTS FROM THE TABLE
				SELECT
					@PARTITION_NO = NULL,
					@ROW_CNT = 0
						
				SELECT
					@PARTITION_NO = PARTITION_NO,
					@ROW_CNT = ROW_CNT
				FROM
					@PARTITIONS
					
				PRINT 'FOUND: MAIN TABLE PARTITION NUMBER = ' + CONVERT(VARCHAR, @PARTITION_NO) + ', NUMBER OF ROWS = ' + CONVERT(VARCHAR, @ROW_CNT)
					


				-- TABLE TO CONTAIN RESULTS FOR PARTITIONS
				DECLARE @PARTITIONS_SWITCH TABLE (PARTITION_NO INT, ROW_CNT BIGINT)
					
				-- GET PARTITION/ROWS
				PRINT 'QUERYING FOR THE PARTITION NUMBER AND NUMBER OF ROWS IN SWITCH TABLE'
					
				SELECT
					@EXEC = '
						SELECT 
							[' + @AGGREGATION_DATABASE + '].$PARTITION.PF_AGGREGATIONKEY(' + @AGGREGATION_KEY_NAME + ') AS PARTITION_NO, 
							COUNT_BIG(*) AS ROW_CNT
						FROM 
							[' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '_SWITCH] 
						WHERE
							' + @AGGREGATION_KEY_NAME + ' = ' + CONVERT(VARCHAR, @AGGREGATIONKEY) + '
						GROUP BY 
							[' + @AGGREGATION_DATABASE + '].$PARTITION.PF_AGGREGATIONKEY(' + @AGGREGATION_KEY_NAME + ')
						'
					
				INSERT INTO @PARTITIONS_SWITCH
				EXEC(@EXEC)

				--SELECT @EXEC

				-- GET THE RESULTS FROM THE TABLE
				SELECT
					@PARTITION_NO_SWITCH = NULL,
					@ROW_CNT_SWITCH = 0
						
				SELECT
					@PARTITION_NO_SWITCH = PARTITION_NO,
					@ROW_CNT_SWITCH = ROW_CNT
				FROM
					@PARTITIONS_SWITCH
					
				PRINT 'FOUND: SWITCH TABLE PARTITION NUMBER = ' + CONVERT(VARCHAR, @PARTITION_NO) + ', NUMBER OF ROWS = ' + CONVERT(VARCHAR, @ROW_CNT)


			--HANDLE INSERTS
			IF (@INSERT = 1)
			BEGIN
				--IF THERE IS ALREADY DATA IN THIS PARTITION IN THE MAIN DESTINATION TABLE RETURN AN ERROR
				--DESTINATION PARTITION MUST BE EMPTY
				IF (@ROW_CNT > 0)
				BEGIN
					SELECT @UDFERRORMESSAGE = 'INSERT: Main table already has data in the partition for this AggregationKey'

					RAISERROR (
							@UDFERRORMESSAGE
							,16-- SEVERITY.
							,1 -- STATE.
							)

					RETURN
				END
				--IF THERE IS NO DATA IN THIS PARTITION IN THE MAIN DESTINATION TABLE
				ELSE
				--CHECK IF THERE IS DATA IN THE SWITCH TABLE TO INSERT 
				IF (@ROW_CNT_SWITCH > 0)
				BEGIN
					SELECT @EXEC = 'ALTER TABLE [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '_SWITCH]  
						SWITCH PARTITION ' + CONVERT(VARCHAR, @PARTITION_NO_SWITCH) + ' TO [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '] PARTITION ' + CONVERT(VARCHAR, @PARTITION_NO_SWITCH)
					EXEC (@EXEC)
					--SELECT @EXEC
					PRINT 'INSERT: SWITCHING OUT PARTITION'
				END
				ELSE
				BEGIN
					PRINT 'INSERT: NO DATA IN SWITCH PARTITION'
				END
			END
			--HANDLE REMOVALS
			ELSE
				--IF THERE ARE ROWS TO REMOVE
				IF(@ROW_CNT > 0)
				BEGIN
					-- TRUNCATE THE SWITCH, SINCE IT COULD HAVE DATA
					SELECT @EXEC = 'TRUNCATE TABLE [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '_SWITCH]'
					PRINT 'REMOVE: TRUNCATING THE STAGING SWITCH TABLE'
					EXEC(@EXEC)

					-- EXPECTS THAT A SWITCH TABLE EXISTS
					SELECT
						@EXEC = 'ALTER TABLE [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + ']  
								SWITCH PARTITION ' + CONVERT(VARCHAR, @PARTITION_NO) + ' TO [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '_SWITCH] PARTITION ' + CONVERT(VARCHAR, @PARTITION_NO)
							
					PRINT 'REMOVE: SWITCHING OUT PARTITION'
					--SELECT @EXEC
					EXEC(@EXEC)
							
					-- TRUNCATE THE STAGE, SINCE IT NOW HAS DATA
					SELECT
						@EXEC = 'TRUNCATE TABLE [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '_SWITCH]'
									
					PRINT 'REMOVE: TRUNCATING THE STAGING SWITCH TABLE'
							
					EXEC(@EXEC)
				END
				ELSE
				BEGIN
					PRINT 'REMOVE: THERE IS NO DATA TO REMOVE'
				END
			END

	END TRY

	BEGIN CATCH
		SET @ErrorMessage = 'An error occurred in stored procedure dbo.pr_SwitchPartition: ' + ERROR_MESSAGE()

		RAISERROR (
				@ErrorMessage
				,16
				,1
				);
	END CATCH

	SET NOCOUNT OFF;
END
	
GO
