{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××}{// UText1Pascal.p}{// ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× }unit UText1Pascal;interface{$IFC UNDEFINED THINK_Pascal}	uses		Events, Types, Quickdraw, Menus, Windows{, Sound};{$ENDC}{ ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ define and export the following constants }	const		mApple = 128;		iAbout = 1;		mFile = 129;		iNew = 1;		iOpen = 2;		iClose = 4;		iSaveAs = 6;		iQuit = 12;		mEdit = 130;		iUndo = 1;		iCut = 3;		iCopy = 4;		iPaste = 5;		iClear = 6;		iSelectAll = 7;		kMaxTELength = 32767;		kTab = $09;		kDel = $7F;		kReturn = $0D;		rWindow = 128;		rMenubar = 128;		rVScrollbar = 128;		eMenuBar = 1;		eMenu = 2;		eDocRecord = 4;		eEditRecord = 5;		eExceedChara = 6;		eNoSpaceCut = 7;		eNoSpacePaste = 8;{ ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ exported global variables }	var		gNumberOfWindows: integer;		menubarHdl: Handle;		menuHdl: MenuHandle;		ignoredWindowPtr: WindowPtr;		theErr: OSErr;{ ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ exported functions and procedures }	procedure DoInitManagers;	function DoNewDocWindow: WindowPtr;	procedure EventLoop;implementationuses{ ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ include the following Universal Interfaces }{$IFC UNDEFINED THINK_Pascal}	Fonts, TextEdit, Dialogs, QuickdrawText,  Memory, ToolUtils, OSUtils, Scrap,StandardFile, Controls, Files, Desk,{$ENDC}{ ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ include the following user-defined units }Balloons, UHelpDialogPascal, unit_docrec, unit_doerroralert, unit_doupdate, unit_dodrawdatapanel;{ ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ global variables }	var		gDone: boolean;		gInBackground: boolean;		gCursorRegion: RgnHandle;{ ÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉÉ function implementations }{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoInitManagers }	procedure DoInitManagers;	begin		MaxApplZone;		MoreMasters;		InitGraf(@thePort);		InitFonts;		InitWindows;		InitMenus;		TEInit;		InitDialogs(nil);		InitCursor;		FlushEvents(everyEvent, 0);	end;		{of procedure DoInitManagers}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoHelpMenu }	procedure DoHelpMenu (menuItem: integer);		var			helpMenuHdl: MenuHandle;			origHelpItems, numItems: integer;			ignored: OSErr;	begin		ignored := HMGetHelpMenuHandle(helpMenuHdl);		numItems := CountMItems(helpMenuHdl);		origHelpItems := numItems - 1;		if (menuItem > origHelpItems) then			DoHelp;	end;		{of procedure DoHelpMenu}	procedure SetScrollBarValue (controlHdl: ControlHandle; var linesToScroll: integer);		var			controlValue, controlMax: integer;	begin		controlValue := GetCtlValue(controlHdl);		controlMax := GetCtlMax(controlHdl);		linesToScroll := controlValue - linesToScroll;		if (linesToScroll < 0) then			linesToScroll := 0		else if (linesToScroll > controlMax) then			linesToScroll := controlMax;		SetCtlValue(controlHdl, linesToScroll);		linesToScroll := controlValue - linesToScroll;	end;		{of procedure SetScrollBarValue}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× CustomClikLoop }	function CustomClikLoop: boolean;		var			myWindowPtr: WindowPtr;			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;			oldPort: GrafPtr;			oldClip: RgnHandle;			tempRect: Rect;			mouseXY: Point;			linesToScroll: integer;	begin		myWindowPtr := FrontWindow;		docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));		editRecHdl := docRecHdl^^.editRecHdl;		GetPort(oldPort);		SetPort(myWindowPtr);		oldClip := NewRgn;		GetClip(oldClip);		SetRect(tempRect, -32767, -32767, 32767, 32767);		ClipRect(tempRect);		GetMouse(mouseXY);		if (mouseXY.v < myWindowPtr^.portRect.top) then			begin				linesToScroll := 1;				SetScrollBarValue(docRecHdl^^.vScrollbarHdl, linesToScroll);				if (linesToScroll <> 0) then					TEScroll(0, linesToScroll * (editRecHdl^^.lineHeight), editRecHdl);			end		else if (mouseXY.v > myWindowPtr^.portRect.bottom) then			begin				linesToScroll := -1;				SetScrollBarValue(docRecHdl^^.vScrollbarHdl, linesToScroll);				if (linesToScroll <> 0) then					TEScroll(0, linesToScroll * (editRecHdl^^.lineHeight), editRecHdl);			end;		DoDrawDataPanel(myWindowPtr);		SetClip(oldClip);		DisposeRgn(oldClip);		SetPort(oldPort);		CustomClikLoop := true;	end;		{of function CustomClikLoop}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoNewDocWindow }	function DoNewDocWindow: WindowPtr;		var			myWindowPtr: WindowPtr;			docRecHdl: DocRecHandle;			destAndViewRect: Rect;			familyID: integer;			ignored: integer;	begin		myWindowPtr := GetNewWindow(rWindow, nil, WindowPtr(-1));		if (myWindowPtr = nil) then			begin				DoErrorAlert(eWindow);				DoNewDocWindow := nil;			end;		SetPort(myWindowPtr);		TextSize(10);		GetFNum('Geneva', familyID);		TextFont(familyID);		docRecHdl := DocRecHandle(NewHandle(sizeof(DocRec)));		if (docRecHdl = nil) then			begin				DoErrorAlert(eDocRecord);				DoNewDocWindow := nil;			end;		SetWRefCon(myWindowPtr, longint(docRecHdl));		gNumberOfWindows := gNumberOfWindows + 1;		docRecHdl^^.vScrollbarHdl := GetNewControl(rVScrollbar, myWindowPtr);		destAndViewRect := myWindowPtr^.portRect;		destAndViewRect.right := destAndViewRect.right - 15;		destAndViewRect.bottom := destAndViewRect.bottom - 15;		InsetRect(destAndViewRect, 2, 2);		MoveHHi(Handle(docRecHdl));		HLock(Handle(docRecHdl));		docRecHdl^^.editRecHdl := TENew(destAndViewRect, destAndViewRect);		if (docRecHdl^^.editRecHdl = nil) then			begin				DisposeWindow(myWindowPtr);				gNumberOfWindows := gNumberOfWindows - 1;				DisposeHandle(Handle(docRecHdl));				DoErrorAlert(eEditRecord);				DoNewDocWindow := nil;			end;		HUnlock(Handle(docRecHdl));		SetClikLoop(ProcPtr(@CustomClikLoop), docRecHdl^^.editRecHdl);		TEAutoView(true, docRecHdl^^.editRecHdl);		ignored := TEFeatureFlag(teFOutlineHilite, 1, docRecHdl^^.editRecHdl);		DoNewDocWindow := myWindowPtr;	end;		{of function DoNewDocWindow}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoOpenFile }	procedure DoOpenFile (fileSpec: FSSpec);		var			myWindowPtr: WindowPtr;			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;			fileRefNum: integer;			textLength: longint;			textBufferHdl: Handle;			ignored: OSErr;	begin		myWindowPtr := DoNewDocWindow;		if (myWindowPtr = nil) then			Exit(DoOpenFile);		docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));		editRecHdl := docRecHdl^^.editRecHdl;		SetWTitle(myWindowPtr, fileSpec.name);		ignored := FSpOpenDF(fileSpec, fsCurPerm, fileRefNum);		ignored := SetFPos(fileRefNum, fsFromStart, 0);		ignored := GetEOF(fileRefNum, textLength);		if (textLength > 32767) then			textLength := 32767;		textBufferHdl := NewHandle(Size(textLength));		ignored := FSRead(fileRefNum, textLength, textBufferHdl^);		MoveHHi(textBufferHdl);		HLock(textBufferHdl);		TESetText(textBufferHdl^, textLength, editRecHdl);		HUnlock(textBufferHdl);		DisposeHandle(textBufferHdl);		ignored := FSClose(fileRefNum);		editRecHdl^^.selStart := 0;		editRecHdl^^.selEnd := 0;		ShowWindow(myWindowPtr);	end;		{of procedure DoOpenFile}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoOpenCommand }	procedure DoOpenCommand;		var			fileReply: StandardFileReply;			fileTypes: SFTypeList;	begin		fileTypes[0] := 'TEXT';		StandardGetFile(nil, 1, fileTypes, fileReply);		if (fileReply.sfGood) then			DoOpenFile(fileReply.sfFile);	end;		{of procedure DoInitManagers}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoSaveAsFile }	procedure DoSaveAsFile (editRecHdl: TEHandle);		var			fileReply: StandardFileReply;			myWindowPtr: WindowPtr;			fileRefNum: integer;			dataLength: longint;			editTextHdl: Handle;			ignored: OSErr;	begin		StandardPutFile('Save as:', 'Untitled', fileReply);		if (fileReply.sfGood) then			begin				myWindowPtr := FrontWindow;				SetWTitle(myWindowPtr, fileReply.sfFile.name);				if not (fileReply.sfReplacing) then					ignored := FSpCreate(fileReply.sfFile, ' KJB', 'TEXT', fileReply.sfScript);				ignored := FSpOpenDF(fileReply.sfFile, fsCurPerm, fileRefNum);				dataLength := editRecHdl^^.teLength;				editTextHdl := editRecHdl^^.hText;				ignored := FSWrite(fileRefNum, dataLength, editTextHdl^);				ignored := FSClose(fileRefNum);			end;	end;		{of procedure DoSaveAsFile}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoCloseWindow }	procedure DoCloseWindow (myWindowPtr: WindowPtr);		var			docRecHdl: DocRecHandle;	begin		docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));		DisposeControl(docRecHdl^^.vScrollbarHdl);		TEDispose(docRecHdl^^.editRecHdl);		DisposeHandle(Handle(docRecHdl));		DisposeWindow(myWindowPtr);		gNumberOfWindows := gNumberOfWindows - 1;	end;		{of procedure DoCloseWindow}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoAdjustCursor }	procedure DoAdjustCursor (myWindowPtr: WindowPtr; mouseRegion: RgnHandle);		var			oldPort: GrafPtr;			arrowRegion, iBeamRegion: RgnHandle;			cursorRect: Rect;			mouseXY: Point;	begin		if (gInBackground) then			begin				SetCursor(arrow);				Exit(DoAdjustCursor);			end;		GetPort(oldPort);		SetPort(myWindowPtr);		arrowRegion := NewRgn;		iBeamRegion := NewRgn;		SetRectRgn(arrowRegion, -32768, -32768, 32766, 32766);		cursorRect := myWindowPtr^.portRect;		cursorRect.bottom := cursorRect.bottom - 15;		cursorRect.right := cursorRect.right - 15;		LocalToGlobal(cursorRect.topLeft);		LocalToGlobal(cursorRect.botRight);		RectRgn(iBeamRegion, cursorRect);		DiffRgn(arrowRegion, iBeamRegion, arrowRegion);		GetMouse(mouseXY);		LocalToGlobal(mouseXY);		if (PtInRgn(mouseXY, iBeamRegion)) then			begin				SetCursor(GetCursor(iBeamCursor)^^);				CopyRgn(iBeamRegion, mouseRegion);			end		else			begin				SetCursor(arrow);				CopyRgn(arrowRegion, mouseRegion);			end;		DisposeRgn(arrowRegion);		DisposeRgn(iBeamRegion);		SetPort(oldPort);	end;		{of procedure DoAdjustCursor}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoAdjustScrollbar }	procedure DoAdjustScrollbar (myWindowPtr: WindowPtr);		var			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;			numberOfLines, controlMax, controlValue: integer;	begin		docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));		editRecHdl := docRecHdl^^.editRecHdl;		numberOfLines := editRecHdl^^.nLines;		if (integer(Ptr(longint(@editRecHdl^^.hText^^) + integer(editRecHdl^^.teLength) - 1)^) = kReturn) then			numberOfLines := numberOfLines + 1;		controlMax := numberOfLines - (editRecHdl^^.viewRect.bottom - editRecHdl^^.viewRect.top) div editRecHdl^^.lineHeight;		if (controlMax < 0) then			controlMax := 0;		SetCtlMax(docRecHdl^^.vScrollbarHdl, controlMax);		controlValue := (editRecHdl^^.viewRect.top - editRecHdl^^.destRect.top) div editRecHdl^^.lineHeight;		if (controlValue < 0) then			controlValue := 0		else if (controlValue > controlMax) then			controlValue := controlMax;		SetCtlValue(docRecHdl^^.vScrollbarHdl, controlValue);		TEScroll(0, (editRecHdl^^.viewRect.top - editRecHdl^^.destRect.top) - (GetCtlValue(docRecHdl^^.vScrollbarHdl) * editRecHdl^^.lineHeight), editRecHdl);	end;		{of procedure DoAdjustScrollbar}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoGetSelectLength }	function DoGetSelectLength (editRecHdl: TEHandle): integer;		var			selectionLength: integer;	begin		selectionLength := editRecHdl^^.selEnd - editRecHdl^^.selStart;		DoGetSelectLength := selectionLength;	end;		{of function DoGetSelectLength}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoEditMenu }	procedure DoEditMenu (menuItem: integer);		var			myWindowPtr: WindowPtr;			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;			totalSize, contigSize, newSize, scrapOffset: longint;			selectionLength: integer;			ignored: OSErr;	begin		myWindowPtr := FrontWindow;		docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));		editRecHdl := docRecHdl^^.editRecHdl;		case (menuItem) of			iUndo: 				begin				end;			iCut: 				begin					if (ZeroScrap = noErr) then						begin							PurgeSpace(totalSize, contigSize);							selectionLength := DoGetSelectLength(editRecHdl);							if (selectionLength > contigSize) then								DoErrorAlert(eNoSpaceCut)							else								begin									TECut(editRecHdl);									DoAdjustScrollbar(myWindowPtr);									if (TEToScrap <> noErr) then										ignored := ZeroScrap;								end;						end;				end;			iCopy: 				begin					if (ZeroScrap = noErr) then						begin							TECopy(editRecHdl);							if (TEToScrap <> noErr) then								ignored := ZeroScrap;						end;				end;			iPaste: 				begin					newSize := editRecHdl^^.teLength + GetScrap(nil, 'TEXT', scrapOffset);					if (newSize > kMaxTELength) then						DoErrorAlert(eNoSpacePaste)					else						begin							if (TEFromScrap = noErr) then								begin									TEPaste(editRecHdl);									DoAdjustScrollbar(myWindowPtr);								end;						end;				end;			iClear: 				begin					TEDelete(editRecHdl);					DoAdjustScrollbar(myWindowPtr);				end;			iSelectAll: 				begin					TESetSelect(0, editRecHdl^^.teLength, editRecHdl);				end;		end;			{of case statement}		DoDrawDataPanel(myWindowPtr);	end;		{of procedure DoEditMenu}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoFileMenu }	procedure DoFileMenu (menuItem: integer);		var			myWindowPtr: WindowPtr;			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;	begin		case (menuItem) of			iNew: 				begin					myWindowPtr := DoNewDocWindow;					if (myWindowPtr <> nil) then						ShowWindow(myWindowPtr);				end;			iOpen: 				begin					DoOpenCommand;				end;			iClose: 				begin					DoCloseWindow(FrontWindow);				end;			iSaveAs: 				begin					docRecHdl := DocRecHandle ( GetWRefCon ( FrontWindow ) );					editRecHdl := docRecHdl^^.editRecHdl;					DoSaveAsFile(editRecHdl);				end;			iQuit: 				begin					gDone := true;				end;		end;			{of case statement}	end;		{of procedure DoFileMenu}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoActivateDocWindow }	procedure DoActivateDocWindow (myWindowPtr: WindowPtr; becomingActive: Boolean);		var			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;	begin		docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));		editRecHdl := docRecHdl^^.editRecHdl;		if (becomingActive) then			begin				SetPort(myWindowPtr);				editRecHdl^^.viewRect.bottom := (((editRecHdl^^.viewRect.bottom - editRecHdl^^.viewRect.top) div editRecHdl^^.lineHeight) * editRecHdl^^.lineHeight) + editRecHdl^^.viewRect.top;				editRecHdl^^.destRect.bottom := editRecHdl^^.viewRect.bottom;				TEActivate(editRecHdl);				HiliteControl(docRecHdl^^.vScrollbarHdl, 0);				DoAdjustScrollbar(myWindowPtr);			end		else			begin				TEDeactivate(editRecHdl);				HiliteControl(docRecHdl^^.vScrollbarHdl, 255);			end;	end;		{of procedure DoActivateDocWindow}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoMenuChoice }	procedure DoMenuChoice (menuChoice: longint);		var			menuID, menuItem: integer;			itemName: Str255;			daDriverRefNum: integer;	begin		menuID := HiWord(menuChoice);		menuItem := LoWord(menuChoice);		if (menuID = 0) then			Exit(DoMenuChoice);		case (menuID) of			mApple: 				begin					if (menuItem = iAbout) then						SysBeep(10)					else						begin							GetItem(GetMHandle(mApple), menuItem, itemName);							daDriverRefNum := OpenDeskAcc(itemName);						end;				end;			mFile: 				begin					DoFileMenu(menuItem);				end;			mEdit: 				begin					DoEditMenu(menuItem);				end;			kHMHelpMenuID: 				begin					if (FrontWindow <> nil) then						DoActivateDocWindow(FrontWindow, false);					DoHelpMenu(menuItem);				end;		end;			{of case statement}		HiliteMenu(0);	end;		{of procedure DoMenuChoice}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoAdjustMenus }	procedure DoAdjustMenus;		var			fileMenuHdl, editMenuHdl: MenuHandle;			myWindowPtr: WindowPtr;			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;			scrapOffset: longint;	begin		fileMenuHdl := GetMHandle(mFile);		editMenuHdl := GetMHandle(mEdit);		if (gNumberOfWindows > 0) then			begin				myWindowPtr := FrontWindow;				docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));				editRecHdl := docRecHdl^^.editRecHdl;				EnableItem(fileMenuHdl, iClose);				if (editRecHdl^^.selStart < editRecHdl^^.selEnd) then					begin						EnableItem(editMenuHdl, iCut);						EnableItem(editMenuHdl, iCopy);						EnableItem(editMenuHdl, iClear);					end				else					begin						DisableItem(editMenuHdl, iCut);						DisableItem(editMenuHdl, iCopy);						DisableItem(editMenuHdl, iClear);					end;				if (GetScrap(nil, 'TEXT', scrapOffset) > 0) then					EnableItem(editMenuHdl, iPaste)				else					DisableItem(editMenuHdl, iPaste);				if (editRecHdl^^.teLength > 0) then					begin						EnableItem(fileMenuHdl, iSaveAs);						EnableItem(editMenuHdl, iSelectAll);					end				else					begin						DisableItem(fileMenuHdl, iSaveAs);						DisableItem(editMenuHdl, iSelectAll);					end;			end		else			begin				DisableItem(fileMenuHdl, iClose);				DisableItem(fileMenuHdl, iSaveAs);				DisableItem(editMenuHdl, iClear);				DisableItem(editMenuHdl, iSelectAll);			end;		DrawMenuBar;	end;		{of procedure DoAdjustMenus}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoOpSysEvent }	procedure DoOpSysEvent (var theEvent: EventRecord);	begin		if (BAnd(BSR(theEvent.message, 24), $000000FF) = suspendResumeMessage) then			begin				if (BAnd(theEvent.message, resumeFlag) = 0) then					gInBackground := true				else					gInBackground := false;				if (gNumberOfWindows > 0) then					DoActivateDocWindow(FrontWindow, not gInBackground);				HiliteMenu(0);			end;	end;		{of procedure DoOpSysEvent}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoActivate }	procedure DoActivate (var theEvent: EventRecord);		var			myWindowPtr: WindowPtr;			becomingActive: boolean;	begin		myWindowPtr := WindowPtr(theEvent.message);		if (BAnd(theEvent.modifiers, activeFlag) = activeFlag) then			becomingActive := true		else			becomingActive := false;		DoActivateDocWindow(myWindowPtr, becomingActive);	end;		{of procedure DoActivate}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× ScrollActionProc }	procedure ScrollActionProc (controlHdl: ControlHandle; partCode: integer);		var			myWindowPtr: WindowPtr;			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;			linesToScroll: integer;			controlValue, controlMax: integer;	begin		if (partCode <> 0) then			begin				myWindowPtr := controlHdl^^.contrlOwner;				docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));				editRecHdl := docRecHdl^^.editRecHdl;				case (partCode) of					inUpButton, inDownButton:						begin							linesToScroll := 1;						end;					inPageUp, inPageDown:						begin							linesToScroll := ((editRecHdl^^.viewRect.bottom - editRecHdl^^.viewRect.top) div editRecHdl^^.lineHeight) - 1;						end;				end;				{of case statement}				if ((partCode = inDownButton) or (partCode = inPageDown)) then					linesToScroll := -linesToScroll;				controlValue := GetCtlValue(controlHdl);				controlMax := GetCtlMax(controlHdl);				linesToScroll := controlValue - linesToScroll;				if (linesToScroll < 0) then					linesToScroll := 0				else if (linesToScroll > controlMax) then					linesToScroll := controlMax;				SetCtlValue(controlHdl, linesToScroll);				linesToScroll := controlValue - linesToScroll;				if (linesToScroll <> 0) then					TEScroll(0, linesToScroll * editRecHdl^^.lineHeight, editRecHdl);				DoDrawDataPanel(myWindowPtr);			end;	end;		{of procedure ScrollActionProc}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoInContent }	procedure DoInContent (var theEvent: EventRecord);		var			myWindowPtr: WindowPtr;			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;			mouseXY: Point;			controlHdl: ControlHandle;			partCode, controlValue: integer;			shiftKeyPosition: boolean;			ignored: OSErr;	begin		shiftKeyPosition := false;		myWindowPtr := FrontWindow;		docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));		editRecHdl := docRecHdl^^.editRecHdl;		mouseXY := theEvent.where;		GlobalToLocal(mouseXY);		partCode := FindControl(mouseXY, myWindowPtr, controlHdl);		if (partCode <> 0) then			begin				case (partCode) of					inUpButton, inDownButton, inPageUp, inPageDown:						begin							ignored := TrackControl(controlHdl, mouseXY, ProcPtr(@ScrollActionProc));						end;					inThumb:						begin							controlValue := GetCtlValue(controlHdl);							partCode := TrackControl(controlHdl, mouseXY, nil);							if (partCode <> 0) then								begin									controlValue := controlValue - GetCtlValue(controlHdl);									if (controlValue <> 0) then										TEScroll(0, controlValue * editRecHdl^^.lineHeight, editRecHdl);								end;							DoDrawDataPanel(myWindowPtr);						end;				end;				{of case statement}			end		else if (PtInRect(mouseXY, editRecHdl^^.viewRect)) then			begin				if (BAnd(theEvent.modifiers, shiftKey) <> 0) then					shiftKeyPosition := true;				TEClick(mouseXY, shiftKeyPosition, editRecHdl);			end;	end;		{of procedure DoInContent}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoMouseDown }	procedure DoMouseDown (var theEvent: EventRecord);		var			myWindowPtr: WindowPtr;			partCode: integer;	begin		partCode := FindWindow(theEvent.where, myWindowPtr);		case (partCode) of			inMenuBar: 				begin					DoAdjustMenus;					DoMenuChoice(MenuSelect(theEvent.where));				end;			inSysWindow: 				begin					SystemClick(theEvent, myWindowPtr);				end;			inContent: 				begin					if (myWindowPtr <> FrontWindow) then						SelectWindow(myWindowPtr)					else						DoInContent(theEvent);				end;			inDrag: 				begin					DragWindow(myWindowPtr, theEvent.where, screenBits.bounds);				end;			inGoAway: 				begin					if (TrackGoAway(myWindowPtr, theEvent.where)) then						DoCloseWindow(FrontWindow);				end;		end;			{of case statement}	end;		{of procedure DoMouseDown}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoKeyEvent }	procedure DoKeyEvent (charCode: char);		var			myWindowPtr: WindowPtr;			docRecHdl: DocRecHandle;			editRecHdl: TEHandle;			selectionLength: integer;	begin		myWindowPtr := FrontWindow;		docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));		editRecHdl := docRecHdl^^.editRecHdl;		if (charCode = char(kTab)) then			begin		{ Do tab key handling here if required. }			end		else if (charCode = char(kDel)) then			begin				selectionLength := DoGetSelectLength(editRecHdl);				if (selectionLength = 0) then					editRecHdl^^.selEnd := editRecHdl^^.selEnd + 1;				TEDelete(editRecHdl);				DoAdjustScrollbar(myWindowPtr);			end		else			begin				selectionLength := DoGetSelectLength(editRecHdl);				if ((editRecHdl^^.teLength - selectionLength + 1) < kMaxTELength) then					begin						TEKey(charCode, editRecHdl);						DoAdjustScrollbar(myWindowPtr);					end				else					DoErrorAlert(eExceedChara);			end;		DoDrawDataPanel(myWindowPtr);	end;		{of procedure DoKeyEvent}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoIdle }	procedure DoIdle;		var			docRecHdl: DocRecHandle;			myWindowPtr: WindowPtr;	begin		myWindowPtr := FrontWindow;		docRecHdl := DocRecHandle(GetWRefCon(myWindowPtr));		if (docRecHdl <> nil) then			TEIdle(docRecHdl^^.editRecHdl);	end;		{of procedure DoIdle}{ ××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× DoEvents }	procedure DoEvents (var theEvent: EventRecord);		var			charCode: char;	begin		case (theEvent.what) of			mouseDown: 				begin					DoMouseDown(theEvent);				end;			keyDown, autoKey: 				begin					charCode := chr(BAnd(theEvent.message, charCodeMask));					if (BAnd(theEvent.modifiers, cmdKey) <> 0) then						begin							DoAdjustMenus;							DoMenuChoice(MenuKey(charCode));						end					else						DoKeyEvent(charCode);				end;			updateEvt: 				begin					DoUpdate(theEvent);				end;			activateEvt: 				begin					DoActivate(theEvent);				end;			osEvt: 				begin					DoOpSysEvent(theEvent);				end;		end;			{of case statement}	end;		{of procedure DoEvents}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× EventLoop }	procedure EventLoop;		var			theEvent: EventRecord;			gotEvent: boolean;			sleepTime: longint;	begin		gDone := false;		gCursorRegion := NewRgn;		sleepTime := GetCaretTime;		while not (gDone) do			begin				gotEvent := WaitNextEvent(everyEvent, theEvent, sleepTime, gCursorRegion);				if ((not gInBackground) and (gNumberOfWindows > 0)) then					DoAdjustCursor(FrontWindow, gCursorRegion);				if (gotEvent) then					DoEvents(theEvent)				else					begin						if (gNumberOfWindows > 0) then							DoIdle;					end;			end;	end;		{of procedure EventLoop}end.	{of unit UText1Pascal}{ ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× }