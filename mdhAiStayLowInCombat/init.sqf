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
		_env  = true;

		_diary  = 0;
		_mdhFnc = 0;		

		if (hasInterface OR isDedicated) then
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
							+ '<img image="'+(if(isNil"_path")then{""}else{_path})+'\mdhAiStayLowInCombat.paa"/><br/>'
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

			if (isDedicated) then
			{
				_diary spawn
				{
					_diary = _this;
					missionNameSpace setVariable["mdhAiStayLowInCombatDiary",_diary,true];
					uiSleep 4;
					[{
						if (hasInterface) then
						{
							0 spawn mdhAiStayLowInCombatDiary;
						};
					}] remoteExec ["call", 0, true];
				};
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

				_cAllUnits = 0;
				_cAllAi = 0;
				_cAllCombat = 0;
				_cEHAdd = 0;
				_cExitWithDownSupressed = 0;
				_cSpeedBiggerTwo = 0;
				_cConf0 = 0;
				_cUnitPosAuto = 0;
				_cAttackTarget = 0;
				_cNoTarget = 0;
				_cUntiPosUpDefend = 0;
				_cVisProne = 0;
				_cVisKneel = 0;
				_cVisNoStance = 0;
				_cUntiPosDownDefend = 0;
				{
					_cAllUnits = _cAllUnits + 1;
					if (alive _x && {local _x} && {vehicle _x == _x} && {!(_x in allPlayers)} && {unitPos _x != "UP" OR _x getVariable["mdhUnitPosUpTmp",0] == 1}) then
					{
						_cAllAi = _cAllAi + 1;
						_x setVariable["mdhUnitPosUpTmp",0];
						if (behaviour _x == "COMBAT") then
						{
							_cAllCombat = _cAllCombat + 1;
							if (profileNameSpace getVariable["mdhAiStayLowInCombatConfig",2] == 2) then
							{
								if !(_x getVariable["mdhAiStayLowInCombatSupressedEH",false]) then
								{
									_x setVariable["mdhAiStayLowInCombatSupressedEH",true];
									_cEHAdd = _cEHAdd + 1;
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
								_cExitWithDownSupressed = _cExitWithDownSupressed + 1;
								_x setVariable["mdhUnitPosDownTmp",0];
								_x setUnitPos "DOWN";
							};

							if (speed _x > 2) then
							{
								_cSpeedBiggerTwo = _cSpeedBiggerTwo + 1;
								_x setUnitPos "MIDDLE";
							}
							else
							{
								if (profileNameSpace getVariable["mdhAiStayLowInCombatConfig",2] == 0) then
								{
									_cConf0 = _cConf0 + 1;
									_x setUnitPos "DOWN";
								}
								else
								{
									_e = getAttackTarget _x;
									if (!isNull _e) then
									{
										_cAttackTarget = _cAttackTarget + 1;
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
													_cVisNoStance = _cVisNoStance + 1;
													_x setUnitPos "DOWN";
												}
												else
												{
													if ((getPosWorld _x) distance (_x getVariable["mdhUnitPosTmp2",[500,500,500]]) < 2) then
													{
														_cUntiPosUpDefend = _cUntiPosUpDefend + 1;
														_x setUnitPos "UP";
														_x setVariable["mdhUnitPosUpTmp",1];
													}
													else
													{
														_cUntiPosDownDefend = _cUntiPosDownDefend + 1;
														_x setUnitPos "DOWN";
													};
													_x setVariable["mdhUnitPosTmp2",(_x getVariable["mdhUnitPosTmp1",getPosWorld _x])];
													_x setVariable["mdhUnitPosTmp1",getPosWorld _x];
												};
											}
											else
											{
												_cVisKneel = _cVisKneel + 1;
												_x setUnitPos "MIDDLE";
											};
										}
										else
										{
											_cVisProne = _cVisProne + 1;
											_x setUnitPos "DOWN";
										};
									}
									else
									{
										_cNoTarget = _cNoTarget + 1;
										_x setUnitPos "MIDDLE";
									};
								}
							}
						}
						else
						{
							_cUnitPosAuto = _cUnitPosAuto + 1;
							_x setUnitPos "AUTO";
						};
					};
				} foreach allUnits;
				//["AllUnits: "+str(_cAllUnits)+" / "+
				//"AllAiCond: "+str(_cAllAi)+" / "+
				//"AllCombat: "+str(_cAllCombat)+" / "+
				//"EHAdd: "+str(_cEHAdd)+" / "+
				//"ExitWithDownSupressed: "+str(_cExitWithDownSupressed)+" / "+
				//"SpeedBiggerTwo: "+str(_cSpeedBiggerTwo)+" / "+
				//"Conf0: "+str(_cConf0)+" / "+
				//"UnitPosAuto: "+str(_cUnitPosAuto)+" / "+
				//"AttackTarget: "+str(_cAttackTarget)+" / "+
				//"NoTarget: "+str(_cNoTarget)+" / "+
				//"UntiPosUpDefend: "+str(_cUntiPosUpDefend)+" / "+
				//"UntiPosDownDefend: "+str(_cUntiPosDownDefend)+" / "+
				//"VisProne: "+str(_cVisProne)+" / "+
				//"VisKneel: "+str(_cVisKneel)+" / "+
				//"VisNoStanceSoGoDown: "+str(_cVisNoStance)
				//] remoteExec ["systemChat", 0];
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
