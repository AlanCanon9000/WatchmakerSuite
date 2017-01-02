unit Breeding_Window;{File name: Breeding_Window.Pas}{Function: Handle a Window}{History: 12/15/90 Original by Prototyper.   }interface	uses		MyGlobals, Ted;	{Initialize us so all our routines can be activated}	procedure Init_Breeding_Window;	{Close our window}	procedure Close_Breeding_Window (whichWindow: WindowPtr; var theInput: TEHandle);	{Open our window and draw everything}	procedure Open_Breeding_Window (var theInput: TEHandle);	{Update our window, someone uncovered a part of us}	procedure Update_Breeding_Window (whichWindow: WindowPtr);	{Handle action to our window, like controls}	procedure Do_Breeding_Window (myEvent: EventRecord; var theInput: TEHandle);	{Handle resizing scrollbars}	procedure Resized_Breeding_Window (OldRect: Rect; whichWindow: WindowPtr);implementation	var		MyWindow: WindowPtr;   		{Window pointer}		tempRect, temp2Rect: Rect;  	{Temporary rectangle}		Index: Integer;    			{For looping}		ScrollHHandle, ScrollVHandle: controlhandle;{Scrolling Control handles}		CtrlHandle: ControlHandle;{Control handle}		sTemp: Str255; 				{Get text entered, temp holding}{=================================}	{Initialize us so all our routines can be activated}	procedure Init_Breeding_Window;	begin   								{Start of Window initialize routine}		MyWindow := nil;  				{Make sure other routines know we are not valid yet}		ScrollHHandle := nil; 			{Make sure other routines know we are not valid yet}		ScrollVHandle := nil; 			{Make sure other routines know we are not valid yet}	end;    								{End of procedure}{=================================}	{Close our window}	procedure Close_Breeding_Window;	begin   								{Start of Window close routine}		if (MyWindow <> nil) and ((MyWindow = whichWindow) or (ord4(whichWindow) = -1)) then{See if we should close this window}			begin				DisposeWindow(MyWindow);{Clear window and controls}				MyWindow := nil;    		{Make sure other routines know we are open}			end;    						{End for if (MyWindow<>nil)}	end;    								{End of procedure}{=================================}	{We were resized or zoomed, update the scrolling scrollbars}	procedure Resized_Breeding_Window;  	{Resized this window}		var			SavePort: WindowPtr;   		{Place to save the last port}			temp2Rect: Rect;   			{temp rectangle}			Index: integer;    			{temp integer}	begin   								{Start of Window resize routine}		if (MyWindow = whichWindow) then{Only do if the window is us}			begin				GetPort(SavePort);  		{Save the current port}				SetPort(MyWindow);  		{Set the port to my window}				if (ScrollHHandle <> nil) then{Only do if the control is valid}					begin						HLock(Handle(ScrollHHandle));{Lock the handle while we use it}						tempRect := ScrollHHandle^^.contrlRect;{Get the last control position}						tempRect.Top := tempRect.Top - 4;{Widen the area to update}						tempRect.Right := tempRect.Right + 16;{Widen the area to update}						InvalRect(tempRect);{Flag old position for update routine}						tempRect := ScrollHHandle^^.contrlRect;{Get the last control position}						temp2Rect := MyWindow^.PortRect;{Get the window rectangle}						Index := temp2Rect.Right - temp2Rect.Left - 13;{Get the scroll area width}						tempRect.Left := 0;  	{Pin at left edge}						HideControl(ScrollHHandle);{Hide it during size and move}						SizeControl(ScrollHHandle, Index, 16);{Make it 16 pixels high, std width}						MoveControl(ScrollHHandle, tempRect.Left - 1, temp2Rect.bottom - temp2Rect.top - 15);{Size it correctly}						ShowControl(ScrollHHandle);{Safe to show it now}						HUnLock(Handle(ScrollHHandle));{Let it float again}					end;    					{End for scroll handle not nil)}				if (ScrollVHandle <> nil) then{Only do if the control is valid}					begin						HLock(Handle(ScrollVHandle));{Lock the handle while we use it}						tempRect := ScrollVHandle^^.contrlRect;{Get the last control position}						tempRect.Left := tempRect.Left - 4;{Widen the area to update}						tempRect.Bottom := tempRect.Bottom + 16;{Widen the area to update}						InvalRect(tempRect);{Flag old position for update routine}						tempRect := ScrollVHandle^^.contrlRect;{Get the last control position}						temp2Rect := MyWindow^.PortRect;{Get the window rectangle}						Index := temp2Rect.bottom - temp2Rect.top - 13;{Get the scroll area height}						tempRect.Top := 0;   	{Pin at top edge}						HideControl(ScrollVHandle);{Hide it during size and move}						SizeControl(ScrollVHandle, 16, Index);{Make it 16 pixels wide, std height}						MoveControl(ScrollVHandle, temp2Rect.right - temp2Rect.Left - 15, tempRect.Top - 1);{Size it correctly}						ShowControl(ScrollVHandle);{Safe to show it now}						HUnLock(Handle(ScrollVHandle));{Let it float again}					end;    					{End for scroll handle not nil)}				SetPort(SavePort);  		{Restore the old port}			end;    						{End for window is us}	end;    						{End of procedure}		{=================================}			{Update our window, someone uncovered a part of us}	procedure UpDate_Breeding_Window;		var			SavePort: WindowPtr;{Place to save the last port}	begin   						{Start of Window update routine}		if (MyWindow <> nil) and (MyWindow = whichWindow) then{Handle an open when already opened}			begin				GetPort(SavePort);{Save the current port}				SetPort(MyWindow);{Set the port to my window}				if resizing then					begin						cliprect(screenbits.bounds);						EraseRect(myWindow^.portrect);					end;				SelectWindow(myWindow);				DrawControls(MyWindow);{Draw all the controls}				DrawGrowIcon(MyWindow);{Draw the Grow box}				UpDateAnimals;				SetPort(SavePort);{Restore the old port}			end;    				{End for if (MyWindow<>nil)}	end;    						{End of procedure}		{=================================}			{Open our window and draw everything}	procedure Open_Breeding_Window;		var			Index: Integer;    	{For looping}			dataBounds: Rect;  	{For making lists}			cSize: Point;  		{For making lists}	begin   						{Start of Window open routine}		if (MyWindow = nil) then{Handle an open when already opened}			begin				MyWindow := GetNewWindow(2, nil, Pointer(-1));{Get the window from the resource file}				SetPort(MyWindow);{Prepare to write into our window}				ShowWindow(MyWindow);{Show the window now}				SelectWindow(MyWindow);{Bring our window to the front}			end 					{End for if (MyWindow<>nil)}		else			SelectWindow(MyWindow);{Already open, so show it}		BreedingWindow := MyWindow;	end;    						{End of procedure}		{=================================}			{Handle action to our window, like controls}	procedure Do_Breeding_Window;		var			RefCon: longint; 		{RefCon for controls}			code: integer;   		{Location of event in window or controls}			theValue: integer;   	{Current value of a control}			whichWindow: WindowPtr;{Window pointer where event happened}			myPt: Point; 			{Point where event happened}			theControl: ControlHandle;{Handle for a control}			MyErr: OSErr;    		{OS error returned}	begin   						{Start of Window handler}		if (MyWindow <> nil) then{Handle only when the window is valid}			begin				code := FindWindow(myEvent.where, whichWindow);{Get where in window and which window}				if (myEvent.what = MouseDown) and (MyWindow = whichWindow) then{}					begin   			{}						myPt := myEvent.where;{Get mouse position}						with MyWindow^.portBits.bounds do{Make it relative}							begin								myPt.h := myPt.h + left;								myPt.v := myPt.v + top;							end;						evolve(myPt)					end;				if (MyWindow = whichWindow) and (code = inContent) then{for our window}					begin						code := FindControl(myPt, whichWindow, theControl);{Get type of control}						if (code <> 0) then{Check type of control}							code := TrackControl(theControl, myPt, nil);{Track the control}					end;    			{End for if (MyWindow=whichWindow)}			end;    				{End for if (MyWindow<>nil)}	end;    						{End of procedure}		{=================================}end.    						{End of unit}