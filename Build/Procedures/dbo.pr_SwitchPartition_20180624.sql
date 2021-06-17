SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




	CREATE PROCEDURE [dbo].[pr_SwitchPartition_20180624]
	(
		@AGGREGATIONKEY INT,
		@AGGREGATION_DATABASE SYSNAME,
		@AGGREGATION_OWNER SYSNAME,
		@AGGREGATION_TABLE SYSNAME
	)
	AS
	DECLARE
		@UDFERRORMESSAGE VARCHAR(300),
		@EXEC VARCHAR(4000),
		@PARTITION_NO INT,
		@ROW_CNT BIGINT,
		@AGGREGATION_KEY_BASE SYSNAME,
		@AGGREGATION_KEY_NAME SYSNAME
	BEGIN
		SET NOCOUNT ON
		
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
					PRINT 'QUERYING FOR THE PARTITION NUMBER AND NUMBER OF ROWS'
					
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

					-- GET THE RESULTS FROM THE TABLE
					SELECT
						@PARTITION_NO = NULL,
						@ROW_CNT = 0
						
					SELECT
						@PARTITION_NO = PARTITION_NO,
						@ROW_CNT = ROW_CNT
					FROM
						@PARTITIONS
					
					PRINT 'FOUND: PARTITION NUMBER = ' + CONVERT(VARCHAR, @PARTITION_NO) + ', NUMBER OF ROWS = ' + CONVERT(VARCHAR, @ROW_CNT)
					
					-- ONLY RUN IF WE HAVE DATA/PARTITION
					IF ((@PARTITION_NO IS NOT NULL) AND (@ROW_CNT > 0))
						BEGIN			
							-- GOT A PARTITION AND ROWS, SO SWITCH IT OUT
							
							-- TRUNCATE THE STAGE, SINCE IT COULD HAVE DATA
							SELECT
								@EXEC = '
									TRUNCATE TABLE [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '_SWITCH]
									'
									
							PRINT 'TRUNCATING THE STAGING SWITCH TABLE'
							
							EXEC(@EXEC)
							
							-- EXPECTS THAT A STAGE SWITCH TABLE EXISTS
							SELECT
								@EXEC = '
									ALTER TABLE [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + ']  
										SWITCH PARTITION ' + CONVERT(VARCHAR, @PARTITION_NO) + ' TO [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '_SWITCH] PARTITION ' + CONVERT(VARCHAR, @PARTITION_NO) + '
									'
							
							PRINT 'SWITCHING OUT PARTITION'
							
							EXEC(@EXEC)
							
							-- TRUNCATE THE STAGE, SINCE IT HAS DATA
							SELECT
								@EXEC = '
									TRUNCATE TABLE [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + '_SWITCH]
									'
									
							PRINT 'TRUNCATING THE STAGING SWITCH TABLE'
							
							EXEC(@EXEC)
						END
					ELSE
						BEGIN
							PRINT 'NO PARTITION NUMBER COULD BE FOUND OR NO ROWS WERE PRESENT FOR THIS AGGREGATION KEY IN TABLE [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + ']'
						END
				END
			ELSE
				BEGIN
					PRINT 'NO AGGREGATION KEY COLUMN WITH A BASE OF "' + @AGGREGATION_KEY_BASE + '" WAS FOUND IN THE TABLE [' + @AGGREGATION_DATABASE + '].[' + @AGGREGATION_OWNER + '].[' + @AGGREGATION_TABLE + ']'
				END
		END TRY

		BEGIN CATCH
			-- STANDARD ROUTINE TO CATCH/LOG ERROR
			SELECT @UDFERRORMESSAGE = ERROR_MESSAGE()
			
			RAISERROR (@UDFERRORMESSAGE,
				16, -- SEVERITY.
				1 -- STATE.
			)
			
			RETURN -1
		END CATCH
	END
	

GO
