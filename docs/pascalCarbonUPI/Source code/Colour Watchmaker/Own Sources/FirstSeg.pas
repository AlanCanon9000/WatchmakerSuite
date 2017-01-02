unit FirstSeg;

interface

	uses
{Palettes,}
		Common_Exhibition, PA_Warning_Alert;

	function chooseColor (index: integer): RGBColor;
	function Rainbow: longint; {delivers the number of colours available with the present hardware;}
	function Randint (Max: Integer): Integer;
	function Odd (i: INTEGER): boolean;
	function RandSwell (Indgene: Swelltype): SwellType;
	procedure EraseInnerRect (box: rect);
	procedure FrameOuterRect (box: rect);
	procedure FrameInnerRect (box: rect);
	function RandLimbType: LimbType;
	function RandLimbFill: LimbFillType;
	procedure Reproduce (parent: person; var child: person);
	function Sgn (x: INTEGER): INTEGER;
	procedure Slide (LiveRect, DestRect: Rect);
	procedure SetUpBoxes (drawing: BOOLEAN);
	procedure PicLine (var ThisPic: Pic; x, y, xnew, ynew: Integer; color: integer);
	procedure ZeroPic (var ThisPic: Pic; Here: Point);
	procedure DrawPic (ThisPic: Pic; Place: Point; var Biomorph: person);
	function CheckAbort: BOOLEAN;
	function ThisColor (j: INTEGER): INTEGER;
	function LongintColour (IntColour: Integer): LongInt;
	function IntColour (LongintColour: Longint): Integer;
	{function ChangedColour (oldColour, Amount: integer): integer;}
	procedure Message (s: str255);


implementation

	procedure Message (s: str255);
	begin
		ParamText(s, '', '', '');
		A_PA_Warning_Alert;
	end; {Message}

	function chooseColor (index: integer): RGBColor;
	begin
		Index2Color(index, chooseColor);
	end;

	function OldPixelDepth (thisWindowPtr: WindowPtr): integer;
{Raise 2 to the power PixelDepth in order to obtain the number of colours available with the present hardware}
		var
			CPtr: CWindowPtr;
	begin
		CPtr := CWindowPtr(ThisWindowPtr);
		OldPixelDepth := CPtr^.portPixMap^^.pixelSize;
	end;

	function PixelDepth: integer;
		var
			cd: GDHandle;
			pmh: PixMapHandle;
	begin
		cd := GetMainDevice;
		pmh := cd^^.gdPMap;
		pixelDepth := pmh^^.pixelSize
	end;

	function Rainbow: longint; {delivers the number of colours available with the present hardware;}
		var
			j, n: integer;
			a: longint;
	begin
		n := PixelDepth;
		a := 1;
		if n > 0 then
			for j := 1 to n do
				a := a * 2;
		Rainbow := a;
	end;

	function randint (Max: Integer): Integer;
	begin
		randint := 1 + (abs(random) mod max);
	end; {randint}

	function Odd (i: INTEGER): boolean;
	begin
		Odd := 2 * (i div 2) <> i
	end;

	function RandSwell (Indgene: Swelltype): SwellType;
		var
			r: 1..3;
	begin
		case Indgene of
			Shrink: 
				Randswell := Same;
			Same: 
				if randint(2) = 1 then
					Randswell := Shrink
				else
					Randswell := Swell;
			Swell: 
				RandSwell := Same
		end {Cases}
	end; {RandSwell}

	procedure EraseInnerRect (box: rect);
		var
			InnerRect: Rect;
	begin
		with InnerRect do
			begin
				left := box.left + 1;
				right := box.right - 1;
				top := box.top + 1;
				bottom := box.bottom - 1
			end;
		EraseRect(InnerRect)
	end; {EraseInnerRect}

	procedure FrameOuterRect (box: rect);
		var
			OuterRect: Rect;
	begin
		with OuterRect do
			begin
				left := box.left - 1;
				right := box.right + 1;
				top := box.top - 1;
				bottom := box.bottom + 1
			end;
		FrameRect(OuterRect)
	end; {FrameOuterRect}

	procedure FrameInnerRect (box: rect);
		var
			InnerRect: Rect;
	begin
		with InnerRect do
			begin
				left := box.left + 1;
				right := box.right - 1;
				top := box.top + 1;
				bottom := box.bottom - 1
			end;
		FrameRect(InnerRect)
	end; {FrameInnerRect}


	function ThisColor (j: INTEGER): INTEGER;
		var
			k: INTEGER;
	begin
		case j of
			1: 
				k := blackColor;
			2: 
				k := redColor;
			3: 
				k := greenColor;
			4: 
				k := blueColor;
			5: 
				k := cyanColor;
			6: 
				k := magentaColor;
			7: 
				k := yellowColor;
			8: 
				k := whiteColor;
		end;
		ThisColor := k
	end;


	function RandLimbType: LimbType;
		var
			Randy: INTEGER;
	begin
		Randy := RandInt(3);
		case Randy of
			1: 
				RandLimbType := Stick;
			2: 
				RandLimbType := Oval;
			3: 
				RandLimbType := Rectangle;
		end {CASES}
	end; {RandLimbType}

	function RandLimbFill: LimbFillType;
		var
			Randy: INTEGER;
	begin
		Randy := RandInt(2);
		case Randy of
			1: 
				RandLimbFill := Open;
			2: 
				RandLimbFill := Filled;
		end {CASES}
	end; {RandLimbType}

	function LongintColour (IntColour: Integer): LongInt;
		var
			temp: Longint;
	begin
		if IntColour < 0 then
			Temp := 65536 + IntColour
		else
			Temp := IntColour;
		LongintColour := Temp;
	end; {LongintColour}

	function IntColour (LongintColour: Longint): Integer;
		var
			temp: Integer;
	begin
	{JHP: LongintColour is sometimes less that -32768, for example when the}
	{ cursor is moved into the menu bar when the application is in Triangle mode  }
		if LongintColour > 32767 then
			Temp := LongintColour - 65536
		else if LongintColour < -32768 then
			Temp := LongIntColour + 65536
		else
			Temp := LongIntColour;
		IntColour := Temp;
	end; {IntColour}

	procedure reproduce (parent: person; var child: person);

		var
			j: INTEGER;	{Loop control}

		function direction: INTEGER;
		begin
			if randint(2) = 2 then
				direction := child.MutSizegene
			else
				direction := -child.MutSizegene
		end;

		function direction9: INTEGER;
		begin
			if randint(2) = 2 then
				direction9 := 1
			else
				direction9 := -1
		end;

	begin
		child := parent;
		with child do
			begin
				if Mut[7] then
					if Randint(100) < MutProbGene then
						begin
							MutProbGene := MutProbGene + direction9;
							if MutProbGene < 1 then
								MutProbGene := 1;
							if MutProbGene > 100 then
								MutProbGene := 100;
						end;
				if Mut[13] then
					begin
						for j := 1 to 8 do
							if Randint(100) < MutProbGene then
								Gene[j] := Gene[j] + direction;
						if Randint(100) < MutProbGene then
							Gene[9] := Gene[9] + direction9;
						if Gene[9] < 1 then
							Gene[9] := 1;
						if (Gene[9] > 8) then
							Gene[9] := 8;
					end;
				if Mut[10] then
					for j := 1 to 8 do
						if Randint(100) < MutProbGene then
							begin
{IF direction9 = 1 THEN}
{ColorGene[j] := ColorGene[j] + direction9 * colorLeap}
{else}
								ColorGene[j] := ColorGene[j] + direction9;
								if (ColorGene[j] > rainbow) or (ColorGene[j] < 0) then
									ColorGene[j] := randint(Rainbow);
							end;
				if Mut[8] then
					if Randint(100) < MutProbGene then
						LimbShapeGene := RandLimbType;
				if Mut[9] then
					if Randint(100) < MutProbGene then
						LimbFillGene := RandLimbFill;
				if Mut[11] then
					if Randint(100) < MutProbGene then
						begin
{IF direction9 = 1 THEN}
{BackColorGene := BackColorGene + direction9 * colorLeap}
{else}
							BackColorGene := BackColorGene + direction9;
							if (BackColorGene > rainbow) or (BackColorGene < 0) then
								BackColorGene := randint(Rainbow);
						end;
				if Mut[12] then
					if RandInt(100) < MutProbGene then
						ThicknessGene := ThicknessGene + direction9;
				if ThicknessGene < 1 then
					ThicknessGene := 1;
				if Mut[1] then
					if RandInt(100) < MutProbGene then
						SegNoGene := SegNoGene + Direction9;
				if SegNoGene < 1 then
					SegNoGene := 1;
				if (Mut[2]) and (SegNoGene > 1) then
					begin
						for j := 1 to 8 do
							if Randint(100) < MutProbGene div 2 then
								dGene[j] := RandSwell(dgene[j]);
						if Randint(100) < MutProbGene div 2 then
							dGene[10] := RandSwell(dgene[10]);
					end;
				if (Mut[1]) and (SegNoGene > 1) then
					if Randint(100) < MutProbGene then
						SegDistGene := SegDistGene + Direction9;
				if Mut[3] then
					if Randint(100) < MutProbGene div 2 then
						if CompletenessGene = Single then
							CompletenessGene := Double
						else
							CompletenessGene := Single;
				if Mut[4] then
					if Randint(100) < MutProbGene div 2 then
						case SpokesGene of
							NorthOnly: 
								SpokesGene := NSouth;
							NSouth: 
								begin
									if Direction9 = 1 then
										SpokesGene := Radial
									else
										SpokesGene := NorthOnly
								end;
							Radial: 
								SpokesGene := NSouth
						end;
				if Mut[5] then
					if Randint(100) < MutProbGene then
						begin
							TrickleGene := Tricklegene + direction9;
							if TrickleGene < 1 then
								TrickleGene := 1
						end;
				if Mut[6] then
					if Randint(100) < MutProbGene then
						begin
							MutSizeGene := MutSizeGene + direction9;
							if MutSizeGene < 1 then
								MutSizeGene := 1
						end;
			end
	end; {reproduce}


	function sgn (x: INTEGER): INTEGER;
	begin
		if x < 0 then
			sgn := -1
		else if x > 0 then
			sgn := 1
		else
			sgn := 0
	end; {sgn}


	procedure Slide (LiveRect, DestRect: Rect);
		var
			SlideRect: RECT;
			xDiscrep, yDiscrep, dh, dv, dx, dy, xmoved, ymoved, xToMove, yToMove, distx, disty: INTEGER;
			TickValue: LONGINT;
	begin {PenMode(PatXor); FrameRect(LiveRect); PenMode(PatCopy);}
		xMoved := 0;
		yMoved := 0;
		distx := DestRect.left - LiveRect.left;
		disty := DestRect.bottom - LiveRect.bottom;
		dx := sgn(distx);
		dy := sgn(disty);
		xToMove := ABS(distx);
		yToMove := ABS(disty);
		xMoved := 0;
		yMoved := 0;
		UnionRect(LiveRect, DestRect, SlideRect);
		ObscureCursor;
		repeat
			xDiscrep := xToMove - xMoved;
			if xDiscrep <= 20 then
				dh := xDiscrep
			else
				dh := (xDiscrep) div 2; {div 2}
			yDiscrep := yToMove - yMoved;
			if Ydiscrep <= 20 then
				dv := yDiscrep
			else
				dv := (yDiscrep) div 2; {div 2}
			if (xMoved < xToMove) or (yMoved < yToMove) then
				ScrollRect(SlideRect, dx * dh, dy * dv, upregion);
			xMoved := xMoved + ABS(dh);
			yMoved := yMoved + ABS(dv);
		until ((xMoved >= xToMove) and (yMoved >= yToMove));
	end; {Slide}

	procedure SetUpBoxes (drawing: BOOLEAN);
		var
			j, l, t, row, column, boxwidth, height: INTEGER;
			inbox: rect;
	begin
		j := 0;
		NBoxes := NRows * NCols;
		MidBox := NBoxes div 2 + 1;
		NActiveBoxes := NBoxes;
		with Prect do
			begin
				boxwidth := (right - left) div ncols;
				height := (bottom - top - GenesHeight) div nrows;
				for row := 1 to nrows do
					for column := 1 to ncols do
						begin
							j := j + 1;
							l := left + boxwidth * (column - 1);
							t := top + GenesHeight + height * (row - 1);
							setrect(box[j], l, t, l + boxwidth, t + height);
							if (TheMode = breeding) and (j <> MidBox) and drawing then
								FrameRect(box[j]);
							with box[j] do
								begin
									Centre[j].h := left + boxwidth div 2;
									CENTRE[j].v := top + height div 2
								end;
						end; {row & column loop}
			end; {WITH Prect}
		if (theMode = breeding) and drawing then
			begin
				PenSize(3, 3);
				FrameRect(box[MidBox]);
				PenSize(1, 1);
			end;
		with BusinessPart do
			begin
				left := box[1].left;
				right := Box[NBoxes].right;
				top := box[1].top;
				bottom := box[Nboxes].bottom
			end;
	end; {setup boxes}

	procedure PicLine (var ThisPic: Pic; x, y, xnew, ynew: Integer; color: integer);
	begin
		with ThisPic do
			begin
				if PicSize >= PicSizeMax then
					begin
						Message('Biomorph too Large. No recovery possible');
						ExitToShell
					end
				else
					with MovePtr^ do
						begin
							StartPt.h := x;
							StartPt.v := y;
							EndPt.h := xnew;
							EndPt.v := ynew;
							col := color
						end;
				MovePtr := linptr(size(MovePtr) + 14);
{advance 'array subscript' by number of bytes occupied by one lin}
				PicSize := PicSize + 1
			end
	end; {PicLine}

	procedure ZeroPic (var ThisPic: Pic; Here: Point);
	begin
		with ThisPic do
			begin
				MovePtr := LinPtr(BasePtr);
				PicSize := 0;
				Origin := Here
			end
	end; {ZeroPic}

	procedure DrawPic (ThisPic: Pic; Place: Point; var Biomorph: person);
 {Pic already contains its own origin, meaning the coordinates at which}
{ it was originally drawn. Now draw it at Place}
		type
			PicStyleType = (LF, RF, FF, LUD, RUD, FUD, LSW, RSW, FSW);
		var
			j, y0, y1, x0, x1, VertOffset, HorizOffset, Mid2, belly2: INTEGER;
			PicStyle: PicStyleType;

		procedure Limb (x0, y0, x1, y1: INTEGER);
			var
				square: rect;
		begin
			with Biomorph do
				if (LimbShapeGene = Oval) or (LimbShapeGene = Rectangle) then
					if x0 < x1 then
						begin
							if y0 > y1 then
								SetRect(square, x0, y1, x1, y0)
							else
								SetRect(square, x0, y0, x1, y1)
						end
					else
						begin
							if y0 > y1 then
								SetRect(square, x1, y1, x0, y0)
							else
								SetRect(square, x1, y0, x0, y1)
						end;
			with Biomorph do
				begin
					PenSize(ThicknessGene, ThicknessGene);
					if LimbShapeGene = Oval then
						begin
							FrameOval(square);
							if LimbFillGene = Filled then
								PaintOval(square)
						end;
					if LimbShapeGene = Rectangle then
						begin
							FrameRect(square);
							if LimbFillGene = Filled then
								PaintRect(square)
						end;
  {PaintRect(square);}
					Moveto(x0, y0);
					LineTo(x1, y1);
					PenSize(MyPenSize, MyPenSize)
				end;
		end; {Limb}

		procedure ActualLine (PicStyle: PicStyleType; Orientation: Compass);
			var
				LinColor: integer;
		begin
			with ThisPic.MovePtr^ do
				begin
					if Orientation = NorthSouth then
						begin
							VertOffset := ThisPic.Origin.v - Place.v;
							HorizOffset := ThisPic.Origin.h - Place.h;
							y0 := StartPt.v - VertOffset;
							y1 := EndPt.v - VertOffset;
							x0 := StartPt.h - HorizOffset;
							x1 := EndPt.h - HorizOffset;
						end
					else
						begin
							VertOffset := ThisPic.Origin.h - Place.v;
							HorizOffset := ThisPic.Origin.v - Place.h;
							y0 := StartPt.h - VertOffset;
							y1 := EndPt.h - VertOffset;
							x0 := StartPt.v - HorizOffset;
							x1 := EndPt.v - HorizOffset
						end;
					LinColor := col; {this is a field of the records in Moveptr^ pointer list}
					RGBForeColor(ChooseColor(LinColor));
					case PicStyle of
						LF: 
							Limb(x0, y0, x1, y1);
						RF: 
							Limb(Mid2 - x0, y0, Mid2 - x1, y1);
						FF: 
							begin
								Limb(x0, y0, x1, y1);
								Limb(Mid2 - x0, y0, Mid2 - x1, y1)
							end;
						LUD: 
							begin
								Limb(x0, y0, x1, y1);
								Limb(Mid2 - x0, belly2 - y0, Mid2 - x1, belly2 - y1);
							end;
						RUD: 
							begin
								Limb(Mid2 - x0, y0, Mid2 - x1, y1);
								Limb(x0, belly2 - y0, x1, belly2 - y1);
							end;
						FUD: 
							begin
								Limb(x0, y0, x1, y1);
								Limb(Mid2 - x0, y0, Mid2 - x1, y1);
								Limb(x0, belly2 - y0, x1, belly2 - y1);
								Limb(Mid2 - x0, belly2 - y0, Mid2 - x1, belly2 - y1)
							end;
					end; {CASES}
				end
		end; {ActualLine}

	begin
		PicStyle := FF; {To correct initialisation bug, due to call in Update}
		with biomorph do
			case CompletenessGene of
				Single: 
					case SpokesGene of
						NorthOnly: 
							PicStyle := LF;
						NSouth: 
							PicStyle := LUD;
						Radial: 
							PicStyle := LUD;
					end;
				Double: 
					case SpokesGene of
						NorthOnly: 
							PicStyle := FF;
						NSouth: 
							PicStyle := FUD;
						Radial: 
							PicStyle := FUD;
					end;
			end; {CASES}
		PenSize(MyPenSize, MyPenSize);
		Mid2 := 2 * Place.h;
		belly2 := 2 * Place.v;
		with ThisPic do
			begin
				MovePtr := linptr(BasePtr); {reposition at base of grabbed space}
				for j := 1 to PicSize do
					with Biomorph do
						begin
							ActualLine(PicStyle, NorthSouth); {sometimes rangecheck error}
							if SpokesGene = Radial then
								begin
									if CompletenessGene = Single then
										ActualLine(RUD, EastWest)
									else
										ActualLine(PicStyle, EastWest)
								end;
							MovePtr := linptr(size(MovePtr) + 14);
						end;
			end;
		PenSize(1, 1);
		ForeColor(blackcolor)
	end; {DrawPic}


	function CheckAbort: BOOLEAN;
		var
			theWindow: WindowPtr;
			myEvent: eventRecord;
			MLoc: Point;
			MenuInf: LONGINT;
			WLoc, Menu, Item: INTEGER;
			Ab: BOOLEAN;
			theKeys: KeyMap;
	begin
		Ab := FALSE;
		GetKeys(theKeys);
{IF theKeys[56] THEN Ab:=TRUE;}
   { BEGIN}
{    MLoc:=myEvent.Where;}
{    WLoc:=FindWindow(MLoc,theWindow);}
{    IF WLoc=InMenuBar THEN}
{        BEGIN MenuInf:=MenuSelect(MLoc);}
{        Menu:=HiWord(MenuInf);}
{        Item:=LoWord(MenuInf);}
{        IF (Menu=OperMenu) AND (Item=9) THEN Ab:=TRUE;}
{        END        }
{    END;}
		CheckAbort := Ab
	end; {CheckAbort}


end.