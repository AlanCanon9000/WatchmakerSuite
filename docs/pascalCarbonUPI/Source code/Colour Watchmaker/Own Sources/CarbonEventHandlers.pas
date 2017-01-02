unit CarbonEventHandlers;

interface

uses MacOSAll, PCommonExhibition, PD_About_Box, Biomorphs, PD_Timing_Dialogue, Common_Exhibition;


function CommandHandler(nextHandler: EventHandlerCallRef; theEvent: EventRef; userData: Pointer): OSSTatus;MWPascal;


implementation



function CommandHandler(nextHandler: EventHandlerCallRef; theEvent: EventRef; userData: Pointer): OSSTatus;MWPascal;
var 
	status: OSStatus;
	theCommand: HICommand;
begin
	status := NoErr;
	GetEventParameter(theEvent, kEventParamDirectObject, typeHICommand, nil, sizeof(HICommand), nil, @theCommand);
	case theCommand.commandID of
		kCoulCmdAppleAbout: M_PD_About_Box;
		kCoulCmdFileTiming: M_PD_Timing_Dialogue;
		kCoulCmdOperBreed: DoBreed;
		kCoulCmdOperNewRandom: 
			begin
				EraseRect(BusinessPart);
				
				DoSaltation(BreedWin)
			end;
		kHICommandQuit: status := eventNotHandledErr;
	end;
	CommandHandler := status;
end;

end.