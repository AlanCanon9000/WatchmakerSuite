unit unit_about_box;{File name: About_Box}{Function: Handle a modal dialog}{ History: 20/6/91 Original by Prototyper 3.0   }interface	uses{$IFC UNDEFINED THINK_Pascal}		Dialogs, Events, {$ENDC}		unit_pcommon_exhibition, unit_common_exhibition, {Common and types}		unit_putils_exhibition, unit_utils_exhibition; {General Utilities}	{Init the modal dialog}	procedure D_Init_About_Box;	{Hook into the modal dialog filter routine}	function D_Filter_About_Box (theDialog: DialogPtr; var theEvent: EventRecord; var itemHit: integer): boolean;	{Refresh the modal dialog}	procedure D_Refresh_About_Box (theDialog: DialogPtr);	{Setup the modal dialog}	procedure D_Setup_About_Box (theDialog: DialogPtr);	{Hit in the modal dialog}	procedure D_Hit_About_Box (theDialog: DialogPtr; itemHit: integer; var ExitDialog: boolean);	{Exit the modal dialog}	procedure D_Exit_About_Box (theDialog: DialogPtr);{=======================================================}implementation{Routine: D_Init_About_Box}{Purpose: This routine is called while when the program is first run.}{	This is used for onetime initialization.}	procedure D_Init_About_Box;	begin     																{Start of init dialog}	end; 																	{End of procedure}{=======================================================}	{Routine: D_Filter_About_Box}	{Purpose: This routine is called while inside of the Modal Dialog filter}	{	theDialog is the dialog(alert) pointer}	{	theEvent is the event that we are to see if we should filter}	{	itemHit is the item we set if we handle the event ourselves}	function D_Filter_About_Box;	begin 																{Start of modal dialog filter hook}		D_Filter_About_Box := FALSE;   							{Let the modal routine handle it}	end;  																{End of function}{=======================================================}		{Routine: D_Refresh_About_Box}		{Purpose: Refresh the modal dialog}	procedure D_Refresh_About_Box;	begin  															{Start of Refresh dialog}	end;   															{End of procedure}{=======================================================}			{Routine: D_Setup_About_Box}			{Purpose: Setup the modal dialog}	procedure D_Setup_About_Box;	begin   														{Start of Setup dialog}	end;    														{End of procedure}{=======================================================}				{Routine: D_Hit_About_Box}				{Purpose: Hit in the modal dialog}	procedure D_Hit_About_Box;	begin    													{Start of Hit dialog}		if (ItemHit = Res_Dlg_OK2) then     				{Handle the Button being pressed}			begin			end;	end;     													{End of procedure}{=======================================================}					{Routine: D_Exit_About_Box}					{Purpose: Exit the modal dialog}	procedure D_Exit_About_Box;	begin     												{Start of Exit dialog}	end; 													{End of procedure}{=======================================================}end.    																		{End of unit}