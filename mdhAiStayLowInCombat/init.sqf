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
							+ '<font color="#33CC33"><execute expression = "[''mdhAiStayLowInCombatOldVersion01'',0,''MDH AI Stay low in Combat new Version activated''] call mdhAiStayLowInCombatBriefingFnc">New: AI get up behind Cover to engage enemy (performance intensive)</execute></font color>'
							+ '<br/>'
							+ 'or'
							+ '<br/>'
							+ '<font color="#33CC33"><execute expression = "[''mdhAiStayLowInCombatOldVersion01'',1,''MDH AI Stay low in Combat old Version activated''] call mdhAiStayLowInCombatBriefingFnc">Old: AI ignore Cover and stay low</execute></font color>'
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
				{
					if (alive _x && {vehicle _x == _x} && {!(_x in allPlayers)} && {unitPos _x != "UP" OR _x getVariable["mdhUnitPosUpTmp",0] == 1}) then
					{
						_x setVariable["mdhUnitPosUpTmp",0];
						if (behaviour _x == "COMBAT") then
						{
							if (speed _x > 2) then
							{
								_x setUnitPos "MIDDLE"
							}
							else
							{
								if (profileNameSpace getVariable["mdhAiStayLowInCombatOldVersion01",0] == 1) then
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
													_x setUnitPos "MIDDLE"
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
														_x setUnitPos "MIDDLE";
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
										_x setUnitPos "MIDDLE"
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
			mdhFncTmp = _mdhFnc;
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
