unit Edit3Menu; 															{Handle this menu list}

{Unit name:  Edit3Menu.p  }
{Function:  Handle this specific menu list.}
{ History: 20/6/91 Original by Prototyper 3.0   }

interface

	uses
		PCommonExhibition, Common_Exhibition,{Common}
		PUtils_Exhibition, Utils_Exhibition, biomorphs; {General Utilities}

	{Our menu handler}
	procedure Do_Edit3Menu (Doing_Pre: boolean; theItem: integer; var SkipProcessing: boolean);

implementation


{=======================================================}


	{Routine: Do_Edit3Menu}
	{Purpose: Handle any menu items in this list specially.}
	{		Get the main handler to ignore this menu item by changing}
	{		SkipProcessing   to be TRUE.}
	{		This routine is called before the main handler does anything}
	{		when Doing_Pre is TRUE, it is called after the main handler}
	{		again with Doing_Pre equal to FALSE.}

	procedure Do_Edit3Menu (Doing_Pre: boolean; theItem: integer; var SkipProcessing: boolean);{Handle this menu selection}
		var
			QErr: LongInt;
	begin     																{Start of procedure}
		{$ifc not undefined THINK_Pascal}
		SkipProcessing := FALSE;     									{Set to not skip the processing of this menu item}

		case theItem of     												{Handle all commands in this menu list}

			MItem_Copy4: 
				begin
					if (Doing_Pre) then
						begin
						end
					else
						begin
							Qerr := ZeroScrap;
							oldcount := Infoscrap^.ScrapCount;
							SendToClipBoard;
{DeskScrap is now false}
							oldcount := Infoscrap^.ScrapCount;
  {Recorded to see if changes before we are asked to Paste}
						end;
				end;

			kCoulMenuEditPaste: 
				begin
					if (Doing_Pre) then
						begin
						end
					else
						begin
							newCount := Infoscrap^.ScrapCount;
							if oldCount <> newCount then
								DeskScrap := true;
{there has been a DA pasting}
							doPaste;
						end;
				end;

			otherwise
				begin
				end;

		end;  																{End of item case}
	{FIXME}
	{$endc}
	end;     																	{End of procedure}


{=======================================================}


end.    																		{End of unit}