{Created: Saturday, July 27, 1991 at 11:39 PM SegLoad.p Pascal Interface to the Macintosh Libraries  Copyright Apple Computer, Inc. 1985-1991  All rights reserved    This file is used in these builds: Mac32 BigBang Sys606	Change History (most recent first):		 <3>	 7/31/91	JL		Updated Copyright.		 <2>	 1/27/91	LN		Checked in Database generate file from DSG.	To Do:} UNIT SegLoad; INTERFACE USES Types;CONSTappOpen = 0;		{Open the Document (s)}appPrint = 1;		{Print the Document (s)}TYPEAppFile = RECORD vRefNum: INTEGER; fType: OSType; versNum: INTEGER;	{versNum in high byte} fName: Str255; END;PROCEDURE UnloadSeg(routineAddr: Ptr);PROCEDURE ExitToShell;PROCEDURE GetAppParms(VAR apName: Str255;VAR apRefNum: INTEGER;VAR apParam: Handle);PROCEDURE CountAppFiles(VAR message: INTEGER;VAR count: INTEGER);PROCEDURE GetAppFiles(index: INTEGER;VAR theFile: AppFile);PROCEDURE ClrAppFiles(index: INTEGER);IMPLEMENTATIONPROCEDURE UnloadSeg(routineAddr: Ptr); BEGIN END;PROCEDURE ExitToShell; BEGIN END;PROCEDURE GetAppParms(VAR apName: Str255;VAR apRefNum: INTEGER;VAR apParam: Handle); BEGIN END;PROCEDURE CountAppFiles(VAR message: INTEGER;VAR count: INTEGER); BEGIN END;PROCEDURE GetAppFiles(index: INTEGER;VAR theFile: AppFile); BEGIN END;PROCEDURE ClrAppFiles(index: INTEGER); BEGIN END;END.