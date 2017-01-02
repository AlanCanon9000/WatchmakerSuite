unit unit_pa_warning_alert;   												{Handle this alert}{Unit name:  PA_Warning_Alert.p  }{Function:  Handle this alert.}{This is a CAUTION alert, it is used to inform the user that if the current path}{is taken then data may be lost.  The user can change the present course and}{save the data.  This is the type of alert used to tell the user that he needs to}{save the data before going on.}{This alert is called when:   }{   }{The choices in this alert allow for:   }{   }{ History: 20/6/91 Original by Prototyper 3.0   }interface	uses{$IFC UNDEFINED THINK_Pascal}		Types, Dialogs, ToolUtils, Resources, Memory, Events, Controls, Quickdraw, {$ENDC}		unit_pcommon_exhibition, unit_common_exhibition,{Common}		unit_putils_exhibition, unit_utils_exhibition, {General Utilities}		unit_warning_alert;{User unique file}	procedure I_A_PA_Warning_Alert;	procedure A_PA_Warning_Alert;implementation	var		FirstTime: boolean;    												{Flag for first time thru the filter}{=======================================================}	function MyFilter (theDialog: DialogPtr; var theEvent: EventRecord; var itemHit: integer): boolean;		var			tempRect: Rect;  													{Temporary rectangle}			DType: Integer;   													{Type of dialog item}			DItem: Handle;    													{Handle to the dialog item}			CItem: controlhandle;    											{Control handle}			chCode: Integer;  													{Key entered}			LTemp: longint;   													{Used for time delay and HotSpot setup}	begin		MyFilter := FALSE;		if (FirstTime = TRUE) then   										{Make all controls and do lines and rects}			begin				GetDItem(theDialog, Res_Alrt_OK3, DType, DItem, tempRect);{Get the item handle}				PenSize(3, 3);  												{Change pen to draw thick default outline}				InsetRect(tempRect, -4, -4);     							{Draw outside the button by 1 pixel}				FrameRoundRect(tempRect, 16, 16);    					{Draw the outline}				PenSize(1, 1);  												{Restore the pen size to the default value}				FirstTime := FALSE;    										{Not first time anymore}			end;		MyFilter := Filter_Warning_Alert(theDialog, theEvent, itemHit);{Call the user routine}		if (theEvent.what = KeyDown) then			begin				with theEvent do					begin						chCode := BitAnd(message, CharCodeMask);{Get character}						if (chCode = 13) or (chCode = $03) then 			{CR or Enter}							begin								MyFilter := TRUE;     								{Flag we got a hit}								itemHit := 1;   										{Default for CR}								GetDItem(theDialog, itemHit, DType, DItem, tempRect);{Get the item}								if (DType = (ctrlItem + btnCtrl)) then 			{If a button then ...}									begin										CItem := Pointer(DItem);     					{Make it a controlhandle}										HiliteControl(CItem, 10);     					{Hilite it}										LTemp := TickCount + 15;    					{Flash the button for 1/4 second}										repeat										until (Ltemp < TickCount);										HiliteControl(CItem, 0);  						{UnHilite it}									end;							end;					end;			end;	end;{=======================================================}	procedure I_A_PA_Warning_Alert;	begin		Init_A_Warning_Alert; 									{Tell the user routine we are inited}	end;   															{End of procedure}	procedure A_PA_Warning_Alert;		var			itemHit: Integer;  												{Get the selection ID in here}			AlertResHandle: AlertTHndl; 									{Resource handle for Alert}			tempRect: Rect;     												{Temp rect for moving the alert}	begin		AlertResHandle := AlertTHndl(GetResource('ALRT', Res_A_Warning_Alert));{Get the Alerts resource template handle}		HLock(Handle(AlertResHandle));     							{Lock the resource down while we use it}		FirstTime := TRUE;     											{Set the flag for the filter proc}			{Let the OS handle the Alert and wait for a result to be returned}		itemHit := CautionAlert(Res_A_Warning_Alert, @MyFilter);{Bring in the alert resource}			{This is the default selection, when RETURN is pressed.}		if (Res_Alrt_OK3 = itemHit) then   							{See if this Button was selected}			begin			end;		A_Hit_Warning_Alert(itemHit); 								{Tell the user routine which item was selected}	end; 																	{End of procedure}end.    																		{End of unit}