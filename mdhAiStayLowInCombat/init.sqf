/////////////////////////////////////////////////////////////////////////////////////////////
// MDH AI STAY LOW IN COMBAT(by Moerderhoschi) - v2025-03-19
// github: https://github.com/Moerderhoschi/arma3_mdhAiStayLowInCombat
// steam mod version: https://steamcommunity.com/sharedfiles/filedetails/?id=3447902000
/////////////////////////////////////////////////////////////////////////////////////////////
if (missionNameSpace getVariable ["pAiStayLowInCombat",99] == 99 && {missionNameSpace getVariable ["pAvoidAiLayingDown",0] == 0}) then
{
	0 spawn
	{
		_valueCheck = 99;
		_defaultValue = 99;
		_path = 'mdhAiStayLowInCombat';
		_env  = isServer;

		_diary  = 0;
		_mdhFnc = 0;		
		
		if (hasInterface) then
		{
			_diary =
			{
				waitUntil {!(isNull player)};
				_c = true;
				_t = "MDH AI Stay Low in Combat";
				if (player diarySubjectExists "MDH Mods") then
				{
					{
						if (_x#1 == _t) exitWith {_c = false}
					} forEach (player allDiaryRecords "MDH Mods");
				}
				else
				{
					player createDiarySubject ["MDH Mods","MDH Mods"];
				};
		
				if(_c) then
				{
					player createDiaryRecord
					[
						"MDH Mods",
						[
							_t,
							(
							  '<br/>MDH AI Stay Low in Combat is a mod, created by Moerderhoschi for Arma 3.<br/>'
							+ '<br/>'
							+ 'This addon let AI units stay low in combat situations.<br/>'
							+ '<br/>'
							+ 'If you have any question you can contact me at the steam workshop page.<br/>'
							+ '<br/>'
							+ '<img image="'+_path+'\mdhAiStayLowInCombat.paa"/><br/>'
							+ '<br/>'
							+ 'Credits and Thanks:<br/>'
							+ 'Armed-Assault.de Crew - For many great ArmA moments in many years<br/>'
							+ 'BIS - For ArmA3<br/>'
							)
						]
					]
				};
				true
			};
		};

		if (_env) then
		{
			_mdhFnc =
			{
				{
					if (alive _x && {vehicle _x == _x} && {!(_x in allPlayers)} && {unitPos _x != "Up"}) then
					{
						if (behaviour _x == "COMBAT") then
						{
							if (speed _x > 2) then {_x setUnitPos "MIDDLE"} else {_x setUnitPos "DOWN"}
						}
						else
						{
							_x setUnitPos "AUTO";
						};
					};
				} foreach allUnits;
			};
		};

		if (hasInterface) then
		{
			uiSleep 2.25;
			call _diary;
		};

		_diaryTimer = 10;
		sleep (3 + random 2);
		while {missionNameSpace getVariable ["pAiStayLowInCombat",_defaultValue] == _valueCheck && {missionNameSpace getVariable ["pAvoidAiLayingDown",0] == 0}} do
		{
			if (_env) then {call _mdhFnc};
			sleep (4 + random 2);
			if (time > _diaryTimer && {hasInterface}) then {call _diary; _diaryTimer = time + 10};
		};					
	};
};
