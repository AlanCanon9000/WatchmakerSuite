PROGRAM Blind_Watchmaker;{< @preformatted(v1.1 Sept 1993Disabled Mutation-Gradient menu item when segmentation offCall WaitNextEvent if available, else systemTask/GetNextEventRemove Repeat/Until loop on save changes.Added QuitConfirmed function and moved savechanges check thereChanged sleep time - when drift sweep is on, small time for bg  tasks;  other modes give lots of bg time.)}USES	User_Interface, Initialize;PROCEDURE CursorAdjust;{<    purpose         change cursors depending upon location}	VAR		MousePt: Point;		j: Integer;		InBox: Boolean;		WhichThird: HorizPos;		WhichRung: VertPos;	BEGIN		IF MainPtr = frontw THEN			WITH MainPeek^ DO				BEGIN					GetMouse(MousePt);                          {  find where mouse is  }					IF PtInRect(MousePt, port.portRect) THEN     {  if over window then  }						BEGIN							IF TheMode = Breeding THEN								SetCursor(CursList[BreedCursor]^^)							ELSE IF theMode = Preliminary THEN								SetCursor(CursList[plusCursor]^^)							ELSE IF (theMode = highlighting) OR (theMode = Albuming) THEN								SetCursor(CursList[BlackCursor]^^)							ELSE IF theMode = randoming THEN								SetCursor(CursList[RandCursor]^^)							ELSE IF theMode = phyloging THEN								SetCursor(CursList[DrawOutCursor]^^)							ELSE IF (theMode = moving) THEN								SetCursor(CursList[HandCursor]^^)							ELSE IF (theMode = Detaching) THEN								SetCursor(CursList[ScissorCursor]^^)							ELSE IF (theMode = Killing) THEN								SetCursor(CursList[GunCursor]^^)							ELSE IF (theMode = Triangling) THEN								BEGIN									IF Naive THEN										BEGIN											Naive := FALSE;											SetCursor(CursList[BlankCursor]^^)										END									ELSE										SetCursor(theCursor)								END							ELSE IF (theMode = engineering) THEN								BEGIN									j := 0;									InBox := FALSE;									REPEAT										j := j + 1;										InBox := (PtInRect(MousePt, GeneBox[j]));									UNTIL (j = 16) OR Inbox;									IF InBox THEN										CASE LeftRightPos(MousePt, GeneBox[j]) OF											LeftThird: 												SetCursor(CursList[leftCursor]^^);											RightThird: 												SetCursor(CursList[rightCursor]^^);											MidThird: 												IF (j <= 9) OR (j = 11) THEN													CASE Rung(MousePt, GeneBox[j]) OF														TopRung: 															SetCursor(CursList[UpCursor]^^);														MidRung: 															SetCursor(CursList[EqCursor]^^);														BottomRung: 															SetCursor(CursList[DownCursor]^^);													END {CASE WhichRung}												ELSE													SetCursor(CursList[EqCursor]^^);										END {Cases}									ELSE										SetCursor(CursList[InjectCursor]^^);								END {engineering}							ELSE								SetCursor(CursList[crossCursor]^^){    else make a cross  }						END					ELSE						SetCursor(Arrow)                     {   else make an arrow  }				END;{IF SpecialFull<>NIL THEN MarkUp(SpecialFull);}		IF Memavail < CarefulThreshold THEN			BEGIN				IF NOT WarningHasBeenGiven THEN					MemoryMessage(27295, ' in Creating new Pedigree origin', Verdict);				WarningHasBeenGiven := TRUE			END;		IF Memavail > CarefulThreshold THEN			WarningHasBeenGiven := FALSE;	END; { of proc CursorAdjust }PROCEDURE WindowAdjust;	VAR		ActualFront, ShouldBeFront: WindowPtr;	BEGIN		ActualFront := FrontWindow;		IF theMode = PlayingBack THEN			ShouldBeFront := PlayBackPtr		ELSE IF NOT DAOn THEN			ShouldBeFront := MainPtr;		IF (NOT DAOn) AND (ShouldBeFront <> ActualFront) THEN			BEGIN				EraseRect(ActualFront^.PortRect);				SelectWindow(ShouldBeFront);				SetPort(ShouldBeFront)			END	END; {WindowAdjust}PROCEDURE DoDrift;	BEGIN		IF (TheMode = Drifting) AND (NOT SweepOn) AND (PtInRect(MLoc, PRect)) THEN			BEGIN				ObscureCursor;				DelayedDrawing := TRUE;				ZeroMargin := FALSE;				ClipRect(PRect);				Develop(Child[Special], MidScreen);				DelayedDrawing := FALSE;				ClipRect(PRect);				Snapshot(MyPic, PRect, Child[Special]);				StoreOffScreen(MainPtr^.PortRect, MyBitMap);        {IF Fossilizing THEN write(Slides,child[special]);}        {Special:=DriftOne;}				Reproduce(Child[Special], Child[Special]);        {ClipRect(Prect);}				NActiveBoxes := NactiveBoxes + 1;				IF NActiveBoxes > NBoxes THEN					NactiveBoxes := NBoxes;			END; {drifting}	END;PROCEDURE DoSweep;	BEGIN		ObscureCursor;		IF DriftOne > 0 THEN			BEGIN				PenPat(White);				PenSize(3, 3);				Framerect(Box[DriftOne])			END;		PenPat(Black);		DriftOne := DriftOne + 1;		IF DriftOne > NBoxes THEN			DriftOne := 1;		EraseRect(Box[DriftOne]);		FrameRect(Box[DriftOne]);		PenSize(1, 1);		ClipRect(Box[DriftOne]);		Child[DriftOne] := Child[Special];		Delayvelop(Child[Special], Centre[DriftOne]);		ClipRect(PRect);        {IF Fossilizing THEN write(Slides,child[special]);}		Special := DriftOne;		Reproduce(Child[Special], Child[Special]);		NActiveBoxes := NactiveBoxes + 1;		IF NActiveBoxes > NBoxes THEN			NactiveBoxes := NBoxes;	END; {sweeping}PROCEDURE MenuGreyAdjust;{< v1.1 Disable Mutation-gradiant if segmentation off.Removed spurious drawing of menu bar when oldMode does not equal theMode.Menu bar is still redrawn unnecessarily when choosing DA, though. Alun}	VAR		Br: Boolean;		j: Integer;	BEGIN{SetItemState(AM, 0, (TheMode <> Drifting) AND (TheMode <> Highlighting) AND (TheMode <> Albuming));  }									{Don't know why the apple menu is disabled -Alun}		OldMode := theMode;		SetItemState(FM, 1, (Album.Size < MaxAlbum) AND NOT albumfull); {Load to Album}		SetItemState(FM, 2, TRUE);{(theMode=Breeding) AND (NOT Fossilizing)} {Load to SlideBox}		SetItemState(FM, 3, Special > 0); {Save Biomorph}		SetItemState(FM, 4, FileSize(Slides) > 0);{Save Fossil File}		SetItemState(FM, 5, ((NOT AlbumEmpty)));{ AND (TheMode=Albuming)}                            {OR (TheMode=Moving)}		SetItemState(FM, 6, (Album.Size > 0) AND (NOT AlbumEmpty) AND (TheMode = Albuming));{Close Album}		SetItemState(EM, 6, DAon OR ((Special > 0) AND (TheMode = Albuming)));		SetItemState(EM, 4, (Special > 0));		SetItemState(MM, 2, Mut[1]);		Pastable := FALSE;		IF (TheMode = Albuming) AND (CopiedAnimal.Gene[9] > 0) THEN			BEGIN {worth checking whether looking at vacant slot}				j := 0;				REPEAT					j := j + 1;				UNTIL (Album.Place[j].Page = CurrentPage) AND (Album.Place[j].BoxNo = Special);				IF Album.member[j].Gene[9] = 0 THEN					Pastable := TRUE			END;		SetItemState(EM, 5, Pastable OR ((frontwindow <> Mainptr) AND (FrontWindow <> PlaybackPtr)));		SetItemState(EM, 7, FALSE); {-----------}     {Highlight Biomorph:-}		SetItemState(EM, 8, ((TheMode = Breeding) OR (TheMode = Highlighting)) AND (NOT DAon));     {Add to Album:-}		SetItemState(EM, 9, (((TheMode = Highlighting) OR (TheMode = Engineering) OR (TheMode = Triangling) OR (TheMode = Phyloging) OR (TheMode = Moving) OR (TheMode = Detaching) OR (TheMode = Breeding) OR (TheMode = Randoming))) AND NOT AlbumFull AND NOT DAon);     {Zoom:=}		SetItemState(EM, 10, (Album.Size > 0) AND (NOT AlbumEmpty) AND NOT DAon);		SetItemState(OM, 1, Special > 0);  {Breed}		SetItemState(OM, 2, Special > 0);  {Drift}		SetItemState(OM, 3, Special > 0);  {3 Engineering}                                    {4 Hopeful Monster}                                    {5 Zero Fossil Record}		SetItemState(OM, 6, (FossilsExist) AND (theMode = Breeding));{Replay Fossil Record}		IF FossilsExist THEN			SetItem(MenuList[OM], 5, 'Reinitialize Fossil Record')		ELSE			SetItem(MenuList[OM], 5, 'Initialize Fossil Record');		SetItemState(OM, 7, FossilsExist);		CheckItem(MenuList[OM], 7, Fossilizing); {Recording Fossils?}		Br := (TheMode = Breeding) OR (TheMode = Highlighting) OR (TheMode = Preliminary) OR (TheMode = Drifting);		SetItemState(BM, 1, Br AND (NBoxes < MaxBoxes));		SetItemState(BM, 2, Br AND (NRows >= 3));		SetItemState(BM, 3, Br AND (NBoxes < MaxBoxes));		SetItemState(BM, 4, Br AND (NCols >= 3));		SetItemState(BM, 5, theMode = Engineering);		SetItemState(BM, 6, (theMode = Engineering) AND (MyPenSize > 1));     {SetItemState(BM,9,(theMode<>Triangling));}{     SetItemState(BM,10,(theMode<>Triangling));}{     SetItemState(BM,11,(theMode<>Triangling));}		SetItemState(PM, 1, Special > 0);		SetItemState(PM, 3, (TheMode = Moving) OR (TheMode = Detaching) OR (TheMode = Phyloging) OR (TheMode = Killing));		SetItemState(PM, 4, TheMode = Phyloging);		SetItemState(PM, 5, TheMode = Phyloging);		SetItemState(PM, 6, TheMode = Phyloging);		SetItemState(PM, 8, (TheMode = Moving) OR (TheMode = Detaching) OR (TheMode = Phyloging) OR (TheMode = Killing));		SetItemState(PM, 9, (TheMode = Moving) OR (TheMode = Detaching) OR (TheMode = Phyloging) OR (TheMode = Killing));		SetItemState(PM, 10, (TheMode = Moving) OR (TheMode = Detaching) OR (TheMode = Phyloging) OR (TheMode = Killing));		SetItemState(PM, 11, FALSE);{(TheMode=Moving) OR (TheMode=Detaching) OR (TheMode=Phyloging) OR (TheMode=Killing)}		SetItemState(HM, 1, TRUE);		SetItemState(HM, 2, TRUE);	END; {MenuGreyAdjust}(******************************************************************************}{ GetAnEvent}{}{		Get the next event in the event queue. }{		Changed for v1.1 to use WaitNextEvent if it is available}{ ******************************************************************************)FUNCTION GetAnEvent (VAR macEvent: EventRecord): Boolean;	VAR		eventResult: Boolean;		sleep: LongInt;	BEGIN		IF (gSystem.hasWNE) THEN			BEGIN					(* WaitNextEvent is the preferred	 call.  It handles multitasking	*)					(*   in a friendly manner.			*)				IF (theMode = Drifting) AND SweepOn THEN					sleep := 2				ELSE					sleep := 20;				eventResult := WaitNextEvent(everyEvent, macEvent, sleep, NIL);			END		ELSE				(* WaitNextEvent is not available.	*)			BEGIN					(*  We must use the old method of calling SystemTask and GetNextEvent.*)				SystemTask;				eventResult := GetNextEvent(everyEvent, macEvent);			END;		GetAnEvent := eventResult;	END;BEGIN { main body of program}	MoreMasters;		{10 are called automatically by Think Pascal}	MoreMasters;		{needs to be called from CODE 1, not init segment}	MoreMasters;	Initialize;	BasicTree(topan);   {3 defaults if all else fails}	Insect(leftan);	Chess(rightan);	Insect(target);	BasicTree(CopiedAnimal);	CopiedAnimal.Gene[9] := 0;	Special := MidBox;	CountAppFiles(DocumentMessage, DocumentCount);	IF DocumentCount > 0 THEN {at least one biomorph double-clicked}		BEGIN			StartDocuments(DocumentCount);			IF ThisMenagerie.Size > 1 THEN				BEGIN					AlbumChanged := True;					DoLoad(FALSE);					SetUpBoxes;					Special := MidBox;					Child[special] := ThisMenagerie.Member[ThisMenagerie.Size];					DoBreed;					StoreOffScreen(MainPtr^.PortRect, MyBitMap);				END			ELSE IF ThisMenagerie.Size = 1 THEN {only one biomorph double-clicked}				BEGIN					Special := MidBox;					Child[Special] := ThisMenagerie.MEMBER[1];					DoBreed;					StoreoffScreen(MainPtr^.PortRect, MyBitMap);				END;			AlbumChanged := FALSE		END {case of biomorph double-clicked, as opposed to BW icon itself}	ELSE {case of BW icon itself double-clicked}		BEGIN			BasicTree(Child[Special]);   {WITH Child[Special] DO Gene[9]:=1;}			DoBreed;{StoreoffScreen(MainPtr^.PortRect, MyBitMap);}		END;	REPEAT                                   { keep doing the following  }{UnloadSeg(@DoShowBoxes);  }{Any procedure in FrillSegment will do}		IF ((theMode = Breeding) OR (theMode = Highlighting)) AND (frontwindow = mainptr) THEN			BEGIN				GetMouse(MLoc);				j := 0;				REPEAT					j := j + 1				UNTIL (PtInRect(Mloc, box[j])) OR (j > NBoxes);				IF (j <= NBoxes) AND (j <> OldBox) THEN					BEGIN						IF oldbox > 0 THEN							ShowChangedGene(child[j], child[oldbox]);						OldBox := j					END			END;		GetMouse(MLoc);		IF (theMode = Drifting) AND (SweepOn) AND (PtInRect(MLoc, PRect)) AND (NOT DAOn) THEN			DoSweep;		IF (TheMode = Drifting) AND (NOT SweepOn) AND (PtInRect(MLoc, PRect)) AND (NOT (DAOn)) THEN			DoDrift;		WindowAdjust;		CursorAdjust;                          { update which cursor       }		MenuGreyAdjust;		IF theMode = triangling THEN			BEGIN				GetMouse(NowMouse);				FlickerTriangle(NowMouse);			END;		IF GetAnEvent(theEvent) THEN			HandleEvent(theEvent);		IF Finished THEN			BEGIN				IF AlbumChanged THEN					DoClose;				IF FossilsToSave THEN					BEGIN						DireMessage(kFossilsID, kQuittingID, Verdict, true);						IF Verdict = 3 THEN							Finished := FALSE; {Cancel}						IF Verdict = 1 THEN							SaveSlides; {Yes}					END;			END;	UNTIL Finished;                          { until user is done        }	Cleanup                                 { clean everything up       }END. { of main progr}