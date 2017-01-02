unit  unit_putils_exhibition; 													{Utilities}{Unit name:  PUtils_Exhibition.p  }{Function:  Utilities for the Prototyper specific code.}{ History: 20/6/91 Original by Prototyper 3.0   }interfaceuses	Types, OSUtils, Dialogs, TextUtils, TextEdit, Fonts, Memory, Script, QuickdrawText, Quickdraw, Controls, unit_pcommon_exhibition, unit_common_exhibition;{Common}{=======================================================}{See if a trap is available} 	Function TrapAvailable (trapNumber: integer; tType: TrapType): boolean;{See if any user events are available} 	Procedure GetUserEvent(var TheUserEvent:UserEventRec);{Add a user event} 	procedure Add_UserEvent(ID, ID2: integer; Data1,Data2: longint;  theHandle: Handle);{This is a routine used to get a string from a TE area, limited to 250 characters} 	procedure Get_TE_String(theTEArea:TEHandle;  var theString:Str255); {This is a routine used to create a TE area} 	procedure Make_TE_Area(var theTEArea:TEHandle;  Position:Rect; theFontSize,theFont:integer; DefaultStringID:integer); {Setup a dialog or alert item}	procedure SetupTheItem (theDialog:DialogPtr; ItemID:integer; SizeIt, ShowIt, EnableIt, SetTheMax:Boolean; {}			var thePosition:Rect;  ExtraData:longint; StringID:integer);implementation{=======================================================}	{Routine: TrapAvailable}	{Purpose: See if trap is available, non-available traps all have a unique address}		Function TrapAvailable (trapNumber: integer; tType: TrapType): boolean;{See if a trap is available}		const			UnimplementedTrapNumber = $A89F;  						{Unimplemented trap number}		begin			TrapAvailable := (NGetTrapAddress(trapNumber, tType) <> GetTrapAddress(UnimplementedTrapNumber));{Check the two traps}	end;{=======================================================}	{Routine: GetUserEvent}	{Purpose: See if any user events are available}		Procedure GetUserEvent(var TheUserEvent:UserEventRec);		var 			NextUserEvent:UserEventHRec; 								{The next user event}		begin			TheUserEvent.ID := UserEvent_None;   						{Set ID to no events are available}			if (UserEventList <> nil) then     								{Get first entry in the list}				begin				HLock(Handle(UserEventList));				TheUserEvent.ID := UserEventList^^.ID;     				{The event ID}				TheUserEvent.ID2 := UserEventList^^.ID2; 				{The optional ID}				TheUserEvent.Data1 := UserEventList^^.Data1;    		{The optional data}				TheUserEvent.Data2 := UserEventList^^.Data2;    		{The optional data}				TheUserEvent.theHandle := UserEventList^^.theHandle;{The optional handle}				NextUserEvent := UserEventList^^.Next;    				{The next list}				DisposHandle(Handle(UserEventList));   					{Remove this list item}				UserEventList := NextUserEvent;    						{Make the next item the new first item}				end; 	end;{=======================================================}	{Routine: Add_UserEvent}	{Purpose: Add a user event}		procedure Add_UserEvent(ID, ID2: integer; Data1,Data2: longint;  theHandle: Handle);		var 			NewUserEvent:UserEventHRec; 								{The new user event}			theUserEvent:UserEventHRec;   								{The user event}		begin			NewUserEvent := UserEventHRec(NewHandle(sizeof(UserEventRec)));{Allocate a record}			if (NewUserEvent <> nil) then    								{Only do if we got the new record}				begin				HLock(Handle(NewUserEvent));				NewUserEvent^^.ID := ID; 									{The event ID}				NewUserEvent^^.ID2 := ID2;  								{The optional ID}				NewUserEvent^^.Data1 := Data1;     						{The optional data}				NewUserEvent^^.Data2 := Data2;     						{The optional data}				NewUserEvent^^.theHandle := theHandle;    				{The optional handle}				NewUserEvent^^.Next := nil;  								{No next item after this one}				if (UserEventList = nil) then  								{See if anyone is in the list yet}					UserEventList := NewUserEvent  						{Make this one the first in the list}				else   															{Not the first in the list}					begin					theUserEvent := UserEventList;   						{Get the first one}					while (theUserEvent^^.Next <> nil) do     				{Get the next one}						theUserEvent := theUserEvent^^.Next;					theUserEvent^^.Next := NewUserEvent; 				{Tack on to the end}					end; 				end; 	end;{=======================================================}	{This is a routine used to get a string from a TE area, limited to 250 characters} 		procedure Get_TE_String(theTEArea:TEHandle;  var theString:Str255); 		var 			Index:integer;  													{Use to loop thru the characters}			TitleLength:integer;   											{Number of characters to do}			theCharsHandle: CharsHandle;   								{Used to get global edit text}		begin 			theCharsHandle := TEGetText(theTEArea);     				{Get the character handle}			HLock(Handle(theCharsHandle));     							{Lock it for safety}			TitleLength := theTEArea^^.teLength;   						{Get the number of characters}			theString := ''; 													{Start with an empty string}			if (TitleLength > 0) then				begin				if (TitleLength > 250) then					TitleLength := 250;				for Index := 1 to TitleLength do					theString := concat(theString, theCharsHandle^^[Index - 1]);				end;	end; {=======================================================}	{This is a routine used to create a TE area} 		procedure Make_TE_Area(var theTEArea:TEHandle;  Position:Rect; theFontSize,theFont:integer; DefaultStringID:integer); 		var 			ThisFontInfo: FontInfo;    										{Use to get the font data}		begin 			TextSize(theFontSize);    										{Set the size}			TextFont(theFont);     											{Set the font}			GetFontInfo(ThisFontInfo);    									{Get Ascent height for positioning}			TextSize(12);  													{Restore the size}			TextFont(applFont);    											{Restore the font}			tempRect := Position; 											{Get the rect}			FrameRect(tempRect);    										{Frame this TE area}			InsetRect(tempRect, 3, 3);   									{Indent for TE inside of box}			theTEArea := TENew(tempRect, tempRect);   				{Create the TE area}			if (theInput <> nil) then    										{See if there is already a TE area}				TEDeactivate(theInput);    									{Yes, so turn it off}			theInput := theTEArea;    										{Activate the TE area}			HLock(Handle(theTEArea));   									{Lock the handle before using it}			theTEArea^^.txFont := theFont;  								{Font to use for the TE area}			theTEArea^^.fontAscent := ThisFontInfo.ascent;  			{Font ascent}			theTEArea^^.lineHeight := ThisFontInfo.ascent+ThisFontInfo.descent+ThisFontInfo.leading;{Font ascent + descent + leading}			HUnLock(Handle(theTEArea));    								{UnLock the handle when done}			GetIndString(sTemp, DefaultStringID, 1); 					{Get the default string}			TESetText(Pointer(Ord4(@sTemp) + 1), length(sTemp), theTEArea);{Place default text in the TE area}			TEActivate(theTEArea);  										{Make the TE area active}	end; {=======================================================}	{Setup a dialog or alert item}		procedure SetupTheItem (theDialog:DialogPtr; ItemID:integer; SizeIt, ShowIt, EnableIt, SetTheMax:Boolean; {}				var thePosition:Rect;  ExtraData:longint; StringID:integer);		var			tempRect: Rect;    												{Temporary rectangle}			DType: integer;     												{Type of dialog item}			DItem: Handle; 													{Handle to the dialog item}			CItem: ControlHandle;     										{Control handle}		begin			GetDItem(theDialog,ItemID,DType,DItem,tempRect);{Get the item handle and size}			CItem :=  ControlHandle(DItem);     							{Change to control handle}			if (SizeIt) then 													{Have to resize all CDEF connected controls}				SizeControl(CItem, tempRect.right-tempRect.left, tempRect.bottom-tempRect.top);{Size it }			thePosition := tempRect; 										{Pass back the zone location and size}			if (ExtraData <> 0) then   										{See if extra data for a CDEF}				CItem^^.contrlData := Handle(ExtraData);  				{Send it}			if (StringID <>  0) then    										{See if a CDEF and needs the title set again}				begin				GetIndString(sTemp,StringID,1);     						{Get the string}				SetCTitle(CItem,sTemp);  									{Set the string}				end;			if (EnableIt) then   												{See if enable or disable the zone}				HiliteControl (CItem,0)     									{Enable the zone}			else				HiliteControl (CItem,255);    								{Dim the zone}			if (SetTheMax) then				SetCtlMax(CItem,12345);     								{Set the flag to the CDEF}			if (ShowIt) then				ShowControl(CItem);   										{Show it to activate it}	end; {=======================================================}end.    																		{End of the Unit}