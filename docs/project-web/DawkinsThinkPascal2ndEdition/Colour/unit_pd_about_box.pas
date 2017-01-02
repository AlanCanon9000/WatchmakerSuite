unit unit_pd_about_box;{File name: About_Box}{Function: Handle a modal dialog}{ History: 20/6/91 Original by Prototyper 3.0   }interfaceuses	unit_pcommon_exhibition, unit_common_exhibition, {Common and types}	unit_putils_exhibition, unit_utils_exhibition ,{General Utilities}	unit_pa_warning_alert,{Alerts}	unit_about_box;{User unique file}	{Init any global variables}	procedure I_PD_About_Box;	{Handle the modal dialog}	procedure M_PD_About_Box;{=======================================================}implementationuses Types, Dialogs, Quickdraw, Controls, Events, Windows, ToolUtils;var 		ExitDialog : boolean;  												{Flag used to exit the Dialog}		MyPt : Point;  														{Current list selection point}		MyErr : OSErr;    													{OS error returned}		GetSelection : DialogPtr;     										{Pointer to this dialog}		SavedPort : GrafPtr;     											{Previous grafport}{=======================================================}	procedure I_PD_About_Box;		var			tempRect : Rect;   												{Temporary rectangle}			DType : Integer;    												{Type of dialog item}			Index : Integer;     												{For looping}			DItem : Handle;     												{Handle to the dialog item}			CItem, CTempItem : controlhandle; 							{Control handle}			sTemp : Str255;   												{Get text entered, temp holding}			itemHit : Integer;  												{Get selection}			temp : Integer; 													{Get selection, temp holding}		begin     																{Start of init code}			D_Init_About_Box;		end; 																	{End of procedure}{=======================================================}		function MyFilter (theDialog : DialogPtr;		                   var theEvent : EventRecord;		                   var itemHit : integer) : boolean;		var			MyPt : Point;   													{Current list selection point}			tempRect : Rect;   												{Temporary rectangle}			DType : Integer;    												{Type of dialog item}			DItem : Handle;     												{Handle to the dialog item}			CItem : controlhandle;     										{Control handle}			chCode : Integer;   												{Key entered}			LTemp : longint;    												{Used for time delay}			MyCmdKey : char;     											{The command key}			CmdDown : boolean;   											{Flag for command key used}		begin			MyFilter := FALSE;			MyFilter:= D_Filter_About_Box(theDialog, theEvent, itemHit);{Call the user routine}			if (theEvent.what = updateEvt)  and (WindowPtr(theEvent.message) = theDialog) then{Only do on an update}				begin				BeginUpdate(theDialog);    									{Start the update}				DrawDialog(theDialog);     									{Draw the controls}				MyFilter := TRUE;  											{Pass out this special itemHit number}				itemHit := 32000;  											{Our special ID}				end;			if (theEvent.what = MouseDown) then  						{Only do on a mouse click}				begin				MyPt := theEvent.where; 									{Get the point where the mouse was clicked}				GlobalToLocal(MyPt);  										{Convert global to local}				end;			if (theEvent.what = KeyDown) then				begin				with theEvent do					begin					chCode := BitAnd (message, CharCodeMask);   		{Get character}					MyCmdKey := CHR(chCode);	    						{Change to ASCII}					CmdDown := Odd(modifiers div CmdKey);   			{Get command key state}					if CmdDown then     										{Do if command key was down}						begin						if ((MyCmdKey = 'x') or (MyCmdKey = 'X')) then							begin							DlgCut(theDialog);							MyFilter := TRUE;							end						else if ((MyCmdKey ='c') or (MyCmdKey = 'C')) then							begin							DlgCopy(theDialog);							MyFilter := TRUE;							end						else if ((MyCmdKey ='v') or (MyCmdKey = 'V')) then							begin							DlgPaste(theDialog);							MyFilter := TRUE;							end;						end					else if (chCode = 13) or (chCode = $03) then   		{CR or Enter}						begin						MyFilter := TRUE;    									{Flag we got a hit}						itemHit := 1;  											{Default for CR}						GetDItem (theDialog ,itemHit, DType, DItem, tempRect);{Get the item}						if (DType = (ctrlItem + btnCtrl)) then     			{If a button then ...}							begin							CItem := Pointer (DItem);    						{Make it a controlhandle}							HiliteControl(CItem, 10);    						{Hilite it}							LTemp := TickCount + 15;   						{Flash the button for 1/4 second}							repeat							until (Ltemp < TickCount);							HiliteControl(CItem, 0); 							{UnHilite it}							end;						end;					end;				end;		end;{=======================================================}		procedure M_PD_About_Box;			var				tempRect : Rect;    											{Temporary rectangle}				DType : Integer;     											{Type of dialog item}				Index : Integer; 												{For looping}				DItem : Handle; 												{Handle to the dialog item}				CItem, CTempItem : controlhandle;  						{Control handle}				sTemp : Str255;    											{Get text entered, temp holding}				itemHit : Integer;   											{Get selection}				temp : Integer;  												{Get selection, temp holding}{=======================================================}		{This is an update routine for non-controls in the dialog} 		{This is executed after the dialog is uncovered by an alert} 		procedure Refresh_Dialog;  										{Refresh the dialogs non-controls}			var 				rTempRect:Rect;    											{Temp rectangle used for drawing}			begin 				SetPort(GetSelection);     									{Point to our dialog window}				GetDItem(GetSelection,Res_Dlg_OK2,DType,DItem,tempRect);{Get the item handle}				PenSize(3, 3);  												{Change pen to draw thick default outline}				InsetRect(tempRect, -4, -4);     							{Draw outside the button by 1 pixel}				FrameRoundRect(tempRect, 16, 16);    					{Draw the outline}				PenSize(1, 1);  												{Restore the pen size to the default value}				D_Refresh_About_Box(GetSelection);   					{Call user refresh routine}		end; {=======================================================}			begin 																{Start of dialog handler}				GetPort(SavedPort);   										{Get the previous grafport}				GetSelection := GetNewDialog(Res_D_About_Box, nil,  Pointer(-1) );{Bring in the dialog resource}				ShowWindow(GetSelection);  								{Open a dialog box}				SelectWindow(GetSelection); 								{Lets see it}				SetPort(GetSelection);     									{Prepare to add conditional text}				{Setup initial conditions}				Refresh_Dialog;     											{Draw any Lists, lines, or rectangles}				ExitDialog:=FALSE;     										{Do not exit dialog handle loop yet}				D_Setup_About_Box(GetSelection); 						{Call user Dialog setup routine}				repeat     														{Start of dialog handle loop}					ModalDialog(@MyFilter, itemHit);     					{Wait until an item is hit}					if (itemHit = 32000) then  								{Check for update}						begin						Refresh_Dialog;  										{Draw any Lists, lines, or rectangles}						EndUpdate(GetSelection);    							{End of the update}						end					else						begin						GetDItem(GetSelection, itemHit, DType, DItem, tempRect);{Get item information}						CItem := Pointer(DItem);    							{Get the control handle}						end;					D_Hit_About_Box(GetSelection,itemHit,ExitDialog);{Let user handle the item hit}					{Handle it real time}					if (ItemHit =Res_Dlg_OK2) then   						{Handle the Button being pressed}						begin					ExitDialog := TRUE; 										{Close a modal dialog}						end;				until ExitDialog;     											{Handle dialog items until exit selected}				{Get results after dialog}				D_Exit_About_Box(GetSelection);   						{Exiting the modal dialog}				SetPort(SavedPort);   										{Restore the previous grafport}				DisposDialog(GetSelection);   								{Flush the dialog out of memory}			end;  																{End of procedure}end.    																		{End of unit}