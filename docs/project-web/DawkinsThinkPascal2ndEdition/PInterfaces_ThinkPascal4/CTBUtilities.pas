{	This file has been processed by The THINK Pascal Source Converter, v1.1.	}{}{	CTBUtilities.p}{	Pascal Interface to the Communications Toolbox Utilities}{	}{	Copyright � Apple Computer, Inc. 1988-90}{	All rights reserved}{}unit CTBUtilities;interface	uses		Appletalk;	const{ version of the Comm Toolbox Utilities }		curCTBUVersion = 2;{ CTBUErr}		ctbuGenericError = -1;		ctbuNoErr = 0;{ DITLMethod }		overlayDITL = 0;		appendDITLRight = 1;		appendDITLBottom = 2;{ Choose responses }		chooseDisaster = -2;		chooseFailed = -1;		chooseAborted = 0;		chooseOKMinor = 1;		chooseOKMajor = 2;		chooseCancel = 3;{ NuLookup responses }		nlOk = 0;		nlCancel = 1;		nlEject = 2;{ Name FilterProc responses }		nameInclude = 1;		nameDisable = 2;		nameReject = 3;{ Zone FilterProc responses }		zoneInclude = 1;		zoneDisable = 2;		zoneReject = 3;{ Dialog items for hook procedure }		hookOK = 1;		hookCancel = 2;		hookOutline = 3;		hookTitle = 4;		hookItemList = 5;		hookZoneTitle = 6;		hookZoneList = 7;		hookLine = 8;		hookVersion = 9;		hookReserved1 = 10;		hookReserved2 = 11;		hookReserved3 = 12;		hookReserved4 = 13;{ Virtual items in the dialog item list }		hookNull = 100;		hookItemRefresh = 101;		hookZoneRefresh = 102;		hookEject = 103;		hookPreflight = 104;		hookPostflight = 105;		hookKeyBase = 1000;	type		CTBUErr = OSErr;		DITLMethod = INTEGER;		NLTypeEntry = record				hIcon: Handle;				typeStr: Str32;			end;		NLType = array[0..3] of NLTypeEntry;		NBPReply = record				theEntity: EntityName;				theAddr: AddrBlock;			end;	function InitCTBUtilities: CTBUErr;	function CTBGetCTBVersion: INTEGER;	procedure AppendDITL (theDialog: DialogPtr; theDITL: Handle; method: DITLMethod);	function CountDITL (theDialog: DialogPtr): INTEGER;	procedure ShortenDITL (theDialog: DialogPtr; numberItems: INTEGER);	function StandardNBP (where: Point; prompt: Str255; numTypes: INTEGER; typeList: NLType; nameFilter: ProcPtr; zoneFilter: ProcPtr; hookProc: ProcPtr; var theReply: NBPReply): INTEGER;	function CustomNBP (where: Point; prompt: Str255; numTypes: INTEGER; typeList: NLType; nameFilter: ProcPtr; zoneFilter: ProcPtr; hookProc: ProcPtr; userData: LONGINT; dialogID: INTEGER; filterProc: ProcPtr; var theReply: NBPReply): INTEGER;{ Obsolete synonyms for above routines }	function NuLookup (where: Point; prompt: Str255; numTypes: INTEGER; typeList: NLType; nameFilter: ProcPtr; zoneFilter: ProcPtr; hookProc: ProcPtr; var theReply: NBPReply): INTEGER;	function NuPLookup (where: Point; prompt: Str255; numTypes: INTEGER; typeList: NLType; nameFilter: ProcPtr; zoneFilter: ProcPtr; hookProc: ProcPtr; userData: LONGINT; dialogID: INTEGER; filterProc: ProcPtr; var theReply: NBPReply): INTEGER;    { UsingCTBUtilities }implementationend.