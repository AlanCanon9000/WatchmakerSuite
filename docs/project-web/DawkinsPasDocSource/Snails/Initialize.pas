UNIT Initialize;{These routines are called once only at startup.  Keep this file in a separate segment that can be unloaded}{At present, initialize proc is *very* long, mostly because of the vast numbers of global vars. We should try}{to cut this down, splitting the proc up and giving vars file scope or less where possible}{History}{v1.1  Added system check}{		   Added attempts to save temp file in several places (v1.01 failed on locked server volumes) }{          Removed calls to toolbox inits (done automatically by Think Pascal)}{          Removed calls to MoreMasters (10 calls "             "       "        "   )}{          No longer lock down cursors throughout program execution}{			Improved out of memory warnings (but still some plain ExitToShells in there) }INTERFACEUSES	Pedigree;PROCEDURE Initialize;IMPLEMENTATIONUSES	Traps, Script, Folders, StandardGetFolder;	{Private uses, keeps compilation speed up}VAR	GenCurveRect: rect;(************************************************}{* 											InspectSystem										   *}{*																										    	*}{*	Gather information about the current OS												*}{*	Added for v1.1.  We collect more info than we really need at present 	*}{************************************************)PROCEDURE InspectSystem;	VAR		err: Integer;		environs: SysEnvRec;		response: Longint;		myFeature: Integer;	BEGIN		gSystem.hasGestalt := TrapAvailable(_GestaltDispatch);		gSystem.hasWNE := WNEIsImplemented;		gSystem.hasScriptMgr := TrapAvailable(_ScriptUtil);		gSystem.scriptsInstalled := 1; (* assume only Roman script	*)		err := SysEnvirons(1, environs);		IF (err = noErr) THEN			BEGIN				gSystem.hasColorQD := environs.hasColorQD;				gSystem.hasFPU := environs.hasFPU;				gSystem.systemVersion := environs.systemVersion; {2-byte hex number, eg $0710 or $0607}				gSystem.sysVRefNum := environs.sysVRefNum;			END		ELSE			BEGIN				gSystem.hasColorQD := FALSE;				gSystem.hasFPU := FALSE;				gSystem.systemVersion := 0;			END;		IF (gSystem.hasGestalt) THEN			{copied from TCL, but I am not sure this always works}			BEGIN				gSystem.hasAppleEvents := Gestalt(gestaltAppleEventsAttr, response) = noErr;				gSystem.hasAliasMgr := Gestalt(gestaltAliasMgrAttr, response) = noErr;				gSystem.hasEditionMgr := Gestalt(gestaltEditionMgrAttr, response) = noErr;				gSystem.hasHelpMgr := Gestalt(gestaltHelpMgrAttr, response) = noErr;				gSystem.hasFolderMgr := Gestalt(gestaltFindFolderAttr, response) = noErr;				IF (gSystem.hasScriptMgr) THEN					BEGIN						err := Gestalt(gestaltScriptCount, response);						IF (err = noErr) THEN							gSystem.scriptsInstalled := Integer(response);					END;			END		ELSE	(* If we don't have Gestalt, then we can't have any System 7 features	*)			BEGIN				gSystem.hasAppleEvents := FALSE;				gSystem.hasAliasMgr := FALSE;				gSystem.hasEditionMgr := FALSE;				gSystem.hasFolderMgr := FALSE;				gSystem.hasHelpMgr := FALSE;				IF (gSystem.hasScriptMgr) THEN					gSystem.scriptsInstalled := GetEnvirons(smEnabled);			END;	END;{************************************************}{*	 We follow this strategy to deal with servers and locked volumes:	  	    *}{*		1) Try to save into the temp folder on the default disk	(sys 7)			*}{* 	2) Try to save in the System folder													*}{*		3) Try to save in the same folder as the application							*}{* 	4) Ask the user																					*}{* 	5) If all the above fail, quit with message to user								*}{*    6) If there is a fossil history file already, delete it							*}{************************************************}PROCEDURE CreateHistoryFile;	CONST		No = 2;		{Button number in alert}	VAR		err, ignore: OSErr;		foundVRefNum: Integer;										{vRefNum and dirID of temp folder}		foundDirID, procID: LongInt;		answer: Integer;												{Alert button pressed}		reply: SFReply;		errString, errCode: Str255;								{String for alerts}		where: Point;													{For positioning SFPutFile dialog}	PROCEDURE GetAFolder (VAR volRefNum: Integer; VAR dirID: LongInt; fName: Str255);{If we have System 7 available we can ask user for a folder if there is trouble. Under System 6}{we use SFGetFile in the main CreateHistoryFile proc to ask to save the file (maybe this stuff}{can be converted to system 6?)}		VAR			mySFReply: StandardFileReply;			myFSSpec: FSSpec;		BEGIN			where.h := -1;							{Get the system to position the box}			where.v := -1;			StandardGetFolder(where, 'Save temp file to:', mySFReply);			IF NOT mySFReply.sfGood THEN	{User cancelled}				ExitToShell;			volRefNum := mySFReply.sfFile.vRefNum;			dirID := mySFReply.sfFile.parID;			err := FSMakeFSSpec(mySFReply.sfFile.vRefNum, mySFReply.sfFile.parID, fName, myFSSpec);			IF err <> noErr THEN				Exit(GetAFolder);			err := FSpCreate(myFSSpec, 'SNAW', 'FOSS', mySFReply.sfScript); {We will exit the loop if this succeeded}		END; {GetAFolder}	BEGIN		fileName := 'Fossil History';		volRefNum := defaultVolNum;		dirID := defaultDir;		err := -1;		{set it to anything but noErr to start}		IF gSystem.hasFolderMgr THEN			IF FindFolder(volRefNum, kTemporaryFolderType, kCreateFolder, foundVRefNum, foundDirID) = noErr THEN				BEGIN		{If we found the temp folder, we will try to use it. Otherwise use default folder}					volRefNum := foundVRefNum;					dirID := foundDirID;					DeleteOldFile(volRefNum, dirID, fileName);				{There may already be a file left open after a crash. }					err := HCreate(volRefNum, dirID, fileName, 'SNAW', 'FOSS');				END;		IF err <> noErr THEN			BEGIN						{Second try under system 7, first try under system 6}				ignore := GetWDInfo(gSystem.sysVRefNum, volRefNum, dirID, procID);				DeleteOldFile(volRefNum, dirID, fileName);				err := HCreate(volRefNum, dirID, fileName, 'SNAW', 'FOSS');			END;		IF err <> noErr THEN			BEGIN			{try the default directory}				volRefNum := defaultVolNum;				dirID := defaultDir;				DeleteOldFile(volRefNum, dirID, fileName);				err := HCreate(volRefNum, dirID, fileName, 'SNAW', 'FOSS');			END;		IF err <> noErr THEN			BEGIN	{ask the user to choose a place}				GetIndString(errString, 128, 1);				NumToString(err, errCode);				ParamText(errString, errCode, '', '');				PositionDialog('ALRT', 200);				answer := StopAlert(200, NIL);			{'Problem saving temp file, do you want to choose a folder?'}				IF answer = No THEN					ExitToShell;				IF gSystem.systemVersion >= $0700 THEN					GetAFolder(volRefNum, dirID, fileName)	{System 7 ask for folder}				ELSE					BEGIN														{System 6 normal save file dialog}						FindDlogPosition('DLOG', PutDlgID, where);{NB NOT sfPutDialogID! That is the System 7 style dialog, which doesn't exist in earlier systems}						SFPutFile(where, 'Save temp file to', fileName, NIL, reply);						WITH reply DO							BEGIN								IF NOT good THEN	{User cancelled operation}									ExitToShell;								ignore := GetWDInfo(vRefNum, volRefNum, dirID, procID);								fileName := fname;								err := HCreate(volRefNum, dirID, fileName, 'SNAW', 'FOSS');							END;{with}					END;{if not sys7}			END;{if}		IF err = noErr THEN		{Okay, we have a file, now try to open it. }			err := HOpen(volRefNum, dirID, fileName, fsRdWrPerm, slides);		IF err <> noErr THEN			BEGIN				GetIndString(errString, 128, 2);				IOError(err, errString);									{ 'Error opening temp file'}				err := HDelete(volRefNum, dirID, fileName);					{Try to clean up after ourself}				ExitToShell			END;	{if}	END;{CreateHistoryFile}PROCEDURE LoadCursors;{* Load Cursors from resources.   v1.1 renumbered cursors to allow looping. }{* We no longer lock handles, just prevent them from being purged. *}	VAR		indx: Integer;	BEGIN		FOR Indx := iBeamCursor TO watchCursor DO					{ get four standard system cursors}			BEGIN				CursList[Indx] := GetCursor(Indx); 							{ read in from system resource}				HNoPurge(Handle(CursList[Indx]));			END;		FOR indx := leftCursID TO BlankCursID DO						{Now load custom cursors}			BEGIN				CursList[indx - 130] := GetCursor(indx);				HNoPurge(Handle(CursList[indx - 130]));					{make sure they don't get purged}			END;		SetCursor(CursList[watchCursor]^^);								{ bring up watch cursor}	END;	{LoadCursors}PROCEDURE Initialize;{}{    purpose         initialize everything for the program}{NB Think Pascal sets up toolbox managers, flushes event queue, and calls MoreMasters 10x}	VAR		SizeNeeded: LONGINT;		j, i: Integer;		ToldToStop: Boolean;		errString, helpString: Str255;		aTime: Longint;	         { keeps track of time }		AlbumBounds: Rect;		ErrorCode: OSErr;		ThumbStrip: Rect;	BEGIN		FossilsToSave := FALSE;		AlbumEmpty := TRUE;		ErrorCode := HGetVol(@DefaultVolume, DefaultVolNum, DefaultDir);	{v1.1 changed to get dirID as well}		IF errorcode <> NoErr THEN			ExitToShell;		InspectSystem;							{**ADDED v1.1*}		CreateHistoryFile;					{      "                 }		Fossilizing := FALSE;    { set up window stuff }		GetWMgrPort(ScreenPort);          			{ get grafport for all windows      }		SetPort(ScreenPort);              				{ and keep hand just in case        }		Prect := ScreenBits.Bounds;		WITH PRect DO			BEGIN				Left := Left + 2;				Top := Top + 20;				Right := Right - 2;				Bottom := Bottom - 2;			END;		PlayBackRect := PRect;		PlayBackRect.Top := PRect.Top + 70;		PlayBackRect.Left := PRect.Left + 50;		PlayBackRect.Bottom := PRect.Bottom - 50;		PlayBackRect.Right := PRect.Right - 50;		MainPtr := NewWindow(@MainRec, PRect, '', TRUE, plainDbox, Pointer(-1), FALSE, 0);    { get window }		SetPort(MainPtr);                 					{ set window to current graf port   }		MainPeek := WindowPeek(MainPtr);  			{ get pointer to window record      }		MainPeek^.windowKind := PascalKind; 			{ set window type  (ID=32700)}		SelectWindow(MainPtr);           					{ and make window active            }		frontw := MainPtr;           						{ remember that it's in front       }		PlayBackPtr := NewWindow(@PlayBackRecord, PlaybackRect, 'Fossils', FALSE, DocumentProc, Pointer(-1), TRUE, 0);    { get window }		WindowPeek(PlayBackPtr)^.windowKind := PascalKind;		PlayBackRect := PlayBackPtr^.PortRect;		ThumbStrip := PlayBackPtr^.PortRect;		WITH PlayBackRect DO			BEGIN				right := right - Scrollbarwidth - 1;				bottom := bottom - Scrollbarwidth - 1;				MidPoint.h := (right - left) DIV 2;				MidPoint.v := (bottom - top) DIV 2			END;		WITH PlayBackPtr^.PortRect DO			BEGIN				ThumbStrip.left := right - (ScrollBarWidth - 1);				thumbStrip.top := top - 1;				thumbStrip.right := right + 1;				ThumbStrip.bottom := (bottom + 1) - (ScrollBarWidth - 1);			END;		LoadCursors;		{Changed v1.1}		MyControl := NewControl(PlayBackPtr, ThumbStrip, '', true, 0, 0, 0, ScrollBarProc, 0);		MakeOffScreen(MainPtr^.PortBits.Bounds, MyBitMap, burst);		IF burst THEN			BEGIN			{Not enough Memory - Added alert v1.1}				GetIndString(errString, 128, 3);				GetIndString(helpString, 128, 4);				DisplayError(-108, errString, helpString, StopError);				ExitToShell			END;		AlbumBounds := MainPtr^.PortBits.Bounds;		SizeNeeded := LONGINT(8 * PicSizeMax);		IF LongInt((Memavail - SizeNeeded)) < SafetyValve THEN			BEGIN{MemoryMessage(4405, 'in setting up space for biomorph linked list', Verdict);  v1.1 changed to below}				GetIndString(errString, 128, 5);	{** v1.1 **}				GetIndString(helpString, 128, 4);				DisplayError(-108, errString, helpString, StopError);				ExitToShell			END;		MyPic.BasePtr := NewPtr(LongInt(SizeNeeded));		IF MemError <> noErr THEN			ExitToShell;		RootGod := GodHandle(NewHandle(SizeOf(God)));		IF MemError <> noErr THEN			ExitToShell;		RootGod^^.Adam := NIL;		RootGod^^.NextGod := NIL;		RootGod^^.PreviousGod := NIL;		ThatFull := Created;		SizeOfPerson := SizeOf(Person);	{v1.1 Saves calculating it before every save to file}		ToldToStop := FALSE;		MaxPages := 4;		{v1.1 was 1, but in turbo was a constant set to 4}		j := 0;		REPEAT			MakeOffScreen(AlbumBounds, AlbumBitMap[j], burst);			IF burst THEN				BEGIN					MaxPages := j - 1;					NumToString(MaxPages, errString);					IF MaxPages >= 1 THEN						BEGIN							MemoryMessage(27291, errString, Verdict)						END					ELSE						BEGIN							GetIndString(errString, 128, 20);	{** v1.1 **}							GetIndString(helpString, 128, 4);							DisplayError(-108, errString, helpString, StopError);							ExitToShell;{MemoryMessage(4405, 'No room for Bitmap screens', Verdict)}						END				END			ELSE				j := j + 1;			ToldToStop := burst OR (j > 4)		UNTIL ToldToStop;		IF MaxPages < 1 THEN			ExitToShell;		ScreenArea := screenBits.Bounds;  { get size of screen (don't assume) }		WITH ScreenArea DO			BEGIN				SetRect(DragArea, 20, 20, Right - 5, Bottom - 10);   { set drag region       }				SetRect(GrowArea, 50, 20, Right - 5, Bottom - 10);   { set grow region       }    {MoveWindow(MainPtr,Left+1,Top+36,TRUE);}{    SizeWindow(MainPtr,Right-1,bottom-36,TRUE);}			END;  { set up menus }		MenuList[AM] := GetMenu(ApplMenu);{ read menus in from resource fork  }		MenuList[FM] := GetMenu(FileMenu);		MenuList[EM] := GetMenu(EditMenu);		MenuList[OM] := GetMenu(OperMenu);		MenuList[BM] := GetMenu(BoxMenu);		MenuList[MM] := GetMenu(AnimalsMenu);		MenuList[PM] := GetMenu(PedigreeMenu);		MenuList[HM] := GetMenu(HelpMenu);		SpecialBreedMenu := GetMenu(SpecMenu);		AddResMenu(MenuList[AM], 'DRVR');  { pull in all desk accessories      }		LargeMenus;		NRows := 3;		Ncols := 5;		NBoxes := NRows * NCols;		BreedNBoxes := NBoxes;		AlbumNRows := NRows;		AlbumNCols := NCols;		BreedNRows := NRows;		BreedNCols := NCols;		FossilCounter := 0;		TheMode := Preliminary;		SetUpBoxes;		Margin := Box[MidBox];{Starting value for self-adjusting Box Number routine}		Page := 1;		BoxNo := 1;		Morph := 1;		Prect := MainPtr^.portRect;  (*SetPortBits (MainPtr^.portbits); needed here? *)		CopyBits(MainPtr^.PortBits, AlbumBitMap[Page], PRect, PRect, srcCopy, NIL);{ program-specific initialization }  {Close(Slides);}		Finished := False;                 { set program terminator to false   }		FOR j := 6 TO MutTypeNo DO			Mut[j] := FALSE;		FOR j := 1 TO 5 DO			Mut[j] := TRUE;				{** changed 1.1 **}		FOR j := 1 TO 6 DO			SetItemState(EM, j, FALSE);		TextSize(9);		TextFace([]);		Album.size := 0;		OldSpecial := 0;		Special := 0;{ShowPen;}		TheMode := Preliminary;		SetUpBoxes; {Needed only to define MidBox. Doesn't show because not breeding}		DelayedDrawing := FALSE;		OldBox := 0;		FOR j := 1 TO 4 DO			SetItemState(BM, j, TRUE);		StoreOffScreen(MainPtr^.PortRect, MyBitMap);		FOR j := 1 TO MaxPages DO			PBoxNo[j] := 0;		CurrentPage := 1;		Page := 1;		LastPutFileName := '';		LastGetFileName := '';		aTime := TickCount;		REPEAT			j := random		UNTIL Tickcount > aTime + 50;{GetDateTime(RandSeed);}		SomethingToRestore := FALSE;		Region2 := NewRgn;		DestRegion := NewRgn;		SaveRegion := NewRgn;		Rays := 1;		OldSpecialFull := NIL;		SpecialFull := NIL;		CheckItem(MenuList[PM], 4, TRUE);		CheckItem(MenuList[PM], 5, FALSE);		CheckItem(MenuList[PM], 6, FALSE);		WITH MidScreen DO			BEGIN				h := PRect.Left + (Prect.right - Prect.left) DIV 2;				v := PRect.Top + (PRect.Bottom - PRect.Top) DIV 2			END;		MyPenSize := 1;{PrDrvrOpen;}		SweepOn := FALSE;		hideInBackGround := FALSE;		{by default, we leave windows alone. Under System 6 this might make disks unaccessable}		AlbumChanged := FALSE;		Danger := FALSE;		GetIndString(AsymString, 12947, 1);		GetIndString(BilatString, 12947, 2);		GetIndString(SingleString, 12947, 3);		GetIndString(UpDnString, 12947, 4);		GetIndString(RadialString, 12947, 5);		SetItemState(EM, 5, FALSE);		Zoomed := FALSE;		OldMode := Breeding;		ClipBoarding := FALSE;		Naive := TRUE;		WarningHasBeenGiven := FALSE;		inc := 16;		pensize(PSize, PSize);		MyPat := Black;		ShellColour := LtGray;		PenPat(MyPat);		Incy := 1;{set up default triangle anchors}		Topan := snail;		Leftan := Turritella;		Rightan := bivalve;		SideView := true;		Threshold := 20;		CurrentGeneratingCurve := 0;		SetRect(GenCurveRect, 0, 0, 511, 511);		MakeOffScreen(GenCurveRect, MugShot, burst);		MakeOffScreen(GenCurveRect, MirrorShot, burst);		WITH WDetails DO			BEGIN				start := 1.2;				by := 1.5;				till := 10;			END;		WITH DDetails DO			BEGIN				start := 0;				by := 0.2;				till := 0.6;			END;		WITH TDetails DO			BEGIN				start := 0;				by := 2;				till := 8;			END;	END; { of proc Initialize }END.