unit Utils_Exhibition;   													{Utilities}{Unit name:  Utils_Exhibition.p  }{Function:  Utilities for the Program specific code.}{ History: 6/10/91 Original by Prototyper 3.0   }interface	uses		PCommonExhibition, Common_Exhibition,{Common}		PUtils_Exhibition;{Utilitys}{=======================================================}	function stripped (s: str255): str255;	procedure FilledClip;	procedure EmptiedClip;	procedure ResetClock;implementation	function stripped (s: str255): str255;{removes  spaces after number, for StringToNum}		var			j, n: integer;	begin		n := length(s);		j := pos(' ', s);		if j = 0 then			stripped := s		else			begin				delete(s, j, 1);				stripped := stripped(s)			end;	end; {stripped}	procedure FilledClip;	begin		ClipFull := true;{EnableItem(Menu_Edit3, 5)}	end;	procedure EmptiedClip;	begin		ClipFull := false;{DisableItem(Menu_Edit3, 5)}	end;	procedure ResetClock;	begin		GetDateTime(TimeOfEvent);	end;{=======================================================}end.    																		{End of the Unit}