Sp_WhoIsActive 1 

EXEC sp_WhoisActive 

    @find_block_leaders = 1, 

    @sort_order = ‘[blocked_session_count] DESC’, 

    @get_plans = 1, 

    @get_task_info = 2, 

    @get_additional_info = 1, 

    @output_column_list =  

    ‘[start_time][session_id][sql_text][query_plan] 

     [wait_info][block%][additional_info]’; 

EXEC sp_WhoisActive 

    @sort_order = ‘[tempdb_current]DESC’, 

    @get_plans = 1, 

    @output_column_list =  

    ‘[start_time][session_id][sql_text][query_plan][wait_info][temp%]’; 

  

  

Sp_WhoIsActive 2 

/* Get query memory grants, memory is reported in 8KB pages */ 

EXEC sp_WhoisActive 

    @get_memory_info = 1, 

    @output_column_list =  

    ‘[start_time][session_id][sql_text][query_plan][wait_info][%memory%]’; 

EXEC sp_WhoisActive 

    @get_transaction_info = 1, 

    @output_column_list =  

    ‘[start_time][session_id][sql_text][implicit_tran]’; 

  

/* When there is a big difference between  

[dd hh:mm:ss.mss] and [dd hh:mm:ss.mss (avg)] that’s a sign of parameter sniffing*/ 

EXEC sp_whoisactive @get_avg_time = 1, @get_plans = 1; 

  

  

  

Sp_WhoIsActive 3 

/* Get extra columns that shows delta values in the interval you specify. 

   Nice to use when you wants to find out what a query really do.*/ 

EXEC sp_WhoisActive 

    @delta_interval = 5, 

    @get_plans = 1; 

/*When you get a high time (dd hh:mm:ss:mss) but a much lower  

avg time (dd hh:mm:ss:mss (avg)). That a good sign av parameter issue. 

(It could be other problems like blocking).*/ 

EXEC sp_WhoisActive 

    @get_avg_time = 1, 

    @get_plans = 1; 

  

EXEC sp_WhoIsActive  

        @find_block_leaders = 1,  

        @sort_order = '[blocked_session_count] DESC' 

  

Sp_Blitz 1 

sp_Blitz @CheckServerInfo = 1, @CheckUserDatabaseObjects = 0; 

Set @CheckUserDatabaseObjects = 1 if you are responsible for the db’s 

Priority 1-50 is BAD ! 

  

Copy the result into Excel 

To get the result in a table. The table is made automagically 

Do this once a week or once a month. 

This can show that issues is beeing fixed 

sp_blitz    @OutputDatabaseName = 'StackOverflow2013’,   

        @OutputSchemaName = 'dbo’,  

        @OutputTableName = 'Blitz’; 

To get a nice output for Typora 

sp_Blitz     @CheckServerInfo = 1,  

        @CheckUserDatabaseObjects = 0,  

        @OutputType = 'markdown'; 

  

Sp_Blitz 2 

sp_Blitz @CheckServerInfo = 1 

/* How to skip stuff you don’t care about */ 

CREATE TABLE dbo.BlitzCheckSkip  

(ServerName SYSNAME NULL, Database SYSNAME NULL, CheckID INT NULL); 

INSERT INTO dbo. BlitzCheckSkip (ServerName, Database, CheckID) 

VALUES     (NULL, NULL,     55), --Database Owner <> SA 

    (NULL, NULL,     86), --Elevated permission in a database 

    (NULL, NULL,       6), --Jobs owned by users 

    (NULL, NULL,     78), --Stored Procedure WITH RECOMPILE 

    (NULL, NULL,   104), --Control Server Permissions 

    (NULL, NULL,        5), --Security Admins 

    (NULL, NULL,        4), --Sysadmins 

    (NULL, NULL, 2301), --Invalid Active Directory Accounts      

  

  

Sp_BlitzFirst 1 

sp_BlitzFirst 

How to Grant Permissions to Non-DBAs so anyone can run sp_blitzfirst 

https://www.brentozar.com/askbrent/ 

sp_blitzFirst @ExpertMode = 1 shows all detail during the 5 sec span 

sp_blitzFirst @ExpertMode = 1, @seconds = 60 Clearer show of what's happening 

  

  

Sp_BlitzFirst 2 

Getting the output to a table: A job every 15 min. 

EXEC dbo.sp_BlitzFirst 

@OutputDatabaseName = 'DBATools', 

@OutputSchemaName = dbo, 

@OutputTableName = 'BlitzFirst' 

@OutputTableNameFileStats = 'BlitzFirst_FileStat' 

@OutputTableNamePerfMonStats = 'BlitzFirst_PerfMonStats' 

@OutputTableNameWaitStats = 'BlitzFirst_WaitStat' 

@OutputTableNameBlitzCache = 'BlitzCahce' 

@OutputTableNameBlitzWho = 'BlitzWho’ 

  

The tables will automagically be created if they do not exist. 

  

  

  

Sp_BlitzFirst 3 

--Uptime between 1 week and 60 days 

sp_BlitzFirst @SinceStartUp = 1 

--Just the top 10 waits! 

sp_BlitzFirst @SinceStartup = 1 , @OutputType = 'Top10' 

--Most Resource-Intensive Queries 

sp_BlitzFirst @CheckProcedureCache = 1  

--Most Resource-Intensive Queries 

sp_BlitzFirst @ExpertMode = 1 , @Seconds = 10 

  

  

  

Sp_BlitzCache 

EXEC sp_BlitzCache @SortOrder = ‘avg cpu’; 

EXEC sp_BlitzCache  @SortOrder = ‘avg cpu’, @minimumExecutionCount = 1000; 

EXEC sp_BlitzCache @SortOrder = ‘unused memory grant’; 

EXEC sp_BlitzCache @SortOrder = ‘duplicate’; /* Queries with many plans*/ 

EXEC sp_BlitzCache @SortOrder = ‘xpm’; /* Executions per minute*/ 

EXEC sp_BlitzCache @OnlySqlHandles = ‘0x…’ 

  

  

Sp_BlitzLock 1 

Deadlocks 

Find the object with most deadlock, run sp_Blitzindex to see if it has too many or too few indexes. Many leads to locks when updateing/deleting, to few or none leavs no free for others when updateing. 

Save from the top list to the far right «deadlock_graph» as «deadlockname.xdl» with quotes. 

  

Open in Sentry Plan Explorer: Layout Type – «Layered Diagraph» and «Optimize Layout» 

Configure system_health: 

https://Mssqltips.com/sqlservertip/6456/improve-sql-server-extended-events-systemhealth-sessions/ 

Sp_BlitzLock save to tables 

  

  

Sp_BlitzLock 2 

sp_BlitzLock @StartDate = ’19000101’ –goes to system health 

sp_BlitzLock @StartDate = ’19000101’, @EventSessionName = ’deadlock’ –goes to another session 

  

  

Sp_BlitzIndex 

--Lighter output 

sp_BlitzIndex     @Mode = 0, @Databasename = N’Stackoverflow2013’ 

--More details 

sp_ BlitzIndex     @Mode = 4, @Databasename = N’Stackoverflow2013’ 

--Everything 

sp_ BlitzIndex     @Mode = 2, @Databasename = N’Stackoverflow2013’ 

--Missing indexes 

sp_ BlitzIndex     @Mode = 3, @Databasename = N’Stackoverflow2013’ 

--Everything, sorted 

sp_ BlitzIndex     @Databasename = N’Stackoverflow2013 , @Mode = 2,  

        @SortOrder = ‘rows’, /*reserved_mb, size, reads, writes*/ @SortDirection = ‘desc’; 

  

  

  

Sp_PerfCheck 

Gathers a comprehensive set of health metrics and configuration settings from your SQL Server instance. It's designed to provide a fast, lightweight, and actionable overview of potential problems without requiring deep knowledge of every Dynamic Management View (DMV) or Extended Event. 

EXEC sp_PerfCheck; 

EXEC sp_PerfCheck @help = 1; 

  

  

Sp_IndexCleanup 

Helps Fix Duplicate Indexes: It identifies indexes that are identical to other indexes on the same table and provides the DROP INDEX script for the duplicate. This is crucial for freeing up space and reducing overhead. 

Identifies Compression Candidates: The script can analyze your indexes to find candidates for compression and generates the COMPRESS script. This is a key feature for saving disk space on large tables. 

EXEC sp_IndexCleanup; 

EXEC sp_ IndexCleanup @help = 1; 

  

  

Sp_PressureDetector 

The script checks for signs of pressure on four main server resources: CPU, Memory, I/O, and TempDB. It gathers data from various Dynamic Management Views (DMVs) and presents it in a clear, actionable format. This allows a DBA to quickly identify if the server's slowness is due to a specific bottleneck. 

  

EXEC sp_PressureDetector @minmum_disk_latency_ms = 20, @what_to_check = ‘all’; 

EXEC sp_PressureDetector @what_to_check = ‘memory’; 

EXEC sp_PressureDetector @what_to_check = ‘cpu’; 

EXEC sp_PressureDetector @help = 1; 

/*Log to tables*/ 

EXEC sp_PressureDetector     @log_to_table = 1,  

            @log_database_name = ‘yourdbname’, 

            @log_schema_name = ‘dbo’, 

            @log_table_name_prefix = ‘atbl_Pressuredetector’, 

            @log_retention_days = 30; 

  

  

Sp_QuickStore 1  

EXEC sp_QuickieStore @help = 1; 

/* More details*/ 

EXEC sp_QuickieStore  @expert_mode = 1, @database_name = ‘StackOverflow2013’; 

/*Removes commas as thousand divider*/ 

EXEC sp_QuickieStore @format_Output = 0, @database_name = ‘StackOverflow2013’; 

/* What type of queries you want, “ad hoc” not from an object in SQL, either from an application or ssms*/ 

EXEC sp_QuickieStore @query_type = ‘a’, @database_name = ‘StackOverflow2013’; 

/* All other than “ad hoc” */ 

EXEC sp_QuickieStore @query_type = ‘module’, @database_name = ‘StackOverflow2013’; 

/*To get accurate time, get you UTC offset: */ SELECT my_offset = SYSDATETIMEOFFSET(); 

/*Then use the offset:*/ 

EXEC sp_QuickieStore  @start_date = ‘20230627 06:00 +2:00’, @end_date = ‘20230627 06:10 +2:00’; 

  

  

  

Sp_HumanEvents - extended events 

The script automates the creation, collection, and analysis of data from an Extended Events session. Its purpose is to make a powerful but complex feature accessible to a wider audience. Instead of manually configuring an Extended Events session, you can run sp_HumanEvents with a few simple parameters to capture specific types of performance data. 

Tuning monster procs: 

  

EXEC sp_HumanEvents  

    @event_type = 'query’, 

    @query_duration_ms = 500, 

    @session_id = your session id 

    @keep_alive = 1; 

Open Management -  Extended events – Human Event, and have a look at the “Watch live Data” 

  

  

Sp_HumanEvents - recompiles / waits 

Sample wait stats: 

EXEC sp_HumanEvents 

    @event_type = 'waits', 

    @seconds_sample = 65; 

Get recompiles in exptended events: 

EXEC sp_HumanEvents 

    @event_type = ‘recompiles', 

    @keep_alive = 1; 

Get compilations in exptended events: 

EXEC sp_HumanEvents 

    @event_type = ‘compilations', 

    @keep_alive = 1; 

  

  

Sp_HumanEvents - query performance 

EXEC sp_HumanEvents  

    @event_type = 'query’, 

    @query_duration_ms = 5000, 

    @seconds_sample = 20; 

EXEC sp_HumanEvents  

    @event_type = 'query', 

    @query_duration_ms = 5000, 

    @seconds_sample = 20 

    @sample_divisor = '5' ; 

EXEC sp_HumanEvents 

    @event_type = 'query', 

    @query_duration_ms = 5000, 

    @keep_alive = 1 

    @object_schema = ‘dbo' 

    @objetc_name = 'TheworstStoredProcedureEverWritten’; 

EXEC sp_HumanEvents  

    @event_type = 'query’, 

    @query_duration_ms = 10000, 

    @session_id = ‘ 60 ‘ 

    @keep_alive = 1; 

  

  

Sp_HumanEventsBlockViewer 

EXEC sp_HumanEventsBlockViewer  

    @session_name = N’bpr’, 

    @startdate = 19000101; 

  

  

  

  

  

  

  

 
