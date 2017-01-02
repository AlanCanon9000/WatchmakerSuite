{Created: Saturday, July 27, 1991 at 8:31 PM DiskInit.p Pascal Interface to the Macintosh Libraries  Copyright Apple Computer, Inc.  1985-1991  All rights reserved    This file is used in these builds: Mac32 BigBang Sys606	Change History (most recent first):		 <3>	 7/30/91	JL		Updated Copyright.		 <2>	 1/27/91	LN		Checked in Database generate file from DSG.	To Do:} UNIT DiskInit; INTERFACE USES Types;TYPEHFSDefaults = RECORD sigWord: PACKED ARRAY [0..1] OF Byte;	{ signature word} abSize: LONGINT;						{ allocation block size in bytes} clpSize: LONGINT;						{ clump size in bytes} nxFreeFN: LONGINT;						{ next free file number} btClpSize: LONGINT;					{ B-Tree clump size in bytes} rsrv1: INTEGER;						{ reserved} rsrv2: INTEGER;						{ reserved} rsrv3: INTEGER;						{ reserved} END;PROCEDURE DILoad;PROCEDURE DIUnload;FUNCTION DIBadMount(where: Point;evtMessage: LONGINT): INTEGER;FUNCTION DIFormat(drvNum: INTEGER): OSErr;FUNCTION DIVerify(drvNum: INTEGER): OSErr;FUNCTION DIZero(drvNum: INTEGER;volName: Str255): OSErr;IMPLEMENTATIONPROCEDURE DILoad; BEGIN END;PROCEDURE DIUnload; BEGIN END;FUNCTION DIBadMount(where: Point;evtMessage: LONGINT): INTEGER; BEGIN DIBadMount := 0 END;FUNCTION DIFormat(drvNum: INTEGER): OSErr; BEGIN DIFormat := noErr END;FUNCTION DIVerify(drvNum: INTEGER): OSErr; BEGIN DIVerify := noErr END;FUNCTION DIZero(drvNum: INTEGER;volName: Str255): OSErr; BEGIN DIZero := noErr END; END.