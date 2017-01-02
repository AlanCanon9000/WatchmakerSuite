unit  Error_Alert;{File name:  Error_Alert.Pas  }{Function: Handle a Alert}{This is a CAUTION alert, it is used to inform the user that if the current path}{is taken then data may be lost.  The user can change the present course and}{save the data.  This is the type of alert used to tell the user that he needs to}{save the data before going on.}{This alert is called when:   }{   }{The choices in this alert allow for:   }{   }{History: 1/4/91 Original by Prototyper.   }{                       }interface	procedure A_Error_Alert;implementation	procedure A_Error_Alert;	const			I_Cancel = 1;			I_OK = 2;			I_x = 3;			I_x4 = 4;	var			itemHit : Integer;  		{Get the selection ID in here}	 	begin   							{Start of alert handler}	 			{Let the OS handle the Alert and wait for a result to be returned}			itemHit := CautionAlert(6, nil);{Bring in the alert resource}			 			{This is a button that may have been pressed.}			if (I_Cancel = itemHit) then{See if this item was selected}			begin   					{Start of handling if this was selected}			end;    					{End of handling if this was selected}			 			{This is a button that may have been pressed.}			{This is the default selection, when RETURN is pressed.}			if (I_OK = itemHit) then{See if this item was selected}			begin   					{Start of handling if this was selected}			end;    					{End of handling if this was selected}			 			 	end;    							{End of procedure}		end.    							{End of unit}	