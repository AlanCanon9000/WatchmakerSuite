{	This file has been processed by The THINK Pascal Source Converter, v1.1.	}{}{Created: Tuesday, August 2, 1988 at 9:06 AM}{	PrintTraps.p}{	Pascal Interface to the Macintosh Libraries}{}{	Copyright Apple Computer, Inc.	1985-1988}{	All rights reserved}{}unit PrintTraps;interface	const		bDraftLoop = 0;		bSpoolLoop = 1;		iPFMaxPgs = 128;						{Max number of pages in a print file.}		iPrPgFract = 120;		iPrPgFst = 1;							{Page range constants}		iPrPgMax = 9999;		iPrRelease = 2; 						{Current version number of the code.}		iPrSavPFil = -1;		iIOAbort = -27;		pPrGlobals = $00000944;		bUser1Loop = 2;		bUser2Loop = 3;		fNewRunBit = 2; 						{Bit 2 (3rd bit) in bDocLoop is new JobRun indicator.}		fHiResOK = 3;							{Bit 3 (4th bit) in bDocLoop is hi res indicator for paint.}		fWeOpenedRF = 4;						{Bit 4 (5th bit) in bDocLoop is set if driver opened the pr res file.}		iPrAbort = 128;		iPrDevCtl = 7;							{The PrDevCtl Proc's ctl number}		lPrReset = $00010000;					{The PrDevCtl Proc's CParam for reset}		lPrLineFeed = $00030000;		lPrLFStd = $0003FFFF;					{The PrDevCtl Proc's CParam for std paper advance}		lPrLFSixth = $0003FFFF;		lPrPageEnd = $00020000; 				{The PrDevCtl Proc's CParam for end page}		lPrDocOpen = $00010000; 				{note: same as lPrReset low order byte indicates number of copies to print}		lPrPageOpen = $00040000;		lPrPageClose = $00020000;				{note: same as lPrPageEnd}		lPrDocClose = $00050000;		iFMgrCtl = 8;							{The FMgr's Tail-hook Proc's ctl number}		iMscCtl = 9;							{Msc Text state / Drvr State ctl number}		iPvtCtl = 10;							{Private ctls start here}		iMemFullErr = -108;{}{Driver constants}		iPrBitsCtl = 4; 						{The Bitmap Print Proc's ctl number}		lScreenBits = 0;						{The Bitmap Print Proc's Screen Bitmap param}		lPaintBits = 1; 						{The Bitmap Print Proc's Paint [sq pix] param}		lHiScreenBits = $00000002;				{The Bitmap Print Proc's Screen Bitmap param}		lHiPaintBits = $00000003;				{The Bitmap Print Proc's Paint [sq pix] param}		iPrIOCtl = 5;							{The Raw Byte IO Proc's ctl number}		iPrEvtCtl = 6;							{The PrEvent Proc's ctl number}		lPrEvtAll = $0002FFFD;					{The PrEvent Proc's CParam for the entire screen}		lPrEvtTop = $0001FFFD;					{The PrEvent Proc's CParam for the top folder}		iPrDrvrRef = -3;		getRslDataOp = 4;						{PrGeneral Cs}		setRslOp = 5;							{PrGeneral Cs}		draftBitsOp = 6;						{PrGeneral Cs}		noDraftBitsOp = 7;						{PrGeneral Cs}		getRotnOp = 8;							{PrGeneral Cs}		NoSuchRsl = 1;							{PrGeneral Cs}		RgType1 = 1;							{PrGeneral Cs}	type		TFeed = (feedCut, feedFanfold, feedMechCut, feedOther);		TScan = (scanTB, scanBT, scanLR, scanRL);		TPPrPort = ^TPrPort;		TPrPort = record				gPort: GrafPort;					{The Printer's graf port.}				gProcs: QDProcs;					{..and its procs}				lGParam1: LONGINT;					{16 bytes for private parameter storage.}				lGParam2: LONGINT;				lGParam3: LONGINT;				lGParam4: LONGINT;				fOurPtr: BOOLEAN;					{Whether the PrPort allocation was done by us.}				fOurBits: BOOLEAN;					{Whether the BitMap allocation was done by us.}			end;{ Printing Graf Port. All printer imaging, whether spooling, banding, etc, happens "thru" a GrafPort.}{This is the "PrPeek" record.}		TPPrInfo = ^TPrInfo;		TPrInfo = record				iDev: INTEGER;						{Font mgr/QuickDraw device code}				iVRes: INTEGER; 					{Resolution of device, in device coordinates}				iHRes: INTEGER; 					{..note: V before H => compatable with Point.}				rPage: Rect;						{The page (printable) rectangle in device coordinates.}			end;{ Print Info Record: The parameters needed for page composition. }		TPPrStl = ^TPrStl;		TPrStl = record				wDev: INTEGER;						{The device (driver) number. Hi byte=RefNum, Lo byte=variant. f0 = fHiRes f1 = fPortrait, f2 = fSqPix, f3 = f2xZoom, f4 = fScroll.}				iPageV: INTEGER;					{paper size in units of 1/iPrPgFract}				iPageH: INTEGER;					{ ..note: V before H => compatable with Point.}				bPort: SignedByte;					{The IO port number. Refnum?}				feed: TFeed;						{paper feeder type.}			end;{ Printer Style: The printer configuration and usage information. }		TPPrXInfo = ^TPrXInfo;		TPrXInfo = record				iRowBytes: INTEGER;				iBandV: INTEGER;				iBandH: INTEGER;				iDevBytes: INTEGER;				iBands: INTEGER;				bPatScale: SignedByte;				bUlThick: SignedByte;				bUlOffset: SignedByte;				bUlShadow: SignedByte;				scan: TScan;				bXInfoX: SignedByte;			end;		TPPrJob = ^TPrJob;		TPrJob = record				iFstPage: INTEGER;				iLstPage: INTEGER;				iCopies: INTEGER;				bJDocLoop: SignedByte;				fFromUsr: BOOLEAN;				pIdleProc: ProcPtr;				pFileName: StringPtr;				iFileVol: INTEGER;				bFileVers: SignedByte;				bJobX: SignedByte;			end;		TPrFlag1 = packed record				f15: BOOLEAN;				f14: BOOLEAN;				f13: BOOLEAN;				f12: BOOLEAN;				f11: BOOLEAN;				f10: BOOLEAN;				f9: BOOLEAN;				f8: BOOLEAN;				f7: BOOLEAN;				f6: BOOLEAN;				f5: BOOLEAN;				f4: BOOLEAN;				f3: BOOLEAN;				f2: BOOLEAN;				fLstPgFst: BOOLEAN;				fUserScale: BOOLEAN;			end;		TPPrint = ^TPrint;		THPrint = ^TPPrint;		TPrint = record				iPrVersion: INTEGER;				prInfo: TPrInfo;				rPaper: Rect;				prStl: TPrStl;				prInfoPT: TPrInfo;				prXInfo: TPrXInfo;				prJob: TPrJob;				case INTEGER of					0: (							printX: array[1..19] of INTEGER					);					1: (							prFlag1: TPrFlag1; 			{a word of flags}							iZoomMin: INTEGER;							iZoomMax: INTEGER;							hDocName: StringHandle					);		{current doc's name, nil = front window}			end;		TPPrStatus = ^TPrStatus;		TPrStatus = record				iTotPages: INTEGER; 				{Total pages in Print File.}				iCurPage: INTEGER;					{Current page number}				iTotCopies: INTEGER;				{Total copies requested}				iCurCopy: INTEGER;					{Current copy number}				iTotBands: INTEGER; 				{Total bands per page.}				iCurBand: INTEGER;					{Current band number}				fPgDirty: BOOLEAN;					{True if current page has been written to.}				fImaging: BOOLEAN;					{Set while in band's DrawPic call.}				hPrint: THPrint;					{Handle to the active Printer record}				pPrPort: TPPrPort;					{Ptr to the active PrPort}				hPic: PicHandle;					{Handle to the active Picture}			end;{ Print Status: Print information during printing. }		TPPfPgDir = ^TPfPgDir;		THPfPgDir = ^TPPfPgDir;		TPfPgDir = record				iPages: INTEGER;				iPgPos: array[0..128] of LONGINT;	{ARRAY [0..iPfMaxPgs] OF LONGINT}			end;{ PicFile = a TPfHeader followed by n QuickDraw Pics (whose PicSize is invalid!) }		TPPrDlg = ^TPrDlg;		TPrDlg = record				Dlg: DialogRecord;					{The Dialog window}				pFltrProc: ProcPtr; 				{The Filter Proc.}				pItemProc: ProcPtr; 				{The Item evaluating proc.}				hPrintUsr: THPrint; 				{The user's print record.}				fDoIt: BOOLEAN;				fDone: BOOLEAN;				lUser1: LONGINT;					{Four longs for user's to hang global data.}				lUser2: LONGINT;					{...Plus more stuff needed by the particular printing dialog.}				lUser3: LONGINT;				lUser4: LONGINT;			end;		TGnlData = record				iOpCode: INTEGER;				iError: INTEGER;				lReserved: LONGINT; 				{more fields here depending on call}			end;		TRslRg = record				iMin: INTEGER;				iMax: INTEGER;			end;		TRslRec = record				iXRsl: INTEGER;				iYRsl: INTEGER;			end;		TGetRslBlk = record				iOpCode: INTEGER;				iError: INTEGER;				lReserved: LONGINT;				iRgType: INTEGER;				xRslRg: TRslRg;				yRslRg: TRslRg;				iRslRecCnt: INTEGER;				rgRslRec: array[1..27] of TRslRec;			end;		TSetRslBlk = record				iOpCode: INTEGER;				iError: INTEGER;				lReserved: LONGINT;				hPrint: THPrint;				iXRsl: INTEGER;				iYRsl: INTEGER;			end;		TDftBitsBlk = record				iOpCode: INTEGER;				iError: INTEGER;				lReserved: LONGINT;				hPrint: THPrint;			end;		TGetRotnBlk = record				iOpCode: INTEGER;				iError: INTEGER;				lReserved: LONGINT;				hPrint: THPrint;				fLandscape: BOOLEAN;				bXtra: SignedByte;			end;		TPRect = ^Rect; 						{ A Rect Ptr }		TPBitMap = ^BitMap; 					{ A BitMap Ptr }		TN = 0..15; 							{ a Nibble }		TPWord = ^TWord;		THWord = ^TPWord;		TWord = packed record				case INTEGER of					0: (							c1, c0: CHAR					);					1: (							b1, b0: SignedByte					);					2: (							usb1, usb0: Byte					);					3: (							n3, n2, n1, n0: TN					);					4: (							f15, f14, f13, f12, f11, f10, f9, f8, f7, f6, f5, f4, f3, f2, f1, f0: BOOLEAN					);					5: (							i0: INTEGER					);			end;		TPLong = ^TLong;		THLong = ^TPLong;		TLong = record				case INTEGER of					0: (							w1, w0: TWord					);					1: (							b1, b0: LONGINT					);					2: (							p0: Ptr					);					3: (							h0: Handle					);					4: (							pt: Point					);			end;	procedure PrPurge;	inline		$2F3C, $A800, $0000, $A8FD;	procedure PrNoPurge;	inline		$2F3C, $B000, $0000, $A8FD;	function PrDrvrDCE: Handle;	inline		$2F3C, $9400, $0000, $A8FD;	function PrDrvrVers: INTEGER;	inline		$2F3C, $9A00, $0000, $A8FD;	procedure PrOpen;	inline		$2F3C, $C800, $0000, $A8FD;	procedure PrClose;	inline		$2F3C, $D000, $0000, $A8FD;	procedure PrintDefault (hPrint: THPrint);	inline		$2F3C, $2004, $0480, $A8FD;	function PrValidate (hPrint: THPrint): BOOLEAN;	inline		$2F3C, $5204, $0498, $A8FD;	function PrStlDialog (hPrint: THPrint): BOOLEAN;	inline		$2F3C, $2A04, $0484, $A8FD;	function PrJobDialog (hPrint: THPrint): BOOLEAN;	inline		$2F3C, $3204, $0488, $A8FD;	procedure PrJobMerge (hPrintSrc: THPrint;									hPrintDst: THPrint);	inline		$2F3C, $5804, $089C, $A8FD;	function PrOpenDoc (hPrint: THPrint;									pPrPort: TPPrPort;									pIOBuf: Ptr): TPPrPort;	inline		$2F3C, $0400, $0C00, $A8FD;	procedure PrCloseDoc (pPrPort: TPPrPort);	inline		$2F3C, $0800, $0484, $A8FD;	procedure PrOpenPage (pPrPort: TPPrPort;									pPageFrame: TPRect);	inline		$2F3C, $1000, $0808, $A8FD;	procedure PrClosePage (pPrPort: TPPrPort);	inline		$2F3C, $1800, $040C, $A8FD;	procedure PrPicFile (hPrint: THPrint;									pPrPort: TPPrPort;									pIOBuf: Ptr;									pDevBuf: Ptr;									var prStatus: TPrStatus);	inline		$2F3C, $6005, $1480, $A8FD;	function PrError: INTEGER;	inline		$2F3C, $BA00, $0000, $A8FD;	procedure PrSetError (iErr: INTEGER);	inline		$2F3C, $C000, $0200, $A8FD;	procedure PrGeneral (pData: Ptr);	inline		$2F3C, $7007, $0480, $A8FD;	procedure PrDrvrOpen;	inline		$2F3C, $8000, $0000, $A8FD;	function PrDlgMain (hPrint: THPrint;									pDlgInit: ProcPtr): BOOLEAN;	inline		$2F3C, $4A04, $0894, $A8FD;	procedure PrDrvrClose;	inline		$2F3C, $8800, $0000, $A8FD;	function PrJobInit (hPrint: THPrint): TPPrDlg;	inline		$2F3C, $4404, $0410, $A8FD;	procedure PrCtlCall (iWhichCtl: INTEGER;									lParam1: LONGINT;									lParam2: LONGINT;									lParam3: LONGINT);	inline		$2F3C, $A000, $0E00, $A8FD;	function PrStlInit (hPrint: THPrint): TPPrDlg;	inline		$2F3C, $3C04, $040C, $A8FD;    { UsingPrintTraps }implementationend.