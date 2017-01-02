unit unit_pw_breedwindow;{File name: BreedWindow}{Function: Handle a Window}{ History: 20/6/91 Original by Prototyper 3.0   }interface	uses{$IFC UNDEFINED THINK_Pascal}		Types, Quickdraw, Events,  {$ENDC}		unit_pcommon_exhibition, unit_common_exhibition, {Common and types}		unit_putils_exhibition, unit_utils_exhibition, {General Utilities}		unit_pa_warning_alert,{Alerts}		unit_pd_about_box, unit_pd_timing_dialogue,{Modal Dialogs}		unit_breed_window;	{Initialize us so all our routines can be activated}	procedure Init_BreedWindow;	{Close our window}	procedure Close_BreedWindow (whichWindow: WindowPtr);	{Handle resizing scrollbars}	procedure Resized_BreedWindow (OldRect: Rect; whichWindow: WindowPtr);	{Our window was moved}	procedure Moved_BreedWindow (OldRect: Rect; whichWindow: WindowPtr);	{Update our window, someone uncovered a part of us}	procedure Update_BreedWindow (whichWindow: WindowPtr);	{Open our window and draw everything}	procedure Open_BreedWindow;	{Handle activation of our window}	procedure Activate_BreedWindow (whichWindow: WindowPtr; Do_An_Activate: boolean);	{Handle action to our window, like controls}	procedure Do_BreedWindow (myEvent: EventRecord);{=======================================================}implementation{$IFC UNDEFINED THINK_Pascal}	uses		Controls, Windows, Memory, TextEdit;{$ENDC}	var		ScrollHHandle: ControlHandle; 											{Scrollbar for horz scrolling}		ScrollVHandle: ControlHandle; 											{Scrollbar for vert scrolling}{=======================================================}	{Routine: Init_BreedWindow}	{Purpose: Initialize our window data to not in use yet}	procedure Init_BreedWindow;	begin		WPtr_BreedWindow := nil;     									{Make sure other routines know we are not valid yet}		ScrollHHandle := nil;    											{Scrollbar is not valid yet}		ScrollVHandle := nil;    											{Scrollbar is not valid yet}		U_Init_BreedWindow; 											{Call the user window init routine}	end;{=======================================================}	{Routine: Close_BreedWindow}	{Purpose: Close out the window}	procedure Close_BreedWindow;	begin		if (WPtr_BreedWindow <> nil) and ((WPtr_BreedWindow = whichWindow) or (ord4(whichWindow) = -1)) then{See if we should close this window}			begin				U_Close_BreedWindow;    									{Call the user window close routine}				DisposeWindow(WPtr_BreedWindow);   					{Clear window and controls}				WPtr_BreedWindow := nil;    								{Make sure other routines know we are closed}			end;   															{End for if (MyWindow<>nil)}	end;     																	{End of procedure}{=======================================================}	{Routine: Resized_BreedWindow}	{Purpose: We were resized or zoomed, update the scrolling scrollbars}	procedure Resized_BreedWindow; 									{Resized this window}		var			SavePort: WindowPtr;   										{Place to save the last port}			temp2Rect: Rect; 												{temp rectangle}			Index: integer;     												{temp integer}	begin		if (WPtr_BreedWindow = whichWindow) then 				{Only do if the window is us}			begin				GetPort(SavePort);     										{Save the current port}				SetPort(WPtr_BreedWindow);    							{Set the port to my window}				U_Resized_BreedWindow(OldRect);  						{Call the user window resized routine}				temp2Rect := WPtr_BreedWindow^.PortRect; 			{Get the window rectangle}				EraseRect(temp2Rect);    									{Erase the new window area}				InvalRect(temp2Rect);     									{Set to update the new window area}				if (ScrollHHandle <> nil) then     							{Only do if the control is valid}					begin						HLock(Handle(ScrollHHandle));     						{Lock the handle while we use it}						tempRect := ScrollHHandle^^.contrlRect;     			{Get the last control position}						tempRect.Top := tempRect.Top - 4;  					{Widen the area to update}						tempRect.Right := tempRect.Right + 16;     			{Widen the area to update}						InvalRect(tempRect);   									{Flag old position for update routine}						tempRect := ScrollHHandle^^.contrlRect;     			{Get the last control position}						temp2Rect := WPtr_BreedWindow^.PortRect;  		{Get the window rectangle}						Index := temp2Rect.Right - temp2Rect.Left - 13;{Get the scroll area width}						tempRect.Left := 0;  										{Pin at left edge}						HideControl(ScrollHHandle);   							{Hide it during size and move}						SizeControl(ScrollHHandle, Index, 16);   				{Make it 16 pixels high, std width}						MoveControl(ScrollHHandle, tempRect.Left - 1, temp2Rect.bottom - temp2Rect.top - 15);{Size it correctly}						ShowControl(ScrollHHandle);  							{Safe to show it now}						HUnLock(Handle(ScrollHHandle)); 						{Let it float again}					end;   															{End for scroll handle not nil)}				if (ScrollVHandle <> nil) then     							{Only do if the control is valid}					begin						HLock(Handle(ScrollVHandle));     						{Lock the handle while we use it}						tempRect := ScrollVHandle^^.contrlRect;     			{Get the last control position}						tempRect.Left := tempRect.Left - 4; 					{Widen the area to update}						tempRect.Bottom := tempRect.Bottom + 16;    		{Widen the area to update}						InvalRect(tempRect);   									{Flag old position for update routine}						tempRect := ScrollVHandle^^.contrlRect;     			{Get the last control position}						temp2Rect := WPtr_BreedWindow^.PortRect;  		{Get the window rectangle}						Index := temp2Rect.bottom - temp2Rect.top - 13;{Get the scroll area height}						tempRect.Top := 0;  										{Pin at top edge}						HideControl(ScrollVHandle);   							{Hide it during size and move}						SizeControl(ScrollVHandle, 16, Index);   				{Make it 16 pixels wide, std height}						MoveControl(ScrollVHandle, temp2Rect.right - temp2Rect.Left - 15, tempRect.Top - 1);{Size it correctly}						ShowControl(ScrollVHandle);  							{Safe to show it now}						HUnLock(Handle(ScrollVHandle)); 						{Let it float again}					end;   															{End for scroll handle not nil)}				SetPort(SavePort);     										{Restore the old port}			end;  																{End for window is us}	end;     																	{End of procedure}{=======================================================}	{Routine: Moved_BreedWindow}	{Purpose: We were moved, possibly to another screen and screen depth}	procedure Moved_BreedWindow;  									{Moved this window}		var			SavePort: WindowPtr;   										{Place to save the last port}	begin		if (WPtr_BreedWindow = whichWindow) then 				{Only do if the window is us}			begin				GetPort(SavePort);     										{Save the current port}				SetPort(WPtr_BreedWindow);    							{Set the port to my window}				U_Moved_BreedWindow(OldRect);   						{Call the user window moved routine}				SetPort(SavePort);     										{Restore the old port}			end;  																{End for window is us}	end;     																	{End of procedure}{=======================================================}	{Routine: UpDate_BreedWindow}	{Purpose: Update our window}	procedure UpDate_BreedWindow;		var			SavePort: WindowPtr;   										{Place to save the last port}	begin		if (WPtr_BreedWindow <> nil) and (WPtr_BreedWindow = whichWindow) then{Handle the update to our window}			begin				GetPort(SavePort);     										{Save the current port}				SetPort(WPtr_BreedWindow);   							{Set the port to my window}				U_Update_BreedWindow;  									{Call the user window update routine}				DrawControls(WPtr_BreedWindow);    					{Draw all the controls}				SetPort(SavePort);     										{Restore the old port}			end;  																{End for if (MyWindow<>nil)}	end;     																	{End of procedure}{=======================================================}	{Routine: Open_BreedWindow}	{Purpose: Open our window}	procedure Open_BreedWindow;		var			theLong: longint;   												{Used for HotSpot setup}	begin		if (WPtr_BreedWindow = nil) then   							{See if already opened}			begin				WPtr_BreedWindow := GetNewCWindow(Res_W_BreedWindow, nil, Pointer(-1));{Get the window from the resource file}				SetPort(WPtr_BreedWindow);    							{Prepare to write into our window}				U_Open_BreedWindow;     									{Call the users window open routine}				ShowWindow(WPtr_BreedWindow); 						{Show the window now}			end    															{End for if (MyWindow<>nil)}		else			SelectWindow(WPtr_BreedWindow);     					{Already open, so show it}	end; 																	{End of procedure}{=======================================================}	{Routine: Activate_BreedWindow}	{Purpose: We activated or deactivated.}	procedure Activate_BreedWindow;    								{Activated or deactivated this window}		var			SavePort: WindowPtr;   										{Place to save the last port}	begin		if (WPtr_BreedWindow = whichWindow) then 				{Only do if the window is us}			begin				GetPort(SavePort);     										{Save the current port}				SetPort(WPtr_BreedWindow);    							{Set the port to my window}				if (Do_An_Activate) then 									{Handle the activate}					begin					end     														{End for activate}				else					begin   														{Start of deactivate}						if (theInput <> nil) then 									{See if there is already a TE area}							TEDeactivate(theInput); 								{Yes, so turn it off}						theInput := nil;  											{Deactivate the TE area}					end;    														{End for deactivate}				U_Activate_BreedWindow(Do_An_Activate);  			{Call the user window activate routine}				SetPort(SavePort);     										{Restore the old port}			end;  																{End for window is us}	end;     																	{End of procedure}{=======================================================}	{Routine: Do_BreedWindow}	{Purpose: Handle action to our window, like controls}	procedure Do_BreedWindow;		var			code: integer;   													{Location of event in window or controls}			whichWindow: WindowPtr;    									{Window pointer where event happened}			myPt: Point;     													{Point where event happened}			theControl: ControlHandle;    									{Handle for a control}	begin     																{Start of Window handler}		if (WPtr_BreedWindow <> nil) then 							{Handle only when the window is valid}			begin				code := FindWindow(myEvent.where, whichWindow);{Get where in window and which window}				if (WPtr_BreedWindow = whichWindow) then					U_DoEvent_BreedWindow(myEvent);				if (myEvent.what = MouseDown) and (WPtr_BreedWindow = whichWindow) then					begin						myPt := myEvent.where;  								{Get mouse position}						GlobalToLocal(myPt);   									{Make it relative}					end;			end;   															{End for if (MyWindow<>nil)}	end; 																	{End of procedure}	{=================================}end.    																		{End of unit}