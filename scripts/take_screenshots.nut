// https://github.com/darnias/Vscripts/blob/master/scripts/take_screenshots.nut

// Purpose:
// Teleports player and takes a screenshot, loops until all coordinates have been visited.
// Automatically sets player -64 units on Z axis because of getpos wrong coordinates.

// Manual:
// Type "getpos" in console to get your current position and view angles.
// Copy that line and put it inside of POSITIONS following the example.
// Execute the script by typing "script_execute take_screenshots" in console.
// You can toggle between Jpeg and Tga by changing the boolean below.

JPEG <- true; // Uses JPEG if true, uses TGA if false

switch (GetMapName()){
	case "de_dust2": // Positions for de_dust2
	{
		POSITIONS <- [
		"setpos 1393.214844 2899.727783 181.817657;setang -1.029628 -132.739288 0.000000",
		"setpos 1636.009521 518.732788 120.176331;setang 0.752369 115.984680 0.000000",
		"setpos -411.184845 -968.474548 169.580078;setang 4.039162 120.974419 0.000000",
		]
		break;
	}
	case "de_example": // Positions for map de_example
	{
		POSITIONS <- [
		"setpos 0 0 0;setang 0 0 0",
		"setpos 0 0 0;setang 0 0 0",
		"setpos 0 0 0;setang 0 0 0",		
		]
		break;
	}
	default: // Default positions if map is not defined
	{
		POSITIONS <- [
		"setpos 0 0 0;setang 0 0 0",
		"setpos 0 0 0;setang 0 0 0",
		"setpos 0 0 0;setang 0 0 0",		
		]
		break;
	}
}

SCREENSHOT_N <- 0; // Screenshot number
function TakeScreenshots(){
	if (SCREENSHOT_N < POSITIONS.len()){
		SendToConsole(POSITIONS[SCREENSHOT_N]);
		SCREENSHOT_N++;
		printl("VSCRIPT SCREENSHOT: " + SCREENSHOT_N);
		EntFire("player", "RunScriptCode", "self.SetOrigin(self.GetOrigin() - Vector(0 , 0, 64))", 0.05, null);
		EntFire("worldspawn", "RunScriptCode", "TakePic()", 0.2, null);
		EntFire("worldspawn", "RunScriptCode", "TakeScreenshots()", 0.35, null);
	}
	else{
		printl("VSCRIPT SCREENSHOTS FINISHED");
		EntFire("player", "AddOutput", "movetype 2", 0, null);
	}
}

function TakePic(){
	if (JPEG){
		SendToConsole("jpeg "+GetMapName()+" 100"); // jpeg <name> <quality>
	}
	else{
		SendToConsole("screenshot"); // TGA
	}
}

printl("VSCRIPT SCREENSHOTS STARTED");
SendToConsole("hideconsole");
EntFire("player", "AddOutput", "movetype 0", 0, null);
TakeScreenshots();
