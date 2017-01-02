unit  FileMenu;   															{Handle this menu list}{Unit name:  FileMenu.p  }{Function:  Handle this specific menu list.}{ History: 20/6/91 Original by Prototyper 3.0   }interfaceuses	PCommonExhibition, Common_Exhibition,{Common}	PUtils_Exhibition, Utils_Exhibition; {General Utilities}	{Our menu handler}	procedure Do_FileMenu(Doing_Pre:boolean; theItem:integer; var SkipProcessing:boolean);implementation{=======================================================}	{Routine: Do_FileMenu}	{Purpose: Handle any menu items in this list specially.}	{		Get the main handler to ignore this menu item by changing}	{		SkipProcessing   to be TRUE.}	{		This routine is called before the main handler does anything}	{		when Doing_Pre is TRUE, it is called after the main handler}	{		again with Doing_Pre equal to FALSE.}		procedure Do_FileMenu(Doing_Pre:boolean; theItem:integer; var SkipProcessing:boolean);{Handle this menu selection}		begin     																{Start of procedure}			SkipProcessing := FALSE;     									{Set to not skip the processing of this menu item}			case theItem of     												{Handle all commands in this menu list}				MItem_Timing:					begin					if (Doing_Pre) then						begin						end					else						begin						end;					end;				MItem_Quit2:					begin					if (Doing_Pre) then						begin						end					else						begin						end;					end;				otherwise					begin					end;			end;  																{End of item case}	end;     																	{End of procedure}{=======================================================}end.    																		{End of unit}