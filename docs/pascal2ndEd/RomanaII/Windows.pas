{Created: Sunday, July 28, 1991 at 12:25 AM Windows.p Pascal Interface to the Macintosh Libraries  Copyright Apple Computer, Inc. 1985-1992  All rights reserved.	Change History (most recent first):		 <8>	 7/28/92	DCL		Moving applicationFloatKind & systemFloatKind constants out of									the public eye and into the private Layers header file. At the									request of TechPubs, and with assistance from Dean, Greg and									Kenny.		 <7>	 7/13/92	DCL		Changed prototype of DragGrayRgn boundsRect to limitRect to									match Inside Mac. (as requested by NIIM writers)		 <6>	 6/26/92	DCL		<KST>: Adding to new Window kinds for floating windows. ...and									Miner Formatting Changes. Digging deep for things to do.		 <5>	 7/31/91	JL		Updated Copyright.		 <4>	 1/27/91	LN		Checked in Database generate file from DSG. Removed some Inside									Mac comments.		 <3>	10/18/90	VL		(jsm) Added new variant for movable modal dialog (5).	To Do:} UNIT Windows; INTERFACE USES Types, Quickdraw, Events, Controls;CONSTdocumentProc = 0;dBoxProc = 1;plainDBox = 2;altDBoxProc = 3;noGrowDocProc = 4;movableDBoxProc = 5;zoomDocProc = 8;zoomNoGrow = 12;rDocProc = 16;dialogKind = 2;userKind = 8;{FindWindow Result Codes}inDesk = 0;inMenuBar = 1;inSysWindow = 2;inContent = 3;inDrag = 4;inGrow = 5;inGoAway = 6;inZoomIn = 7;inZoomOut = 8;{window messages}wDraw = 0;wHit = 1;wCalcRgns = 2;wNew = 3;wDispose = 4;wGrow = 5;wDrawGIcon = 6;{defProc hit test codes}wNoHit = 0;wInContent = 1;wInDrag = 2;wInGrow = 3;wInGoAway = 4;wInZoomIn = 5;wInZoomOut = 6;deskPatID = 16;{Window Part Identifiers which correlate color table entries with window elements}wContentColor = 0;wFrameColor = 1;wTextColor = 2;wHiliteColor = 3;wTitleBarColor = 4;TYPEWindowPeek = ^WindowRecord;WindowRecord = RECORD port: GrafPort; windowKind: INTEGER; visible: BOOLEAN; hilited: BOOLEAN; goAwayFlag: BOOLEAN; spareFlag: BOOLEAN; strucRgn: RgnHandle; contRgn: RgnHandle; updateRgn: RgnHandle; windowDefProc: Handle; dataHandle: Handle; titleHandle: StringHandle; titleWidth: INTEGER; controlList: ControlHandle; nextWindow: WindowPeek; windowPic: PicHandle; refCon: LONGINT; END;CWindowPeek = ^CWindowRecord;CWindowRecord = RECORD port: CGrafPort; windowKind: INTEGER; visible: BOOLEAN; hilited: BOOLEAN; goAwayFlag: BOOLEAN; spareFlag: BOOLEAN; strucRgn: RgnHandle; contRgn: RgnHandle; updateRgn: RgnHandle; windowDefProc: Handle; dataHandle: Handle; titleHandle: StringHandle; titleWidth: INTEGER; controlList: ControlHandle; nextWindow: CWindowPeek; windowPic: PicHandle; refCon: LONGINT; END;WStateDataPtr = ^WStateData;WStateDataHandle = ^WStateDataPtr;WStateData = RECORD userState: Rect;			{user state} stdState: Rect;			{standard state} END;AuxWinPtr = ^AuxWinRec;AuxWinHandle = ^AuxWinPtr;AuxWinRec = RECORD awNext: AuxWinHandle;		{handle to next AuxWinRec} awOwner: WindowPtr;		{ptr to window } awCTable: CTabHandle;		{color table for this window} dialogCItem: Handle;		{handle to dialog manager structures} awFlags: LONGINT;			{reserved for expansion} awReserved: CTabHandle;	{reserved for expansion} awRefCon: LONGINT;			{user Constant} END;WCTabPtr = ^WinCTab;WCTabHandle = ^WCTabPtr;WinCTab = RECORD wCSeed: LONGINT;			{reserved} wCReserved: INTEGER;		{reserved} ctSize: INTEGER;			{usually 4 for windows} ctTable: ARRAY [0..4] OF ColorSpec; END;PROCEDURE InitWindows;PROCEDURE GetWMgrPort(VAR wPort: GrafPtr);FUNCTION NewWindow(wStorage: Ptr;boundsRect: Rect;title: Str255;visible:  BOOLEAN; theProc: INTEGER;behind: WindowPtr;  goAwayFlag: BOOLEAN;refCon: LONGINT): WindowPtr;FUNCTION GetNewWindow(windowID: INTEGER;wStorage: Ptr;behind: WindowPtr): WindowPtr;PROCEDURE CloseWindow(theWindow: WindowPtr);PROCEDURE DisposeWindow(theWindow: WindowPtr);PROCEDURE GetWTitle(theWindow: WindowPtr;VAR title: Str255);PROCEDURE SelectWindow(theWindow: WindowPtr);PROCEDURE HideWindow(theWindow: WindowPtr);PROCEDURE ShowWindow(theWindow: WindowPtr);PROCEDURE ShowHide(theWindow: WindowPtr;showFlag: BOOLEAN);PROCEDURE HiliteWindow(theWindow: WindowPtr;fHilite: BOOLEAN);PROCEDURE BringToFront(theWindow: WindowPtr);PROCEDURE SendBehind(theWindow: WindowPtr;behindWindow: WindowPtr);FUNCTION FrontWindow: WindowPtr;PROCEDURE DrawGrowIcon(theWindow: WindowPtr);PROCEDURE MoveWindow(theWindow: WindowPtr;hGlobal: INTEGER;vGlobal: INTEGER; front: BOOLEAN);PROCEDURE SizeWindow(theWindow: WindowPtr;w: INTEGER;h: INTEGER;fUpdate: BOOLEAN);PROCEDURE ZoomWindow(theWindow: WindowPtr;partCode: INTEGER;front: BOOLEAN);PROCEDURE InvalRect(badRect: Rect);PROCEDURE InvalRgn(badRgn: RgnHandle);PROCEDURE ValidRect(goodRect: Rect);PROCEDURE ValidRgn(goodRgn: RgnHandle);PROCEDURE BeginUpdate(theWindow: WindowPtr);PROCEDURE EndUpdate(theWindow: WindowPtr);PROCEDURE SetWRefCon(theWindow: WindowPtr;data: LONGINT);FUNCTION GetWRefCon(theWindow: WindowPtr): LONGINT;PROCEDURE SetWindowPic(theWindow: WindowPtr;pic: PicHandle);FUNCTION GetWindowPic(theWindow: WindowPtr): PicHandle;FUNCTION CheckUpdate(VAR theEvent: EventRecord): BOOLEAN;PROCEDURE ClipAbove(window: WindowPeek);PROCEDURE SaveOld(window: WindowPeek);PROCEDURE DrawNew(window: WindowPeek;update: BOOLEAN);PROCEDURE PaintOne(window: WindowPeek;clobberedRgn: RgnHandle);PROCEDURE PaintBehind(startWindow: WindowPeek;clobberedRgn: RgnHandle);PROCEDURE CalcVis(window: WindowPeek);PROCEDURE CalcVisBehind(startWindow: WindowPeek;clobberedRgn: RgnHandle);FUNCTION GrowWindow(theWindow: WindowPtr;startPt: Point;bBox: Rect): LONGINT;FUNCTION FindWindow(thePoint: Point;VAR theWindow: WindowPtr): INTEGER;FUNCTION PinRect(theRect: Rect;thePt: Point): LONGINT;FUNCTION DragGrayRgn(theRgn: RgnHandle;startPt: Point;limitRect: Rect; slopRect: Rect;axis: INTEGER;actionProc: ProcPtr): LONGINT;FUNCTION TrackBox(theWindow: WindowPtr;thePt: Point;partCode: INTEGER): BOOLEAN;PROCEDURE GetCWMgrPort(VAR wMgrCPort: CGrafPtr);PROCEDURE SetWinColor(theWindow: WindowPtr;newColorTable: WCTabHandle);FUNCTION GetAuxWin(theWindow: WindowPtr;VAR awHndl: AuxWinHandle): BOOLEAN;PROCEDURE SetDeskCPat(deskPixPat: PixPatHandle);FUNCTION NewCWindow(wStorage: Ptr;boundsRect: Rect;title: Str255;visible: BOOLEAN; procID: INTEGER;behind: WindowPtr;goAwayFlag: BOOLEAN;refCon: LONGINT): WindowPtr;FUNCTION GetNewCWindow(windowID: INTEGER;wStorage: Ptr;behind: WindowPtr): WindowPtr;FUNCTION GetWVariant(theWindow: WindowPtr): INTEGER;FUNCTION GetGrayRgn: RgnHandle;PROCEDURE SetWTitle(theWindow: WindowPtr;title: Str255);FUNCTION TrackGoAway(theWindow: WindowPtr;thePt: Point): BOOLEAN;PROCEDURE DragWindow(theWindow: WindowPtr;startPt: Point;boundsRect: Rect);IMPLEMENTATIONPROCEDURE InitWindows; BEGIN END;PROCEDURE GetWMgrPort(VAR wPort: GrafPtr); BEGIN END;FUNCTION NewWindow(wStorage: Ptr;boundsRect: Rect;title: Str255;visible: BOOLEAN; theProc: INTEGER;behind: WindowPtr;goAwayFlag: BOOLEAN;refCon: LONGINT): WindowPtr; BEGIN NewWindow := new(WindowPtr) END;FUNCTION GetNewWindow(windowID: INTEGER;wStorage: Ptr;behind: WindowPtr): WindowPtr; BEGIN GetNewWindow := new(WindowPtr) END;PROCEDURE CloseWindow(theWindow: WindowPtr); BEGIN END;PROCEDURE DisposeWindow(theWindow: WindowPtr); BEGIN END;PROCEDURE GetWTitle(theWindow: WindowPtr;VAR title: Str255); BEGIN END;PROCEDURE SelectWindow(theWindow: WindowPtr); BEGIN END;PROCEDURE HideWindow(theWindow: WindowPtr); BEGIN END;PROCEDURE ShowWindow(theWindow: WindowPtr); BEGIN END;PROCEDURE ShowHide(theWindow: WindowPtr;showFlag: BOOLEAN); BEGIN END;PROCEDURE HiliteWindow(theWindow: WindowPtr;fHilite: BOOLEAN); BEGIN END;PROCEDURE BringToFront(theWindow: WindowPtr); BEGIN END;PROCEDURE SendBehind(theWindow: WindowPtr;behindWindow: WindowPtr); BEGIN END;FUNCTION FrontWindow: WindowPtr; BEGIN FrontWindow := new(WindowPtr) END;PROCEDURE DrawGrowIcon(theWindow: WindowPtr); BEGIN END;PROCEDURE MoveWindow(theWindow: WindowPtr;hGlobal: INTEGER;vGlobal: INTEGER; front: BOOLEAN); BEGIN END;PROCEDURE SizeWindow(theWindow: WindowPtr;w: INTEGER;h: INTEGER;fUpdate: BOOLEAN); BEGIN END;PROCEDURE ZoomWindow(theWindow: WindowPtr;partCode: INTEGER;front: BOOLEAN); BEGIN END;PROCEDURE InvalRect(badRect: Rect); BEGIN END;PROCEDURE InvalRgn(badRgn: RgnHandle); BEGIN END;PROCEDURE ValidRect(goodRect: Rect); BEGIN END;PROCEDURE ValidRgn(goodRgn: RgnHandle); BEGIN END;PROCEDURE BeginUpdate(theWindow: WindowPtr); BEGIN END;PROCEDURE EndUpdate(theWindow: WindowPtr); BEGIN END;PROCEDURE SetWRefCon(theWindow: WindowPtr;data: LONGINT); BEGIN END;FUNCTION GetWRefCon(theWindow: WindowPtr): LONGINT; BEGIN GetWRefCon := 0 END;PROCEDURE SetWindowPic(theWindow: WindowPtr;pic: PicHandle); BEGIN END;FUNCTION GetWindowPic(theWindow: WindowPtr): PicHandle; BEGIN GetWindowPic := new(PicHandle) END;FUNCTION CheckUpdate(VAR theEvent: EventRecord): BOOLEAN; BEGIN CheckUpdate := false END;PROCEDURE ClipAbove(window: WindowPeek); BEGIN END;PROCEDURE SaveOld(window: WindowPeek); BEGIN END;PROCEDURE DrawNew(window: WindowPeek;update: BOOLEAN); BEGIN END;PROCEDURE PaintOne(window: WindowPeek;clobberedRgn: RgnHandle); BEGIN END;PROCEDURE PaintBehind(startWindow: WindowPeek;clobberedRgn: RgnHandle); BEGIN END;PROCEDURE CalcVis(window: WindowPeek); BEGIN END;PROCEDURE CalcVisBehind(startWindow: WindowPeek;clobberedRgn: RgnHandle); BEGIN END;FUNCTION GrowWindow(theWindow: WindowPtr;startPt: Point;bBox: Rect): LONGINT; BEGIN GrowWindow := 0 END;FUNCTION FindWindow(thePoint: Point;VAR theWindow: WindowPtr): INTEGER; BEGIN FindWindow := 0 END;FUNCTION PinRect(theRect: Rect;thePt: Point): LONGINT; BEGIN PinRect := 0 END;FUNCTION DragGrayRgn(theRgn: RgnHandle;startPt: Point;limitRect: Rect; slopRect: Rect;axis: INTEGER;actionProc: ProcPtr): LONGINT; BEGIN DragGrayRgn := 0 END;FUNCTION TrackBox(theWindow: WindowPtr;thePt: Point;partCode: INTEGER): BOOLEAN; BEGIN TrackBox :=  false END;PROCEDURE GetCWMgrPort(VAR wMgrCPort: CGrafPtr); BEGIN END;PROCEDURE SetWinColor(theWindow: WindowPtr;newColorTable: WCTabHandle); BEGIN END;FUNCTION GetAuxWin(theWindow: WindowPtr;VAR awHndl: AuxWinHandle): BOOLEAN; BEGIN GetAuxWin := false END;PROCEDURE SetDeskCPat(deskPixPat: PixPatHandle); BEGIN END;FUNCTION NewCWindow(wStorage: Ptr;boundsRect: Rect;title: Str255;visible: BOOLEAN; procID: INTEGER;behind: WindowPtr;goAwayFlag: BOOLEAN;refCon: LONGINT): WindowPtr; BEGIN NewCWindow := new(WindowPtr) END;FUNCTION GetNewCWindow(windowID: INTEGER;wStorage: Ptr;behind: WindowPtr): WindowPtr; BEGIN GetNewCWindow := new(WindowPtr)  END;FUNCTION GetWVariant(theWindow: WindowPtr): INTEGER; BEGIN GetWVariant := 0 END;FUNCTION GetGrayRgn: RgnHandle; BEGIN GetGrayRgn :=  new(RgnHandle) END;PROCEDURE SetWTitle(theWindow: WindowPtr;title: Str255); BEGIN END;FUNCTION TrackGoAway(theWindow: WindowPtr;thePt: Point): BOOLEAN; BEGIN TrackGoAway := false END;PROCEDURE DragWindow(theWindow: WindowPtr;startPt: Point;boundsRect: Rect); BEGIN END; END.