/////////////////////////////////////////////////////////////////////////////////////////////
// MDH AI STAY LOW IN COMBAT(by Moerderhoschi) - v2025-04-24
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
					mdhAiStayLowInCombatBriefingFnc =
					{
						if (isServer OR serverCommandAvailable "#logout") then
						{
							profileNameSpace setVariable[_this#0,_this#1];
							systemChat (_this#2);
							if (isMultiplayer && !isServer) then
							{
								missionNameSpace setVariable[_this#0,_this#1,true];
							};
						}
						else
						{
							systemChat "ONLY ADMIN CAN CHANGE OPTION";
						};
					};

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
							+ 'set Modversion: '
							+ '<br/>'
							+ '<font color="#33CC33"><execute expression = "[''mdhAiStayLowInCombatConfig'',2,''MDH AI Stay low in Combat: AI get up behind Cover to engage enemy but go back down if supressed by enemy fire activated''] call mdhAiStayLowInCombatBriefingFnc">AI get up behind Cover to engage enemy <br/>but go back down if supressed by enemy fire</execute></font color>'
							+ '<br/>'
							+ 'or'
							+ '<br/>'
							+ '<font color="#33CC33"><execute expression = "[''mdhAiStayLowInCombatConfig'',1,''MDH AI Stay low in Combat: AI get up behind Cover to engage enemy activated''] call mdhAiStayLowInCombatBriefingFnc">AI get up behind Cover to engage enemy</execute></font color>'
							+ '<br/>'
							+ 'or'
							+ '<br/>'
							+ '<font color="#33CC33"><execute expression = "[''mdhAiStayLowInCombatConfig'',0,''MDH AI Stay low in Combat: AI ignore Cover and always stay low activated''] call mdhAiStayLowInCombatBriefingFnc">AI ignore Cover and always stay low</execute></font color>'
							+ '<br/>'
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
				if (isDedicated) then
				{
					_v = missionNameSpace getVariable["mdhAiStayLowInCombatConfig",-1];
					if (_v != -1) then 
					{
						profileNameSpace setVariable["mdhAiStayLowInCombatConfig",_v];
						missionNameSpace setVariable["mdhAiStayLowInCombatConfig",nil,true];
					};
				};

				{
					if (alive _x && {vehicle _x == _x} && {!(_x in allPlayers)} && {unitPos _x != "UP" OR _x getVariable["mdhUnitPosUpTmp",0] == 1}) then
					{
						_x setVariable["mdhUnitPosUpTmp",0];
						if (behaviour _x == "COMBAT") then
						{
							if (profileNameSpace getVariable["mdhAiStayLowInCombatConfig",2] == 2) then
							{
								if !(_x getVariable["mdhAiStayLowInCombatSupressedEH",false]) then
								{
									_x setVariable["mdhAiStayLowInCombatSupressedEH",true];
									_x addEventHandler ["Suppressed",
									{
										params ["_unit", "_distance", "_shooter", "_instigator", "_ammoObject", "_ammoClassName", "_ammoConfig"];
										if (_distance < 2 && _unit getVariable["mdhUnitPosDownTmp",0] == 0) then
										{
											_unit setVariable["mdhUnitPosDownTmp",1];
											_unit setUnitPos "DOWN";
										};
									}];
								};
							};

							if
							(
								(profileNameSpace getVariable["mdhAiStayLowInCombatConfig",2] == 2) 
								&& {_x getVariable["mdhUnitPosDownTmp",1] == 1}
							)
							exitWith
							{
								_x setVariable["mdhUnitPosDownTmp",0];
								_x setUnitPos "DOWN";
							};

							if (speed _x > 2) then
							{
								_x setUnitPos "MIDDLE"
							}
							else
							{
								if (profileNameSpace getVariable["mdhAiStayLowInCombatConfig",2] == 0) then
								{
									_x setUnitPos "DOWN"
								}
								else
								{
									_e = getAttackTarget _x;
									if (!isNull _e) then
									{
										_a = getPosWorld _x;
										_p = [_a#0, _a#1, (_a#2) + 0.3];
										if (([_x,"VIEW",_e] checkVisibility [eyePos _e, _p]) == 0) then
										{
											_k = [_a#0, _a#1, (_a#2) + 1];
											if (([_x,"VIEW",_e] checkVisibility [eyePos _e, _k]) == 0) then
											{
												_s = [_a#0, _a#1, (_a#2) + 1.5];
												if (([_x,"VIEW",_e] checkVisibility [eyePos _e, _s]) == 0) then
												{
													_x setUnitPos "DOWN"
												}
												else
												{
													if ((getPosWorld _x) distance (_x getVariable["mdhUnitPosTmp2",[500,500,500]]) < 2) then
													{
														_x setUnitPos "UP";
														_x setVariable["mdhUnitPosUpTmp",1];
													}
													else
													{
														_x setUnitPos "DOWN";
													};
													_x setVariable["mdhUnitPosTmp2",(_x getVariable["mdhUnitPosTmp1",getPosWorld _x])];
													_x setVariable["mdhUnitPosTmp1",getPosWorld _x];
												};
											}
											else
											{
												_x setUnitPos "MIDDLE";
											};
										}
										else
										{
											_x setUnitPos "DOWN"
										};
									}
									else
									{
										_x setUnitPos "DOWN"
									};
								}
							}
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
