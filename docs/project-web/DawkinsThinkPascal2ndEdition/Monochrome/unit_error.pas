UNIT unit_error;{**************************************************}{* 	PURPOSE  : Error message alert tools						 							*}{*  	added for v1.1 for cases where we don't care about saving the bitmap 	*}{**************************************************}INTERFACE                           {Items visible to a host program}USES	Types, unit_miscellaneous;CONST	ErrorID = 999;            {Error alert box resource ID}TYPE	ErrorType = (StopError, NoteError, CautionError);PROCEDURE DisplayError (errNum: INTEGER; errMessage, errHelp: Str255; errKind: ErrorType);PROCEDURE IOError (errNum: INTEGER; helpMessage: Str255);IMPLEMENTATION          {Items not visible to a host program}uses Dialogs, TextUtils;PROCEDURE DisplayError;{Display error number, message, and help strings.}	VAR		errNumStr: Str255;		itemHit: INTEGER;	BEGIN		PositionDialog('ALRT', 999);		NumToString(errNum, errNumStr);		ParamText(errNumStr, errMessage, errHelp, '');		CASE errKind OF			StopError: 				itemHit := StopAlert(ErrorID, NIL);			NoteError: 				itemHit := NoteAlert(ErrorID, NIL);			CautionError: 				itemHit := CautionAlert(ErrorID, NIL)		END   {case}	END;  {DisplayError}PROCEDURE IOError;{Display message for this standard IOResult error number}	VAR		s: Str255;	BEGIN		CASE errNum OF			-33: 				s := 'File directory full';			-34: 				s := 'Volume allocation blocks full';			-35: 				s := 'Volume does not exist';			-36: 				s := 'Disk I/O error';			-37: 				s := 'Bad file or volume name';			-38: 				s := 'File not open';			-39: 				s := 'Unexpected end of file';			-40: 				s := 'Reference before start of file';			-41: 				s := 'System heap is full';			-42: 				s := 'Too many files open';			-43: 				s := 'File not found';			-44: 				s := 'Write protect tab open';			-45: 				s := 'File is locked';			-46: 				s := 'Volume locked';			-47: 				s := 'One or more files open';			-48: 				s := 'File already exists';			-49: 				s := 'Attempt to write to an already open file';			-50: 				s := 'No default volume';			-51: 				s := 'Bad file reference number';			-53: 				s := 'Volume not on line';			-54, -61: 				s := 'Writing not permitted';			-55: 				s := 'Volume already mounted and on line';			-56: 				s := 'Bad drive number';			-57: 				s := 'Not a Macintosh format directory';			-58: 				s := 'Problem in external file system';			-59: 				s := 'Cannot rename';			-60: 				s := 'Bad master directory block';			-108: 				s := 'Heap zone full';			-120: 				s := 'Directory not found';			-121: 				s := 'Too many directories open';			-122: 				s := 'Bad HFS command';			-123: 				s := 'Non HFS-directory';			-127: 				s := 'Internal file system error';			-128: 				s := 'Text file not open for input';			-129: 				s := 'Text file not open for output';			-130: 				s := 'Error in number';			OTHERWISE				BEGIN					s := 'Unknown error condition';					helpMessage := 'Suggest you check you system with a disk utility and try again'				END		END;  {case}		DisplayError(errNum, s, helpMessage, StopError)	END;  {IOError}END.  {ErrorUnit}