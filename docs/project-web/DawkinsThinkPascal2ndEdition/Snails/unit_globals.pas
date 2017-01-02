{***********************************************************}{*												v1.1 sept 1993																	*}{*																																		*}{*		Made a start at cleaning up all these globals, but still a lot to do.  I have removed a	*}{*		couple of dozen variables which were just wasting memory, and moved others to		*}{*		local variable status.  For the most part, they need to be made into parameters or		*}{*		file-scoped variables with unit initializer; this is too much work for now.					*}{**********************************************************}UNIT unit_globals;INTERFACEuses ToolUtils, Types, Quickdraw, Events, Menus, Windows, Controls, PictUtil, Memory;CONST	GenesDlogID = 129;	SafetyValve = 20;	CarefulThreshold = 8192;	trickle = 10;	MutSizestart = 10;	iconhalfsize = 128;	ScrollBarWidth = 16;	TopBoxHeight = 10;	MaxGene9 = 12;	MaxAlbum = 100;	{v1.1 was set to 15, but turbo version said 100}	MaxBoxes = 100; {v1.1 was set to 50}	StackSize = 100;	GenesHeight = 20;	PicSizeMax = 4095;	WorryMax = 4095;	TickDelay = 20;	MutTypeNo = 7;{*** Menu Constants ***}	MenuCnt = 8;	ApplMenu = 1000;	FileMenu = 1001;	LoadAlbumItem = 1;	{v1.1 added these menu item constants. Life is too hard without them}	LoadFossilsItem = 2;	SaveBiomorphItem = 3;	SaveFossilsItem = 4;	SaveAlbumItem = 5;	CloseAlbumItem = 6;	QuitItem = 7;	EditMenu = 1002;	UndoItem = 1;	CutItem = 3;	Copyitem = 4;	PasteItem = 5;	ClearItem = 6;	HighlightBiomItem = 8;	AddBiomItem = 9;	ShowAlbumItem = 10;	ImportPICTItem = 11;	OperMenu = 1004;	BreedItem = 1;	DriftItem = 2;	EngineeringItem = 3;	HopeMonsterItem = 4;	InitFossRecItem = 5;	PlayFossilItem = 6;	RecordFossilItem = 7;	TriangleItem = 8;	ArrayItem = 9;	BoxMenu = 1005;	MoreRowsItem = 1;	FewerRowsItem = 2;	MoreColumnsItem = 3;	FewerColumnsItem = 4;	SideViewItem = 5;	DriftSweepItem = 6;	TriangleTopItem = 7;	TriangleLeftItem = 8;	TriangleRightItem = 9;	ViewPedigreeItem = 10;	AnimalsMenu = 1006;	CustomiseItem = 1;	SnailItem = 2;	TurritellaItem = 3;	BivalveItem = 4;	AmmoniteItem = 5;	NautilusItem = 6;	BrachiopodItem = 7;	ConeItem = 8;	WhelkItem = 9;	ScallopItem = 10;	EloiseItem = 11;	GallaghersItem = 12;	RapaItem = 13;	LightningItem = 14;	SundialItem = 15;	FigItem = 16;	TunItem = 17;	RazorShellItem = 18;	JapaneseWonderItem = 19;	PedigreeMenu = 1007;	DisplayPedigreeItem = 1;	DrawOutItem = 3;	NoMirrorsItem = 4;	SingleMirrorItem = 5;	DoubleMirrorItem = 6;	MoveItem = 8;	DetachItem = 9;	KillItem = 10;	HelpMenu = 3238;	HelpCurrentItem = 1;	HelpMiscItem = 2;	SpecMenu = 21537;	ClosePlaybackItem = 1;	BreedCurrentItem = 2;	QuitPlaybackItem = 3;	AM = 1;    { index into MenuList for Apple Menu }	FM = 2;    { ditto for File Menu                }	EM = 3;	OM = 4;    { ditto for Operation Menu             }	BM = 5;    { ditto for Boxes Menu                }	MM = 6;    { ditto for Mutations Menu}	PM = 7;    { ditto for Pedigree Menu}	HM = 8;	{W for Window Menu}CONST	DMutsize = 0.01;	SMutSize = 0.1;	TMutSize = 0.1;	PSize = 1;	PascalKind = 32700;  {windowKind of pascal windows}	MainID = 1000;    { resource ID for MainWindow         }	AboutID = 1000;    { resource ID for dialog box         }	Text1ID = 1000;    { resource IDs for 'About...' text   }	Text2ID = 1001;	Text3ID = 1002;	Text4ID = 21950;	WarnDiscString = 22773;	SaveAlbumString = 4720;	SaveFossilString = 11609;	WarnIconString = 7852;	TooLargeString = 13603;	SaveBiomorphString = 3866;{new STR# IDs for alerts - v1.1}	kAlertStringsID = 128;	kFossilsID = 7;	kAlbumID = 8;	kBiomorphID = 9;	kQuittingID = 10;	kClosingID = 11;	kResettingID = 12;	PlusIconString = 4477;	AsString = 17474;	AlbumPageID = 5102;	ClipID = 2000;	Clip1ID = 2000;	Clip2ID = 2001;	Clip3ID = 2002;{CURSORS > made these contiguous numbers so that they can be read in a loop and checked - Alun}	leftCursID = 135;	leftCursor = 5;	rightCursID = 136;	rightCursor = 6;	UpCursId = 137;	UpCursor = 7;	DownCursID = 138;	DownCursor = 8;	EqCursID = 139;	EqCursor = 9;	InjectCursID = 140;	InjectCursor = 10;	QCursID = 141;	QCursor = 11;	BlackCursId = 142;	BlackCursor = 12;	BoxCursID = 143;	BoxCursor = 13;	RandCursID = 144;	RandCursor = 14;	BreedCursID = 145;	BreedCursor = 15;	HandCursID = 146;	HandCursor = 16;	DrawOutCursID = 147;	DrawOutCursor = 17;	ScissorCursId = 148;	ScissorCursor = 18;	GunCursID = 149;	GunCursor = 19;	LensCursID = 150;	LensCursor = 20;	BlankCursID = 151;	BlankCursor = 21;	BSize = 512;	BCount = 256;TYPE	tSystem = PACKED RECORD		{****Added for v1.1****}			hasWNE: BOOLEAN;			hasColorQD: BOOLEAN;			hasGestalt: BOOLEAN;			hasAppleEvents: BOOLEAN;			hasAliasMgr: BOOLEAN;			hasFolderMgr: BOOLEAN;			hasEditionMgr: BOOLEAN;			hasHelpMgr: BOOLEAN;			hasScriptMgr: BOOLEAN;			hasFPU: BOOLEAN;			scriptsInstalled: Integer;			systemVersion: Integer;			sysVRefNum: Integer;		END;	CursorList = ARRAY[iBeamCursor..BlankCursor] OF CursHandle;	PtrInteger = ^Integer;	PtrString = ^str255;	SwellType = (Swell, Same, Shrink);	HorizPos = (LeftThird, MidThird, RightThird);	VertPos = (TopRung, MidRung, BottomRung);	SmallNumber = -1..1;	chromosome = ARRAY[1..9] OF Integer;	Compass = (NorthSouth, EastWest);	CompletenessType = (Single, Ddouble);	SpokesType = (NorthOnly, NSouth, Radial);	person = RECORD			WOpening, DDisplacement, SShape, TTranslation: real;			Coarsegraininess, Reach, GeneratingCurve: integer;			TranslationGradient, DGradient: real;			Handedness: -1..1;		END;	MarchingOrders = RECORD			Start, By, Till: real;			Kind: (Wop, Dis, Trans);		END;	FullPtr = ^Full;	FullHandle = ^FullPtr;	Full = RECORD			genome: person;			surround: Rect;			origin, centre: Point;			parent: FullHandle;			firstborn: FullHandle;			lastborn: FullHandle;			eldersib: FullHandle;			youngersib: FullHandle;			Prec, Next: FullHandle;			Damaged{,Blackened}			: Boolean;			snapHandle: Handle;			snapBytes: Integer;			snapBounds: Rect;		END;	GodPtr = ^God;	GodHandle = ^GodPtr;	God = RECORD			Adam: FullHandle;			PreviousGod, NextGod: GodHandle;		END;	PartOfBox = (MainPart, MovePart, GoAwayPart, AnyPart);	Lin = RECORD			StartPt, EndPt: Point		END;	LinPtr = ^Lin;	LinHandle = ^LinPtr;	Pic = RECORD			BasePtr: Ptr;			MovePtr: LinPtr;			Origin: Point;			PicSize: Integer;			PicPerson: person		END;	BaseHandle = ^Ptr;	PointArray = ARRAY[1..4] OF Point;	Menagerie = RECORD			Member: ARRAY[1..MaxAlbum] OF person;			Place: ARRAY[1..MaxAlbum] OF RECORD					Page, BoxNo: Integer				END;			Size: Integer		END;	mode = (preliminary, breeding, albuming, phyloging, killing, moving, detaching, randoming, engineering, drifting, highlighting, PlayingBack, triangling, sweeping, arraying);VAR	OffCentre: point;	DontDraw, LighterFaster, SideView: Boolean;	MyPat, ShellColour: Pattern;	Finished, DotheSave, LoadingFossils, AlbumChanged, Danger, Pastable, Zoomed: Boolean;	theEvent: EventRecord;      			{ event passed from operating system }	TV, TH: Integer;	         				{ location of text }	FossilCounter: LongInt;	SizeWorry: integer;	theScale: real;  { ******** Screen stuff ************}	DragArea: Rect;							{ defines area where window can be dragged in }	GrowArea: Rect;							{ defines area to which a window's size can change }	ScreenArea: Rect;						{ defines screen dimensions }	CursList: CursorList;   					{ used to hold cursor handles }	theCursor: Cursor;  { ******** Menu stuff ***************}	MenuList: ARRAY[1..MenuCnt] OF MenuHandle;  { holds menu info }	SpecialBreedMenu: MenuHandle;  { ******** Window stuff  ***************}	MainPtr: WindowPtr;        			{ pointer to main window        }	MainRec: WindowRecord;     			{ holds data for main window    }	PlayBackPtr: WindowPtr;	PlayBackRecord: WindowRecord;	PlayBackRect: Rect;	MyControl: ControlHandle;	MainPeek: WindowPeek;       			{ pointer to MainRec            }	ScreenPort: GrafPtr;          			{ pointer to entire screen      }	frontw: WindowPtr;        				{ pointer to active window      }	AlbumBitMap: ARRAY[0..4] OF BitMap;	mybitmap, MugShot, Mirrorshot: bitmap;	OldBox, k, NumberInFile, MyPenSize, CurrentGeneratingCurve: Integer;	MLoc, MidScreen: Point;	hideInBackGround: Boolean;			{added v1.1 if TRUE hide our windows when switched out. Toggled by menu}	WDetails, DDetails, TDetails: MarchingOrders;{******** File Stuff **********}	DefaultVolume: Str255;					{name of disk we are running on}	dirID, defaultDir: LongInt;					{Folder ID for fossil file and app}	fileName: Str63;								{name of fossil file, normally 'Fossil History'}	volRefNum, DefaultVolNum, MaxPages: Integer;  {volRefNum is volume containing fossil file, DefaultVolNum contains app}	Slides: Integer;									{fileNum of fossil file}	SizeOfPerson: LongInt;						{Record size for saving to files.}	LastPutFileName, LastGetFileName: Str255;	FossilsToSave, FirstTime, ThereAreLines, SweepOn, AlbumEmpty: Boolean;	j, NRows, Ncols, NBoxes, NActiveBoxes, MidBox, special, oldspecial, width, height, AlbumNRows, AlbumNCols, BreedNRows, BreedNCols, BreedNBoxes: Integer;	RememberSpecial: integer;	margin, DamageRect, RectOfInterest: Rect;	PRect, BusinessPart, DummyRect: Rect;	child: ARRAY[1..MaxBoxes] OF person;	box: ARRAY[1..MaxBoxes] OF Rect;	centre: ARRAY[1..MaxBoxes] OF point;	TheMode, SaveMode, OldMode, RememberMode: mode;	GeneBox: ARRAY[1..16] OF Rect;	ClipBoarding, Fossilizing, naive, burst, WarningHasBeenGiven: Boolean;	Midline, CurrentPage: Integer;	DelayedDrawing, ZeroMargin, DAon, BrokenOut: Boolean;	MyPic: Pic;	ThisPic: PicHandle;	Mut: ARRAY[1..MutTypeNo] OF Boolean;	DocumentMessage, DocumentCount, Rays, Verdict: Integer;	Album, ThisMenagerie: Menagerie;	NPages, Morph, Page, BoxNo, DriftOne, GodCounter: Integer;	PBoxNo: ARRAY[1..4] OF Integer;	MyPicture: PicHandle;	StoreChild: ARRAY[1..MaxBoxes] OF Person;	SomethingToRestore, AlreadyTriangling: Boolean;	SpecialFull, OldSpecialFull, RunningFull, ThatFull: FullHandle;	FullSize: Size;	Region2, DestRegion, SaveRegion: RgnHandle;	RootGod, theGod, SaveGod, HitListHead: GodHandle;	firstBiomorph, theBiomorph, topan, leftan, rightan, copiedanimal, target: Person;	MidPoint: Point;	incy, MutProb, r1, r2, r3: real;	a, b, c, mous, LastMouse, NowMouse: Point;	AsymString, BilatString, SingleString, UpDnString, RadialString: Str255;	gSystem: tSystem;			{v1.1 A record of info on the capabilities of the current system}	inc, Threshold: integer;IMPLEMENTATIONEND.