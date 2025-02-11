UNIT unit_engineering;

INTERFACE
USES
	Quickdraw, Types, unit_globals, unit_miscellaneous, unit_biomorphs;

PROCEDURE DoEngineer;
PROCEDURE DoSaltation;
PROCEDURE Manipulation (MLoc: point);
FUNCTION LeftRightPos (MLoc: Point; Box: Rect): HorizPos;
FUNCTION Rung (Mloc: Point; Box: Rect): VertPos;

IMPLEMENTATION

PROCEDURE DoEngineer;
	BEGIN
		TheMode := engineering;
		EraseRect(Prect);
		SetUpBoxes;
		child[midbox] := child[special];
		special := midbox;
		Delayvelop(child[special], centre[MidBox]);
		MakeGeneBox(child[special]);
		StoreOffScreen(MainPtr^.PortRect, MyBitMap);
	END; {DoEngineer}

FUNCTION LeftRightPos (MLoc: Point; Box: Rect): HorizPos;
	BEGIN
		WITH Box DO
			IF MLoc.h < left + (right - left) DIV 3 THEN
				LeftRightPos := LeftThird
			ELSE IF Mloc.h > right - (right - left) DIV 3 THEN
				LeftRightPos := RightThird
			ELSE
				LeftRightPos := MidThird
	END;

FUNCTION Rung (Mloc: Point; Box: Rect): VertPos;
	BEGIN
		WITH Box DO
			IF MLoc.v < top + (bottom - top) DIV 3 THEN
				Rung := TopRung
			ELSE IF MLoc.v > bottom - (bottom - top) DIV 3 THEN
				Rung := BottomRung
			ELSE
				Rung := MidRung
	END;


PROCEDURE SnapDevelop (Biomorph: person; Place: Point);
	VAR
		SnappyBox: Rect;
	BEGIN
		DelayedDrawing := TRUE;
		SnappyBox := Margin;
		ZeroMargin := TRUE;
		Develop(biomorph, Place);
		WITH Snappybox DO
			BEGIN
				IF Margin.left < left THEN
					left := Margin.left;
				IF Margin.right > right THEN
					right := Margin.right;
				IF Margin.top < top THEN
					top := Margin.top;
				IF Margin.bottom > bottom THEN
					bottom := Margin.bottom
			END;
		Grow(Snappybox, MyPenSize);
		Snapshot(MyPic, Snappybox, Biomorph);
	END; {SnapDevelop}


PROCEDURE Manipulation (MLoc: point);
	VAR
		j, chosenbox: Integer;
		Cent: Point;
		swallowing, refrain: Boolean;
	BEGIN
		GlobalToLocal(Mloc);
		ChosenBox := 0;
		IF Mloc.v < GeneBox[1].bottom THEN
			FOR j := 1 TO 16 DO
				IF PtInRect(MLoc, GeneBox[j]) THEN
					ChosenBox := j;
		j := ChosenBox;
		IF ChosenBox = 0 THEN
			SyringeMessage
		ELSE
			BEGIN
				WITH child[special] DO
					CASE ChosenBox OF
						1..8: 
							CASE LeftRightPos(Mloc, GeneBox[j]) OF
								LeftThird: 
									gene[j] := gene[j] - MutSizeGene;
								RightThird: 
									gene[j] := gene[j] + MutSizeGene;
								MidThird: 
									CASE Rung(Mloc, GeneBox[j]) OF
										TopRung: 
											dGene[j] := Swell;
										MidRung: 
											dGene[j] := Same;
										BottomRung: 
											dGene[j] := Shrink;
									END; {MidThird}
							END; {CASE 1..8}
						9: 
							CASE LeftRightPos(Mloc, GeneBox[j]) OF
								LeftThird: 
									gene[j] := gene[j] - 1;
								RightThird: 
									BEGIN
										gene[j] := gene[j] + 1;
										SizeWorry := SegNoGene * TwoToThe(gene[9]);
										IF SizeWorry > WorryMax THEN
											Gene[9] := Gene[9] - 1;
									END;
								MidThird: 
									CASE Rung(Mloc, GeneBox[j]) OF
										TopRung: 
											dGene[j] := Swell;
										MidRung: 
											dGene[j] := Same;
										BottomRung: 
											dGene[j] := Shrink;
									END; {MidThird}
							END; {CASE 1..8}
						10: 
							CASE LeftRightPos(Mloc, GeneBox[10]) OF
								LeftThird: 
									SegNoGene := SegNoGene - 1;
								MidThird: 
									;   {No Action}
								RightThird: 
									BEGIN
										SegNoGene := SegNoGene + 1;
										SizeWorry := SegNoGene * TwoToThe(gene[9]);
										IF SizeWorry > WorryMax THEN
											SegNoGene := SegNoGene - 1;
									END;
							END;
						11: 
							CASE LeftRightPos(Mloc, GeneBox[11]) OF
								LeftThird: 
									SegDistGene := SegDistGene - TrickleGene;
								MidThird: 
									CASE Rung(Mloc, GeneBox[j]) OF
										TopRung: 
											dGene[10] := Swell;
										MidRung: 
											dGene[10] := Same;
										BottomRung: 
											dGene[10] := Shrink;
									END; {MidThird}
								RightThird: 
									SegDistGene := SegDistGene + TrickleGene;
							END;
						12: 
							CASE LeftRightPos(Mloc, GeneBox[12]) OF
								LeftThird: 
									CompletenessGene := Single;
								MidThird: 
									;    {No Action}
								RightThird: 
									CompletenessGene := Double;
							END;
						13: 
							CASE LeftRightPos(Mloc, GeneBox[13]) OF
								LeftThird: 
									SpokesGene := NorthOnly;
								MidThird: 
									SpokesGene := NSouth;
								RightThird: 
									SpokesGene := Radial;
							END;
						14: 
							CASE LeftRightPos(Mloc, GeneBox[j]) OF
								LeftThird: 
									BEGIN
										tricklegene := tricklegene - 1;
										IF tricklegene < 1 THEN
											tricklegene := 1;
									END;
								RightThird: 
									tricklegene := tricklegene + 1;
								MidThird: 
									; {No action}
							END;
						15: 
							CASE LeftRightPos(Mloc, GeneBox[j]) OF
								LeftThird: 
									BEGIN
										MutSizegene := MutSizegene - 1;
										IF MutSizegene < 1 THEN
											MutSizegene := 1
									END;
								RightThird: 
									MutSizegene := MutSizegene + 1;
								MidThird: {No action}
							END;
						16: 
							CASE LeftRightPos(Mloc, GeneBox[j]) OF
								LeftThird: 
									BEGIN
										MutProbGene := MutProbGene - 1;
										IF MutProbgene < 1 THEN
											MutProbgene := 1
									END;
								RightThird: 
									BEGIN
										MutProbGene := MutProbGene + 1;
										IF MutProbgene > 100 THEN
											MutProbgene := 100
									END;
								MidThird: {No action}
							END;
					END;
				WITH child[special] DO
					BEGIN
						Refrain := (Gene[9] > 12) OR (Gene[9] < 1) OR (SegNoGene < 1) OR (ChosenBox >= 15);{����}
						IF Gene[9] < 1 THEN
							Gene[9] := 1;
						IF SegNoGene < 1 THEN
							SegNoGene := 1
					END;
				IF NOT Refrain THEN
					SnapDevelop(child[special], centre[MidBox]);
				ShowGeneBox(chosenbox, child[special]);
			END
	END; {Manipulation}


PROCEDURE DoSaltation;
	VAR
		j, maxgene, r: Integer;
		factor: -1..1;
	BEGIN
		DelayedDrawing := FALSE;
		special := MidBox;
		WITH child[special] DO {bomb 5, range check failed, here after killing top Adam}
			BEGIN
				IF Mut[1] THEN
					BEGIN
						SegNoGene := randint(6);
						SegDistGene := randint(20);
					END
				ELSE
					BEGIN
						SegNoGene := 1;
						SegDistGene := 1
					END;
				r := randint(100);
				CompletenessGene := Double;
				IF Mut[3] THEN
					IF r < 50 THEN
						CompletenessGene := Single
					ELSE
						CompletenessGene := Double;
				r := randint(100);
				IF Mut[4] THEN
					BEGIN
						IF r < 33 THEN
							SpokesGene := Radial
						ELSE IF r < 66 THEN
							SpokesGene := NSouth
						ELSE
							SpokesGene := NorthOnly
					END
				ELSE
					SpokesGene := NorthOnly;
				IF Mut[5] THEN
					BEGIN
						TrickleGene := 1 + randint(100) DIV 10;
						IF TrickleGene > 1 THEN
							MutSizeGene := Tricklegene DIV 2
					END;
				FOR j := 1 TO 8 DO
					REPEAT
						gene[j] := MutSizeGene * (randint(19) - 10);
						IF Mut[2] THEN
							dGene[j] := RandSwell(dgene[j])
						ELSE
							dGene[j] := Same;
						CASE dGene[j] OF
							Shrink: 
								factor := 1;
							Same: 
								factor := 0;
							Swell: 
								factor := 1;
						END; {Cases}
						maxgene := gene[j] * SegNoGene * factor;
					UNTIL (maxgene <= 9 * Tricklegene) AND (maxgene >= -9 * Tricklegene);
				REPEAT
					IF Mut[8] THEN
						dGene[9] := RandSwell(dgene[9])
					ELSE
						dGene[9] := Same;
					IF Mut[2] THEN
						dGene[10] := RandSwell(dgene[9])
					ELSE
						dGene[10] := Same;
					CASE dGene[j] OF
						Shrink: 
							factor := 1;
						Same: 
							factor := 0;
						Swell: 
							factor := 1;
					END; {Cases}
					maxgene := SegDistGene * SegNoGene * factor;
				UNTIL (maxgene <= 100) AND (maxgene >= -100);
				REPEAT
					Gene[9] := randint(6)
				UNTIL Gene[9] > 1;
			END;
		EraseRect(Prect);
		Develop(child[special], centre[midBox]);
		MakeGeneBox(child[special]);
		TheMode := Randoming;
	END; {DoSaltation}

END.
