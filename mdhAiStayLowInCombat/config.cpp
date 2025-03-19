class CfgPatches 
{
	class mdhAiStayLowInCombat
	{
		author = "Moerderhoschi";
		name = "MDH AI Stay low in Combat";
		url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3438379619";
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};
		version = "1.20160815";
		versionStr = "1.20160815";
		versionAr[] = {1,20160816};
		authors[] = {};
	};
};

class CfgFunctions
{
	class mdh
	{
		class mdhFunctions
		{
			class mdhAiStayLowInCombat
			{
				file = "mdhAiStayLowInCombat\init.sqf";
				postInit = 1;
			};
		};
	};
};

class CfgMods
{
	class mdhAiStayLowInCombat
	{
		dir = "@mdhAiStayLowInCombat";
		name = "MDH AI Stay low in Combat";
		picture = "mdhAiStayLowInCombat\mdhAiStayLowInCombat.paa";
		hidePicture = "true";
		hideName = "true";
		actionName = "Website";
		action = "https://steamcommunity.com/sharedfiles/filedetails/?id=3438379619";
	};
};