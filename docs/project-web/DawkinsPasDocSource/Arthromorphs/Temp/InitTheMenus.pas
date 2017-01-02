unit  InitTheMenus; {File name:  InitTheMenus.Pas}{Function: Pull in menu lists from a resource file.}{          This procedure is called once at program start.}{          AppleMenu is the handle to the Apple menu, it is also}{          used in the procedure that handles menu events.}{History: 1/4/91 Original by Prototyper.   }{                       }interface 	procedure Init_My_Menus;    		{Initialize the menus} var		AppleMenu:MenuHandle;   		{Menu handle}		M_File:MenuHandle;  			{Menu handle}		M_Edit:MenuHandle;  			{Menu handle}		M_Operation:MenuHandle; 		{Menu handle}		M_View:MenuHandle;  			{Menu handle} implementation 	procedure Init_My_Menus;    		{Initialize the menus}const		Menu1 = 1001;   				{Menu resource ID}		Menu2 = 1002;   				{Menu resource ID}		Menu3 = 1003;   				{Menu resource ID}		Menu4 = 1004;   				{Menu resource ID}		Menu5 = 1005;   				{Menu resource ID} begin   								{Start of Init_My_Menus}		ClearMenuBar;   				{Clear any old menu bars} 		{ This menu is the APPLE menu, used for About and desk accessories.}		AppleMenu := GetMenu(Menu1);{Get the menu from the resource file}		InsertMenu (AppleMenu,0);   	{Insert this menu into the menu bar}		AddResMenu(AppleMenu,'DRVR');{Add in DAs} 		M_File := GetMenu(Menu2);   	{Get the menu from the resource file}		InsertMenu (M_File,0);  		{Insert this menu into the menu bar} 		M_Edit := GetMenu(Menu3);   	{Get the menu from the resource file}		InsertMenu (M_Edit,0);  		{Insert this menu into the menu bar} 		M_Operation := GetMenu(Menu4);{Get the menu from the resource file}		InsertMenu (M_Operation,0);{Insert this menu into the menu bar} 		M_View := GetMenu(Menu5);   	{Get the menu from the resource file}		InsertMenu (M_View,0);  		{Insert this menu into the menu bar} 		DrawMenuBar;    				{Draw the menu bar} end;    								{End of procedure Init_My_Menus}end.    								{End of this unit}