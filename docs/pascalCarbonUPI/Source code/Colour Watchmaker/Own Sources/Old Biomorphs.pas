unit biomorphs;interface	uses{Palettes, }		PCommonExhibition, Common_Exhibition, Utils_Exhibition, FirstSeg;	procedure Develop (var biomorph: person; Here: point);	procedure Delayvelop (var Biomorph: Person; Here: Point);	procedure DrawAllBoxes;	procedure Evolve (MLoc: point);	procedure GeneBoxTemplate;	procedure ShowGeneBox (j: INTEGER; biomorph: person);	procedure ShowChangedGene (an1, an2: person);	procedure MakeGeneBox (biomorph: person);	procedure DoBreed;	procedure BasicTree (var genotype: person);	procedure RandomForeColour (var theBiomorph: person);	procedure RandomBackColour (var theBiomorph: person);	procedure DeliverSaltation (var theBiomorph: Person);	procedure DoSaltation;	procedure DoPaste;	procedure SendToClipBoard;	procedure Suzy;	procedure myDoEvent (loc: point);	procedure myUpdate;	procedure myOpen (theWindow: WindowPtr);	var		oldSpecial: integer;implementation	var		zeroMargin, delayedDrawing: boolean;		width: integer;	procedure develop (var biomorph: person; Here: point);		var			order, j, x, y, seg, Upextent, Downextent, wid, ht: integer;			dx, dy: array[0..7] of integer;			Running: chromosome;			OldHere, Centre: Point;			OddOne: BOOLEAN;			ExtraDistance, IncDistance: INTEGER;			DummyColour: integer;		procedure tree (x, y, lgth, dir: integer);			var				xnew, ynew, subscript: INTEGER;		begin			if dir < 0 then				dir := dir + 8;			if dir >= 8 then				dir := dir - 8;			xnew := x + lgth * dx[dir] div biomorph.tricklegene;			ynew := y + lgth * dy[dir] div biomorph.tricklegene;			with margin do				begin					if x < left then						left := x;					if (x + biomorph.thicknessGene) > right then						right := x + biomorph.thicknessGene;					if (y + biomorph.thicknessGene) > bottom then						bottom := y + biomorph.thicknessGene;					if y < top then						top := y;					if xnew < left then						left := xnew;					if xnew > right then						right := xnew;					if ynew > bottom then						bottom := ynew;					if ynew < top then						top := ynew;				end;   {IF (x<>xnew) OR (y<>ynew) THEN }			subscript := (Biomorph.gene[9] - lgth) mod 8 + 1;			PicLine(MyPic, x, y, xnew, ynew, biomorph.colorgene[subscript]);			AbortFlag := CheckAbort;			if (lgth > 1) and (not AbortFlag) then				begin					if oddone then						begin							tree(xnew, ynew, lgth - 1, dir + 1);							if lgth < order then								tree(xnew, ynew, lgth - 1, dir - 1)						end					else						begin							tree(xnew, ynew, lgth - 1, dir - 1);							if lgth < order then								tree(xnew, ynew, lgth - 1, dir + 1)						end				end		end; {tree}		procedure PlugIn (Gene: chromosome);		begin			order := gene[9];			dx[3] := gene[1];			dx[4] := gene[2];			dx[5] := gene[3];			dy[2] := gene[4];			dy[3] := gene[5];			dy[4] := gene[6];			dy[5] := gene[7];			dy[6] := gene[8];			dx[1] := -dx[3];			dy[1] := dy[3];			dx[0] := -dx[4];			dy[0] := dy[4];			dx[7] := -dx[5];			dy[7] := dy[5];			dx[2] := 0;			dx[6] := 0;		end; {PlugIn}	begin {develop}		AbortFlag := FALSE;		if zeromargin then			with margin do				begin					left := Here.h;					right := Here.h;					right := Here.h;					top := Here.v;					bottom := Here.v;				end;		Centre := Here;		PlugIn(Biomorph.gene);		ZeroPic(MyPic, Here);		with biomorph do			begin				if SegNoGene < 1 then					SegNoGene := 1;				if dGene[10] = Swell then					Extradistance := Tricklegene				else if dGene[10] = Shrink then					Extradistance := -Tricklegene				else					ExtraDistance := 0;				Running := gene;				IncDistance := 0;				for seg := 1 to SegNoGene do					begin						OddOne := odd(seg);						if seg > 1 then							begin								OldHere := Here;								Here.v := Here.v + (SegDistGene + IncDistance) div Tricklegene;								IncDistance := IncDistance + ExtraDistance;								dummycolour := 100;								PicLine(MyPic, OldHere.h, Oldhere.v, Here.h, Here.v, dummycolour);								for j := 1 to 8 do									begin										if dGene[j] = Swell then											Running[j] := Running[j] + Tricklegene;										if dGene[j] = Shrink then											Running[j] := Running[j] - Tricklegene;									end;            {IF dGene[9]=Swell THEN Running[9]:=Running[9]+1;}{            IF dGene[9]=Shrink THEN Running[9]:=Running[9]-1;}								if Running[9] < 1 then									Running[9] := 1;								PlugIn(Running)							end;						tree(Here.h, Here.v, order, 2);					end;			end;		if not AbortFlag then			with biomorph do				with margin do					begin						if Centre.h - left > right - Centre.h then							right := Centre.h + (Centre.h - left)						else							left := Centre.h - (right - Centre.h);						Upextent := Centre.v - top; {can be zero if biomorph goes down}						Downextent := bottom - Centre.v;						if ((SpokesGene = NSouth) or (SpokesGene = Radial)) or (TheMode = Engineering) then{Obscurely necessary to cope with erasing last rect in Manipulation}							begin								if UpExtent > DownExtent then									bottom := Centre.v + UpExtent								else									top := Centre.v - DownExtent							end;						if SpokesGene = Radial then							begin								wid := right - left;								ht := bottom - top;								if wid > ht then									begin										top := centre.v - wid div 2 - 1;										bottom := centre.v + wid div 2 + 1									end								else									begin										left := centre.h - ht div 2 - 1;										right := centre.h + ht div 2 + 1									end							end					end;		MyPic.PicPerson := biomorph;		if not DelayedDrawing then			DrawPic(MyPic, Centre, biomorph);	end; {develop}	procedure delayvelop (var Biomorph: Person; Here: Point);		var			margcentre, offset: INTEGER;			OffCentre: Point;	begin		DelayedDrawing := TRUE;		Zeromargin := TRUE;		develop(Biomorph, Here);		DelayedDrawing := FALSE;		with margin do			margcentre := top + (bottom - top) div 2;		offset := margcentre - Here.v;		with Margin do			begin				Top := Top - Offset;				Bottom := Bottom - Offset			end;		with OffCentre do			begin				h := Here.h;				v := Here.v - offset;			end;		DrawPic(MyPic, offcentre, Biomorph);	end; {Delayvelop}	procedure RimAdjust;		var			tickValue: LongInt;	begin		tickValue := TickCount;		repeat		until TickCount - TickValue > 2;		PenMode(PatXor);		PenPat(Black);		FrameRect(Box[special]);		PenMode(PatCopy);    {PaintRect(Box[special]);}{    PenPat(Black);}		repeat		until TickCount - TickValue > 4;	end; {RimAdjust}	procedure DrawAllBoxes;		var			J: INTEGER;	begin		for j := 1 to MidBox do{-1}			begin				ClipRect(Box[j]);				if not AbortFlag then					begin						RGBBackcolor(chooseColor(child[j].BackColorGene));						EraseRect(box[j]);						FrameRect(box[j]);						delayvelop(Child[j], Centre[j]);						BackColor(whiteColor);					end			end;		PenSize(3, 3);		Framerect(box[MidBox]);		PenSize(1, 1);		for j := MidBox + 1 to NBoxes do			begin				ClipRect(Box[j]);				if not AbortFlag then					begin						RGBBackcolor(chooseColor(child[j].BackColorGene));						EraseRect(box[j]);						FrameRect(box[j]);						delayvelop(Child[j], Centre[j]);						BackColor(whiteColor);					end			end;		ClipRect(PRect);		if theMode = Highlighting then			RimAdjust;	end; {DrawAllBoxes}	procedure evolve (MLoc: point);		var			j: INTEGER;			BoxesChanged: BOOLEAN;			SlideRect: rect;	begin		GlobalToLocal(Mloc);		j := 0;		repeat			j := j + 1		until (PtInRect(Mloc, box[j])) or (j > NBoxes);		if j <= NBoxes then			special := j		else			special := 0;		if special > 0 then			begin				ObscureCursor;				for j := 1 to NBoxes do					if j <> special then						EraseRect(box[j]);				PenPat(white);				Framerect(box[special]);				PenPat(Black);				Slide(box[special], box[MidBox]);				child[MidBox] := child[special];				SetUpBoxes(TRUE);				for j := 1 to MidBox - 1 do					begin						if j <> MidBox then							reproduce(child[MidBox], child[j]);						ClipRect(Box[j]);						if not AbortFlag then							begin								RGBBackcolor(chooseColor(child[j].BackColorGene));								EraseRect(box[j]);								FrameRect(box[j]);								delayvelop(Child[j], Centre[j]);								BackColor(whiteColor);							end					end;				PenSize(3, 3);				Framerect(box[MidBox]);				PenSize(1, 1);				for j := MidBox + 1 to NBoxes do					begin						reproduce(child[MidBox], child[j]);						ClipRect(Box[j]);						if not AbortFlag then							begin								RGBBackcolor(chooseColor(child[j].BackColorGene));								EraseRect(box[j]);								FrameRect(box[j]);								delayvelop(Child[j], Centre[j]);								BackColor(whiteColor);							end					end;			end;		ClipRect(Prect);		special := MidBox;	end; {evolve}	procedure drawint (i: integer);		procedure drawi (i: INTEGER);			var				l, r: integer;		begin			textSize(9);			if i <= 9 then				drawchar(chr(ord('0') + i))			else				begin					l := i div 10;					r := i - 10 * l;					drawi(l);					drawi(r);				end;		end; {drawi}	begin {drawint proper}		if i < 0 then			begin				drawchar('-');				i := abs(i);			end;{Drawchar('+');}		drawi(i);	end; {drawint}	procedure GeneBoxTemplate;		var			j: INTEGER;	begin		width := (Prect.right - Prect.left) div GeneCount;		with GeneBox[1] do			begin				left := box[1].left;				right := left + width + 3;				top := Prect.Top;				bottom := top + GenesHeight;				EraseRect(GeneBox[1]);				Framerect(GeneBox[1])			end;		for j := 2 to 11 do			with GeneBox[j] do				begin					top := PRect.top;					bottom := top + GenesHeight;					left := GeneBox[j - 1].right;					right := left + width + 3;					EraseRect(GeneBox[j]);					Framerect(GeneBox[j])				end;		for j := 12 to 13 do			with GeneBox[j] do				begin					top := PRect.top;					bottom := top + GenesHeight;					left := GeneBox[j - 1].right;					right := left + width + 7;					EraseRect(GeneBox[j]);					Framerect(GeneBox[j])				end;		for j := 14 to 26 do			with GeneBox[j] do				begin					top := PRect.top;					bottom := top + GenesHeight;					left := GeneBox[j - 1].right;					right := left + width - 2;					EraseRect(GeneBox[j]);					Framerect(GeneBox[j])				end;		with GeneBox[GeneCount] do			begin				top := PRect.top;				bottom := top + GenesHeight;				left := GeneBox[GeneCount - 1].right;				right := left + width - 2;				EraseRect(GeneBox[GeneCount]);				Framerect(GeneBox[GeneCount])			end;	end; {GeneBoxTemplate}	procedure ShowGeneBox (j: INTEGER; biomorph: person);		var			thestring: str255;			LittleRect: Rect;			thePort: GrafPtr;	begin		SetPort(WPtr_BreedWindow);{cure system font bug}		if (j > GeneCount) or (j < 1) then			begin				sysbeep(1);				ExitToShell;			end;		with GeneBox[j] do			begin				EraseInnerRect(GeneBox[j]);				MoveTo(left - 7 + width div 2, top + 14);				case j of					1..9: 						begin {DrawInt(biomorph.gene[j]);}							Numtostring(biomorph.gene[j], thestring);							MoveTo(left + (width - stringwidth(thestring)) div 2, top + 14);							Drawstring(thestring);							case biomorph.dGene[j] of								Shrink: 									begin										MoveTo(left + 2, top + 21);										DrawChar(chr(165))									end;								Same: 									;								Swell: 									begin										MoveTo(left + 2, top + 7);										DrawChar(chr(165))									end;							end; {dGene cases}						end; {1..9}					10: 						DrawInt(biomorph.SegNoGene);					11: 						begin							DrawInt(biomorph.SegDistGene);							case biomorph.dGene[10] of								Shrink: 									begin										MoveTo(left + 2, top + 21);										DrawChar(chr(165))									end;								Same: 									;								Swell: 									begin										MoveTo(left + 2, top + 7);										DrawChar(chr(165))									end;							end; {dGene cases}						end;					12: 						begin							MoveTo(left + 2, top + 14);							case Biomorph.CompletenessGene of								Single: 									Drawstring('Asym');								Double: 									Drawstring('Bilat')							end						end;					13: 						begin							MoveTo(left + 2, Top + 14);							case Biomorph.SpokesGene of								NorthOnly: 									DrawString('Single');								NSouth: 									DrawString('UpDn');								Radial: 									DrawString('Radial')							end						end;					14: 						DrawInt(biomorph.tricklegene);					15: 						DrawInt(biomorph.MutSizegene);					16: 						Drawint(biomorph.MutProbGene);					17..24: 						begin							with GeneBox[j] do								begin									BackColor(WhiteColor);									EraseRect(GeneBox[j]);									FrameRect(GeneBox[j]);									textsize(9);									textfont(Geneva);									MoveTo(left + 2, top + 14);									drawint(Biomorph.Colorgene[j - 16]);								end;						end;					25: 						begin							Pensize(Biomorph.ThicknessGene, Biomorph.ThicknessGene);							MoveTo(Left + 1 - Biomorph.ThicknessGene + (right - left) div 2, bottom - Biomorph.ThicknessGene);							LineTo(Left + (right - left) div 2, bottom - (bottom - top) div 2);							PenSize(1, 1);							SetRect(LittleRect, left + (right - left) div 3, top + (bottom - top) div 6, right - (right - left) div 3, top + (bottom - top) div 2);							case Biomorph.LimbShapeGene of								Stick: 									begin										MoveTo(Left + (right - left) div 2, top + (bottom - top) div 2);										LineTo(Left + 1, Top);										MoveTo(Left + (right - left) div 2, bottom - (bottom - top) div 2);										LineTo(Right - 1, Top);									end;								Oval: 									begin										PenSize(1, 1);										FrameOval(LittleRect);										if Biomorph.LimbFillGene = Filled then											FillOval(LittleRect, Black);									end;								Rectangle: 									begin										Pensize(1, 1);										FrameRect(LittleRect);										if Biomorph.LimbFillGene = Filled then											FillOval(LittleRect, Black);									end;							end; {Limb Cases}						end;					26: 						begin							with GeneBox[j] do								begin									BackColor(WhiteColor);									EraseRect(GeneBox[j]);									FrameRect(GeneBox[j]);									textsize(9);									textfont(Geneva);									MoveTo(left + 2, top + 14);									drawint(Biomorph.BackColorGene);								end;						end;				end; {Gene Cases}			end; {WITH GeneBox}	end; {ShowGeneBox}	procedure ShowChangedGene (an1, an2: person);		var			k: INTEGER;	begin		if OldBox > 0 then			begin				for k := 1 to 9 do					if (an1.gene[k] <> an2.gene[k]) or (an1.dgene[k] <> an2.dgene[k]) then						ShowGeneBox(k, an1);				for k := 17 to 24 do					if an1.ColorGene[k - 16] <> an2.ColorGene[k - 16] then						ShowGeneBox(k, an1);				if (an1.LimbShapeGene <> an2.LimbShapeGene) or (an1.LimbFillGene <> an2.LimbFillGene) or (an1.ThicknessGene <> an2.ThicknessGene) then					ShowGeneBox(25, an1);				if an1.BackColorGene <> an2.BackColorGene then					ShowGeneBox(26, an1);				if (an1.dgene[10] <> an2.dgene[10]) then					ShowGeneBox(k, an1);				if an1.SegNoGene <> an2.SegNoGene then					ShowGeneBox(10, an1);				if (an1.SegDistGene <> an2.SegDistGene) or (an1.dgene[10] <> an2.dgene[10]) then					ShowGeneBox(11, an1);				if an1.CompletenessGene <> an2.CompletenessGene then					ShowGeneBox(12, an1);				if an1.SpokesGene <> an2.SpokesGene then					ShowGeneBox(13, an1);				if an1.TrickleGene <> an2.TrickleGene then					ShowGeneBox(14, an1);				if an1.MutSizeGene <> an2.MutSizeGene then					ShowGeneBox(15, an1);				if an1.MutProbGene <> an2.MutProbGene then					ShowGeneBox(16, an1);			end	end; {ShowChangedGene}	procedure MakeGeneBox (biomorph: person);		var			j: INTEGER;	begin		GeneBoxTemplate;		for j := 1 to GeneCount do			ShowGeneBox(j, biomorph);	end; {MakeGeneBox}	procedure DoBreed;		var			p: point;			oldMode: mode;	begin		textSize(9);		oldMode := theMode;		TheMode := breeding;		OldBox := special;		EraseRect(PRect);		SetUpBoxes(TRUE);		special := MidBox;		OldSpecial := 0;{***SetCursor(CursList[watchCursor]^^);}		Child[MidBox] := child[special];		Special := MidBox;{if (oldMode <> Breeding) and (oldMode <> Preliminary) then}		MakeGeneBox(Child[special]);		RGBBackColor(chooseColor(Child[special].BackColorGene));		EraseRect(Box[MidBox]);		Delayvelop(Child[Special], Centre[MidBox]);		p := centre[MidBox];		p.v := box[MidBox].bottom - 1;		Evolve(p);		ClipRect(PRect);		ResetClock;	end; {DoBreed}	procedure makegenes (var genotype: person; a, b, c, d, e, f, g, h, i: integer);		var			j: INTEGER;	begin		with genotype do			begin				for j := 1 to 10 do					dgene[j] := same;				SegNoGene := 1;				SegDistGene := 1;				CompletenessGene := Double;				SpokesGene := NorthOnly;				TrickleGene := Trickle;				MutSizeGene := Trickle div 2;				MutProbGene := 10;				gene[1] := a;				gene[2] := b;				gene[3] := c;				gene[4] := d;				gene[5] := e;				gene[6] := f;				gene[7] := g;				gene[8] := h;				gene[9] := i;			end;	end; {makegenes}	procedure chess (var genotype: person);		var			j: INTEGER;	begin		makegenes(genotype, -trickle, 3 * trickle, -3 * trickle, -3 * trickle, trickle, -2 * trickle, 6 * trickle, -5 * trickle, 7);		with genotype do			begin				for j := 1 to 8 do					colorgene[j] := rainbow div 2;				backcolorGene := rainbow div 3;				LimbShapeGene := Stick;				LimbFillGene := Filled;				ThicknessGene := 1;			end;	end; {chess}	procedure BasicTree (var genotype: person);		var			j: INTEGER;	begin		makegenes(genotype, -trickle, -trickle, -trickle, -trickle, -trickle, 0, trickle, trickle, 6);		with GENOTYPE do			begin				for j := 1 to 8 do					for j := 1 to 8 do						colorgene[j] := rainbow div 2;				backcolorGene := rainbow div 3;				LimbShapeGene := Stick;				LimbFillGene := Filled;				ThicknessGene := 1;			end;	end; {root}	procedure insect (var genotype: person);		var			j: INTEGER;	begin		makegenes(genotype, trickle, trickle, -4 * trickle, trickle, -trickle, -2 * trickle, 8 * trickle, -4 * trickle, 6);		with genotype do			begin				for j := 1 to 8 do					for j := 1 to 8 do						colorgene[j] := rainbow div 2;				backcolorGene := rainbow div 3;				LimbShapeGene := Stick;				LimbFillGene := Filled;				ThicknessGene := 1;			end;	end; {insect}	procedure RandomForeColour (var theBiomorph: person);		var			j, k: integer;	begin		for j := 1 to 8 do			theBiomorph.ColorGene[j] := randint(Rainbow);	end; {RandomForeColour}	procedure RandomBackColour (var theBiomorph: person);		var			j: integer;	begin		theBiomorph.BackColorGene := randint(Rainbow);	end; {RandomBackColour}	procedure DeliverSaltation (var thebiomorph: person);		var			j, maxgene, r: INTEGER;			factor: -1..1;	begin		DelayedDrawing := FALSE;		special := MidBox;		with theBiomorph do {bomb 5, range check failed, here after killing top Adam}			begin				if Mut[1] then					begin						SegNoGene := randint(6);						SegDistGene := randint(20);					end				else					begin						SegNoGene := 1;						SegDistGene := 1					end;				r := randint(100);				CompletenessGene := Double;				if Mut[3] then					if r < 50 then						CompletenessGene := Single					else						CompletenessGene := Double;				r := randint(100);				if Mut[4] then					begin						if r < 33 then							SpokesGene := Radial						else if r < 66 then							SpokesGene := NSouth						else							SpokesGene := NorthOnly					end				else					SpokesGene := NorthOnly;				if Mut[5] then					begin						TrickleGene := 1 + randint(100) div 10;						if TrickleGene > 1 then							MutSizeGene := Tricklegene div 2					end;				if Mut[10] then					RandomForeColour(theBiomorph);				if Mut[8] then					LimbShapeGene := RandLimbType;				if Mut[9] then					LimbFillGene := RandLimbFill;				if Mut[11] then					RandomBackColour(theBiomorph);				if Mut[12] then					ThicknessGene := RandInt(3);				for j := 1 to 8 do					repeat						if Mut[13] then							gene[j] := MutSizeGene * (randint(19) - 10);						if Mut[2] then							dGene[j] := RandSwell(dgene[j])						else							dGene[j] := Same;						case dGene[j] of							Shrink: 								factor := 1;							Same: 								factor := 0;							Swell: 								factor := 1;						end; {Cases}						maxgene := gene[j] * SegNoGene * factor;					until (maxgene <= 9 * Tricklegene) and (maxgene >= -9 * Tricklegene);				repeat					if Mut[2] then						dGene[10] := RandSwell(dgene[10])					else						dGene[10] := Same;					case dGene[j] of						Shrink: 							factor := 1;						Same: 							factor := 0;						Swell: 							factor := 1;					end; {Cases}					maxgene := SegDistGene * SegNoGene * factor;				until (maxgene <= 100) and (maxgene >= -100);				repeat					Gene[9] := randint(6)				until Gene[9] > 1;				dGene[9] := Same;			end;		RGBBackColor(chooseColor(theBiomorph.BackColorGene));	end; {DeliverSaltation}	procedure DoSaltation;	begin		if special = 0 then			special := midbox;		DeliverSaltation(child[special]);		EraseRect(Prect);		zeroMargin := true;		Develop(child[special], centre[midBox]);		BackColor(WhiteColor);		TheMode := Randoming;		ResetClock;	end; {DoSaltation}	procedure PictureToScrap (theBiomorph: person);		type			BiPtr = ^person;		var			LENGTH: LongInt;			Source: Ptr;			BiSource: BiPtr;	begin		if ZeroScrap <> NoErr then			begin				SysBeep(1);			end		else			begin				HLock(handle(MyPicture));				Length := MyPicture^^.PicSize;				Source := Ptr(MyPicture^);				if PutScrap(Length, 'PICT', Ptr(MyPicture^)) <> NoErr then					Message('Problem with fitting Biomorph Picture in ClipBoard')				else					begin						HUnlock(handle(MyPicture));						Length := SizeOf(person);						BiSource := BiPtr(NewPtr(Length));						BiSource^ := theBiomorph;						if PutScrap(Length, 'BIOC', Ptr(BiSource)) <> NoErr then							Message('Problem with storing Biomorph Genes in ClipBoard ');					end;			end	end;	function GetFromScrap: person;		type			BiPtr = ^person;			biHdl = ^BiPtr;		var			bHdl: biHdl;			length, offset: Longint;			return: integer;	begin		bHdl := biHdl(NewHandle(0));		length := GetScrap(Handle(bHdl), 'BIOC', offset);		if length < 0 then			begin				EmptiedClip;				Message(' Nothing to Paste . You can only Paste if you have previously Copied , either from Blind Watchmaker or Scrapbook ');			end		else			begin				GetFromScrap := bHdl^^;				FilledClip;			end;	end; {GetFromScrap}	procedure DoPaste;	begin		if DeskScrap then			ClipBiomorph := GetFromScrap; {Special:=MidBox;}		if clipfull then			begin				Child[special] := ClipBiomorph;				RGBBackColor(chooseColor(child[special].BackColorGene));				if theMode = Breeding then					begin						EraseRect(Box[special]);						FrameRect(Box[special])					end				else					eraserect(Prect);				Delayvelop(child[special], centre[special]);				BackColor(WhiteColor);			end	end;	procedure SendToClipBoard;		var			HS: INTEGER;	begin		MyPicture := OpenPicture(Box[MidBox]);		RGBBackColor(ChooseColor(Child[special].BackColorGene));		EraseRect(Box[MidBox]);		Delayvelop(Child[Special], Centre[MidBox]);		CopiedAnimal := Child[special];		ClipBiomorph := Child[special];		ClosePicture;		HS := GetHandleSize(Handle(MyPicture));		if (HS = 0) or (HS > 32000) then{***Message('Biomorph too large, or otherwise impossible to send to ClipBoard')}		else			PictureToScrap(Child[special]);		KillPicture(MyPicture);		BackColor(whiteColor);		FilledClip;		DeskScrap := FALSE;	end; {SendToClipBoard}	procedure Suzy;	begin		Message('You are using the mouse incorrectly.  HOLD your finger down on, say, "Operation", then "pull" to the option you want, then let go.  Before trying again you must click OK to remove this message');	end; {suzy}	procedure myUpdate;	begin		if theMode = breeding then			begin				DrawAllBoxes;				ClipRect(ScreenBits.Bounds);				MakeGeneBox(Child[midbox]);				ClipRect(Prect);			end;		if theMode = randoming then			begin				RGBBackColor(chooseColor(child[special].backColorGene));				EraseRect(Prect);				Develop(child[special], centre[midBox]);				BackColor(WhiteColor);			end;		ResetClock;	end; {myUpdate}	procedure myOpen (theWindow: WindowPtr);	begin		Prect := theWindow^.portrect;		Prect.bottom := Prect.bottom - 20;		special := 8;		midBox := 8;		setUpBoxes(true);		doSaltation;	end; {myOpen}	procedure myDoEvent (loc: point);	begin     																{Handle U_DoEvent_}{***DEAL WITH CHOICES OF BIOMORPHS HERE}		if theMode = Breeding then			evolve(loc);		if theMode = Randoming then			begin				globalToLocal(loc);				if PtInRect(loc, margin) then					doBreed				else					DoSaltation;			end;		ResetClock;		flushevents(everyEvent, nullEvent);	end; 																	{end of Handle U_DoEvent_}end.