--Real Scl's new library
--the old library (c10199990.lua and c10199991.lua) has gone out of service, becuase it has become a SHIT MOUNTAIN, hard for reading.
--any problems, you can call me: QQ/VX 852415212, PLZ note sth. about YGO while you add me, otherwise I will reject your friend request.

local Version_Number = "2023.02.09"

--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Constant <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

--Library switch, ensure read the library only once.
if Scl_Library_Switch then 
	return 
end
Scl_Library_Switch = true 
--Print version number
Debug.Message("You are using Scl's library, Version: " .. Version_Number .. ".")
Debug.Message("If you find any script errors, call Scl to fix them.")
Debug.Message("His QQ/VX: 852415212, Email: 15161685390@163.com.")
--this table's contents can be used in anywhere, commonly be used for create effects, or be used in effect's condtions/costs/targets/operations.
Scl = { }
--this table's contents can be used in anywhere, commonly be used for registering effect's condtions/costs/targets/operations/values.
scl = { }
local id = 10100000
--this table's contents can only be used in this library. 
local s = { }
--Record Scl's custom card filter functions and group filter functions
Scl.Card = { }
Scl.Group = { }
--Value for inside series, inside type, etc.
Scl.String_Value   = { } 
--Record some cost's operate count.
Scl.Cost_Count= { }
--Record some operation's infomation.
Scl.Operation_Info = { }
--Record token
Scl.Token_List = { }
--Record attach effects, for 10170008 to repeat
Scl.Add_Additional_Effect_Before_Original_List = { } 
Scl.Add_Additional_Effect_List = { }
Scl.Add_Additional_Effect_Original_List  = { }
--For some creat effect functions. If = true, that function will only creat effects but not register them.
Scl.Creat_Effect_Without_Register = false 
--For some operate functions, check if they can operate
Scl.Operate_Check = 1
Scl.Operate_Check_Effect = nil
Scl.Operate_Check_Player = 0
Scl.Card_Target_Count_Check = 0
Scl.Player_Cost_And_Target_Value = { }
--Use for checking current effect 
Scl.Current_Effect = nil
--Record previous inside series
Scl.Previous_Series_List = { }
--Record global effects
Scl.Global_Effet_List = { } 
--Record reason for some operate
Scl.Reason_List = { }
--Record card's activate
Scl.Activate_List = { }
--When register property, add this additional property in
Scl.Global_Property = 0
--Record buffs for Scl.SpecialSummon/ Scl.Equip
Scl.Single_Buff_List = { }
Scl.Single_Buff_Affect_Self_List = { }
Scl.Equip_Buff_List = { }
--Record official filters 
Scl.Official_Filter = { }
--Use for scl.value_reason
Scl.Global_Reason = nil
--Use for Scl.SpecialSummonStep to call Scl.AddSingleBuff
Scl.Global_Zone = nil
--Use for Scl.SetExtraSelectAndOperateParama
Scl.Extra_Operate_Parama_Check_Hint = would_hint
Scl.Extra_Operate_Parama_Need_Break = need_break
Scl.Extra_Operate_Parama_Select_Hint = sel_hint
--Use for Scl.CreateActivateEffect_Activate1ofTheseEffects
Scl.Choose_One_Effect_Condition_Index = nil
Scl.Choose_One_Effect_Select_Index = { }
--Use for Scl.GetPreviousXyzMaterials
Scl.Previous_Xyz_Material_List = { }
--Use for debug error message
Scl.Global_Effect_Owner_ID = nil

--Attach extra effect
EFFECT_ADDITIONAL_EFFECT_SCL  =   id + 100 
--Extra synchro material
EFFECT_EXTRA_SYNCHRO_MATERIAL_SCL =  id + 101 
--Extra xyz material
EFFECT_EXTRA_XYZ_MATERIAL_SCL   =   id + 102
--Utility Xyz Material
EFFECT_UTILITY_XYZ_MATERIAL_SCL =   id + 103 
--For c:CompleteProcedure()
EFFECT_COMPLETE_SUMMON_PROC_SCL = id + 104
--For c:SetMaterial()
EFFECT_SET_MATERIAL_SCL = id + 105
--For special buff: activate spell & trap form any zone
EFFECT_ACTIVATE_SPELL_AND_TRAP_FROM_ANY_ZONE_SCL = id + 106


--Event for any set operation
EVENT_SET_SCL  =   id + 200 
--Flag for previous inside series 
FLAG_PREVIOUS_SERIES_SCL	=   id + 300
--Flag for phase operate 
FLAG_PHASE_OPERATE_SCL = id + 301
--Flag for previous xyz materials
FLAG_PREVIOUS_XYZ_MATERIAL_SCL = id + 302


RESET_EP_SCL  =   RESET_PHASE + PHASE_END  
RESET_SP_SCL = RESET_PHASE + PHASE_STANDBY 
RESET_BP_SCL = RESET_PHASE + PHASE_BATTLE 
RESETS_SCL  =   RESET_EVENT + RESETS_STANDARD 
RESETS_DISABLE_SCL   =   RESET_EVENT + RESETS_STANDARD + RESET_DISABLE 
RESETS_WITHOUT_TO_FIELD_SCL = RESETS_SCL - RESET_TOFIELD 
RESETS_EP_SCL =   RESETS_SCL +  RESET_EP_SCL 
RESETS_REDIRECT_SCL =   RESET_EVENT + RESETS_REDIRECT 


DESC_SPSUMMON_BY_SELF_PROC_SCL = aux.Stringid(id, 0) 
DESC_PHASE_OPERATION_SCL = aux.Stringid(id, 1) 
DESC_DARK_TUNER_SCL = aux.Stringid(id, 2)
DESC_DARK_SYNCHRO_SCL = aux.Stringid(id, 3)
HINTMSG_EXTRA_EFFECT_CARD_SCL = aux.Stringid(id, 4)
HINTMSG_EXTRA_EFFECT_SCL = aux.Stringid(id, 5)
HINTMSG_WOULD_TO_DECK_SCL = aux.Stringid(id, 6)
HINTMSG_WOULD_CHANGE_POSITION_SCL = aux.Stringid(id, 7)
DESC_NEGATE_SUMMON_SCL = aux.Stringid(id, 8)
DESC_PLACE_TO_FIELD_SCL = aux.Stringid(id, 9)
DESC_ACTIVATE_SCL = aux.Stringid(id, 10)
DESC_ACTIVATE_SPELL_AND_TRAP_FROM_ANY_ZONE_SCL = aux.Stringid(id, 11)
HINTMSG_OPERATE_COUNT_SCL = aux.Stringid(id, 12)
HINTMSG_WOULD_SET_SCL = aux.Stringid(id, 13)
DESC_RESET_COPY_SCL = aux.Stringid(14017402, 1)


TYPEM_EXTRA_SCL = TYPE_FUSION + TYPE_SYNCHRO + TYPE_XYZ + TYPE_LINK 
TYPEM_RFSXL_SCL = TYPEM_EXTRA_SCL + TYPE_RITUAL
TYPEM_PFSXL_SCL = TYPEM_EXTRA_SCL + TYPE_PENDULUM
TYPEM_RPFSXL_SCL = TYPEM_EXTRA_SCL + TYPE_RITUAL + TYPE_PENDULUM
TYPE_NORMAL_SPELL_OR_TRAP_SCL = 0x10000000


ZONE_HAND_SCL = LOCATION_HAND
ZONE_DECK_SCL = LOCATION_DECK
ZONE_MONSTER_SCL = LOCATION_MZONE
ZONE_SPELLANDTRAP_SCL = LOCATION_SZONE
ZONE_FIELD_SCL = LOCATION_ONFIELD
ZONE_BANISH_SCL = LOCATION_REMOVED
ZONE_GY_SCL = LOCATION_GRAVE
ZONE_FIELD_SCL = LOCATION_FZONE
ZONE_PENDULUMN_SCL = LOCATION_PZONE
ZONE_EXTRA_SCL = LOCATION_EXTRA
ZONE_XYZ_MATERIAL_SCL = LOCATION_OVERLAY


ZONEM_HAND_DECK_SCL = LOCATION_HAND + LOCATION_DECK
ZONEM_HAND_DECK_GY_SCL = LOCATION_HAND + LOCATION_DECK + LOCATION_GRAVE
ZONEM_DECK_GY_SCL = LOCATION_DECK + LOCATION_GRAVE
ZONEM_GY_BANISH_SCL = LOCATION_GRAVE + LOCATION_REMOVED
ZONEM_HAND_FIELD_SCL = LOCATION_HAND + LOCATION_ONFIELD
ZONEM_HAND_MONSTER_SCL = LOCATION_HAND + LOCATION_MZONE


--Hex to bin map
Scl.Hex_Bin_Map = {

	['0'] = "0000", ['1'] = "0001", ['2'] = "0010", ['3'] = "0011",
	['4'] = "0100", ['5'] = "0101", ['6'] = "0110", ['7'] = "0111",
	['8'] = "1000", ['9'] = "1001", ['A'] = "1010", ['B'] = "1011",
	['C'] = "1100", ['D'] = "1101", ['E'] = "1110", ['F'] = "1111"

}

--Zone map
Scl.Zone_Map = {
	
		0x0, 0x00000000, 0x00000000, 0x00000000, 0x10000000, 0x08000000, 0x04000000, 0x02000000, 0x01000000, 0x00000000, 0x00000000, 0x20000000, 0x0,
		0x0, 0x00000000, 0x80000000, 0x00000000, 0x00100000, 0x00080000, 0x00040000, 0x00020000, 0x00010000, 0x00000000, 0x40000000, 0x00000000, 0x0,
		
		0x0, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000020, 0x00000000, 0x00000040, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x0,
		
		0x0, 0x00000000, 0x04000000, 0x00000000, 0x00000001, 0x00000002, 0x00000004, 0x00000008, 0x00000010, 0x00000000, 0x00008000, 0x00000000, 0x0,
		0x0, 0x00002000, 0x00000000, 0x00000000, 0x00000100, 0x00000200, 0x00000400, 0x00000800, 0x00001000, 0x00000000, 0x00000000, 0x00000000, 0x0

}

--Zone list
Scl.Zone_List = {

	["Hand"] = LOCATION_HAND, ["Deck"] = LOCATION_DECK,
	["GY"] = LOCATION_GRAVE, ["Extra"] = LOCATION_EXTRA,
	["Banished"] = LOCATION_REMOVED, ["OnField"] = LOCATION_ONFIELD,
	["MonsterZone"] = LOCATION_MZONE, ["Spell&TrapZone"] = LOCATION_SZONE,
	["FieldZone"] = LOCATION_FZONE, ["PendulumZone"] = LOCATION_PZONE,
	["XyzMaterial"] = LOCATION_OVERLAY
	
}

--Reason list
Scl.Reason_List = {

	["Cost"] = REASON_COST, ["Effect"] = REASON_EFFECT,
	["Rule"] = REASON_RULE, ["Battle"] = REASON_BATTLE,
	["Material"] = REASON_MATERIAL, ["Tribute"] = REASON_RELEASE,
	["Ritual"] = REASON_RITUAL, ["Fusion"] = REASON_FUSION,
	["Synchro"] = REASON_SYNCHRO, ["Xyz"] = REASON_XYZ,
	["Link"] = REASON_LINK, ["Replace"] = REASON_REPLACE,
	["Return"] = REASON_RETURN, ["Draw"] = REASON_DRAW,
	["Discard"] = REASON_DISCARD, ["SpecialSummon"] = REASON_SPSUMMON,
	["Destroy"] = REASON_DESTROY, ["LoseTarget"] = REASON_LOST_TARGET,
	["LostXyzTarget"] = REASON_LOST_OVERLAY

}

--Phase list 
function s.phase_bp(phase)
	return phase >= PHASE_BATTLE_START and phase <= PHASE_BATTLE
end
function s.phase_damage_step(phase)
	return phase & PHASE_DAMAGE + PHASE_DAMAGE_CAL ~= 0
end
Scl.Phase_List = {

	["M1"] = PHASE_MAIN1, ["M2"] = PHASE_MAIN2, ["MP"] = PHASE_MAIN1 + PHASE_MAIN2,
	["DP"] = PHASE_DRAW, ["SP"] = PHASE_STANDBY, 
	["BP"] = s.phase_bp, ["BPStart"] = PHASE_BATTLE_START, ["BPEnd"] = PHASE_BATTLE,
	["BattleStep"] = PHASE_BATTLE_STEP, ["DamageStep"] = s.phase_damage_step, ["DamageCalculation"] = PHASE_DAMAGE_CAL,
	["EP"] = PHASE_END

}

--Card type list.
Scl.Card_Type_List   =   { 

	["Monster"] = TYPE_MONSTER, ["Normal"] = TYPE_NORMAL, ["Effect"] = TYPE_EFFECT, 
	["Dual"] = TYPE_DUAL, ["Union"] = TYPE_UNION, ["Toon"] = TYPE_TOON, 
	["Tuner"] = TYPE_TUNER, ["Ritual"] = TYPE_RITUAL, ["Fusion"] = TYPE_FUSION, 
	["Synchro"] = TYPE_SYNCHRO, ["Xyz"] = TYPE_XYZ, ["Link"] = TYPE_LINK, 
	["Token"] = TYPE_TOKEN, ["Pendulum"] = TYPE_PENDULUM, ["SpecialSummon"] = TYPE_SPSUMMON, 
	["Flip"] = TYPE_FLIP, ["Spirit"] = TYPE_SPIRIT, ["Spell"] = TYPE_SPELL, 
	["Equip"] = TYPE_EQUIP, ["Field"] = TYPE_FIELD, ["Continuous"] = TYPE_CONTINUOUS, 
	["QuickPlay"] = TYPE_QUICKPLAY, ["Trap"] = TYPE_TRAP, ["Counter"] = TYPE_COUNTER, 
	["TrapMonster"] = TYPE_TRAPMONSTER, ["NormalSpell"] = TYPE_SPELL + TYPE_NORMAL_SPELL_OR_TRAP_SCL,
	["NormalTrap"] = TYPE_TRAP + TYPE_NORMAL_SPELL_OR_TRAP_SCL

}
--add TYPE_NORMAL_SPELL_OR_TRAP_SCL to normal spells and normal traps
function s.add_type_normal_spell_or_trap_scl()
	local e1 = Scl.CreateFieldBuffEffect({ true, 0 }, "+Type", TYPE_NORMAL_SPELL_OR_TRAP_SCL, s.add_type_normal_spell_or_trap_scl_target, { 0xff, 0xff })
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_IGNORE_RANGE + EFFECT_FLAG_SET_AVAILABLE)
end
function s.add_type_normal_spell_or_trap_scl_target(e, c)
	return c:GetType() == TYPE_SPELL or c:GetType() == TYPE_TRAP
end

--Effect type list
--use for some functions that need to check activate effect's type.
Scl.Effect_Type_List = {

	["Spell"] = { TYPE_SPELL },
	["Trap"] = { TYPE_TRAP },
	["Monster"] = { TYPE_MONSTER },
	["Activate"] = { nil, EFFECT_TYPE_ACTIVATE },
	["TrapActivate"] = { TYPE_TRAP, EFFECT_TYPE_ACTIVATE },
	["SpellActivate"] = { TYPE_SPELL, EFFECT_TYPE_ACTIVATE },
	["All"] = { TYPE_SPELL + TYPE_TRAP + TYPE_MONSTER }

}

--Summon type list.
--use for some functions that need fo ergodic each summon type.
Scl.Summon_Type_List = {

	["SpecialSummon"] = SUMMON_TYPE_SPECIAL, 
	["TributeSummon"] = SUMMON_TYPE_ADVANCE, 
	["RitualSummon"] = SUMMON_TYPE_RITUAL,
	["FusionSummon"] = SUMMON_TYPE_FUSION, 
	["SynchroSummon"] = SUMMON_TYPE_SYNCHRO, 
	["XyzSummon"] = SUMMON_TYPE_XYZ,
	["LinkSummon"] = SUMMON_TYPE_LINK, 
	["PendulumSummon"] = SUMMON_TYPE_PENDULUM,
	["SpecialSummonBySelf"] = SUMMON_TYPE_SPECIAL + SUMMON_VALUE_SELF,
	["DualSummon"] = SUMMON_TYPE_DUAL, 
	["FlipSummon"] = SUMMON_TYPE_FLIP, 
	["NormalSummon"] = SUMMON_TYPE_NORMAL

}

--Timing list
function s.create_timing_list()
	
	Scl.Timing_List = {
	
	["FreeChain"] = { EVENT_FREE_CHAIN },
	["Adjust"] = { EVENT_ADJUST },
	["BreakEffect"] = { EVENT_BREAK_EFFECT },
	["DuringDP"] = { EVENT_PHASE + PHASE_DRAW },
	["DuringSP"] = { EVENT_PHASE + PHASE_STANDBY },
	["DuringMP"] = { EVENT_FREE_CHAIN, scl.cond_during_phase("MP") },
	["DuringM1"] = { EVENT_FREE_CHAIN, scl.cond_during_phase("M1") },
	["DuringBP"] = { EVENT_FREE_CHAIN, scl.cond_during_phase("BP") },
	["DuringM2"] = { EVENT_FREE_CHAIN, scl.cond_during_phase("M2") },
	["DuringEP"] = { EVENT_PHASE + PHASE_END },
	["BeMoved"] = { EVENT_MOVE },
	["BeSummoned"] = { EVENT_SUMMON_SUCCESS, aux.TRUE, aux.TRUE, EVENT_SPSUMMON_SUCCESS, aux.TRUE, aux.TRUE, EVENT_FLIP_SUMMON_SUCCESS, aux.TRUE, aux.TRUE },
	["BeNormalSummoned"] = { EVENT_SUMMON_SUCCESS },
	["BeSpecialSummoned"] = { EVENT_SPSUMMON_SUCCESS },
	["BeNormal/SpecialSummoned"] = { EVENT_SUMMON_SUCCESS, aux.TRUE, aux.TRUE, EVENT_SPSUMMON_SUCCESS, aux.TRUE, aux.TRUE },
	["BeRitualSummoned"] = { EVENT_SPSUMMON_SUCCESS, { Card.IsSummonType, SUMMON_TYPE_RITUAL } },
	["BeFusionSummoned"] = { EVENT_SPSUMMON_SUCCESS, { Card.IsSummonType, SUMMON_TYPE_FUSION } },
	["BeSynchroSummoned"] = { EVENT_SPSUMMON_SUCCESS, { Card.IsSummonType, SUMMON_TYPE_SYNCHRO } },
	["BeXyzSummoned"] = { EVENT_SPSUMMON_SUCCESS, { Card.IsSummonType, SUMMON_TYPE_XYZ } },
	["BePendulumSummoned"] = { EVENT_SPSUMMON_SUCCESS, { Card.IsSummonType, SUMMON_TYPE_PENDULUM } },
	["BeLinkSummoned"] = { EVENT_SPSUMMON_SUCCESS, { Card.IsSummonType, SUMMON_TYPE_LINK } },
	["BeFlipSummoned"] = { EVENT_FLIP_SUMMON_SUCCESS, { Card.IsSummonType, SUMMON_TYPE_FLIP } },
	["WouldBeSummoned"] = { EVENT_SUMMON, aux.TRUE, aux.TRUE, EVENT_SPSUMMON, aux.TRUE, aux.TRUE, EVENT_FLIP_SUMMON, aux.TRUE, aux.TRUE },
	["WouldBeNormalSummoned"] = { EVENT_SUMMON },
	["WouldBeSepcialSummoned"] = { EVENT_SPSUMMON },
	["WouldBeFlipSummoned"] = { EVENT_FLIP_SUMMON },
	["NegateSummon"] = { EVENT_SUMMON_NEGATED, aux.TRUE, aux.TRUE, EVENT_SPSUMMON_NEGATED, aux.TRUE, aux.TRUE, EVENT_FLIP_SUMMON_NEGATED, aux.TRUE, aux.TRUE },
	["NegateNomralSummon"] = { EVENT_SUMMON_NEGATED },
	["NegateSpecialSummon"] = { EVENT_SPSUMMON_NEGATED },
	["NegateFlipSummon"] = { EVENT_FLIP_SUMMON_NEGATED },
	["BeFlippedFaceup"] = { EVENT_FLIP },
	["DeclareAttack"] = { EVENT_ATTACK_ANNOUNCE },
	["BeAttackTarget"] = { EVENT_BE_BATTLE_TARGET },
	["AttackBeNegated"] = { EVENT_ATTACK_DISABLED },
	["AtStartOfDamageStep"] = { EVENT_BATTLE_START },
	["BeforeDamageCalculation"] = { EVENT_BATTLE_CONFIRM },
	["DuringDamageCalculation"] = { EVENT_PRE_DAMAGE_CALCULATE },
	["AfterDamageCalculation"] = { EVENT_BATTLED },
	["AtEndOfDamageStep"] = { EVENT_DAMAGE_STEP_END },
	["BeDestroyed"] = { EVENT_DESTROYED },
	["BeDestroyedByBattle"] = { EVENT_BATTLE_DESTROYED },
	["BeDestroyedByEffect"] = { EVENT_DESTROYED, { Scl.IsReason, 0, "Effect" } },
	["BeDestroyedByBattle/Effect"] = { EVENT_DESTROYED, { Scl.IsReason, 0, "Battle", "Effect" } },
	["BeDestroyed&Sent2GY"] = { EVENT_TO_GRAVE, { Scl.IsReason, 0, "Destroy" } },
	["BeDestroyedByBattle&Sent2GY"] = { EVENT_TO_GRAVE, { Scl.IsReason, "Destroy", "Battle" } },
	["BeDestroyedByEffect&Sent2GY"] = { EVENT_TO_GRAVE, { Scl.IsReason, "Destroy", "Effect" } },
	["BeDestroyedByBattle/Effect&Sent2GY"] = { EVENT_TO_GRAVE, { Scl.IsReason, "Destroy", "Battle", "Effect" } },
	["DestroyMonsterByBattle"] = { EVENT_BATTLE_DESTROYING, s.bdcon },
	["DestroyMonsterByBattle&Send2GY"] = { EVENT_BATTLE_DESTROYING, s.bdgcon  },
	["DestroyOpponent'sMonsterByBattle"] = { EVENT_BATTLE_DESTROYING, s.bdocon },
	["DestroyOpponent'sMonsterByBattle&Send2GY"] = { EVENT_BATTLE_DESTROYING, s.bdogcon },
	["BeSent2GY"] = { EVENT_TO_GRAVE },
	["BeSent2GYByEffect"] = { EVENT_TO_GRAVE, { Scl.IsReason, 0, "Effect" } },
	["BeSentFromField2GY"] = { EVENT_TO_GRAVE, { Scl.IsPreviouslyInZone, "OnField" } },
	["BeBanished"] = { EVENT_REMOVE },
	["Draw"] = { EVENT_DRAW },
	["Discard"] = { EVENT_DISCARD },
	["BeAdded2Hand"] = { EVENT_TO_HAND },
	["BeReturned2Deck"] = { EVENT_TO_DECK },
	["BeforeLeavingField"] = { EVENT_LEAVE_FIELD_P },
	["LeaveField"] = { EVENT_LEAVE_FIELD },
	["FaceupCardLeavesField"] = { EVENT_LEAVE_FIELD, { Card.IsPreviousPosition, POS_FACEUP } },
	["SetSpell/Trap"] = { EVENT_SSET },
	["BeSet"] = { EVENT_SET_SCL },
	["PositionBeChanged"] = { EVENT_CHANGE_POS },
	["BeforeBeUsedAsMaterial"] = { EVENT_BE_PRE_MATERIAL },
	["BeUsedAsMaterial"] = { EVENT_BE_MATERIAL },
	["BeUsedAsMaterial4FusionSummon"] = { EVENT_BE_MATERIAL, { Scl.IsReason, "Material", "Fusion" } },
	["BeUsedAsMaterial4FusionSummon&BeSent2GY"] = { EVENT_BE_MATERIAL, { s.material_to_gy_or_be_banished("Fusion", "GY") } },
	["BeUsedAsMaterial4FusionSummon&BeSent2GY/Banished"] = { EVENT_BE_MATERIAL, { s.material_to_gy_or_be_banished("Fusion", "GY,Banished") } },
	["BeUsedAsSynchroMaterial"] = { EVENT_BE_MATERIAL, { Scl.IsReason, "Material", "Synchro" } },
	["BeUsedAsSynchroMaterial&BeSent2GY"] = { EVENT_BE_MATERIAL, { s.material_to_gy_or_be_banished("Synchro", "GY") } },
	["BeUsedAsSynchroMaterial&BeSent2GY/Banished"] = { EVENT_BE_MATERIAL, { s.material_to_gy_or_be_banished("Synchro", "GY,Banished") } },
	["BeUsedAsMaterial4XyzSummon"] = { EVENT_BE_MATERIAL, { Scl.IsReason, "Material", "Xyz" } },
	["BeUsedAsLinkMaterial"] = { EVENT_BE_MATERIAL, { Scl.IsReason, "Material", "Link" } },
	["BeUsedAsLinkMaterial&BeSent2GY"] = { EVENT_BE_MATERIAL, { s.material_to_gy_or_be_banished("Link", "GY") } },
	["BeUsedAsLinkMaterial&BeSent2GY/Banished"] = { EVENT_BE_MATERIAL, { s.material_to_gy_or_be_banished("Link", "GY,Banished") } },
	["BeTributed"] = { EVENT_RELEASE },
	["BeEffectTarget"] = { EVENT_BECOME_TARGET },
	["ActivateEffect"] = { EVENT_CHAINING },	
	["BeforeEffectResolving"] = { EVENT_CHAIN_SOLVING },	
	["AfterEffectResolving"] = { EVENT_CHAIN_SOLVED },  
	["ChainEnd"] = { EVENT_CHAIN_END },
	["NegateActivation"] = { EVENT_CHAIN_NEGATED },
	["TakeDamage"] = { EVENT_DAMAGE },
	["YouTakeDamage"] = { EVENT_DAMAGE, scl.cond_check_rp(0) },
	["OpponentTakesDamage"] = { EVENT_DAMAGE, scl.cond_check_rp(1) },
	["InflictDamage2Opponent"] = { EVENT_DAMAGE, scl.cond_check_rp(1) },
	["TakeBattleDamage"] = { EVENT_BATTLE_DAMAGE },
	["YouTakeBattleDamage"] = { EVENT_BATTLE_DAMAGE, scl.cond_check_rp(0) },
	["OpponentTakesBattleDamage"] = { EVENT_DAMAGE, scl.cond_check_rp(1) },
	["TakeEffectDamage"] = { EVENT_DAMAGE, scl.cond_check_r(0, "Effect") },
	["YouTakeEffectDamage"] = { EVENT_DAMAGE, aux.AND(scl.cond_check_r(0, "Effect"), scl.cond_check_rp(0)) },
	["OpponentTakesEffectDamage"] = { EVENT_DAMAGE, aux.AND(scl.cond_check_r(0, "Effect"), scl.cond_check_rp(1)) }
	
	}

end
function s.material_to_gy_or_be_banished(reason, zone)
	return function(c)
		return Scl.IsInZone(c, zone) and Scl.IsReason(c, "Material", reason)
	end
end
function s.bdcon(e)
	local c = e:GetHandler()
	return not e:IsHasType(EFFECT_TYPE_SINGLE) or c:IsRelateToBattle()
end
function s.bdocon(e)
	local c = e:GetHandler()
	return s.bdcon(e) and c:IsStatus(STATUS_OPPO_BATTLE)
end
function s.bdgcon(e)
	local c = e:GetHandler()
	local bc = c:GetBattleTarget()
	return s.bdcon(e) and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function s.bdogcon(e)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return s.bdgcon(e) and c:IsStatus(STATUS_OPPO_BATTLE)
end

--Effet property list 
--use for some functions that creat effects.
Scl.Effect_Property_List =   { 
	
	["Target"] = EFFECT_FLAG_CARD_TARGET, 
	["PlayerTarget"] = EFFECT_FLAG_PLAYER_TARGET, 
	["Delay"] = EFFECT_FLAG_DELAY, 
	["DamageStep"] = EFFECT_FLAG_DAMAGE_STEP, 
	["DamageCalculation"] = EFFECT_FLAG_DAMAGE_CAL, 
	["IgnoreUnaffected"] = EFFECT_FLAG_IGNORE_IMMUNE, 
	["SetAvailable"] = EFFECT_FLAG_SET_AVAILABLE, 
	["IgnoreZone"] = EFFECT_FLAG_IGNORE_RANGE,
	["BuffZone"] = EFFECT_FLAG_SINGLE_RANGE, 
	["BothSide"] = EFFECT_FLAG_BOTH_SIDE, 
	["Uncopyable"] = EFFECT_FLAG_UNCOPYABLE, 
	["ClientHint"] = EFFECT_FLAG_CLIENT_HINT, 
	["LimitActivateZone"] = EFFECT_FLAG_LIMIT_ZONE, 
	["AbsoluteTarget"] = EFFECT_FLAG_ABSOLUTE_TARGET, 
	["SummonParama"] = EFFECT_FLAG_SPSUM_PARAM, 
	["EventPlayer"] = EFFECT_FLAG_EVENT_PLAYER, 
	["Oath"] = EFFECT_FLAG_OATH, 
	["NoTurnReset"] = EFFECT_FLAG_NO_TURN_RESET,
	["!NegateActivation"] = EFFECT_FLAG_CANNOT_INACTIVATE,
	["!NegateEffect"] = EFFECT_FLAG_CANNOT_DISABLE,
	["!NegateEffect2"] = EFFECT_FLAG_CANNOT_NEGATE

}   

--Creat effect category list (Scl.Category_List)
--the Scl.Category_List is using for some functions that creat effects or get a effect/select hint.
--the format of Scl.Category_List:
-- [Index_String] = { description, category, select_hint, effect_hint, would_do_hint, operation(fun, total_parama_len, parama1, ...) }
function s.extra_reason(exr)
	local f = function(r)
		return r | exr
	end
	Scl.Reason_List[f] = true 
	return f
end
function s.create_category_list()
	local sg = "solve_parama"
	local tp = "activate_player"
	local r = "reason"
	local e = "activate_effect"
	Scl.Category_List =   {

	["Destroy"] = { "Destroy", CATEGORY_DESTROY, HINTMSG_DESTROY, { 1571945, 0 }, { 20590515, 2 }, { Scl.Destroy, 3, sg, r } },
	["DestroyReplace"] = { "Destroy Replace", CATEGORY_DESTROY, HINTMSG_DESTROY, { 1571945, 0 }, { 20590515, 2 }, { Scl.Destroy, 3, sg, s.extra_reason(REASON_REPLACE) } },
	["Tribute"] = { "Tribute", CATEGORY_RELEASE, HINTMSG_RELEASE, { 33779875, 0 }, nil, { Scl.Tribute, 2, sg, r } },
	["Banish"] = { "Banish Face-Up", CATEGORY_REMOVE, HINTMSG_REMOVE, { 612115, 0 }, { 93191801, 2 }, { Scl.Banish, 3, sg, POS_FACEUP, r } },
	["BanishFacedown"] = { "Banish Face-Down", CATEGORY_REMOVE, HINTMSG_REMOVE, { 612115, 0 }, { 93191801, 2 }, { Scl.Banish, 3, sg, POS_FACEDOWN, r } },
	["Search"] = { "Search", CATEGORY_SEARCH, 0, { 135598, 0 } },
	["Add2Hand"] = { "Add to Hand", CATEGORY_TOHAND, HINTMSG_ATOHAND, { 1249315, 0 }, { 26118970, 1 }, { Scl.Send2Hand, 4, sg, nil, r } },
	["AddFromDeck2Hand"] = { "Add from Deck to Hand", { CATEGORY_SEARCH, CATEGORY_TOHAND }, HINTMSG_ATOHAND, { 1249315, 0 }, { 26118970, 1 }, { Scl.Send2Hand, 4, sg, nil, r } },
	["AddFromGY2Hand"] = { "Add from GY to Hand", { CATEGORY_GRAVE_ACTION, CATEGORY_TOHAND }, HINTMSG_ATOHAND, { 1249315, 0 }, { 26118970, 1 }, { Scl.Send2Hand, 4, sg, nil, r } },
	["AddFromDeck/GY2Hand"] = { "Add from GY to Hand", { CATEGORY_GRAVE_ACTION, CATEGORY_SEARCH, CATEGORY_TOHAND }, HINTMSG_ATOHAND, { 1249315, 0 }, { 26118970, 1 }, { Scl.Send2Hand, 4, sg, nil, r } },
	["Return2Hand"] = { "Return to Hand", CATEGORY_TOHAND, HINTMSG_RTOHAND, { 13890468, 0 }, { 9464441, 2 }, { Scl.Send2Hand, 4, sg, nil, r } },
	["ShuffleIn2Deck"] = { "Send to Deck", CATEGORY_TODECK, HINTMSG_TODECK, { 4779823, 1 }, HINTMSG_WOULD_TO_DECK_SCL, { Scl.Send2Deck, 4, sg, nil, 2, r } },
	["Look&ShuffleIn2Deck"] = { "Send to Deck", CATEGORY_TODECK, HINTMSG_TODECK, { 4779823, 1 }, HINTMSG_WOULD_TO_DECK_SCL, { Scl.LookAndSend2Deck, 4, sg, nil, 2, r } },
	["ShuffleIn2DeckTop"] = { "Shuffle into Deck-Top", CATEGORY_TODECK, HINTMSG_TODECK, { 55705473, 1 }, HINTMSG_WOULD_TO_DECK_SCL, { Scl.Send2Deck, 4, sg, nil, 2, r } },
	["ShuffleIn2DeckBottom"] = { "Shuffle into Deck-Bottom", CATEGORY_TODECK, HINTMSG_TODECK, { 55705473, 2 }, HINTMSG_WOULD_TO_DECK_SCL, { Scl.Send2Deck, 4, sg, nil, 0, r } },
	["PlaceOnDeckTop"] = { "Place on the top of the Deck", 0, { 45593826, 3 }, { 15521027, 3 }, 0, { Scl.PlaceOnDeckTopOrBottom, 3, sg, 0 } },
	["PlaceOnDeckBottom"] = { "Place on the bottom of the Deck",0, 0, { 15521027, 4}, 0, { Scl.PlaceOnDeckTopOrBottom, 3, sg, 1 } },
	["Return2Extra"] = { "Return to Extra", CATEGORY_TOEXTRA, HINTMSG_TODECK, { 4779823, 1 }, HINTMSG_WOULD_TO_DECK_SCL, { Scl.Send2Extra, 4, sg, nil, 2, r } },
	["ShuffleIn2Deck/ExtraAsCost"] = { "Return to Main or Extra as cost", CATEGORY_TODECK, HINTMSG_TODECK, { 4779823, 1 }, HINTMSG_WOULD_TO_DECK_SCL, { Scl.Send2DeckOrExtraAsCost, 4, sg, nil, 2, r } },
	["ShuffleIn2Deck&Draw"] = { "Shuffle into deck, and if you do, draw card(s)", CATEGORY_TODECK + CATEGORY_DRAW, HINTMSG_TODECK, { 4779823, 1 }, HINTMSG_WOULD_TO_DECK_SCL, { Scl.ShuffleIn2DeckAndDraw, 8, sg, nil, 2, tp, 1, r, false, false } },
	["Add2ExtraFaceup"] = { "Pendulum to Extra", CATEGORY_TOEXTRA, { 24094258, 3 }, { 18210764, 0 }, nil, { Scl.Send2ExtraP, 3, sg, nil, r } },
	["Send2GY"] = { "Send to Grave", CATEGORY_TOGRAVE, HINTMSG_TOGRAVE, { 1050186, 0 }, { 62834295, 2 }, { Scl.Send2Grave, 2, sg, r } },
	["Return2GY"] = { "Return to Grave", CATEGORY_TOGRAVE, { 48976825, 0 }, { 28039390, 1 }, 0, { Scl.Send2Grave, 2, sg, s.extra_reason(REASON_RETURN)} },
	["Discard2GY"] = { "Discard to Grave", { CATEGORY_HANDES, CATEGORY_TOGRAVE }, HINTMSG_DISCARD, { 18407024, 0 }, { 43332022, 1 }, { Scl.Send2Grave, 2, sg, s.extra_reason(REASON_DISCARD)} },
	["Discard"] = { "Discard Hand", CATEGORY_HANDES, HINTMSG_DISCARD, { 18407024, 0 }, { 43332022, 1 }, { s.discard_hand_special, 2, sg, r } },
	["DiscardWithFilter"] = { "Discard some cards meet filter", CATEGORY_HANDES, HINTMSG_DISCARD, { 18407024, 0 }, { 43332022, 1 }, { Scl.Send2Grave, 2, sg, s.extra_reason(REASON_DISCARD) } },
	["SendDeckTop2GY"] = { "Send Deck-Top to GY", CATEGORY_DECKDES, 0, { 13995824, 0 }, nil, { s.discard_deck_special, 2, sg, r } } ,
	["Draw"] = { "Draw", CATEGORY_DRAW, 0, { 4732017, 0 }, { 3679218, 1 }, { s.draw_special, 2, sg, r } },
	["Damage"] = { "Inflict/take Damage", CATEGORY_DAMAGE, 0, { 3775068, 0 }, { 12541409, 1 } },
	["GainLP"] = { "Gain LP", CATEGORY_RECOVER, 0, { 16259549, 0 }, { 54527349, 0 } },
	["NormalSummon"] = { "Normal Summon", CATEGORY_SUMMON, HINTMSG_SUMMON, { 65247798, 0 }, { 41139112, 0 }, { s.normal_summon, 6, sg, tp, true, nil } },
	["Token"] = { "Token", CATEGORY_TOKEN, 0, { 9929398, 0 }, { 2625939, 0 } },
	["SpecialSummon"] = { "Special Summon", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP } },
	["SpecialSummonToken"] = { "Special Summon", {CATEGORY_SPECIAL_SUMMON, CATEGORY_TOKEN}, HINTMSG_SPSUMMON, { 9929398, 0 }, { 2625939, 0 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP } },
	["SpecialSummonInFaceupDefensePosition"] = { "Special summon in defense position", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP_DEFENSE } },
	["SpecialSummonInFacedownDefensePosition"] = { "Special summon in defense position", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEDOWN_DEFENSE } },
	["IgnoreSummonCondition&SpecialSummon"] = { "Special summon ignore summon condition", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, true, false, POS_FACEUP } },
	["NegateEffect&SpecialSummon"] = { "Special summon, but negate its effects", { CATEGORY_SPECIAL_SUMMON, CATEGORY_DISABLE }, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { s.negate_effect_and_special_summon, 10, sg, 0, tp, tp, true, false, POS_FACEUP } },
	["SpecialSummonFromGY"] = { "Special Summon from GY", { CATEGORY_GRAVE_SPSUMMON, CATEGORY_SPECIAL_SUMMON }, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP } },
	["SpecialSummonFromDeck"] = { "Special Summon from deck", { CATEGORY_DECKDES, CATEGORY_SPECIAL_SUMMON }, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP } },
	["SpecialSummonFromExtra"] = { "Special Summon from extra", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP } },
	["SpecialSummonFromHand/Deck/GY"] = { "Special Summon from hand, deck and/or GY", { CATEGORY_DECKDES, CATEGORY_GRAVE_SPSUMMON, CATEGORY_SPECIAL_SUMMON }, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP } },
	["SpecialSummonFromDeck/GY"] = { "Special Summon from deck or GY", { CATEGORY_DECKDES, CATEGORY_GRAVE_SPSUMMON, CATEGORY_SPECIAL_SUMMON }, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP } },
	["SpecialSummonFromHand/GY"] = { "Special Summon from hand or GY", { CATEGORY_GRAVE_SPSUMMON, CATEGORY_SPECIAL_SUMMON }, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP } },
	["SpecialSummonFromDeck/Extra"] = { "Special Summon from Deck or Extra", { CATEGORY_DECKDES, CATEGORY_SPECIAL_SUMMON }, HINTMSG_SPSUMMON, { 74892653, 2 }, { 17535764, 1 }, { Scl.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP } },
	["RitualSummon"] = { "Ritual Summon", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 59514116, 1 } },
	["FusionSummon"] = { "Fusion Summon", { CATEGORY_FUSION_SUMMON, CATEGORY_SPECIAL_SUMMON }, HINTMSG_SPSUMMON, { 7241272, 1 } },
	["SynchroSummon"] = { "Synchro Summon", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 30983281, 1 }, { 27503418, 0 } },
	["XyzSummon"] = { "Xyz Summon", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 197042, 0 } },
	["LinkSummon"] = { "Link Summon", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 65741786, 0 } },
	["ChangeLevel"] = { "Change level", 0, { 88875132, 2 }, { 3606728, 0 }, { 19301729, 2 } },
	["ChangePosition"] = { "Change Position", CATEGORY_POSITION, HINTMSG_POSCHANGE, { 3648368, 0 }, HINTMSG_WOULD_CHANGE_POSITION_SCL, { Scl.ChangePosition, 7, sg } },
	["Change2AttackPosition"] = { "Change to POS_FACEUP_ATTACK", CATEGORY_POSITION, HINTMSG_POSCHANGE, { 359563, 0 }, HINTMSG_WOULD_CHANGE_POSITION_SCL, { Scl.ChangePosition, 7, sg, POS_FACEUP_ATTACK } },
	["Change2DefensePosition"] = { "Change to POS_DEFENSE", CATEGORY_POSITION, HINTMSG_SET, { 359563, 0 }, HINTMSG_WOULD_CHANGE_POSITION_SCL, { Scl.ChangePosition, 7, sg, POS_DEFENSE } },
	["Change2FaceupDefensePosition"] = { "Change to POS_FACEUP_DEFENSE", CATEGORY_POSITION, HINTMSG_POSCHANGE, { 52158283, 1 }, HINTMSG_WOULD_CHANGE_POSITION_SCL, { Scl.ChangePosition, 7, sg, POS_FACEUP_DEFENSE } },
	["Change2FacedownDefensePosition"] = { "Change to POS_FACEDOWN_DEFENSE", CATEGORY_POSITION, HINTMSG_SET, { 359563, 0 }, HINTMSG_WOULD_CHANGE_POSITION_SCL, { Scl.ChangePosition, 7, sg, POS_FACEDOWN_DEFENSE } },
	["ChangeControl"] = { "Change Control", CATEGORY_CONTROL, HINTMSG_CONTROL, { 4941482, 0 }, nil, { Scl.GetControl, 5, sg, tp, 0, 0, 0xff } },
	["SwitchControl"] = { "Switch Control", CATEGORY_CONTROL, HINTMSG_CONTROL, { 36331074, 0 } },
	["NegateEffect"] = { "Negate Effect", CATEGORY_DISABLE, HINTMSG_DISABLE, { 39185163, 1 }, { 25166510, 2 }, { Scl.NegateCardEffects, 3, sg, false, RESETS_SCL } },
	["NegateSummon"] = { "Negate Summon", CATEGORY_DISABLE_SUMMON, 0, DESC_NEGATE_SUMMON_SCL },
	["NegateFlipSummon"] = { "Negate Summon", CATEGORY_DISABLE_SUMMON, 0, DESC_NEGATE_SUMMON_SCL },
	["NegateSpecialSummon"] = { "Negate Summon", CATEGORY_DISABLE_SUMMON, 0, DESC_NEGATE_SUMMON_SCL },
	["NegateActivation"] = { "Negate Activation", CATEGORY_NEGATE, 0, { 19502505, 1 } },
	["Equip"] = { "Equip", CATEGORY_EQUIP, HINTMSG_EQUIP, { 68184115, 0 }, { 35100834, 0 }, { Scl.Equip, 4, sg } },
	["ChangeATK"] = { "Change Attack", CATEGORY_ATKCHANGE, HINTMSG_FACEUP, { 7194917, 0 } },
	["GainATK"] = { "Gain Attack", CATEGORY_ATKCHANGE, HINTMSG_FACEUP, { 1412158, 0 }, { 95824983, 2 } },
	["LoseATK"] = { "Lose Attack", CATEGORY_ATKCHANGE, HINTMSG_FACEUP, { 2250266, 0 } },
	["ChangeDEF"] = { "Change Defense", CATEGORY_DEFCHANGE, HINTMSG_FACEUP, { 7194917, 0 } },
	["GainDEF"] = { "Gain Defense", CATEGORY_DEFCHANGE, HINTMSG_FACEUP, { 4997565, 2 }, { 95824983, 2 } },
	["LoseDEF"] = { "Lose Defense", CATEGORY_DEFCHANGE, HINTMSG_FACEUP, { 80949182, 2 } },
	["ChangeATK&DEF"] = { "Change attack and defense", { CATEGORY_ATKCHANGE, CATEGORY_DEFCHANGE }, HINTMSG_FACEUP, { 4997565, 2 } },
	["GainATK&DEF"] = { "Gain attack and defense", { CATEGORY_ATKCHANGE, CATEGORY_DEFCHANGE }, HINTMSG_FACEUP, { 10000010, 0 }, { 95824983, 2 } },
	["LoseATK&DEF"] = { "Lose attack and defense", { CATEGORY_ATKCHANGE, CATEGORY_DEFCHANGE }, HINTMSG_FACEUP, { 80949182, 0 } },
	["PlaceCounter"] = { "Place Counter", CATEGORY_COUNTER, HINTMSG_COUNTER, { 3070049, 0 } },
	["RemoveCounter"] = { "Remove Counter", CATEGORY_COUNTER, HINTMSG_COUNTER, { 67234805, 0 } },
	["TossCoin"] = { "Toss Coin", CATEGORY_COIN, 0, { 17032740, 1 } } ,
	["TossDice"] = { "Toss Dice",CATEGORY_DICE, 0, { 42421606, 0 } },
	["AnnounceCard"] = { "Announce Card", CATEGORY_ANNOUNCE, 0 },
	["ChangLevel"] = { "Change Level", 0, HINTMSG_FACEUP, { 9583383, 0 } },
	["GYAction"] = { "Grave Action", CATEGORY_GRAVE_ACTION, 0 },
	["LeaveGY"] = { "Leave Grave", CATEGORY_LEAVE_GRAVE, 0 },
	["Look"] = { "Look (can show public)", 0, HINTMSG_CONFIRM, {51351302, 0}, nil, { Scl.Look, 1, sg } },
	["Reveal"] = { "Reveal, (cannot show public)", 0, HINTMSG_CONFIRM, {51351302, 0}, nil, { Scl.RevealCards, 2, sg, RESETS_SCL } },
	["RevealUntilEP"] = { "Reveal until End-Phase", 0, HINTMSG_CONFIRM, {51351302, 0}, nil, { Scl.RevealCards, 2, sg, RESETS_EP_SCL } },
	["PlaceOnField"] = { "Place on field", 0, HINTMSG_TOFIELD, DESC_PLACE_TO_FIELD_SCL, nil, { Scl.Place2Field, 7, sg, tp } },
	["PlaceInSpell&TrapZone"] = { "Place in spell and trap zone", 0, HINTMSG_TOFIELD, DESC_PLACE_TO_FIELD_SCL, nil, { Scl.Place2Field, 7, sg, tp, tp, "Spell&TrapZone", POS_FACEUP, true } },
	["PlaceInFieldZone"] = { "Place in spell and trap zone", 0, HINTMSG_TOFIELD, DESC_PLACE_TO_FIELD_SCL, nil, { Scl.Place2Field, 7, sg, tp, tp, "FieldZone", POS_FACEUP, true } },
	["PlaceInPendulumZone"] = { "Place in spell and trap zone", 0, HINTMSG_TOFIELD, DESC_PLACE_TO_FIELD_SCL, nil, { Scl.Place2Field, 7, sg, tp, tp, "PendulumZone", POS_FACEUP, true } },
	["ActivateSpell/Trap"] = { "Activate", 0, HINTMSG_RESOLVEEFFECT, DESC_ACTIVATE_SCL, nil, { Scl.ActivateSepllOrTrap, 4, sg, tp, false } } ,
	["ActivateSpell"] = { "Activate", 0, HINTMSG_RESOLVEEFFECT, DESC_ACTIVATE_SCL, nil, { Scl.ActivateSepllOrTrap, 4, sg, tp, false } } ,
	["ActivateTrap"] = { "Activate", 0, HINTMSG_RESOLVEEFFECT, DESC_ACTIVATE_SCL, nil, { Scl.ActivateSepllOrTrap, 4, sg, tp, false } } ,
	["Return2Field"] = { "Return to field", 0, { 80335817, 0 }, nil, nil, { Scl.Return2Field, 3, sg } },
	["ApplyEffect"] = { "Apply 1 Effect from Many", 0, HINTMSG_RESOLVEEFFECT, { 9560338, 0 } },
	["SetTrap"] = { "SSet", 0, HINTMSG_SET, { 2521011, 0 }, { 30741503, 1 }, { Scl.SetSpellOrTrap, 4, sg, tp, tp } },
	["SetSpell"] = { "SSet", 0, HINTMSG_SET, { 2521011, 0 }, { 30741503, 1 }, { Scl.SetSpellOrTrap, 4, sg, tp, tp } },
	["SetSpell/Trap"] = { "SSet", 0, HINTMSG_SET, { 2521011, 0 }, { 30741503, 1 }, { Scl.SetSpellOrTrap, 4, sg, tp, tp } },
	["Set"] = { "Set card(s)", CATEGORY_SPECIAL_SUMMON, HINTMSG_SET, { 2521011, 0 }, HINTMSG_WOULD_SET_SCL, { Scl.SetCards, 4, sg, tp, tp } },
	["AttachXyzMaterial"] = { "Attach Xyz Material", 0, HINTMSG_XMATERIAL, { 55285840, 0 } },
	["DetachXyzMaterial"] = { "Detach Xyz Material", 0, HINTMSG_REMOVEXYZ, { 55285840, 1 } },
	["MoveZone"] = { "Move Zone", 0, HINTMSG_OPERATECARD, { 25163979, 1 } },
	["Dummy"] = { "Dummy Operate", 0, HINTMSG_OPERATECARD, 0, 0, { s.dummy_operate, 1, sg } },
	["Self"] = { "Select Your Card(s)", 0, HINTMSG_SELF, 0, 0, { s.dummy_operate, 1, sg } },
	["Opponent"] = { "Select Your Card(s)", 0, HINTMSG_OPPO, 0, 0, { s.dummy_operate, 1, sg } },
	["Target"] = { "Select Target(s)", 0, HINTMSG_TARGET, 0, 0, { s.dummy_operate, 1, sg } },
	["GainEffect"] = { "Select Target(s)", 0, HINTMSG_TARGET, { 10032958, 0 } }

	}
end

--Creat value effect code list (Scl.Buff_Code_List)
--the Scl.Buff_Code_List is using for some functions that creat value-effects.
--the format of Scl.Buff_Code_List:
-- [Index_String] = { effect_code, is_only_affect_self_and_need_reset_when_disable, default_value, default_count_limit, extra_flag_for_single_value, extra_flag_for_field_value, extra_reset }
function s.cannot_be_fusion_summon_material_value(e, c, st)
	if not c then 
		return false 
	end
	return not c:IsControler(e:GetHandlerPlayer()) and st & SUMMON_TYPE_FUSION == SUMMON_TYPE_FUSION
end
function s.create_buff_list()
	Scl.Buff_Code_List = {
	
	["=ATK"] = { EFFECT_SET_ATTACK, true }, 
	["=DEF"] = { EFFECT_SET_DEFENSE, true },
	["=BaseATK"] = { EFFECT_SET_BASE_ATTACK, true }, 
	["=BaseDEF"] = { EFFECT_SET_BASE_DEFENSE, true },
	["=FinalATK"] = { EFFECT_SET_ATTACK_FINAL, true },
	["=FinalDEF"] = { EFFECT_SET_DEFENSE_FINAL, true },
	["=BattleATK"] = { EFFECT_SET_BATTLE_ATTACK, true },
	["=BattleDEF"] = { EFFECT_SET_BATTLE_DEFENSE, true },
	["=Level"] = { EFFECT_CHANGE_LEVEL, true },
	["=Rank"] = { EFFECT_CHANGE_RANK, true },
	["=LeftScale"] = { EFFECT_CHANGE_LSCALE, true },
	["=RightScale"] = { EFFECT_CHANGE_RSCALE, true },
	["=Name"] = { EFFECT_CHANGE_CODE, true },
	["=Attribute"] = { EFFECT_CHANGE_ATTRIBUTE, true },
	["=Race"] = { EFFECT_CHANGE_RACE, true },
	["=Type"] = { EFFECT_CHANGE_TYPE, true },
	["=FusionAttribute"] = { EFFECT_CHANGE_FUSION_ATTRIBUTE, true },
	["+ATK"] = { EFFECT_UPDATE_ATTACK, true },
	["+DEF"] = { EFFECT_UPDATE_DEFENSE, true },
	["+Level"] = { EFFECT_UPDATE_LEVEL, true },
	["+Rank"] = { EFFECT_UPDATE_RANK, true },
	["+LeftScale"] = { EFFECT_UPDATE_LSCALE, true },
	["+RightScale"] = { EFFECT_UPDATE_RSCALE, true },
	["+Name"] = { EFFECT_ADD_CODE, true },
	["+Attribute"] = { EFFECT_ADD_ATTRIBUTE, true },
	["+Race"] = { EFFECT_ADD_RACE, true },
	["+Series"] = { EFFECT_ADD_SETCODE, true },
	["+Type"] = { EFFECT_ADD_TYPE, true },
	["+FusionAttribute"] = { EFFECT_ADD_FUSION_ATTRIBUTE, true },
	["+FusionName"] = { EFFECT_ADD_FUSION_CODE, true },
	["+FusionSeries"] = { EFFECT_ADD_FUSION_SETCODE, true },
	["+LinkAttribute"] = { EFFECT_ADD_LINK_ATTRIBUTE, true },
	["+LinkRace"] = { EFFECT_ADD_LINK_RACE, true },
	["+LinkName"] = { EFFECT_ADD_LINK_CODE, true },
	["+LinkSeries"] = { EFFECT_ADD_LINK_SETCODE, true },
	["-Type"] = { EFFECT_REMOVE_TYPE, true },
	["-Race"] = { EFFECT_REMOVE_RACE, true },
	["-Attribute"] = { EFFECT_REMOVE_ATTRIBUTE, true },
	["!BeDestroyed"] = { EFFECT_INDESTRUCTABLE },
	["!BeDestroyedCountPerTurn"] = { EFFECT_INDESTRUCTABLE_COUNT, false, scl.value_indestructable_count(REASON_EFFECT + REASON_BATTLE), 1 },
	["!BeDestroyedByBattle"] = { EFFECT_INDESTRUCTABLE_BATTLE },
	["!BeDestroyedByEffects"] = { EFFECT_INDESTRUCTABLE_EFFECT },
	["!BeDestroyedByBattle/Effects"] = { { "!BeDestroyedByBattle", "!BeDestroyedByEffects" } },
	["UnaffectedByEffects"] = { EFFECT_IMMUNE_EFFECT, scl.value_unaffected_by_other_card_effects },
	["SpecialSummonCondition"] = { EFFECT_SPSUMMON_CONDITION },
	["!BeUsedAsFusionMaterial"] = { EFFECT_CANNOT_BE_FUSION_MATERIAL },
	["!BeUsedAsMaterial4FusionSummon"] = { EFFECT_CANNOT_BE_FUSION_MATERIAL, s.cannot_be_fusion_summon_material_value },
	["!BeUsedAsSynchroMaterial"] = { EFFECT_CANNOT_BE_SYNCHRO_MATERIAL },
	["!BeUsedAsMaterial4SynchroSummon"] = { EFFECT_CANNOT_BE_SYNCHRO_MATERIAL },
	["!BeUsedAsXyzMaterial"] = { EFFECT_CANNOT_BE_XYZ_MATERIAL },
	["!BeUsedAsMaterial4XyzSummon"] = { EFFECT_CANNOT_BE_XYZ_MATERIAL },
	["!BeUsedAsLinkMaterial"] = { EFFECT_CANNOT_BE_LINK_MATERIAL },
	["!BeUsedAsMaterial4LinkSummon"] = { EFFECT_CANNOT_BE_LINK_MATERIAL },
	["!BeUsedAsMaterial4SpecialSummon"] = { { "!BeUsedAsMaterial4FusionSummon", "!BeUsedAsMaterial4SynchroSummon", "!BeUsedAsMaterial4XyzSummon", "!BeUsedAsMaterial4LinkSummon" } },
	["!BeUsedAsMaterial4Fusion/Synchro/Xyz/LinkSummon"] = { { "!BeUsedAsMaterial4FusionSummon", "!BeUsedAsMaterial4SynchroSummon", "!BeUsedAsMaterial4XyzSummon", "!BeUsedAsMaterial4LinkSummon" } },
	["!BeBattleTarget"] = { EFFECT_CANNOT_BE_BATTLE_TARGET, false, aux.imval1, nil, nil, EFFECT_FLAG_IGNORE_IMMUNE },
	["!BeEffectTarget"] = { EFFECT_CANNOT_BE_EFFECT_TARGET, false, 1, nil, nil, EFFECT_FLAG_IGNORE_IMMUNE },
	["NegateEffect"] = { EFFECT_DISABLE },
	["NegateActivatedEffect"] = { EFFECT_DISABLE_EFFECT },
	["NegateTrapMonster"] = { EFFECT_DISABLE_TRAPMONSTER },
	["!NegateEffect"] = { EFFECT_CANNOT_DISABLE, false, 1, nil, EFFECT_FLAG_CANNOT_DISABLE },
	["!NegateNormalSummon"] = { EFFECT_CANNOT_DISABLE_SUMMON, false, 1, nil, EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE, EFFECT_FLAG_SET_AVAILABLE },
	["!NegateSpecialSummon"] = { EFFECT_CANNOT_DISABLE_SPSUMMON, false, 1, nil, EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE, EFFECT_FLAG_SET_AVAILABLE },
	["!NegateFlipSummon"] = { EFFECT_CANNOT_DISABLE_FLIP_SUMMON, false, 1, nil, EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE, EFFECT_FLAG_SET_AVAILABLE },
	["+AttackCount"] = { EFFECT_EXTRA_ATTACK, true },
	["+AttackMonsterCount"] = { EFFECT_EXTRA_ATTACK_MONSTER, true },
	["AttackAll"] = { EFFECT_ATTACK_ALL, true },
	["Pierce"] = { EFFECT_PIERCE, true },
	["AttackDirectly"] = { EFFECT_DIRECT_ATTACK, true },
	["AttackInDefensePosition"] = { EFFECT_DEFENSE_ATTACK, true },
	["!Attack"] = { EFFECT_CANNOT_ATTACK },
	["!AttackAnnounce"] = { EFFECT_CANNOT_ATTACK_ANNOUNCE },
	["!AttackDirectly"] = { EFFECT_CANNOT_DIRECT_ATTACK },
	["!BeTributed"] = { { "!BeTributed4TributeSummon", "!BeTributedExcept4TributeSummon" } },
	["!BeTributed4TributeSummon"] = { EFFECT_UNRELEASABLE_SUM },
	["!BeTributedExcept4TributeSummon"] = { EFFECT_UNRELEASABLE_NONSUM },
	["!BeUsedAsCost"] = { EFFECT_CANNOT_USE_AS_COST },
	["!BeSent2GYAsCost"] = { EFFECT_CANNOT_TO_GRAVE_AS_COST },
	["!BeBanished"] = { EFFECT_CANNOT_REMOVE },
	["!SwitchControl"] = { EFFECT_CANNOT_CHANGE_CONTROL },
	["!ChangePosition"] = { EFFECT_CANNOT_CHANGE_POSITION, false, nil, nil, EFFECT_FLAG_SET_AVAILABLE },
	["!ChangePositionByEffect"] = { EFFECT_CANNOT_CHANGE_POS_E, false, nil, nil, EFFECT_FLAG_SET_AVAILABLE },
	["!Activate"] = { EFFECT_CANNOT_TRIGGER },
	["Instead2GY"] = { EFFECT_TO_GRAVE_REDIRECT, false, LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT },
	["Instead2Deck"] = { EFFECT_TO_DECK_REDIRECT, false, LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT },
	["Instead2Hand"] = { EFFECT_TO_HAND_REDIRECT, false, LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT },
	["InsteadLeaveField"] = { EFFECT_LEAVE_FIELD_REDIRECT, false, LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT },
	["OpponentTakeBattleDamageInstead"] = { EFFECT_REFLECT_BATTLE_DAMAGE },
	["ChangeBattleDamage"] = { EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE },
	["HalveBattleDamageYouTake"] = { EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE, false, aux.ChangeBattleDamage(0,HALF_DAMAGE) },
	["YouTakeNoBattleDamage"] = { EFFECT_AVOID_BATTLE_DAMAGE }, 
	["YourOpponentTakesNoBattleDamage"] = { EFFECT_NO_BATTLE_DAMAGE },  
	["NeitherPlayerTakesNoBattleDamage"] = { { "YouTakeNoBattleDamage", "YourOpponentTakesNoBattleDamage" } },  
	["ActivateQuickPlaySpellFromHand"] = { EFFECT_QP_ACT_IN_NTPHAND },
	["ActivateQuickPlaySpellInSetTurn"] = { EFFECT_QP_ACT_IN_SET_TURN, false,1, nil, EFFECT_FLAG_SET_AVAILABLE, EFFECT_FLAG_SET_AVAILABLE },
	["ActivateTrapFromHand"] = { EFFECT_TRAP_ACT_IN_HAND },
	["ActivateTrapInSetTurn"] = { EFFECT_TRAP_ACT_IN_SET_TURN, false, 1, nil, EFFECT_FLAG_SET_AVAILABLE, EFFECT_FLAG_SET_AVAILABLE },
	["ActivateFromHand"] = { {"ActivateQuickPlaySpellFromHand", "ActivateTrapFromHand"} },
	["ActivateInSetTurn"] = { {"ActivateQuickPlaySpellInSetTurn", "ActivateTrapInSetTurn"} },
	["MaterialCheck"] = { EFFECT_MATERIAL_CHECK, false, 1, nil, nil, EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_SET_AVAILABLE + EFFECT_FLAG_IGNORE_RANGE },
	["ExtraRitualTribute"] = { EFFECT_EXTRA_RITUAL_MATERIAL  },
	["XyzMaterial4ExtraRitualTribute"] = { EFFECT_OVERLAY_RITUAL_MATERIAL  }, 
	["ExtraFusionMaterial"] = { EFFECT_EXTRA_FUSION_MATERIAL  },
	["ExtraSynchroMaterial"] = { EFFECT_EXTRA_SYNCHRO_MATERIAL_SCL, false, Scl.ReturnTrue(2), nil, nil, EFFECT_FLAG_IGNORE_IMMUNE },
	["ExtraXyzMaterial"] = { EFFECT_EXTRA_XYZ_MATERIAL_SCL, false, Scl.ReturnTrue(2), nil, nil, EFFECT_FLAG_IGNORE_IMMUNE},
	["UtilityXyzMaterial"] = { EFFECT_UTILITY_XYZ_MATERIAL_SCL, false, 2, nil, nil, EFFECT_FLAG_IGNORE_IMMUNE },
	["ExtraLinkMaterial"] = { EFFECT_EXTRA_LINK_MATERIAL, false, Scl.ReturnTrue(2), nil, nil , EFFECT_FLAG_IGNORE_IMMUNE },
	["EquipLimit"] = { EFFECT_EQUIP_LIMIT, false, 1, nil, EFFECT_FLAG_CANNOT_DISABLE },
	["Reveal"] = { EFFECT_PUBLIC, false, 1, nil, EFFECT_FLAG_CANNOT_DISABLE },
	["SetMaterial"] = { EFFECT_SET_MATERIAL_SCL },
	["CompleteProcedure"] = { EFFECT_COMPLETE_SUMMON_PROC_SCL },
	["ActivateCardFromAnyZone"] = { EFFECT_ACTIVATE_SPELL_AND_TRAP_FROM_ANY_ZONE_SCL }
	
	}

	Scl.Player_Buff_Code_List = {
	
	["!Return2Deck"] = { EFFECT_CANNOT_TO_DECK },
	["!Add2Hand"] = { EFFECT_CANNOT_TO_HAND },
	["!Banish"] = { EFFECT_CANNOT_REMOVE },
	["!Activate"] = { EFFECT_CANNOT_ACTIVATE },
	["!Tribute"] = { EFFECT_CANNOT_RELEASE },
	["!NormalSummon"] = { EFFECT_CANNOT_SUMMON },
	["!FilpSummon"] = { EFFECT_CANNOT_FLIP_SUMMON },
	["!SpecialSummon"] = { EFFECT_CANNOT_SPECIAL_SUMMON },
	["!Normal&SpecialSummon"] = { {"!NormalSummon", "!SpecialSummon"} },
	["!Draw"] = { EFFECT_CANNOT_DRAW },
	["!Send2GY"] = { EFFECT_CANNOT_TO_GRAVE },
	["!SetSpell&Trap"] = { EFFECT_CANNOT_SSET },
	["!NormalSet"] = { EFFECT_CANNOT_MSET },
	["!Discard"] = { EFFECT_CANNOT_DISCARD_HAND },
	["!SendDeckTop2GY"] = { EFFECT_CANNOT_DISCARD_DECK },
	["SkipBP"] = { EFFECT_SKIP_BP },
	["SkipM1"] = { EFFECT_SKIP_M1 },
	["SkipM2"] = { EFFECT_SKIP_M2 },
	["SkipDP"] = { EFFECT_SKIP_DP },
	["SkipSP"] = { EFFECT_SKIP_SP },
	["ChangeDamage"] = { EFFECT_CHANGE_DAMAGE, false },
	["ChangeBattleDamage"] = { EFFECT_CHANGE_BATTLE_DAMAGE, false, DOUBLE_DAMAGE  },
	["OpponentTakeDamageInstead"] = { EFFECT_REFLECT_DAMAGE },
	["OpponentTakeBattleDamageInstead"] = { EFFECT_REFLECT_BATTLE_DAMAGE },
	["GainLPInsteadOfTakingDamage"] = { EFFECT_REVERSE_DAMAGE },
	["AddAdditionalEffect"] = { EFFECT_ADDITIONAL_EFFECT_SCL }
	
	}
	
	Scl.Effect_Buff_Code_List = {
	
	["!NegateActivation"] = { EFFECT_CANNOT_INACTIVATE_SCL },
	["!NegateActivatedEffect"] = { EFFECT_CANNOT_DISEFFECT_SCL },
	
	}
	
	--Special case1  "ActivateSpell&TrapFromAnyZone"
	--"This card (Spell/Trap) can activate from Deck/GY ..."
	--normally, activate from hand or activate on the set turn, plz use Scl.CreateSingleBuffEffect(reg_arr, "ActivateTrapFromHand"/"ActivateTrapInSetTurn"/"ActivateQuickPlayFromHand"/"ActivateQuickPlayInSetTurn", ...), rather than use this function.
	--its value is a dummy value.
	--it can be set the cost (Effect.SetCost), means if you activate card by this buff, you should pay this cost. 
	-->>eg1. local e1 = Scl.CreateFieldBuffEffect({c, tp}, "ActivateSpell&TrapFromAnyZone", 1, aux.TRUE, {LOCATION_DECK,0} )
	-->>this function make any Spell & Trap in your Deck can activate from Deck directly, if activate this way, you should pay s.cost as cost.
	local ge1 = Scl.SetGlobalFieldTriggerEffect(0, EVENT_ADJUST, EFFECT_ACTIVATE_SPELL_AND_TRAP_FROM_ANY_ZONE_SCL, nil, s.activate_from_any_zone_regop)
	--Special case2  "AddAdditionalEffect"
	--it has a bug when VS Duel.ChangeChainOperation (if you use "Duel.ChangeChainOperation" to change the original effect's operation to op2, that op2 can still be added the additional effect(s), but this function cannot achieve the effect (also, until today 2022.09.18, the OCG official card "白銀の迷宮城" has a same bug), for achieving, it needs OCGCore's supprot, or you must permanently hack the operation mode of "Duel.ChangeChainOperation", but I don't want to do that, one more hack, one more bug.)
	--also, this function has a logic error - you must first solving the original effect, then select and solving the additional effect(s), but this function reverses the sequence, same reason as the above bug, but I don't think it's a big problem, so be it.
	local ge2 = Scl.SetGlobalFieldTriggerEffect(0, EVENT_CHAIN_SOLVING, EFFECT_ADDITIONAL_EFFECT_SCL, nil, s.add_additional_effect_regop)
end
--Special case1  "ActivateSpell&TrapFromAnyZone"
function s.activate_from_any_zone_regop(e,tp)
	local g = Duel.GetMatchingGroup(Card.IsHasEffect, 0, 0xff, 0xff, nil, EFFECT_ACTIVATE_SPELL_AND_TRAP_FROM_ANY_ZONE_SCL)
	for tc in aux.Next(g) do 
		local ae_arr = { tc:GetActivateEffect() }
		for _, ae in pairs(ae_arr) do 
			if not Scl.Activate_List[ae] then
				local te = ae:Clone()
				Scl.Activate_List[ae] = te 
				Scl.Activate_List[te] = ae
				te:SetType(EFFECT_TYPE_QUICK_O + EFFECT_TYPE_ACTIVATE)
				te:SetRange(0xff)
				if not tc:IsType(TYPE_QUICKPLAY) and not tc:IsType(TYPE_TRAP) then
					Scl.RegisterHintTiming(te, { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE })
				end 
				tc:RegisterEffect(te, true)
				local ce = Effect.CreateEffect(tc)
				ce:SetType(EFFECT_TYPE_FIELD)
				ce:SetCode(EFFECT_ACTIVATE_COST)
				ce:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_SET_AVAILABLE)
				ce:SetTargetRange(1, 1)
				ce:SetCost(s.activate_from_any_zone_costchk)
				ce:SetTarget(s.activate_from_any_zone_tg)
				ce:SetOperation(s.activate_from_any_zone_op)
				ce:SetLabelObject(te)
				Duel.RegisterEffect(ce, tp) 
			end
		end
	end
end
function s.activate_from_any_zone_costchk(e, te_or_c, tp)
	local c = e:GetHandler()
	local se_arr = { c:IsHasEffect(EFFECT_ACTIVATE_SPELL_AND_TRAP_FROM_ANY_ZONE_SCL, tp) }
	if #se_arr == 0 then return false end 
	for _, se in pairs(se_arr) do 
		local act_zone = se:GetValue()
		local cost = se:GetCost() or aux.TRUE
		if Scl.IsInZone(c, act_zone) and cost(e, tp, eg, ep, ev, re, r, rp, 0) then 
			return true
		end
	end
	return false
end 
function s.activate_from_any_zone_tg(e, te)
	return te == e:GetLabelObject() 
end
function s.activate_from_any_zone_op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local se_arr = { c:IsHasEffect(EFFECT_ACTIVATE_SPELL_AND_TRAP_FROM_ANY_ZONE_SCL, tp) }
	local se_arr2 = { }
	local desc_arr = { }
	local cost_arr = { }
	for _, se in pairs(se_arr) do 
		local cost = se:GetCost() or aux.TRUE
		if cost(e, tp, eg, ep, ev, re, r, rp, 0) then 
			table.insert(se_arr2, se)
			table.insert(desc_arr, se:GetDescription() or DESC_ACTIVATE_SPELL_AND_TRAP_FROM_ANY_ZONE_SCL)
			table.insert(cost_arr, cost)
		end
	end
	local opt = #desc_arr == 1 and 1 or Duel.SelectOption(tp, table.unpack(desc_arr)) + 1
	local se = se_arr2[opt]
	se:UseCountLimit(tp)
	local cost = cost_arr[opt]
	cost(e, tp, eg, ep, ev, re, r, rp, 1)
	local loc = LOCATION_SZONE 
	if c:IsType(TYPE_PENDULUM) then loc = LOCATION_PZONE 
	elseif c:IsType(TYPE_FIELD) then loc = LOCATION_FZONE 
	end
	Duel.MoveToField(c, tp, tp, loc, POS_FACEUP, true)
end
--Special case2  "AddAdditionalEffect"
function s.add_additional_effect_regop(e, p, eg, ep, ev, re, r, rp)
	Scl.Add_Additional_Effect_Before_Original_List[ev] = { } 
	Scl.Add_Additional_Effect_List[ev] = { }
	Scl.Add_Additional_Effect_Original_List[ev]  = { }
	local parr = { [0] = Duel.GetTurnPlayer(), [1] = 1 - Duel.GetTurnPlayer() }
	local add_desc = { [0] = { }, [1] = { } }
	local add_op = { [0] = { }, [1] = { } } 
	local add_e = { }
	local add_op_final = { } 
	local add_op_force_final = { }
	local sel_group = { [0] = Group.CreateGroup(), [1] = Group.CreateGroup() }
	local ap, arr, ac 
	for p = 0, 1 do
		ap = parr[p]
		arr = { Duel.IsPlayerAffectedByEffect(ap, EFFECT_ADDITIONAL_EFFECT_SCL) }
		for _, ae in pairs(arr) do 
			ac = ae:GetHandler()
			local av = ae:GetValue()
			local con, op, force= av(ae, ap, ev, re, rp)
			if con then
				if force then
					s.add_additional_effect_hint(ae, ap)
					ae:UseCountLimit(ap)
					table.insert(add_op_force_final, op)
				else
					add_desc[ac] = add_desc[ac] or { }
					add_op[ac] = add_op[ac] or { }
					add_e[ac] = add_e[ac] or { }
					table.insert(add_desc[ac], ae:GetDescription())
					table.insert(add_op[ac], op)
					table.insert(add_e[ac], ae)
					sel_group[ap]:AddCard(ac)
				end
			end
		end
	end
	local sel_group_x = Group.CreateGroup()
	local ac, opt
	for p = 0, 1 do 
		ap = parr[p]
		if #(sel_group[ap]) > 0 then
			Duel.ConfirmCards(ap, sel_group[ap])
			repeat 
				Duel.Hint(HINT_SELECTMSG, ap, HINTMSG_EXTRA_EFFECT_CARD_SCL)
				ac = sel_group[ap]:SelectUnselect(sel_group_x, ap, true, true, 1, 1)
				if ac then 
					s.add_additional_effect_hint2(ac)
					Duel.Hint(HINT_SELECTMSG, ap, HINTMSG_EXTRA_EFFECT_SCL)
					opt = Duel.SelectOption(ap, table.unpack(add_desc[ac])) + 1
					table.insert(add_op_final, add_op[ac][opt])
					Duel.Hint(HINT_OPSELECTED, 1 - ap, add_desc[ac][opt])
					add_e[ac][opt]:UseCountLimit(ap)
					table.remove(add_op[ac],opt)
					table.remove(add_desc[ac],opt)
					if #add_op[ac] == 0 then
						sel_group[ap]:RemoveCard(ac)
					end
				end
			until #sel_group[ap] == 0 or not ac
		end
	end
	if #add_op_force_final > 0 or #add_op_final > 0 then
		local orig_op = re:GetOperation() or aux.TRUE
		re:SetOperation(s.add_additional_effect_op(orig_op, add_op_force_final, add_op_final))
		local e1 = Scl.CreateFieldTriggerContinousEffect({e:GetHandler(),0},EVENT_CHAIN_SOLVED, nil, nil, nil, nil, s.add_additional_effect_reset_con(re),s.add_additional_effect_reset_op(re, orig_op))
	end 
end
function s.add_additional_effect_op(op, a_f_op, a_op)
	return function(e, tp, eg, ep, ev0, re, r, rp)
		local c = e:GetHandler()
		e:SetOperation(op)
		local ev = Duel.GetCurrentChain()
		for _, aop in pairs(a_f_op) do 
			aop(e, tp, eg, ep, ev, re, r, rp, 0)
			table.insert(Scl.Add_Additional_Effect_Before_Original_List[ev], aop)
		end
		for _, aop in pairs(a_op) do 
			aop(e, tp, eg, ep, ev, re, r, rp, 0)
			table.insert(Scl.Add_Additional_Effect_Before_Original_List[ev], aop)
		end
		op(e, tp, eg, ep, ev, re, r, rp)
		table.insert(Scl.Add_Additional_Effect_Original_List[ev], op)
		for _, aop in pairs(a_f_op) do
			aop(e, tp, eg, ep, ev, re, r, rp, 1)
			table.insert(Scl.Add_Additional_Effect_List[ev], aop)
		end
		for _, aop in pairs(a_op) do
			aop(e, tp, eg, ep, ev, re, r, rp, 1)
			table.insert(Scl.Add_Additional_Effect_List[ev], aop)
		end 
	end
end
function s.add_additional_effect_hint(ae, tp)
	s.add_additional_effect_hint2(ae:GetHandler())
	Duel.Hint(HINT_OPSELECTED, 1 - tp, ae:GetDescription())
end
function s.add_additional_effect_hint2(c)
	if c:IsLocation(LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED) and c:IsFaceup() then
		Scl.HintSelection(c)
	else
		Duel.Hint(HINT_CARD, 0, c:GetOriginalCode())
	end
end
function s.add_additional_effect_reset_con(re)
	return function(e, tp, eg, ep, ev0, re0, r, rp)
		return re == re0
	end
end
function s.add_additional_effect_reset_op(re, op)
	return function(e, ...)
		e:Reset()
		re:SetOperation(op)
	end
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Effect <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--use to set initial registering effect's owner's card id, for print error message.
function s.set_global_error_code(reg_obj)
	local owner = Scl.GetRegisterInfo(reg_obj)
	Scl.Global_Effect_Owner_ID = aux.GetValueType(owner) == "Card" and owner:GetOriginalCode() or "Global Effect"
end
--use to get current registering/checking/operating effect's owner's card id, for print error message.
--//return card id
function s.get_error_card_id()
	local e, c1, tp, c2, id = Scl.GetCurrentEffectInfo()
	return Scl.Global_Effect_Owner_ID or id
end
--Mix several single events that meet their condition to 1 global event (code).
--the ... format: event code1, that event's condition, event code2, that event's condition, and so on ...
--//return the trigger effects for each single event.
-->>eg1. Scl.RaiseGlobalEvent(114514, EVENT_ATTACK_ANNOUNCE, s.con1, EVENT_BE_BATTLE_TARGET, s.con2)
-->>this when a monster is declaring an attack announce, and the scene meets s.con1(e, tp, ...), OR a monster is being select as the battle target, and the scene meets s.son2(e, tp, ...), system will creat a global event by use 114514 as code.
-->>return the trigger effect for EVENT_ATTACK_ANNOUNCE, and the trigger effect for EVENT_BE_BATTLE_TARGET
function Scl.RaiseGlobalEvent(code, ...)
	Scl.RaiseGlobalEvent_Switch = Scl.RaiseGlobalEvent_Switch or { }
	if Scl.RaiseGlobalEvent_Switch[code] then return end
	Scl.RaiseGlobalEvent_Switch[code] = true
	local event_arr, con_arr = Scl.SplitArrayByParity({ ... })
	local eff_arr = { }
	for idx, event in pairs(event_arr) do
		local e1 = Scl.CreateFieldTriggerContinousEffect({ true, 0 }, event)
		e1:SetOperation(s.raise_global_event_op(con_arr[ idx ], code))
		table.insert(eff_arr, e1)
	end
	return table.unpack(eff_arr)
end
function s.raise_global_event_op(con, event_code)
	return function(e, tp, eg, ep, ev, re, r, rp)
		con = con or aux.TRUE 
		local res, sg = con(e, tp, eg, ep, ev, re, r, rp)
		if not res then return end
		sg = sg or eg 
		Duel.RaiseEvent(sg, event_code, re, r, rp, ep, ev)
		for tc in aux.Next(sg) do
			Duel.RaiseSingleEvent(tc, event_code, re, r, rp, ep, ev)
		end
	end
end
--Mix any single SET-events to a global SET event (EVENT_SET_SCL).
--including normal set monster, special summon monster(s) in face-down position, change a face-up monster(s) to face-down position, set a Spell/Trap(s).
--//return the trigger effect for EVENT_MSET, EVENT_SSET, EVENT_SPSUMMON_SUCCESS, EVENT_CHANGE_POS
function Scl.RaiseGlobalSetEvent()
	return Scl.RaiseGlobalEvent(EVENT_SET_SCL, EVENT_MSET, nil, EVENT_SSET, nil, EVENT_SPSUMMON_SUCCESS, s.raise_global_set_event_con, EVENT_CHANGE_POS, s.raise_set_event_con)
end
function s.raise_global_set_event_con(e, tp, eg)
	local sg = eg:Filter(Card.IsFacedown, nil)
	return #sg > 0, sg
end
--Check whether the effect chk_e has a certain property(s), by use eff_str as index to find the property(s) in the Scl.Effect_Type_List.
--eff_str can be  combined freely by the follow strings:
--"a" (means Spell/Trap card activate), "s" (means Spell's effect), "t" (means Trap's effect), "m" (means monster's effect).
--return if has the certain property(s).
--[[>>eg1. Scl.EffectTypeCheck("s,t",e)
	when you activate an effect of a Spell or Trap, it return true.
	>>eg2. Scl.EffectTypeCheck("a", e)
	only when you activate a Spell or Trap, it return true.
]]--
function Scl.EffectTypeCheck(eff_str, chk_e)
	local typ_arr 
	local typ, typ2
	local res1, res2 = false, false
	for _, str in pairs(Scl.SplitString(eff_str)) do 
		typ_arr = Scl.Effect_Type_List[str]
		typ = typ_arr[1]
		typ2 = typ_arr[2]
		res1 = not typ or chk_e:IsActiveType(typ)
		res2 = not typ2 or chk_e:IsHasType(typ2)
		if res1 and res2 then return true end
	end
	return false
end
--Quick set chain limit, using after the object effect is registered.
--sp means which your effects cannot chaining, op means which your opponent's effects cannot chaining.
--[[sp & op can be nil, means no limit,
	OR, can be combined freely by the follow strings:
	"a" (means limit Spell/Trap card activate), "s" (means limt Spell's effect), "t" (means limit Trap's effect), "m" (means limit monster's effect).
	OR, can be a function, that call sp/op(e, rp, tp, target_group) to return the limit effects.
--]]
function Scl.SetChainLimit(e, sp, op)
	local tg = e:GetTarget() or aux.TRUE 
	e:SetTarget(s.set_chain_limit_target(tg, sp, op))
end
function s.set_chain_limit_target(tg, sp, op)
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		if chkc or chk == 0 then 
			return tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc) 
		end
		tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS) or Group.CreateGroup()
		Duel.SetChainLimit(s.set_chain_limit_value(sp, op, g))
	end
end
function s.set_chain_limit_value(sp, op, g)
	return function(e, rp, tp)
		if type(sp) == "nil" and type(op) == "nil" then 
			sp = "All"
			op = "All"
		end  
		if sp and rp == tp and s.set_chain_limit_check(sp, g, e, rp, tp) then 
			return false 
		end
		if op and rp ~= tp and s.set_chain_limit_check(op, g, e, rp, tp) then 
			return false 
		end
		return true 
	end
end
function s.set_chain_limit_check(obj, g, e, rp, tp)
	local c = e:GetHandler()
	if type(obj) == "string" then
		return Scl.EffectTypeCheck(obj, e)
	elseif type(obj) == "function" then 
		return not obj(e, rp, tp, g)
	end
end
--Get register information.
--reg_obj can be card (self effect), or { card, card, boolean } (buff effect), {card, player} (player effet) or {boolean, player} (global effect)
--//return owner, handler (default = owner), ignore immue (default = false)
-->>eg1. Scl.GetRegisterInfo({c, tc})
-->>return c, tc, false
function Scl.GetRegisterInfo(reg_obj)
	local reg_arr = type(reg_obj) == "table" and reg_obj or { reg_obj }
	return reg_arr[1] , reg_arr[2] or reg_arr[1], reg_arr[3] or false
end
--Get default effective zones for registing effects, by checking effect handler's card type.
--reg_obj can be Card, or { card, card, boolean }
--//return zones
-->>eg1. Scl.GetEffectApplyDefaultZone(monster card)
-->>return LOCATION_MZONE
-->>eg2. Scl.GetEffectApplyDefaultZone({monster card, field card})
-->>return LOCATION_FZONE
function Scl.GetEffectApplyDefaultZone(reg_obj)
	local rng
	local _, handler = Scl.GetRegisterInfo(reg_obj)
	if aux.GetValueType(handler) ~= "Card" then return nil end
	local ctyp_arr = { TYPE_MONSTER, TYPE_FIELD, TYPE_SPELL + TYPE_TRAP }
	local rng_arr = { LOCATION_MZONE, LOCATION_FZONE, LOCATION_SZONE }
	for idx, ctyp in pairs(ctyp_arr) do
		if handler:IsType(ctyp) then 
			rng = rng_arr[idx]
			break 
		end
	end
	return rng 
end
--Switch different formats flag_obj to the number-format flag.
--flag_obj can be number (directly return those number), 
--OR can be string, split the string, and use the split subset strings as indexes to find number-format flags in Scl.Effect_Property_List.
--//return number-format flag, flag array contains each single flag.
-->>eg1. Scl.GetNumFormatProperty(EFFECT_FLAG_CARD_TARGET)
-->>return EFFECT_FLAG_CARD_TARGET, { EFFECT_FLAG_CARD_TARGET }
-->>eg2. Scl.GetNumFormatProperty("!NegateEffect,Uncopyable")
-->>return EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE, { EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_UNCOPYABLE }
function Scl.GetNumFormatProperty(flag_obj)
	local crt_flag, flag, flag_arr = 0, 0, { }
	if type(flag_obj) == "number" then 
		return flag_obj, Scl.SplitNumber2PowerOf2(flag_obj)
	elseif type(flag_obj) == "string" then
		local str_list = Scl.SplitString(flag_obj)
		for _, flag_str in pairs(str_list) do
			crt_flag = Scl.Effect_Property_List[flag_str] 
			if not crt_flag then
				local error_code = s.get_error_card_id()
				Debug.Message(error_code .. ": --" .. flag_str .. "-- is error, Scl.GetNumFormatProperty must have a correct flag string")
			end
			flag = flag | crt_flag
			table.insert(flag_arr, crt_flag)
		end
	end
	return flag, flag_arr
end
--Switch different formats ctgy_obj to the number-format category.
--ctgy_obj can be number (directly return those number), 
--OR can be string, split the string, and use the split subset strings as indexes to find number-format categories in Scl.Category_List.
--//return number-format category, category array contains each single number-format category, string array contains each single string-format category
-->>eg1. Scl.GetNumFormatCategory(CATEGORY_TOGRAVE)
-->>return CATEGORY_TOGRAVE, { CATEGORY_TOGRAVE }, { "Send2GY" }
-->>eg2. Scl.GetNumFormatCategory("AddFromDeck2Hand")
-->>return CATEGORY_SEARCH + CATEGORY_TOHAND, { CATEGORY_SEARCH, CATEGORY_TOHAND }, { "AddFromDeck2Hand" }
function Scl.GetNumFormatCategory(ctgy_obj)
	local ctr_ctgy, ctgy, ctgy_arr, str_arr = 0, 0, { }, { }
	if type(ctgy_obj) == "number" then 
		ctgy = ctgy_obj 
		for ctgy_str, ctgy_arr2 in pairs(Scl.Category_List) do
			local ctgy_cacahe_arr = type(ctgy_arr2[2]) == "table" and ctgy_arr2[2] or { ctgy_arr2[2] }
			for _, ctgy_cache in pairs(ctgy_cacahe_arr) do
				if ctgy_cache &  ctgy ~= 0 then 
					table.insert(ctgy_arr, ctgy_cache)
					table.insert(str_arr, ctgy_str)
				end
			end

		end
	elseif type(ctgy_obj) == "string" then
		local str_list = Scl.SplitString(ctgy_obj)
		for _, ctgy_str in pairs(str_list) do 
			if not Scl.Category_List[ctgy_str] then
				local error_code = s.get_error_card_id()
				Debug.Message(error_code .. ": --" .. ctgy_str .. "-- is error, Scl.GetNumFormatCategory must have a correct category string")
			end
			ctr_ctgy_arr = Scl.Category_List[ctgy_str][2]
			ctr_ctgy_arr = type(ctr_ctgy_arr) == "table" and ctr_ctgy_arr or { ctr_ctgy_arr }
			if not ctr_ctgy then
				local error_code = s.get_error_card_id()
				Debug.Message(error_code .. ": --" .. ctgy_str .. "-- is error, Scl.GetNumFormatCategory must have a correct category string")
			end
			ctgy = ctgy | (ctr_ctgy_arr[1] | (ctr_ctgy_arr[2] or 0))
			table.insert(ctgy_arr, ctr_ctgy_arr[1])
			if ctr_ctgy_arr[2] then 
				table.insert(ctgy_arr, ctr_ctgy_arr[2]) 
			end
			table.insert(str_arr, ctgy_str)
		end
	end
	return ctgy, ctgy_arr, str_arr
end
--Clone the base_eff to reg_obj.
--the ... format : string-format clone object1, that object's value, string-format clone object2, that object's value, and so on ...
--//return clone effect, that effect's id.
-->>eg1. Scl.CloneEffect(c, e1, "code", EVENT_SPSUMMON_SUCCESS)
-->>card c will get a same effect as e1, but change the cloned effect's trigger event to EVENT_SPSUMMON_SUCCESS
-->>return clone effect, that effect's id.
function Scl.CloneEffect(reg_obj, base_eff, ...)
	s.set_global_error_code(reg_obj) 
	local typ_arr, val_arr = Scl.SplitArrayByParity({ ... })
	local clone_eff = base_eff:Clone()
	local str_arr = { "Code", "Type", "Zone", "Condition", "Cost", "Target", "Operation", "Label", "LabelObject", "Value" }
	local fun_arr = { Effect.SetCode, Effect.SetType, Effect.SetRange, Effect.SetCondition, Effect.SetCost, Effect.SetTarget, Effect.SetOperation, Effect.SetLabel, Effect.SetLabelObject, Effect.SetValue }
	for idx, typ in pairs(typ_arr) do 
		local val = val_arr[idx]
		local bool, idx2 = Scl.IsArrayContains(str_arr, typ)
		if bool and idx2 then
			fun_arr[idx2](clone_eff, val)
		end
		if typ == "Description" then 
			Scl.RegisterDescription(clone_eff, val)
		elseif typ == "Property" then 
			clone_eff:SetProperty(Scl.GetNumFormatProperty(val))
		elseif typ == "Category" then 
			clone_eff:SetCategory(Scl.GetNumFormatCategory(val)) 
		elseif typ == "Reset" then 
			Scl.RegisterReset(clone_eff, val) 
		elseif typ == "HintTiming" then
			Scl.RegisterHintTiming(clone_eff, val) 
		elseif typ == "TargetRange" then
			Scl.RegisterTargetRange(clone_eff, val) 
		end
	end
	local _, clone_fid = Scl.RegisterEffect(reg_obj, clone_eff)
	Scl.Global_Effect_Owner_ID = nil
	return clone_eff, clone_fid
end 
--"This effect becomes Qucik Effect while xxxx".
--the base_eff cannot be activated if meets the quick_con, and the cloned Quick Effect cannot be activated if miss the quick_con.
--tmg_arr default = { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE }, using for the cloned Quick Effect's activate timing.
--//return cloned Quick Effect, that effet's id.
-->>eg1. Scl.CloneEffectAsQucikEffect(c, e1, scl.cond_in_phase("M2"))
-->>clone e1 as e2, while in M2, you can activate e2 as Quick Effect but cannot activate e1, otherwise, you can activate e1 but cannot activate e2.
-->>return cloned Quick Effect, that effet's id.
function Scl.CloneEffectAsQucikEffect(reg_obj, base_eff, quick_con, tmg_arr)
	tmg_arr = tmg_arr or { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE }
	local quick_eff, quick_fid = Scl.CloneEffect(reg_obj, base_eff, "Type", EFFECT_TYPE_QUICK_O, "Code", EVENT_FREE_CHAIN, "HintTiming", tmg_arr)
	base_con = base_eff:GetCondition() or aux.TRUE 
	base_eff:SetCondition(aux.AND(base_con, aux.NOT(quick_con)))
	quick_eff:SetCondition(aux.AND(base_con, quick_con))
	return quick_eff, quick_fid
end
--Register Condition,  Cost,  Target and Operation for reg_eff 
--cost, target and operation can be function or array. If be array-format, it calls  scl.list_format_cost_or_target_or_operation to change it to function.
-->>eg1. Scl.RegisterSolvePart(e, s.con, s.cost, s.tg, s.op)
-->>eg1. Scl.RegisterSolvePart(e, s.con, s.cost, { "~Target", Card.IsAbleToHand, "Add2Hand", LOCATION_DECK }, s.op)
function Scl.RegisterSolvePart(reg_eff, con, cost, tg, op)
	local error_code = s.get_error_card_id()
	if con then
		if type(con) ~= "function" then
			Debug.Message(error_code .. " Scl.RegisterSolvePart con must be function")
		end
		reg_eff:SetCondition(con)
	end
	if cost then
		if type(cost) ~= "function" and type(cost) ~= "table" then
			Debug.Message(error_code .. " Scl.RegisterSolvePart cost must be function or table")
		end
		reg_eff:SetCost(scl.list_format_cost_or_target_or_operation(cost))
	end
	if tg then
		if type(tg) ~= "function" and type(tg) ~= "table" then
			Debug.Message(error_code .. " Scl.RegisterSolvePart tg must be function or table")
		end
		reg_eff:SetTarget(scl.list_format_cost_or_target_or_operation(tg))
	end
	if op then
		if type(op) ~= "function" then
			Debug.Message(error_code .. " Scl.RegisterSolvePart op must be function")
		end
		reg_eff:SetOperation(scl.list_format_cost_or_target_or_operation(op))
	end
end
--Register property and category for reg_eff.
--reg_obj is use to print the error infomation. 
--ctgy and flag's formats see Scl.GetNumFormatCategory, Scl.GetNumFormatProperty.
-->>eg1. Scl.RegisterCategoryAndProperty(e1, "AddFromDeck2Hand", "Delay")
-->>e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
-->>e1:SetProperty(EFFECT_FLAG_DELAY)
function Scl.RegisterCategoryAndProperty(reg_eff, ctgy, flag)
	--use Effect.GetOwner on a EFFECT_TYPE_XMATERIAL effect will crash the game.
	reg_eff:SetCategory(Scl.GetNumFormatCategory(ctgy))
	local flag2 = Scl.GetNumFormatProperty(flag)
	reg_eff:SetProperty(flag2 | Scl.Global_Property) 
	Scl.Global_Property = 0
end
--Register description for reg_eff.
--desc_obj can be number, array, or string format, refer to s.switch_hint_object_format for details.
-->>eg1. Scl.RegisterDescription(e1, {id, 1})
-->>e1:SetDescription(aux.Stringid(id, 1))
-->>eg2. Scl.RegisterDescription(e1, "Add2Hand")
-->>set e1's description to "add to hand".
function Scl.RegisterDescription(reg_eff, desc_obj)
	if not desc_obj and ctgy_str then 
		desc_obj = (Scl.SplitString(ctgy_str))[1]
	end
	reg_eff:SetDescription(s.switch_hint_object_format(desc_obj or 0))
end
--Register activate count limit for reg_eff.
--[[lim_obj can be : 
	count   > reg_eff:SetCountLimit(lim_obj)
	len2 table > if lim_obj[2] is "Share" - reg_eff:SetCountLimit(lim_obj[1], EFFECT_COUNT_CODE_SINGLE)
				else reg_eff:SetCountLimit(lim_obj[1], lim_obj[2])
	len3 table > reg_eff:SetCountLimit(lim_obj[1], lim_obj[2] + special), 
				special is depending to lim_obj[3], 
				lim_obj[3] can be: "Share" - EFFECT_COUNT_CODE_SINGLE, "Duel" - EFFECT_COUNT_CODE_DUEL, "Oath" - EFFECT_COUNT_CODE_OATH 
--]]
-->>eg1. Scl.RegisterActivateCountLimit(e1, 1)
-->>e1:SetCountLimit(1)
-->>eg2. Scl.RegisterActivateCountLimit(e1, {1, id, "Oath"})
-->>e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
function Scl.RegisterActivateCountLimit(reg_eff, lim_obj)
	if lim_obj then
		local lim_ct, lim_code = 0, 0
		if type(lim_obj) == "table" then
			if #lim_obj == 1 then
				if lim_obj[1] <= 100 then
					lim_ct = lim_obj[1]
				else
					lim_ct = 1
					lim_code = lim_obj[1]
				end
			elseif #lim_obj == 2 then
				lim_ct = lim_obj[1]
				local val = lim_obj[2]
				if (type(val) == "number" and (val == 3 or val == 0x1)) or
					 (type(val) == "string" and val == "Share") then
					lim_code = EFFECT_COUNT_CODE_SINGLE 
				else
					lim_code = lim_obj[2]
				end
			elseif #lim_obj == 3 then
				lim_ct = lim_obj[1]
				lim_code = lim_obj[2] or 0
				local val = lim_obj[3]
				if (type(val) == "number" and val == 1) or
					 (type(val) == "string" and val == "Oath") then 
					lim_code = lim_code + EFFECT_COUNT_CODE_OATH 
				elseif (type(val) == "number" and val == 1) or
					 (type(val) == "string" and val == "Duel") then
					lim_code = lim_code + EFFECT_COUNT_CODE_DUEL 
				elseif (type(val) == "number" and val == 3) or
					 (type(val) == "string" and val == "Share") then
					lim_code = lim_code + EFFECT_COUNT_CODE_SINGLE 
				else
					lim_code = lim_code + val
				end
			end
		else
			if lim_ct <= 100 then
				lim_ct = lim_obj
			else
				lim_ct = 1
				lim_code = lim_obj
			end
		end
		reg_eff:SetCountLimit(lim_ct, lim_code)
	end
end
--Switch different formats zone_obj to number-format.
--zone_obj can be number-format (like LOCATION_MZONE), or can be string-format (Like "Hand" or "Hand,Deck")
--//return number-format zone, array contains each number-format zone
-->>eg1. Scl.GetNumFormatZone(LOCATION_DECK)
-->>return LOCATION_DECK, { LOCATION_DECK }
-->>eg2. Scl.GetNumFormatZone("Hand,Deck,XyzMaterial")
-->>return LOCATION_HAND + LOCATION_DECK + LOCATION_OVERLAY, { LOCATION_HAND, LOCATION_DECK, LOCATION_OVERLAY }
function Scl.GetNumFormatZone(zone_obj)
	if type(zone_obj) == "number" then 
		return zone_obj, Scl.SplitNumber2PowerOf2(zone_obj)
	else
		local zone, zone2, zone_arr = 0, 0, { }
		for _, chk_zone in pairs(Scl.SplitString(zone_obj)) do 
			zone2 = Scl.Zone_List[chk_zone]
			if not zone2 then
				local error_code = s.get_error_card_id()
				Debug.Message(error_code .. ": --" .. chk_zone .. "-- is error, Scl.GetNumFormatZone must have a correct zone string")
			end
			zone = zone | (zone2 or 0)
			table.insert(zone_arr, zone2)
		end
		return zone, zone_arr
	end
end
--Register apply zone for reg_eff.
--format for zone_obj: see Scl.GetNumFormatZone
-->>eg1. Scl.RegisterZone(e1, LOCATION_MZONE)
-->>e1:SetRange(LOCATION_MZONE)
-->>eg2. Scl.RegisterZone(e1, "Hand,MonsterZone,GY")
-->>e1:SetRange(LOCATION_HAND + LOCATION_MZONE + LOCATION_GRAVE)
function Scl.RegisterZone(reg_eff, zone_obj)
	local zone = Scl.GetNumFormatZone(zone_obj)
	reg_eff:SetRange(zone)
end
--Register target range for reg_eff. 
--tgrng_obj can be number-format, dircetly use it as target range, OR can be table-format like { self rng, oppo rng }.
-->>eg1. Scl.RegisterTargetRange(e1, LOCATION_HAND)
-->>e1:SetTargetRange(LOCATION_HAND, 0)
-->>eg2. Scl.RegisterTargetRange(e1, { LOCATION_HAND, LOCATION_MZONE })
-->>e1:SetTargetRange(LOCATION_HAND, LOCATION_MZONE)
function Scl.RegisterTargetRange(reg_eff, tgrng_obj)
	local tgrng_arr = type(tgrng_obj) == "table" and tgrng_obj or { tgrng_obj }
	local zone1 = Scl.GetNumFormatZone(tgrng_arr[1])
	local zone2 = Scl.GetNumFormatZone(tgrng_arr[2] or 0)
	reg_eff:SetTargetRange(zone1, zone2) 
end
--Register hint timing for Quick Effect reg_eff.
--tmg_obj can be number-format, dircetly use it as HintTiming, OR can be table-format like { self timing, oppo timing }.
-->>eg1. Scl.RegisterHintTiming(e1, TIMING_SUMMON)
-->>e1:SetHintTiming(TIMING_SUMMON)
-->>eg2. Scl.RegisterHintTiming(e1, { TIMING_SUMMON, TIMINGS_CHECK_MONSTER })
-->>e1:SetTargetRange(TIMING_SUMMON, TIMINGS_CHECK_MONSTER)
function Scl.RegisterHintTiming(reg_eff, tmg_obj)
	local tmg_arr = type(tmg_obj) == "table" and tmg_obj or { tmg_obj }
	reg_eff:SetHintTiming(tmg_arr[1], tmg_arr[2] or tmg_arr[1]) 
end
--Switch number or table-format rst_obj to number-format reset event and reset turn count.
--//return reset event, reset turn count
-->>eg1. Scl.GetNumFormatReset(RESET_EVENT + RESETS_STANDARD)
-->>return RESET_EVENT + RESETS_STANDARD, 1
-->>eg2. Scl.GetNumFormatReset({ RESET_PHASE + PHASE_END, 2 })
-->>return RESET_PHASE + PHASE_END, 2
function Scl.GetNumFormatReset(rst_obj)
	local rst_arr = type(rst_obj) == "table" and rst_obj or { rst_obj }
	return rst_arr[1], rst_arr[2] or 1
end
--Register reset for reg_eff.
--rst_obj's format : see Scl.GetNumFormatReset(rst_obj).
function Scl.RegisterReset(reg_eff, rst_obj)
	local rst_event, rst_ct = Scl.GetNumFormatReset(rst_obj)
	reg_eff:SetReset(rst_event, rst_ct) 
end
--Register reg_eff on the reg_obj.
--//if Scl.Creat_Effect_Without_Register = true, this function won't do the RegisterEffect operation, only return reg_eff, -1.
--//else do the RegisterEffect operation, and return register effect, that effect's id.
-->>eg1. Scl.RegisterEffect(c, e1)
-->>c:RegisterEffect(e1)
-->>eg2. Scl.RegisterEffect({c, tc}, e1)
-->>tc:RegisterEffect(e1)
-->>eg3. Scl.RegisterEffect({c, 0}, e1)
-->>Duel.RegisterEffect(e1, 0)
function Scl.RegisterEffect(reg_obj, reg_eff)
	if Scl.Creat_Effect_Without_Register then
		return reg_eff, -1 
	end
	local owner, handler, ignore = Scl.GetRegisterInfo(reg_obj)
	if type(handler) == "number" then
		Duel.RegisterEffect(reg_eff, handler)
	else
		handler:RegisterEffect(reg_eff, ignore)
	end
	return reg_eff, reg_eff:GetFieldID()
end
--Switch different formats phase_obj to number-format.
--phase_obj can be number-format (like PHASE_END), or can be string-format (Like "EP")
--//return number-format phase, array contains each number-format phase
-->>eg1. Scl.GetNumFormatPhase(PHASE_END)
-->>return PHASE_END, { PHASE_END }
function Scl.GetNumFormatPhase(phase_obj)
	if type(phase_obj) == "number" then 
		return phase_obj, Scl.SplitNumber2PowerOf2(phase_obj)
	else
		local phase, phase2, phase_arr = 0, 0, { }
		for _, chk_phase in pairs(Scl.SplitString(phase_obj)) do 
			phase2 = Scl.Phase_List[chk_phase]
			phase = phase | phase2
			table.insert(phase_arr, phase2)
		end
		return phase, phase_arr
	end
end
--Complete creat a new effect.
--reg_obj: see Scl.GetRegisterInfo(reg_obj)
--code_obj: can be number-format (like EVENT_FREE_CHAIN) or string-format (like "BeNormalSummoned" or "BeNormalSummoned,BeSpecialSummoned")
--desc_obj: see Scl.RegisterDescription(reg_eff, desc_obj)
--lim_obj: see Scl.RegisterActivateCountLimit(reg_eff, lim_obj)
--ctgy and flag: see Scl.RegisterCategoryAndProperty(reg_eff, ctgy, flag)
--tgrng_obj: see Scl.RegisterTargetRange(reg_eff, tgrng_obj)
--tmg_obj: see Scl.RegisterHintTiming(reg_eff, tmg_obj)
--rst_obj: see Scl.RegisterReset(reg_eff, rst_obj)
--//return register effect1, register effect2, ...
-->>eg1. Scl.CreateEffect(c, EFFECT_TYPE_IGNITION, nil, "Add2Hand", {id, 1}, "Search,Add2Hand", nil, LOCATION_MZONE, nil, nil, s.thtg, s.thop)
-->>register an Ignition effect on the card c, seems this effect is a search effect.
-->>eg2. Scl.CreateEffect(c, EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O, "BeNormalSummoned,BeSpecialSummoned", "Add2Hand", {id, 1}, "Search,Add2Hand", nil, nil, nil, s.thtg, s.thop)
-->>register 2 single trigger effects on the card c, when it is normal summoned or speical summoned, the effect could be activated.
function Scl.CreateEffect(reg_obj, eff_typ, code_obj, desc_obj, lim_obj, ctgy, flag, zone_obj, con, cost, tg, op, val, tgrng_obj, tmg_obj, rst_obj)
	s.set_global_error_code(reg_obj)
	local owner, handler, ignore_immnue = Scl.GetRegisterInfo(reg_obj)
	local error_code = s.get_error_card_id()
	local reg_arr = { }
	local reg_eff
	if type(code_obj) ~= "string" then
		if Scl.CheckBoolean(owner, true) then
			reg_eff = Effect.GlobalEffect()
		else
			reg_eff = Effect.CreateEffect(owner)
		end
		if eff_typ then
			reg_eff:SetType(eff_typ)
		end
		if code_obj then
			reg_eff:SetCode(code_obj)
		end
		Scl.RegisterDescription(reg_eff, desc_obj)
		if lim_obj then
			Scl.RegisterActivateCountLimit(reg_eff, lim_obj)
		end
		Scl.RegisterCategoryAndProperty(reg_eff, ctgy, flag)
		if zone_obj then
			Scl.RegisterZone(reg_eff, zone_obj)
		end
		Scl.RegisterSolvePart(reg_eff, con, cost, tg, op)
		if val then
			--case inside series
			if type(val) == "string" then
				Scl.String_Value[reg_eff] = eff_val
			else
				reg_eff:SetValue(val)
			end
		end
		if tgrng_obj then
			Scl.RegisterTargetRange(reg_eff, tgrng_obj)
		end
		if tmg_obj then
			Scl.RegisterHintTiming(reg_eff, tmg_obj)
		end
		if rst_obj then
			Scl.RegisterReset(reg_eff, rst_obj)
		end
		Scl.RegisterEffect(reg_obj, reg_eff)
		table.insert(reg_arr, reg_eff)
	elseif type(code_obj) == "string" then
		local code_str_arr = Scl.SplitString(code_obj, ",")
		for _, code_str in pairs(code_str_arr) do
			if not Scl.Timing_List[code_str] then
				Debug.Message(error_code .. ": --" .. code_str .. "-- is error, Scl.CreateEffect must have a correct timing string")
				return
			end
			local timing_arr, single_con_arr, field_con_arr = Scl.SplitArrayByMultipleOf3(Scl.Timing_List[code_str])
			for idx, timing in pairs(timing_arr) do
				reg_eff = Scl.CreateEffect(reg_obj, eff_typ, timing, desc_obj, lim_obj, ctgy, flag, zone_obj, s.create_effect_con(eff_typ, con, single_con_arr[idx] or aux.TRUE, field_con_arr[idx] or single_con_arr[idx] or aux.TRUE), cost, tg, op, val, tgrng_obj, tmg_obj, rst_obj)
				table.insert(reg_arr, reg_eff)
			end
		end
	end
	Scl.Global_Effect_Owner_ID = nil
	return table.unpack(reg_arr)
end
function s.create_effect_con(eff_typ, con, single_con, field_con)
	return function(e, tp, eg, ...)
		local c = e:GetHandler()
		local single_con_fun, field_con_fun
		if type(single_con) == "table" then
			single_con_fun = function()
				return single_con[1](c, single_con[2], single_con[3], single_con[4], single_con[5])
			end
		else
			single_con_fun = single_con
		end
		if type(field_con) == "table" then
			field_con_fun = function()
				return eg:IsExists(field_con[1], 1, nil, field_con[2], field_con[3], field_con[4], field_con[5])
			end
		else
			field_con_fun = field_con
		end
		if con and not con(e, tp, eg, ...) then
			return false
		end
		if eff_typ & EFFECT_TYPE_SINGLE ~= 0 and not single_con_fun(e, tp, eg, ...) then
			return false
		end
		if eff_typ & EFFECT_TYPE_SINGLE == 0 and not field_con_fun(e, tp, eg, ...) then
			return false
		end
		return true
	end
end
--[[turn the eff_obj (can be single effect or effect list) to the EFFECT_TYPE_GRANT effect(s)
--the cards meets tg(e, c) and is in tgrng_obj will gain effects from eff_obj
--//return the effects with code EFFECT_TYPE_GRANT
-->>eg1. local e1 = Scl.CreateSingleBuffEffect(c, "!BeDestroyedByBattle", 1, "MonsterZone")
		local e2 = Scl.Turn2GainedEffect(c, e1, s.tg, { "MonsterZone", 0 }, "Spell&TrapZone")
	>>while card c is in your spell and trap zone, each faceup monsters in your monster zone and meet s.tg(e,c) will gain the effect e1.
--]]
function Scl.Turn2FieldGainedEffect(reg_obj, eff_obj, tg, tgrng_obj, zone_obj, con, rst_obj, ex_flag)
	local rtn_arr = { }
	local eff_arr = type(eff_obj) == "table" and eff_obj or { eff_obj }
	for _, e0 in pairs(eff_arr) do
		local e1 = Scl.CreateEffect(reg_obj, EFFECT_TYPE_FIELD + EFFECT_TYPE_GRANT, nil, nil, nil, nil, ex_flag, zone_obj, con, nil, tg, nil, nil, tgrng_obj, nil, rst_obj)
		e0:Reset()
		e1:SetLabelObject(e0)
		table.insert(rtn_arr)
	end
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<< Buff Effects <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Creat a buff effect (single buff (eff_typ == "SingleBuff"), field buff (eff_typ == "FieldBuff") or equip buff (eff_typ == "EquipBuff")).
--base_att_str can be string-fromat (like "+ATK", or "+ATK,+DEF"), the function will split base_att_str to several single attribute strings, and for each string, use it as index to find effect code in Scl.Buff_Code_List and create a corresponding buff.
--val_obj can be single value (like 1000, s.val), or be table-format (like { 1000, 2000, s.val }).
--if be table-format, each value in the table is corresponding to each effect code, in order.
--if be single value but there's 2+ effect codes, or be table-format but its length is less than the count of effect code, the first value will corresponding to all the effect codes that is out of correspondence.
--other param's format see Scl.CreateEffect
--because Scl.Buff_Code_List listed each buff's default property(s), and functions like Scl.CreateSingleBuffEffect, Scl.CreateSingleBuffCondition, Scl.CreateFieldBuffEffect,  Scl.CreatePlayerBuffEffect and Scl.AddSingleBuff, Scl.AddEquipBuff can also automatic add the corresponding property(s), that means you won't need to add property(s) manually in most of the time when you call those fucntions. So, I post the parama "flag" to last.
--//return effect for code1, effect for code2, ...
-->>this function is an intermediate function, eg see Scl.CreateSingleBuffEffect, Scl.CreateSingleBuffCondition, Scl.CreateFieldBuffEffect,  Scl.CreatePlayerBuffEffect and Scl.AddSingleBuff, Scl.AddEquipBuff
function Scl.CreateBuffEffect(reg_obj, eff_typ, base_att_str, val_obj, tg, tgrng_obj, rng, con, rst_obj, desc_obj, lim_obj, flag)
	s.set_global_error_code(reg_obj) 
	local error_code = s.get_error_card_id()
	Scl.Global_Effect_Owner_ID = nil
	local eff_typ_arr = Scl.SplitString(eff_typ, ",")
	local eff_typ1, eff_typ2 = eff_typ_arr[1], eff_typ_arr[2]
	local reg_typ2 = 0
	if eff_typ2 and eff_typ2 == "XyzMaterial" then 
		reg_typ2 = EFFECT_TYPE_XMATERIAL
	end
	--"EFFECT_TYPE_TARGET" is useless now
	if eff_typ2 and eff_typ2 == "Target" then 
		reg_typ2 = EFFECT_TYPE_TARGET
	end
	local val_arr = type(val_obj) == "table" and val_obj or { val_obj }
	local owner, handler = Scl.GetRegisterInfo(reg_obj)
	local flag = Scl.GetNumFormatProperty(flag) or 0
	local att_str_arr = type(base_att_str) == "number" and { base_att_str } or Scl.SplitString(base_att_str)
	local eff_list = { }
	for idx, att_str in pairs(att_str_arr) do
		local att_arr = { }
		local eff_code, only_affect_self, dft_val, dft_lim, ex_sflag, ex_fflag, ex_rst 
		--case1 custom buff 
		if type(att_str) == "number" then 
			att_arr =  { att_str } 
		--case2 single buff in Scl.Buff_Code_List and Scl.Player_Buff_Code_List
		elseif type(att_str) == "string" then
			if eff_typ1 == "PlayerBuff" then
				att_arr = Scl.Player_Buff_Code_List[att_str]
			elseif eff_typ1 == "EffectBuff" then
				att_arr = Scl.Effect_Buff_Code_List[att_str]
			else
				att_arr = Scl.Buff_Code_List[att_str]
			end
		end
		if not att_arr then 
			Debug.Message("Scl.Creat" .. eff_typ .. "Effect for " .. error_code .. " must have a correct base_att_str (2nd parama).")
			return 
		end
		if type(att_arr[1]) == "number" then
			eff_code, only_affect_self, dft_val, dft_lim, ex_sflag, ex_fflag, ex_rst = Scl.GetArrayElementsByNumIndex(att_arr, 1, 7)
			ex_sflag = ex_sflag or 0
			ex_fflag = ex_fflag or 0
			ex_rst = ex_rst or 0
			local eff_val = val_arr[idx] or val_arr[1] or dft_val or 1 
			if desc_obj then 
				flag = flag | EFFECT_FLAG_CLIENT_HINT
			end
			if not rng and aux.GetValueType(handler) == "Card" and reg_typ2 == 0 then
				rng = Scl.Global_Zone or handler:GetLocation()
			end
			if rst_obj then
				rst_obj = type(rst_obj) == "table" and rst_obj or { rst_obj }
				rst_obj[1] = rst_obj[1] | ex_rst 
			end
			local lim = lim_obj or dft_lim
			local e1
			if eff_typ1 == "SingleBuff" or eff_typ1 == "SingleBuffCondition" then
				e1 = Scl.CreateEffect(reg_obj, reg_typ2 ~= 0 and reg_typ2 or EFFECT_TYPE_SINGLE, eff_code, desc_obj, lim, nil, flag | ex_sflag, rng, con, nil, nil, nil, eff_val, nil, nil, rst_obj)
			elseif eff_typ1 == "EquipBuff" then
				e1 = Scl.CreateEffect(reg_obj, EFFECT_TYPE_EQUIP, eff_code, desc_obj, lim, nil, flag | ex_sflag, nil, con, nil, nil, nil, eff_val, nil, nil, rst_obj)
			elseif eff_typ1 == "FieldBuff" or eff_typ1 == "PlayerBuff" then
				e1 = Scl.CreateEffect(reg_obj, EFFECT_TYPE_FIELD | reg_typ2, eff_code, desc_obj, lim, nil, flag | ex_fflag, rng, con, nil, tg, nil, eff_val, tgrng_obj, nil, rst_obj)
			elseif eff_typ1 == "EffectBuff" then
				e1 = Scl.CreateEffect(reg_obj, EFFECT_TYPE_FIELD | reg_typ2, eff_code, desc_obj, lim, nil, flag | ex_fflag, rng, con, nil, nil, nil, eff_val, nil, nil, rst_obj)
			end
			table.insert(eff_list, e1)
		--case3 buffs in Scl.Buff_Code_List and Scl.Player_Buff_Code_List
		elseif type(att_arr[1]) == "table" then
			local eff_list2
			for _, single_att_str in pairs(att_arr[1]) do
				local e1 = Scl.CreateBuffEffect(reg_obj, eff_typ, single_att_str, val_obj, tg, tgrng_obj, rng, con, rst_obj, desc_obj, lim_obj, flag)
				table.insert(eff_list, e1)
			end
		end
	end
	return table.unpack(eff_list)   
end 
--Creat a single buff effect.
--flag will auto add EFFECT_FLAG_SINGLE_RANGE
--paramas format: see Scl.CreateBuffEffect
--if you want to use an effect to add a buff, better use Scl.AddSingleBuff
--//return effect for code1, effect for code2, ...
-->>eg1. Scl.CreateSingleBuffEffect(c, "+ATK", 1000, LOCATION_MZONE)
-->>register 1 buff on the card c, the effect will increase 1000 ATK for c, while it is on the MZONE.
-->>eg2. Scl.CreateSingleBuffEffect(c, "+ATK,+DEF", 1000, LOCATION_MZONE)
-->>register 2 buffs on the card c, increase 1000 ATK and 1000 DEF for c, while it is on the MZONE.
-->>eg3. Scl.CreateSingleBuffEffect({c, tc}, "+ATK,+DEF", {1000, 2000}, nil, nil, RESETS_DISABLE_SCL)
-->>register 2 buffs on the card tc, increase 1000 ATK and 2000 DEF for tc, and the buff will be reset cause RESETS_DISABLE_SCL.
function Scl.CreateSingleBuffEffect(reg_obj, att_obj, val_obj, rng, con, rst_obj, desc_obj, lim_obj, flag)
	local flag2 = Scl.GetNumFormatProperty(flag)
	return Scl.CreateBuffEffect(reg_obj, "SingleBuff", att_obj, val_obj, nil, nil, rng, con, rst_obj, desc_obj, lim_obj, flag2 | EFFECT_FLAG_SINGLE_RANGE)
end
--Creat a single buff effect(s) to the xyz monster attached the card has these buffs as material.
--use same as Scl.CreateSingleBuffEffect but the parama-zone is removed
--paramas format: see Scl.CreateBuffEffect
--//return effect for code1, effect for code2, ...
function Scl.CreateSingleBuffEffectGainedByXyzMaterial(reg_obj, att_obj, val_obj, con, rst_obj, desc_obj, lim_obj, flag)
	return Scl.CreateBuffEffect(reg_obj, "SingleBuff,XyzMaterial", att_obj, val_obj, nil, nil, nil, con, rst_obj, desc_obj, lim_obj, flag)
end
--Creat a single buff condition.
--flag will auto add EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_SINGLE_RANGE
--rng default == "0xff" (in any where)
--other paramas format: see Scl.CreateBuffEffect
--//return effect for code1, effect for code2, ...
-->>eg1. Scl.CreateSingleBuffCondition(c, "!FusionMaterial", 1)
-->>register 1 buff on the card c, the condition will forbid it be fusion material in any time any where.
-->>eg2. Scl.CreateSingleBuffCondition(c, "!FusionMaterial,!SynchroMaterial", 1)
-->>register 2 buff on the card c, the condition will forbid it be fusion and synchro material in any time any where.
-->>eg3. Scl.CreateSingleBuffCondition(c, "SpecialSummonCondition", aux.FALSE)
-->>register 1 buff on the card c, the condition will forbid it be speical summoned from any where in any time.
function Scl.CreateSingleBuffCondition(reg_obj, att_obj, val_obj, rng, con, rst_obj, desc_obj, lim_obj, flag)
	local flag2 = Scl.GetNumFormatProperty(flag)
	flag2 = flag2 | (EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_SINGLE_RANGE)
	return Scl.CreateBuffEffect(reg_obj, "SingleBuffCondition", att_obj, val_obj, nil, nil, rng or 0xff, con, rst_obj, desc_obj, lim_obj, flag2)
end
--Creat a single buff condition(s) to the xyz monster attached the card has these buffs as material.
--use same as Scl.CreateSingleBuffCondition but the parama-zone is removed
--paramas format: see Scl.CreateBuffEffect
--//return effect for code1, effect for code2, ...
function Scl.CreateSingleBuffConditionGainedByXyzMaterial(reg_obj, att_obj, val_obj, con, flag, rst_obj, desc_obj, lim_obj)
	local flag2 = Scl.GetNumFormatProperty(flag)
	flag2 = flag2 | (EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE)
	return Scl.CreateBuffEffect(reg_obj, "SingleBuffCondition,XyzMaterial", att_obj, val_obj, nil, nil, nil, con, rst_obj, desc_obj, lim_obj, flag2)
end
--Creat a field buff effect.
--paramas format: see Scl.CreateBuffEffect
--//return effect for code1, effect for code2, ...
-->>eg1. Scl.CreateFieldBuffEffect(c, "+ATK", 1000, aux.TRUE, { LOCATION_MZONE, 0 }, LOCATION_MZONE)
-->>register 1 buff on the card c, the buff will increase 1000 ATK for any monsters your control, while card c is on the MZONE.
-->>eg2. Scl.CreateFieldBuffEffect(c, "+ATK,+DEF", -1000, s.atktg, { 0, LOCATION_MZONE }, LOCATION_MZONE)
-->>register 2 buffs on the card c, decrease 1000 ATK and 1000 DEF for any monsters your opponent controls that meet the filter s.atktg, while card c is on the MZONE.
-->>eg3. Scl.CreateFieldBuffEffect({c, tp}, "+ATK,+DEF", {1000, 2000}, aux.TRUE, { LOCATION_MZONE, 0 }, nil, nil, RESET_EP_SCL)
-->>register 2 buffs on player tp, increase 1000 ATK and 2000 DEF for any monsters you control, and the buff will be reset cause RESET_EP_SCL
function Scl.CreateFieldBuffEffect(reg_obj, att_obj, val_obj, tg, tgrng_obj, rng, con, rst_obj, desc_obj, lim_obj, flag)
	return Scl.CreateBuffEffect(reg_obj, "FieldBuff", att_obj, val_obj, tg, tgrng_obj, rng, con, rst_obj, desc_obj, lim_obj, flag)
end
--Creat a field buff effect(s) to the xyz monster attached the card has these buffs as material.
--use same as Scl.CreateFieldBuffEffect but the parama-zone is removed
--paramas format: see Scl.CreateBuffEffect
--//return effect for code1, effect for code2, ...
function Scl.CreateFieldBuffEffectGainedByXyzMaterial(reg_obj, att_obj, val_obj, tg, tgrng_obj, con, rst_obj, desc_obj, lim_obj, flag)
	return Scl.CreateBuffEffect(reg_obj, "FieldBuff,XyzMaterial", att_obj, val_obj, tg, tgrng_obj, nil, con, rst_obj, desc_obj, lim_obj, flag)
end
--Creat a player buff effect.
--paramas format: see Scl.CreateBuffEffect
--flag will auto add EFFECT_FLAG_PLAYER_TARGET
--//return effect for code1, effect for code2, ...
-->>eg1. Scl.CreatePlayerBuffEffect(c, "!2Hand", 1, nil, { 1, 1 }, nil, LOCATION_MZONE)
-->>register 1 buff on the card c, the buff will limit both player add card to their hand, while card c is on the MZONE.
-->>eg2. Scl.CreatePlayerBuffEffect(c, "!2Hand,!SpecialSummon", 1, nil, { 0, 1 }, LOCATION_MZONE)
-->>register 2 buffs on the card c, limit your opponent add card to their hand and Speical Summon any monsters, while card c is on the MZONE.
-->>eg3. Scl.CreatePlayerBuffEffect({c, tp}, "!SpecialSummon", 1, s.limit, { 1, 0 }, nil, nil, RESET_EP_SCL)
-->>register 1 buff on player tp, limit him cannot Special Summon any monsters meets the filter s.limit, and the buff will be reset cause RESET_EP_SCL
function Scl.CreatePlayerBuffEffect(reg_obj, att_obj, val_obj, tg, tgrng_obj, rng, con, rst_obj, desc_obj, lim_obj, flag)
	local flag2 = Scl.GetNumFormatProperty(flag)
	return Scl.CreateBuffEffect(reg_obj, "PlayerBuff", att_obj, val_obj, tg, tgrng_obj, rng, con, rst_obj, desc_obj, lim_obj, flag2 | EFFECT_FLAG_PLAYER_TARGET)
end
--Creat a player buff effect(s) to the xyz monster attached the card has these buffs as material.
--use same as Scl.CreatePlayerBuffEffect but the parama-zone is removed
--paramas format: see Scl.CreateBuffEffect
--//return effect for code1, effect for code2, ...
function Scl.CreatePlayerBuffEffectGainedByXyzMaterial(reg_obj, att_obj, val_obj, tg, tgrng_obj, con, rst_obj, desc_obj, lim_obj, flag)
	local flag2 = Scl.GetNumFormatProperty(flag)
	return Scl.CreateBuffEffect(reg_obj, "PlayerBuff,XyzMaterial", att_obj, val_obj, tg, tgrng_obj, nil, con, rst_obj, desc_obj, lim_obj, flag2 | EFFECT_FLAG_PLAYER_TARGET)
end
--Creat an equip buff condition(s).
--other paramas format: see Scl.CreateBuffEffect
--//return effect for code1, effect for code2, ...
-->>eg1. Scl.CreateEquipBuffEffect(c, "!FusionMaterial", 1)
-->>register 1 buff on the card c, the buff will forbid its equip target be fusion material.
-->>eg2. Scl.CreateEquipBuffEffect(c, "+ATK,+DEF", 1000)
-->>register 2 buff on the card c, the buff will increase 1000 ATK and DEF for its equip target.
-->>eg3. Scl.CreateEquipBuffEffect({c, tc}, "+Type", TYPE_TUNER, "ImmuneEffect", s.imval)
-->>register 2 buffs on the card tc, the buff will make its equip target becomes a tunner, and make it immune to effects that meet s.imval
function Scl.CreateEquipBuffEffect(reg_obj, att_obj, val_obj, con, rst_obj, desc_obj, lim_obj, flag)
	return Scl.CreateBuffEffect(reg_obj, "EquipBuff", att_obj, val_obj, nil, nil, nil, con, rst_obj, desc_obj, lim_obj, flag)
end
--Create an effect buff effect(s), affect to effects
--other paramas format: see Scl.CreateBuffEffect
--//return effect for code1, effect for code2, ...
-->>eg1. Scl.CreateEffectBuffEffect(c, "!NegateActivation", s.val)
-->>creat a buff affect any effects meet s.val(e, chain_index), make their activations cannot be negated.
function Scl.CreateEffectBuffEffect(reg_obj, att_obj, val_obj, rng, con, rst_obj, desc_obj, lim_obj, flag)
	return Scl.CreateBuffEffect(reg_obj, "EffectBuff", att_obj, val_obj, nil, nil, rng, con, rst_obj, desc_obj, lim_obj, flag)
end
--Qucik add buff in cards (single buff (eff_typ == "SingleBuff"), field buff (eff_typ == "FieldBuff") or equip buff (eff_typ == "EquipBuff")).
--differ from Scl.CreateEffect and Scl.CreateBuffEffect, this function's param - reg_obj, in addition to normal format, it also can be - { owner, handler_group, ignore_immnue }, or {owner, handler_list (see Scl.Mix2Group), ingnore_immnue}, because an effect always add buffs to many cards at the same time.
--if only_affect_self = true, means this buff is only affect to the owner self (owner == handler), the reg_obj's format must be Card, and the buff will be reset while it is disable.
--the ... format: buff_str1, its value, buff_str2, its value, ...
--the format of buff_str: see Scl.Buff_Code_List
--[[the follow special buff_str can use in ... :
	"Reset", reset_obj : means when to reset the front buff(s). Its default to "Reset", RESETS_SCL
	"Zone", zone_obj : means in which zone(s) can the buff(s) take effect. Its default to "Zone", handler:GetLocation().
]]--
--//return buff_effect1, buff_effect2, ...
-->>this function is an intermediate function, eg see Scl.AddSingleBuff and Scl.AddEquipBuff
function Scl.AddBuff(reg_obj, eff_typ, only_affect_self, ...)
	local owner, handler_group, ignore_immnue 
	if type(reg_obj) ~= "table" then 
		owner = reg_obj 
		handler_group = Scl.Mix2Group(owner)
		ignore_immnue = false
	else
		owner = reg_obj[1]
		handler_group = Scl.Mix2Group(reg_obj[2])
		ignore_immnue = reg_obj[3]
	end
	local total_arr = { }
	local buff_arr = { ... }  
	table.insert(buff_arr, "Reset") 
	table.insert(buff_arr, RESETS_SCL) 
	for handler in aux.Next(handler_group) do 
		local reg_arr = { owner, handler, ignore_immnue }
		local buff_arr2, val_arr = Scl.SplitArrayByParity(buff_arr)
		local arr = { }
		local cache_arr1, cache_arr2 = { },{ }
		for idx, buff_str in pairs(buff_arr2) do 
			local val = val_arr[idx]
			if buff_str == "Reset" then 
				Scl.Creat_Effect_Without_Register = false 
				local rst_event, rst_ct = Scl.GetNumFormatReset(val)
				if only_affect_self then
					rst_event = rst_event | RESET_DISABLE
				end
				for _, reg_eff in pairs(cache_arr1) do 
					Scl.RegisterReset(reg_eff, { rst_event, rst_ct })
					Scl.RegisterEffect(reg_obj, reg_eff)
				end
				cache_arr1 = { }
			elseif buff_str == "Zone" then 
				for _, reg_eff in pairs(cache_arr2) do 
					Scl.RegisterZone(reg_eff, val)
				end
				cache_arr2 = { }
			else
				Scl.Creat_Effect_Without_Register = true 
				if not only_affect_self or not Scl.Buff_Code_List[buff_str][2] then 
					Scl.Global_Property = EFFECT_FLAG_CANNOT_DISABLE
				end
				if eff_typ == "SingleBuff" then 
					arr = { Scl.CreateSingleBuffEffect(reg_obj, buff_str, val) }
				elseif eff_typ == "EquipBuff" then 
					arr = { Scl.CreateEquipBuffEffect(reg_obj, buff_str, val) }
				end
				cache_arr1 = Scl.MixArrays(cache_arr1, arr)
				cache_arr2 = Scl.CloneArray(cache_arr1)
				total_arr = Scl.MixArrays(total_arr, arr)
			end
		end
		Scl.Creat_Effect_Without_Register = false  
	end
	return table.unpack(total_arr)
end
--Quick add single buff(s) to reg_obj.
--paramas format: see Scl.CreateBuffEffect
--if c == nil, it won't add buff(s), it turn to record the buff paramas into Scl.Single_Buff_Affect_Self_List, become a outcase function, plug in to some functions to add buff(s) in those functions (like Scl.SpecialSummon)
-->>eg1. Scl.AddSingleBuff({c, tc}, "+ATK", 1000)
-->>add a buff to tc that increase its 1000 ATK while it is in current zone (default), this buff will reset when RESETS_SCL (default)
-->>return buff_effect 
-->>eg2. Scl.AddSingleBuff(c, "+ATK,+DEF", 1000, "Reset", RESETS_DISABLE_SCL)
-->>add a buff to c that increase its 1000 ATK and DEF while it is in current zone (default), those buffs will reset when RESETS_DISABLE_SCL 
-->>return buff_effect1, buff_effect2
-->>eg3. Scl.AddSingleBuff(c, "+Level", -1, "+Race", RACE_WARRIOR, "Reset", RESETS_WITHOUT_TO_FIELD_SCL,"Zone","Hand,MonsterZone")
-->>add a buff to c that decrease its 1 Level and make it become a Warrior monster while it is in your hand or monster zone, those buffs will reset when RESETS_WITHOUT_TO_FIELD_SCL
-->>return buff_effect1, buff_effect2 
-->>eg4. Scl.AddSingleBuff({c, g, true}, "!FusionMaterial", 1)
-->>add a buff to each card in g, that forbid them be used as fusion material while they are in current zone (default), this buff will reset when RESETS_SCL (default)
-->>return buff_effect_4_card1, buff_effect_4_card2,...
function Scl.AddSingleBuff(reg_obj, ...)
	if not reg_obj then 
		Scl.Single_Buff_List = { ... }
		return true
	else
		return Scl.AddBuff(reg_obj, "SingleBuff", false, ...)
	end
end
--Quick add single buff(s) to card c self (owner == handler), the buff can only affect owner. If Scl.Buff_Code_List[buff_str][2] == true, the buff will be reset while it is disabled.
--if c == nil, it won't add buff(s), it turn to record the buff paramas into Scl.Single_Buff_Affect_Self_List, become a outcase function, plug in to some functions to add buff(s) in those functions (like Scl.SpecialSummon)
--paramas format: see Scl.CreateBuffEffect
-->>eg1. Scl.AddSingleBuff2Self(c, "+ATK", 1000)
-->>card c add a buff to self that increase its 1000 ATK while it is in current zone (default), this buff will reset when RESETS_DISABLE_SCL (default)
function Scl.AddSingleBuff2Self(c, ...)
	if not c then 
		Scl.Single_Buff_Affect_Self_List = { ... }
		return true
	else
		return Scl.AddBuff(c, "SingleBuff", true, ...)
	end
end
--Quick add equip buff(s) to reg_obj.
--paramas format: see Scl.CreateBuffEffect
--if c == nil, it won't add buff(s), it turn to record the buff paramas into Scl.Single_Buff_Affect_Self_List, become a outcase function, plug in to some functions to add buff(s) in those functions (like Scl.Equip)
-->>eg1. Scl.AddEquipBuff({c, tc}, "+ATK", 1000)
-->>add a buff to tc that increase its equip target's 1000 ATK, this buff will reset when RESETS_SCL (default)
-->>return buff_effect 
-->>eg2. Scl.AddEquipBuff(c, "+ATK,+DEF", 1000, "Reset",RESETS_DISABLE_SCL)
-->>add a buff to c that increase its equip target's 1000 ATK and DEF, those buffs will reset when RESETS_DISABLE_SCL 
-->>return buff_effect1, buff_effect2
-->>eg3. Scl.AddEquipBuff(c, "+Level", -1, "+Race", RACE_WARRIOR, "Reset", RESETS_WITHOUT_TO_FIELD_SCL,"Zone","Hand,MonsterZone")
-->>add a buff to c that decrease its equip target's 1 Level and make it become a Warrior monster while it is in your hand or monster zone, those buffs will reset when RESETS_WITHOUT_TO_FIELD_SCL
-->>return buff_effect1, buff_effect2 
-->>eg4. Scl.AddEquipBuff({c, g, true}, "!FusionMaterial", 1)
-->>add a buff to each card in g, that forbid their equip targets be used as fusion material, those buffs will reset when RESETS_WITHOUT_TO_FIELD_SCL
-->>return buff_effect_4_card1, buff_effect_4_card2,...
function Scl.AddEquipBuff(reg_obj, ...)
	if not reg_obj then 
		Scl.Equip_Buff_List = { ... }
		return true
	else
		return Scl.AddBuff(reg_obj, "EquipBuff", false, ...)
	end
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<Spell&Trap Activate<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Create a Spell/Trap's activate effect. 
--code default == EVENT_FREE_CHAIN 
--desc_obj default == DESC_ACTIVATE_SCL
--if the register handler is a Trap or Quick Play Spell, tmg_obj will automatic set to { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE }.
--other parama format : see Scl.CreateEffect
--//return effect, effect id
-->>eg1. Scl.CreateActivateEffect(c, nil, nil, {1, "Oath"}, "Search,Add2Hand", nil, nil, nil, s.tg, s.op)
-->>register an activate effect to card c, it can only activate once per turn, it is an searcher.
-->>return effect, effect id
function Scl.CreateActivateEffect(reg_obj, code, desc_obj, lim_obj, ctgy, flag, con, cost, tg, op, tmg_obj, rst_obj)
	local _, handler = Scl.GetRegisterInfo(reg_obj)
	if handler:IsType(TYPE_TRAP + TYPE_QUICKPLAY) and not tmg_obj then
		tmg_obj = { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE }
	end
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_ACTIVATE, code or EVENT_FREE_CHAIN, desc_obj or DESC_ACTIVATE_SCL , lim_obj, ctgy, flag, nil, con, cost, tg, op, nil, nil, tmg_obj, rst_obj)
end  
--Create an activate equip effect for Equip Spell, and automatic set the Equip Limit effect.
--eqfilter(c ,e, tp) is the condition the equip card should meet, it will automatic add a "Card.IsFaceup" check.
--//return equip activate effect, EFFECT_EQUIP_LIMIT buff condition
-->>eg1. Scl.CreateActivateEffect_Equip(c)
-->>create an equip effect that make the Equip Spell can equip to any faceup monster on the field.
-->>eg2. Scl.CreateActivateEffect_Equip(c, aux.FilterBoolFunction(Card.IsRace, RACE_WARRIOR), nil, nil, nil, s.cost)
-->>create an equip effect that make the Equip Spell can only equip to Warrior-monster on the field, and should pay s.cost when activate.
function Scl.CreateActivateEffect_Equip(reg_obj, eqfilter, desc_obj, lim_obj, con, cost) 
	eqfilter = eqfilter or Card.IsFaceup 
	local limf = function(c, e, tp)
		return c:IsFaceup() and eqfilter(c, tp)
	end
	local e1 = Scl.CreateActivateEffect(reg_obj, nil, nil, lim_obj, "Equip", "Target", con, cost, { "Target", limf, "Equip", LOCATION_MZONE, LOCATION_MZONE}, s.create_activate_effect_equip_op)
	local e2 = Scl.CreateSingleBuffCondition(reg_obj, "EquipLimit", s.create_activate_effect_equip_value(limf))
	return e1, e2
end
function s.create_activate_effect_equip_op(e, tp, eg, ep, ev, re, r, rp) 
	local _, c = Scl.GetFaceupActivateCard()
	local _, tc = Scl.GetTargetsReleate2Chain(Card.IsFaceup)
	if c and tc then
		Duel.Equip(tp, c, tc)
	end
end
function s.create_activate_effect_equip_value(eqfilter) 
	return function(e, c)
		local tp = e:GetHandlerPlayer()
		return eqfilter(c, e, tp)
	end
end
--Create an activate effect, negate the card's effect.
--param see Scl.CreateQuickOptionalEffect_Negate
--//return effect
-->>eg1. Scl.CreateActivateEffect_NegateEffect(c, "Destroy")
-->>create an activate effect that can negate any effect and destroy that effect's handler.
-->>eg2. Scl.CreateActivateEffect_NegateEffect(c, "Dummy", {1, "Oath"}, { "Monster" }, s.cost, "Return2Hand", "Target", s.tg, s.op)
-->>create an activate effect that can negate monster effect, and can only activate once per turn. You must pay s.cost for its activation, and add the s.op ass the additional operation.
function Scl.CreateActivateEffect_NegateEffect(reg_obj, op_str, lim_obj, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	local e1 = Scl.CreateQuickOptionalEffect_Negate(reg_obj, "NegateEffect", op_str, lim_obj, nil, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	return e1
end
--Create an activate effect, negate the effect's activation.
--param see Scl.CreateQuickOptionalEffect_Negate
--//return effect
-->>eg1. Scl.CreateActivateEffect_NegateActivation(c, "Destroy")
-->>create an activate effect that can negate any activation and destroy that activate effect's handler.
-->>eg2. Scl.CreateActivateEffect_NegateActivation(c, "Dummy", {1, "Oath"}, { "Monster" }, s.cost, "Return2Hand", "Target", s.tg, s.op)
-->>create an activate effect that can negate monster effect's activations, and can only activate once per turn. You must pay s.cost for its activation, and add the s.op ass the additional operation.
function Scl.CreateActivateEffect_NegateActivation(reg_obj, op_str, lim_obj, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	local e1 = Scl.CreateQuickOptionalEffect_Negate(reg_obj, "NegateActivation", op_str, lim_obj, nil, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	return e1
end
--Create an activate effect, fusion summon a monster meets "fus_filter", use cards from "mat_obj" as fusion materials, and do "mat_fun" to those materials, the materials must meet "fcheck" and "gcheck"
--"mat_obj" should be function-format, call mat_obj(e, tp, eg, ...) to get materials.
--"mat_fun" can be string-format (like "Send2GY", "Bainsh", see Scl.Category_List), call s.operate_selected_objects to do the operation on the selected materials and set operation info due to the categroy.
--OR can be function-format, call mat_fun(selected_materials, e, tp, eg, ep, ev, re, r, rp) to do the operation on the selected materials.
--only after all the selected materials be operated successfully by "mat_fun", the fusion summon will be continued, so if you used function-format "mat_fun", PLZ noticed that you should return a boolean value to make this function to distinguish whether you have operated successfully (like return Duel.Destroy(g, REASON_MATERIAL + REASON_EFFECT + REASON_FUSION) == #g)
--if you set the parama must_include_card (defualt = nil), means you must use that card as one of the fusion materials
--fcheck, gcheck (defualt == nil) use to limit your to select materials.
--ex_ctgy (defualt == nil) means extra categroy(s) the ex_op and the function-format mat_fun brings to. 
--ex_flag (defualt == nil) means extra property(s) the ex_tg and ex_op brings to.
--ex_tg (defualt == aux.TRUE) means add an additional target-check to this function.
--[[ex_op (defualt == nil) means add an additional operation to this function.
	call ex_op(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0, means do this operation before select-material-operation, and only this function returns true, the select-material-operation will be continued.
	if chk == 1, means do this operation after the fuison-summon-operation be operated successfully (return true)
	if chk == 2, means do this operation after all the other operations, and ingore whether those operations have succeeded or not.
]]--
--//return fusion summon effect
--[[
	>>eg1. "Polymerization" (24094653) =
		local e1 = Scl.CreateActivateEffect_FusionSummon(c, nil, aux.TRUE, s.mat, "Send2GY")
		function s.mat(e,tp)
			return Duel.GetFusionMaterial(tp)
		end
	>>eg2. "Super Polymerization" (48130397) =
		local e1 = Scl.CreateActivateEffect_FusionSummon(c, nil, aux.TRUE, s.mat, "Send2GY", nil, nil, nil, nil, nil, nil, nil, { "PlayerCost", "Discard", 1 }, s.extg)
		function s.mat(e,tp)
			local g1 = Duel.GetFusionMaterial(tp):Filter(Card.IsOnField, nil)
			local g2 = Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			return g1 + g2
		end
		function s.extg(e, tp, eg, ep, ev, re, r, rp, chk)
			if chk == 0 then 
				return true
			end
			if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
				Duel.SetChainLimit(aux.FALSE)
			end
		end
	>>eg3. "Cynet Fusion" (65801012) =
		local e1 = Scl.CreateActivateEffect_FusionSummon(c, nil, aux.FilterBoolFunction(Card.IsRace, RACE_CYBERSE), s.mat, s.matop, nil, s.fcheck, nil, s.gcheck, nil, nil, "Banished,GYAction")
		function s.exfilter(c)
			return c:IsType(TYPE_LINK) and c:IsRace(RACE_CYBERSE) and c:IsAbleToRemove()
		end
		function s.mat(e,tp)
			local g1 = Duel.GetFusionMaterial(tp):Filter(Card.IsOnField, nil)
			local g2 = Duel.GetMatchingGroup(s.exfilter,tp,LOCATION_GRAVE,0,nil)
			return g1 + g2
		end
		function s.matop(g, e, tp, eg, ep, ev, re, r, rp)
			local rg = g:Filter(Card.IsInZone, "GY")
			g:Sub(rg)
			local ct = 0
			if #g > 0 then
				ct = ct + Duel.SendtoGrave(g, POS_FACEUP, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
			end
			if #rg > 0 then 
				ct = ct + Duel.Remove(rg, POS_FACEUP, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
			end
			return ct == #g
		end
		function s.fcheck(tp,sg,fc)
			return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
		end
		function s.gcheck(sg)
			return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
		end
]]  
function Scl.CreateActivateEffect_FusionSummon(reg_obj, lim_obj, fus_filter, mat_obj, mat_fun, must_include_card, fcheck, fgcheck, gcheck, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj)
	local ctgy2 = ex_ctgy and ex_ctgy .. ",FusionSummon" or "FusionSummon"
	if type(mat_fun) == "string" then
		ctgy2 = ctgy2 .. "," .. mat_fun
	end
	ex_tg = ex_tg or aux.TRUE
	ex_op = ex_op or aux.TRUE
	local e1 = Scl.CreateActivateEffect(reg_obj, nil, desc_obj or "FusionSummon", lim_obj, ctgy2, ex_flag, con, cost, s.fusion_summon_target(ex_tg, fus_filter, mat_obj, mat_fun, must_include_card, fcheck, fgcheck, gcheck), s.fusion_summon_operation(ex_op, fus_filter, mat_obj, mat_fun, must_include_card, fcheck, fgcheck, gcheck))
	return e1
end
function s.fusion_summon_filter(c, fus_filter, e, tp, mat, matf, must_include_card, chkf)
	local mat2 = mat:Filter(Card.IsCanBeFusionMaterial, nil, c)
	return s.operate_filter(fus_filter)(c, e, tp) and c:IsType(TYPE_FUSION) and (not matf or matf(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION, tp, false, false) and c:CheckFusionMaterial(mat2, must_include_card, chkf)
end
function s.fusion_summon_target(ex_tg, fus_filter, mat_obj, mat_fun, must_include_card, fcheck, fgcheck, gcheck)
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		local mat = type(mat_obj) == "function" and mat_obj(e, tp, eg, ep, ev, re, r, rp) or Scl.Mix2Group(mat_obj)
		if chkc then 
			return ex_tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		end
		if chk == 0 then 
			local chkf = tp
			if not ex_tg(e, tp, eg, ep, ev, re, r, rp, 0) then
				return false 
			end
			if #mat == 0 then 
				return false
			end
			aux.FCheckAdditional = fcheck
			aux.FGoalCheckAdditional = fgcheck
			aux.GCheckAdditional = gcheck
			local res = Duel.IsExistingMatchingCard(s.fusion_summon_filter, tp, LOCATION_EXTRA, 0, 1, nil, fus_filter, e, tp, mat, nil, must_include_card, chkf)
			aux.GCheckAdditional = nil
			aux.FCheckAdditional = nil
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce ~= nil then
					local fgroup = ce:GetTarget()
					local mat2 = fgroup(ce,e,tp)
					local mf = ce:GetValue()
					res = Duel.IsExistingMatchingCard(s.fusion_summon_filter, tp, LOCATION_EXTRA, 0, 1, nil, fus_filter, e, tp, mat2, mf, must_include_card, chkf)
				end
			end
			aux.FGoalCheckAdditional = nil
			return res
		end
		scl.list_format_cost_or_target_or_operation(ex_tg)(e, tp, eg, ep, ev, re, r, rp, 1)
		if type(mat_fun) == "string" then
			local reg_p
			if mat:IsExists(Card.IsControler, 1, nil, tp) then 
				reg_p = tp
			end
			if mat:IsExists(Card.IsControler, 1, nil, 1 - tp) then 
				reg_p = 1- tp
			end
			if mat:GetClassCount(Card.GetControler) == 2 then 
				reg_p = PLAYER_ALL
			end
			Duel.SetOperationInfo(0, Scl.Category_List[mat_fun][2], mat, 1, reg_p, 0)
		end
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
		Duel.SetOperationInfo(0, CATEGORY_FUSION_SUMMON, nil, 1, tp, LOCATION_EXTRA)
	end
end
function s.fusion_summon_operation(ex_op, fus_filter, mat_obj, mat_fun, must_include_card, fcheck, fgcheck, gcheck)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local res = not ex_op and true or scl.list_format_cost_or_target_or_operation(ex_op)(e, tp, eg, ep, ev, re, r, rp, 0)
		if Scl.CheckBoolean(res, true) or type(res) == "nil" then
			local chkf=tp
			local mat = type(mat_obj) == "function" and mat_obj(e, tp, eg, ep, ev, re, r, rp) or Scl.Mix2Group(mat_obj)
			mat = mat:Filter(aux.NOT(Card.IsImmuneToEffect), nil, e)
			if #mat == 0 then 
				goto FINAL
			end
			aux.FCheckAdditional = fcheck
			aux.FGoalCheckAdditional = fgcheck
			aux.GCheckAdditional = gcheck
			local sg1=Duel.GetMatchingGroup(s.fusion_summon_filter, tp, LOCATION_EXTRA, 0, nil, fus_filter, e, tp, mat, nil, must_include_card, chkf)
			aux.FCheckAdditional = nil
			aux.GCheckAdditional = nil
			local mat2=nil
			local sg2=nil
			local ce = Duel.GetChainMaterial(tp)
			if ce ~= nil then
				local fgroup = ce:GetTarget()
				mat2 = fgroup(ce,e,tp)
				local mf = ce:GetValue()
				sg2 = Duel.GetMatchingGroup(s.fusion_summon_filter, tp, LOCATION_EXTRA, 0, nil, fus_filter, e, tp, mat2, mf, must_include_card, chkf)
			end
			aux.FGoalCheckAdditional = nil
			local sg = sg1:Clone()
			if sg2 then 
				sg:Merge(sg2) 
			end
			Scl.SelectHint(tp, "SpecialSummon")
			local tc = sg:Select(tp, 1, 1, nil):GetFirst()
			if not tc then  
				goto FINAL
			end
			if sg1:IsContains(tc) and (sg2 == nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp, ce:GetDescription())) then
				aux.FCheckAdditional = fcheck
				aux.FGoalCheckAdditional = fgcheck
				aux.GCheckAdditional = gcheck
				local mat0 = Duel.SelectFusionMaterial(tp, tc, mat, must_include_card, chkf)
				tc:SetMaterial(mat0)
				if type(mat_fun) == "string" then
					res = s.operate_selected_objects(mat0, mat_fun, REASON_FUSION + REASON_MATERIAL + REASON_EFFECT, 1, e, tp, eg, ep, ev, re, r, rp)() == #mat0
				else
					res = mat_fun(mat0, e, tp, eg, ep, ev, re, r, rp, 1)
				end
				if not res then
					goto FINAL
				end
				Duel.BreakEffect()
				res = Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP) > 0
			else
				aux.FGoalCheckAdditional = fgcheck
				local mat0 = Duel.SelectFusionMaterial(tp, tc, mg2, must_include_card, chkf)
				local fop = ce:GetOperation()
				res = fop(ce, e, tp, tc, mat0)
			end
			tc:CompleteProcedure()
			if res or type(res) == "nil" then
				scl.list_format_cost_or_target_or_operation(ex_op)(e, tp, eg, ep, ev, re, r, rp, 1)
			end
		end
		:: FINAL ::
		aux.FCheckAdditional = nil
		aux.FGoalCheckAdditional = nil
		aux.GCheckAdditional = nil
		scl.list_format_cost_or_target_or_operation(ex_op)(e, tp, eg, ep, ev, re, r, rp, 2)
	end
end
--Mix several single activate effects into one activate effect.
--when you activate the mixed effect, you will select which single activate effect you want to activate and apply.
--this function use single activate effects' descriptions as the hint for you selecting, so you should add corresponding descriptions to thoes single activate effects.
--... is the single activate effects that you want to mix in.
--the single activate effects that be mixed cannot be activated.
--//return the mixed effect.
-->>eg1. local e1 = Scl.CreateActivateEffect(c, nil, "Banish", { 1, id, "Oath" }, "Banish", "Target", nil, nil, s.tg, s.op)
-->>	 local e2 = Scl.CreateActivateEffect(c, nil, "Destroy", { 1, id, "Oath" }, "Destroy", "Target", nil, nil, s.tg2, s.op2)
-->>	 local e3 = Scl.CreateActivateEffect_Activate1ofTheseEffects(c, e1, e2)
-->>mix effect e1 and e2 into e3.
function Scl.CreateActivateEffect_Activate1ofTheseEffects(reg_obj, ...)
	local eff_arr = { ... }
	local code_arr = { }
	local con_arr = { }
	local cost_arr = { }
	local tg_arr = { }
	local op_arr = { }
	local desc_arr = { }
	for _, e in pairs(eff_arr) do
		table.insert(code_arr, e:GetCode() or EVENT_FREE_CHAIN)
		table.insert(con_arr, e:GetCondition() or aux.TRUE)
		table.insert(cost_arr, e:GetCost() or aux.TRUE)
		table.insert(tg_arr, e:GetTarget() or aux.TRUE)
		table.insert(op_arr, e:GetOperation() or aux.TRUE)
		table.insert(desc_arr, e:GetDescription() or DESC_ACTIVATE_SCL)
		e:Reset()
	end
	local code = 0
	if Scl.GetValuesKindsFromArray(code_arr) == 1 then 
		code = code_arr[1]
	else
		code = EVENT_FREE_CHAIN
	end
	local e1 = Scl.CreateActivateEffect(reg_obj, code, nil, nil, nil, nil, s.apply_1_of_these_effects_condition(eff_arr, code_arr, con_arr), nil, s.apply_1_of_these_effects_target(eff_arr, code_arr, cost_arr, tg_arr, op_arr, desc_arr))
	return e1
end
function s.apply_1_of_these_effects_condition(eff_arr, code_arr, con_arr)
	return function(e, tp, ...)
		local arr = { }
		for idx, con in pairs(con_arr) do
			local ce = eff_arr[idx]
			local code = code_arr[idx]
			if code == EVENT_FREE_CHAIN then 
				if con(e, tp, ...) and ce:CheckCountLimit(tp) then
					table.insert(arr, idx)
				end
			else
				local res, eg, ep, ev, re, r, rp = Duel.CheckEvent(code, true)
				if res and con(e, tp, eg, ep, ev, re, r, rp) and ce:CheckCountLimit(tp) then
					table.insert(arr, idx)
				end
			end
		end
		Scl.Choose_One_Effect_Condition_Index = arr
		return #arr > 0
	end
end
function s.apply_1_of_these_effects_target(eff_arr, code_arr, cost_arr, tg_arr, op_arr, desc_arr)
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		local con_arr = Scl.Choose_One_Effect_Condition_Index
		if chkc then 
			local idx = Scl.Choose_One_Effect_Select_Index[e][Duel.GetCurrentChain()]
			return idx > 0 and tg_arr[idx](e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		end
		local arr = { }
		if e:IsCostChecked() then 
			for idx, cost in pairs(cost_arr) do
				local code = code_arr[idx]
				if code == EVENT_FREE_CHAIN then 
					if cost(e, tp, eg, ep, ev, re, r, rp, 0) then
						table.insert(arr, idx)
					end
				else
					local res, eg2, ep2, ev2, re2, r2, rp2 = Duel.CheckEvent(code, true)
					if cost(e, tp, eg2, ep2, ev2, re2, r2, rp2, 0) then
						table.insert(arr, idx)
					end
				end
			end
		end
		local arr2 = { }
		for idx, tg in pairs(tg_arr) do
			if not e:IsCostChecked() then
				table.insert(arr, idx)
			end
			local code = code_arr[idx]
			if code == EVENT_FREE_CHAIN then 
				if tg(e, tp, eg, ep, ev, re, r, rp, 0) then
					table.insert(arr2, idx)
				end
			else
				local res, eg2, ep2, ev2, re2, r2, rp2 = Duel.CheckEvent(code, true)
				if tg(e, tp, eg2, ep2, ev2, re2, r2, rp2, 0) then
					table.insert(arr2, idx)
				end
			end
		end
		local res, arr3 = Scl.IsArraysHasIntersection(arr, arr2)
		if chk == 0 then
			return res and (not con_arr or Scl.IsArraysHasIntersection(arr3, con_arr))
		end
		local desc_arr2 = { }
		for idx, desc in pairs(desc_arr) do
			local res = Scl.IsArrayContains_Single(arr3, idx)
			table.insert(desc_arr2, res and Scl.IsArrayContains_Single(con_arr, idx))
			table.insert(desc_arr2, desc)
		end
		local opt = Scl.SelectOption(tp, table.unpack(desc_arr2))
		Scl.Choose_One_Effect_Select_Index[e] = Scl.Choose_One_Effect_Select_Index[e] or { }
		Scl.Choose_One_Effect_Select_Index[e][Duel.GetCurrentChain()] = opt
		local code = code_arr[opt]
		local res, eg2, ep2, ev2, re2, r2, rp2 = false, nil, 0, 0, nil, 0, 0
		if code ~= EVENT_FREE_CHAIN then 
			res, eg2, ep2, ev2, re2, r2, rp2 = Duel.CheckEvent(code, true)
		end
		local ce = eff_arr[opt]
		ce:UseCountLimit(tp)
		if e:IsCostChecked() then
			local cost = cost_arr[opt]
			if code == EVENT_FREE_CHAIN then
				cost(e, tp, eg, ep, ev, re, r, rp, 1)
			else
				cost(e, tp, eg2, ep2, ev2, re2, r2, rp2, 1)
			end
		end
		--beacuse some effects' operations is set in there targets, so first set operation, and second do the chk == 1 target, make target can reset operation.
		e:SetOperation(op_arr[opt])
		local tg = tg_arr[opt]
		if code == EVENT_FREE_CHAIN then
			tg(e, tp, eg, ep, ev, re, r, rp, 1)
		else
			tg(e, tp, eg2, ep2, ev2, re2, r2, rp2, 1)
		end
		Scl.Choose_One_Effect_Condition_Index = nil
		return #arr > 0
	end
end

--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<Triggering Effect<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Create single trigger optional effect.
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateSingleTriggerOptionalEffect(c, EVENT_SPSUMMON_SUCCESS, "Add2Hand", nil, "Add2Hand", "Delay", nil, nil, s.tg, s.op)
--create an effect to card c, if card c is  special summon success, it can activate this effect. 
function Scl.CreateSingleTriggerOptionalEffect(reg_obj, code, desc_obj, lim_obj, cgty, flag, con, cost, tg, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_TRIGGER_O + EFFECT_TYPE_SINGLE, code, desc_obj, lim_obj, cgty, flag, nil, con, cost, tg, op, nil, nil, nil, rst_obj)
end
--Create single trigger mandatory effect.
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateSingleTriggerMandatoryEffect(c, EVENT_SPSUMMON_SUCCESS, "Add2Hand", nil, "Add2Hand", "Delay", nil, nil, s.tg, s.op)
--create an effect to card c, if card c is  special summon success, it must activate this effect.
function Scl.CreateSingleTriggerMandatoryEffect(reg_obj, code, desc_obj, lim_obj, cgty, flag, con, cost, tg, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_TRIGGER_F + EFFECT_TYPE_SINGLE, code, desc_obj, lim_obj, cgty, flag, nil, con, cost, tg, op, nil, nil, nil, rst_obj)
end
--Create flip optional effect.
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateFlipOptionalEffect(c, "Add2Hand", 1, "Add2Hand", "Delay", nil, nil, s.tg, s.op)
--create an effect to the flip card c, if it is flipped, it can activate this effect.
function Scl.CreateFlipOptionalEffect(reg_obj, desc_obj, lim_obj, ctgy, flag, con, cost, tg, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_TRIGGER_O + EFFECT_TYPE_SINGLE + EFFECT_TYPE_FLIP, nil, desc_obj, lim_obj, ctgy, flag, nil, con, cost, tg, op, nil, nil, nil, rst_obj)
end 
--Create flip optional effect.
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateFlipMandatoryEffect(c, "Add2Hand", 1, "Add2Hand", "Target", nil, nil, s.tg, s.op)
--create an effect to the flip card c, if it is flipped, it must activate this effect.
function Scl.CreateFlipMandatoryEffect(reg_obj, desc_obj, lim_obj, ctgy, flag, con, cost, tg, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_SINGLE + EFFECT_TYPE_FLIP, nil, desc_obj, lim_obj, ctgy, flag, nil, con, cost, tg, op, nil, nil, nil, rst_obj)
end 
--Create field trigger optional effect 
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateFieldTriggerOptionalEffect(c, EVENT_SPSUMMON_SUCCESS, "Add2Hand", 1, "Add2Hand", "Delay", LOCATION_MZONE, nil, nil, s.tg, s.op)
--Create an field trigger effect: Once per turn, if a monster(s) is special summoned, you can activate this effect to do s.op. 
function Scl.CreateFieldTriggerOptionalEffect(reg_obj, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_TRIGGER_O + EFFECT_TYPE_FIELD, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, nil, nil, nil, rst_obj)
end
--Create field trigger optional effect 
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateFieldTriggerMandatoryEffect(c, EVENT_SPSUMMON_SUCCESS, "Add2Hand", 1, "Add2Hand", "Delay", LOCATION_MZONE, nil, nil, s.tg, s.op)
-->>create an field trigger effect: Once per turn, if a monster(s) is special summoned, you must activate this effect to do s.op. 
function Scl.CreateFieldTriggerMandatoryEffect(reg_obj, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_TRIGGER_F + EFFECT_TYPE_FIELD, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, nil, nil, nil, rst_obj)
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<Ignition Effect<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Create an ignition effect.
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateIgnitionEffect(c, "Add2Hand", 1, "Add2Hand", "Target", LOCATION_MZONE, nil, nil, s.tg, s.op)
-->>create an ignition effect: Once per turn, you can activate this effect and do s.tg, s.op.
function Scl.CreateIgnitionEffect(reg_obj, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_IGNITION, nil, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, nil, nil, nil, rst_obj)
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Quick Effect<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Create a quick optional effect.
--code default == EVENT_FREE_CHAIN
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateQuickOptionalEffect(c, nil, "Add2Hand", 1, "Add2Hand", nil, LOCATION_MZONE, nil, nil, s.tg, s.op)
-->>create a quick effect: Once per either player's turn, you can activate this effect and do s.tg, s.op.
function Scl.CreateQuickOptionalEffect(reg_obj, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, tmg_obj, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_QUICK_O, code or EVENT_FREE_CHAIN, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, nil, nil, tmg_obj or { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE }, rst_obj)
end 
--Create a quick effect, negate the card's effect (neg_typ == "NegateEffect") or activation (neg_typ == "NegateActivation").
--op_str is the index to find the corresponding operation and the extra category(s) in Scl.Category_List, means negate the effect/activation, and do that operation to the negated card. 
--con can be function, nil, or be a array { ... }, if be nil or array-format, it equals to call the scl.negate_activation_or_effect_con("NegateEffect" ,nil/ ...).
--automatic add "EFFECT_FLAG_DAMAGE_STEP" to the property if neg_typ == "NegateEffect".
--automatic add "EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL" to the property if neg_typ == "NegateActivation".
--ex_ctgy (defualt == nil) means extra categroy(s) the ex_op brings to.
--ex_flag (defualt == nil) means extra property(s) the ex_tg and ex_op brings to.
--ex_tg (defualt == aux.TRUE) means add an additional target-check to this function.
--[[ex_op (defualt == nil) means add an additional operation to this function.
	call ex_op(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0, means do this operation before negate-operation, and only this function returns true, the negate-operation will be continued.
	if chk == 1, means do this operation after both the negate-operation and the operate-negated-card-operation(if has) be operated successfully (return true)
	if chk == 2, means do this operation after all the other operations, and ingore whether those operations have succeeded or not.
]]--
--//return effect
-->>this function is an intermediate function, eg see Scl.CreateQuickOptionalEffect_NegateEffect, Scl.CreateQuickOptionalEffect_NegateActivation, Scl.CreateActivateEffect_NegateEffect, Scl.CreateActivateEffect_NegateActivation
function Scl.CreateQuickOptionalEffect_Negate(reg_obj, neg_typ, op_str, lim_obj, rng, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	local reg_ctgy = Scl.GetNumFormatCategory(ex_ctgy or 0)
	reg_ctgy = reg_ctgy | Scl.Category_List[op_str][2]
	reg_ctgy = neg_typ == "NegateActivation" and reg_ctgy | CATEGORY_NEGATE or reg_ctgy | CATEGORY_DISABLE 
	local reg_flag = Scl.GetNumFormatProperty(ex_flag or 0)
	reg_flag = neg_typ == "NegateActivation" and reg_flag | (EFFECT_FLAG_DAMAGE_CAL + EFFECT_FLAG_DAMAGE_STEP) or reg_flag | ( EFFECT_FLAG_DAMAGE_STEP)
	local reg_con = con or scl.negate_activation_or_effect_con(neg_typ)
	if type(con) == "table" then 
		reg_con = scl.negate_activation_or_effect_con(neg_typ, table.unpack(con))
	end
	ex_tg = ex_tg or aux.TRUE 
	ex_op = ex_op or aux.TRUE 
	local reg_tg = s.negate_activation_or_effect_tg(neg_typ, op_str, ex_tg)
	local reg_op = s.negate_activation_or_effect_op(neg_typ, op_str, ex_op)
	return Scl.CreateQuickOptionalEffect(reg_obj, EVENT_CHAINING, desc_obj or neg_typ, lim_obj, reg_ctgy, reg_flag, rng, reg_con, cost, reg_tg, reg_op, nil, rst_obj)  
end 
--Create a quick effect, negate the card's effect.
--param see Scl.CreateQuickOptionalEffect_Negate
--//return effect
-->>eg1. Scl.CreateQuickOptionalEffect_NegateEffect(c, "Destroy", 1, LOCATION_MZONE)
-->>create an activate effect that can negate any effect and destroy that effect's handler once per turn.
-->>eg2. Scl.CreateQuickOptionalEffect_NegateEffect(c, "Dummy", 1, { "Monster" }, s.cost, "Return2Hand", "Target", s.tg, s.op)
-->>create an activate effect that can negate monster effect, and can only activate once per turn. You must pay s.cost for its activation, and add the s.op ass the additional operation.
function Scl.CreateQuickOptionalEffect_NegateEffect(reg_obj, op_str, lim_obj, rng, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	return Scl.CreateQuickOptionalEffect_Negate(reg_obj, "NegateEffect", op_str, lim_obj, rng, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
end
--Create a quick effect, negate the effect's activation.
--param see Scl.CreateQuickOptionalEffect_Negate
--//return effect
-->>eg1. Scl.CreateQuickOptionalEffect_NegateActivation(c, "Destroy", 1, LOCATION_MZONE)
-->>create an activate effect that can negate any activation and destroy that activation's handler once per turn.
-->>eg2. Scl.CreateQuickOptionalEffect_NegateActivation(c, "Dummy", 1, { "Monster" }, s.cost, "Return2Hand", "Target", s.tg, s.op)
-->>create an activate effect that can negate monster effect's activation, and can only activate once per turn. You must pay s.cost for its activation, and add the s.op ass the additional operation.
function Scl.CreateQuickOptionalEffect_NegateActivation(reg_obj, op_str, lim_obj, rng, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	return Scl.CreateQuickOptionalEffect_Negate(reg_obj, "NegateActivation", op_str, lim_obj, rng, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
end
function scl.negate_activation_or_effect_con(neg_typ, eff_typ_obj, player)
	return function(e, tp, eg, ep, ev, re, r, rp)
		eff_typ_obj = eff_typ_obj or "All"
		local c = e:GetHandler()
		local loc, cp, seq = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_LOCATION, CHAININFO_TRIGGERING_CONTROLER, CHAININFO_TRIGGERING_SEQUENCE)
		local tg = not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Group.CreateGroup() or Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
		if c:IsStatus(STATUS_BATTLE_DESTROYED) then 
			return false
		end
		if player and player == 0 and rp ~= tp then 
			return false 
		end
		if player and player == 1 and rp == tp then 
			return false 
		end
		if neg_typ == "NegateEffect" and not Duel.IsChainDisablable(ev) then 
			return false 
		end
		if neg_typ == "NegateActivation" and not Duel.IsChainNegatable(ev) then 
			return false 
		end
		local typ = type(eff_typ_obj)
		if typ == "function" then 
			return eff_typ_obj(e, tp, ev, re, rp, tg, loc, seq, cp) 
		elseif typ == "string" then 
			for _, str in pairs(Scl.SplitString(eff_typ_obj)) do 
				if Scl.EffectTypeCheck(str, re) then 
					return true 
				end
			end
		end
		return false
	end 
end
function s.negate_activation_or_effect_tg(neg_typ, op_str, ex_tg)
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		op_str = op_str or "Dummy"
		local rc = re:GetHandler()
		local cgty, ctgy_arr = Scl.GetNumFormatCategory(op_str)
		if chkc then 
			return scl.list_format_cost_or_target_or_operation(ex_tg)(e, tp, eg, ep, ev, re, r, rp, 0, chkc)
		end
		if chk == 0 then 
			return (cgty & CATEGORY_REMOVE == 0 or aux.nbcon(tp, re)) and (scl.list_format_cost_or_target_or_operation(ex_tg)(e, tp, eg, ep, ev, re, r, rp, 0)) 
		end
		if rc:IsRelateToChain(ev) then
			for _, ctgy in pairs(ctgy_arr) do
				Duel.SetOperationInfo(0, ctgy, eg, 1, 0, 0)
			end
		end
		scl.list_format_cost_or_target_or_operation(ex_tg)(e, tp, eg, ep, ev, re, r, rp, 1)
	end
end
function s.negate_activation_or_effect_op(neg_typ, op_str, ex_op)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local rc = re:GetHandler()
		local res = not ex_op and true or scl.list_format_cost_or_target_or_operation(ex_op)(e, tp, eg, ep, ev, re, r, rp, 0)
		if Scl.CheckBoolean(res, true) or type(res) == "nil" then
			if neg_typ == "NegateEffect" then
				res = Duel.NegateEffect(ev)
			else
				res = Duel.NegateActivation(ev)
			end
			if op_str and op_str ~= "Dummy" and not rc:IsRelateToChain(ev) then 
				res = false
			else
				res = s.operate_selected_objects(eg, op_str, REASON_EFFECT, 1, e, tp, eg, ep, ev, re, r, rp)() > 0
			end
			if res or type(res) == "nil" then
				scl.list_format_cost_or_target_or_operation(ex_op)(e, tp, eg, ep, ev, re, r, rp, 1)
			end
		end
		scl.list_format_cost_or_target_or_operation(ex_op)(e, tp, eg, ep, ev, re, r, rp, 2)
	end
end

--Create a quick mandatory effect.
--code default == EVENT_FREE_CHAIN
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateQuickOptionalEffect(c, nil, "Add2Hand", 1, "Add2Hand", nil, LOCATION_MZONE, nil, nil, s.tg, s.op)
-->>create a quick effect: Once per either player's turn, you must activate this effect and do s.tg, s.op.
function Scl.CreateQuickMandatoryEffect(reg_obj, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_QUICK_F, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, nil, nil, nil, rst_obj)
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<Continues Trigger Effect<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Create a single trigger continous effect.
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateSingleTriggerContinousEffect(c, EVENT_TO_GRAVE, nil, nil, "!NegateEffect", nil, s.op)
-->>create a single trigger continous effect, when it is send to GY, do s.op, and this effect cannot be negated.
function Scl.CreateSingleTriggerContinousEffect(reg_obj, code, desc_obj, lim_obj, flag, con, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS, code, desc_obj, lim_obj, nil, flag, nil, con, nil, nil, op, nil, nil, nil, rst_obj)
end
--Create a single destroy replace effect.
--repfilter default == not c:IsReason(REASON_REPLACE), the card must first meet repfilter(c, e, tp, ...)
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateSingleTriggerContinousEffect_DestroyReplace(c, 1, LOCATION_MZONE, nil, s.tg, s.op)
-->>If card c is destroyed by any ways except replace, you can do s.tg and s.op to replace the destroy.
function Scl.CreateSingleTriggerContinousEffect_DestroyReplace(reg_obj, lim_obj, rng, repfilter, tg, op, con, flag, rst_obj)
	local flag2 = Scl.GetNumFormatProperty(flag)
	local e1 = Scl.CreateSingleTriggerContinousEffect(reg_obj, EFFECT_DESTROY_REPLACE, nil, lim_obj, flag2 | EFFECT_FLAG_SINGLE_RANGE, con, op, rst_obj)
	e1:SetTarget(s.create_single_trigger_continous_effect_destroy_replace_tg(repfilter or aux.TRUE, tg))
	e1:SetRange(rng)
	return e1
end 
function s.create_single_trigger_continous_effect_destroy_replace_filter(c, repfilter, ...)
	return repfilter(c, ...) and not c:IsReason(REASON_REPLACE)
end
function s.create_single_trigger_continous_effect_destroy_replace_tg(repfilter, tg)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		if chk == 0 then 
			return s.create_single_trigger_continous_effect_destroy_replace_filter(c, repfilter, e, tp, eg, ep, ev, re, r, rp) 
				and tg(e, tp, eg, ep, ev, re, r, rp, 0)
		end
		if Duel.SelectEffectYesNo(tp, c, 96) then
			Scl.HintCard(c:GetOriginalCode())
			tg(e, tp, eg, ep, ev, re, r, rp, 1)
			return true
		end
		return false
	end
end
--Create a field trigger continous effect.
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateFieldTriggerContinousEffect(c, EVENT_TO_GRAVE, nil, nil, "!NegateEffect", LOCATION_MZONE, nil, s.op)
-->>create a field trigger continous effect, when any cards is send to GY, do s.op, and this effect cannot be negated.
function Scl.CreateFieldTriggerContinousEffect(reg_obj, code, desc_obj, lim_obj, flag, rng, con, op, rst_obj)
	return Scl.CreateEffect(reg_obj, EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS, code, desc_obj, lim_obj, nil, flag, rng, con, nil, nil, op, nil, nil, nil, rst_obj)
end 
--Create a field destroy replace effect.
--repfilter default == not c:IsReason(REASON_REPLACE), the card must first meet repfilter(c, e, tp, ...)
--if force(default == false) == true, it is a force-replace, won't ask you whether you want to replace or not.
--other parama format : see Scl.CreateEffect
--//return effect
-->>eg1. Scl.CreateFieldTriggerContinousEffect_DestroyReplace(c, 1, LOCATION_MZONE, nil, s.tg, s.op)
-->>If a card(s) meet s.tg(chk == 0) is destroyed by any ways except replace, you can do s.tg and s.op to replace the destroy.
function Scl.CreateFieldTriggerContinousEffect_DestroyReplace(reg_obj, lim_obj, rng, repfilter, tg, op, con, force, flag, rst_obj)
	repfilter = repfilter or aux.TRUE 
	local e1 = Scl.CreateFieldTriggerContinousEffect(reg_obj, EFFECT_DESTROY_REPLACE, nil, lim_obj, nil, rng, con, op, rst_obj)
	e1:SetValue(s.create_field_trigger_continous_effect_destroy_replace_value(repfilter))
	e1:SetTarget(s.create_field_trigger_continous_effect_destroy_replace_tg(repfilter, tg, force))
	local g = Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	return e1, g 
end
function s.create_field_trigger_continous_effect_destroy_replace_value(repfilter)
	return function(e, c)
		return e:GetLabelObject():IsContains(c)
	end
end
function s.create_field_trigger_continous_effect_destroy_replace_tg(repfilter, tg, force)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		local rg = eg:Filter(s.create_single_trigger_continous_effect_destroy_replace_filter, nil, repfilter, e, tp, eg, ep, ev, re, r, rp)
		if chk == 0 then 
			return #rg >0 and tg(e, tp, eg, ep, ev, re, r, rp, 0)
		end
		if force or Duel.SelectEffectYesNo(tp, c, 96) then
			Scl.HintCard(c:GetOriginalCode())
			local container=e:GetLabelObject()
			container:Merge(rg)
			tg(e, tp, eg, ep, ev, re, r, rp, 1)
			return true
		end
		return false
	end
end
--Create a phase operate function, to operate op_obj.
--you should first meet ex_con (default == aux.TRUE), then you can apply the effect.
--[[times: nil  every phase 
			0  next  phase
			1 or +  times  phase 
	whos:  nil  each player 
			tp  yours phase
			1-tp  your opponent's phase
--]]
--fun_obj can be string-format, as the index to find the operate function in Scl.Category_List, or can be a function that will be call operate(g, e, tp, ...)
--//return effect
-->>eg1. Scl.CreateFieldTriggerContinousEffect_PhaseOpearte({c, tp}, c, 1, nil, PHASE_END, nil, "Destroy")
-->>in 1st EP after this effect is applied (equal to this turn's EP), destroy card c.
-->>eg2. Scl.CreateFieldTriggerContinousEffect_PhaseOpearte({c, tp}, g, 0, 1-tp, PHASE_STANDBY, nil, "Add2Hand")
-->>in next your opponent's SP, add g to the hand.
-->>eg2. Scl.CreateFieldTriggerContinousEffect_PhaseOpearte({c, tp}, g, 2, tp, PHASE_STANDBY, nil, s.op)
-->>in 2nd SP after this effect is applied, do s.op(g, e, tp, ...)
function Scl.CreateFieldTriggerContinousEffect_PhaseOpearte(reg_obj, op_obj, times, whos, phase, ex_con, fun_obj)
	local owner = Scl.GetRegisterInfo(reg_obj)
	local cphase = Duel.GetCurrentPhase()
	local atct = Duel.GetTurnCount()
	local turnp = Duel.GetTurnPlayer()
	phase = phase or PHASE_END 
	phase = Scl.GetNumFormatPhase(phase)
	local sg = Scl.Mix2Group(op_obj)
	local fid = owner:GetFieldID()
	for tc in aux.Next(sg) do
		local desc = ""
		if type(fun_obj) == "string" then 
			desc = s.switch_hint_object_format(fun_obj, "")
		end
		if desc == "" then
			desc = DESC_PHASE_OPERATION_SCL
		end
		tc:RegisterFlagEffect(FLAG_PHASE_OPERATE_SCL, RESETS_SCL, EFFECT_FLAG_CLIENT_HINT, 0, fid, desc)
	end
	sg:KeepAlive()
	local e1 = Scl.CreateFieldTriggerContinousEffect(reg_obj, EVENT_PHASE + phase, DESC_PHASE_OPERATION_SCL, 1, "IgnoreUnaffected", nil, s.phase_opearte_con(phase, atct, whos, fid, times, ex_con), s.phase_opearte_op(fun_obj, fid))
	Scl.Operation_Info[e1] = {sg, 0, 0}
	return e1
end
function s.phase_operate_filter(c, fid)
	return c:GetFlagEffectLabel(FLAG_PHASE_OPERATE_SCL) == fid
end 
function s.phase_opearte_con(phase, atct, whos, fid, times, ex_con)
	return function(e, tp, ...)
		local sg, tct, ph_chk = table.unpack(Scl.Operation_Info[e])
		local cur_t = Duel.GetTurnCount()
		if ph_chk ~= cur_t then
			if not whos or (whos == 0 and Duel.GetTurnPlayer() == tp) or (whos == 1 and Duel.GetTurnPlayer() ~= tp) then
				-- case1 , next phase 
				if times and times == 0 and Duel.GetTurnCount() > atct then
					ph_chk = cur_t
					tct = tct + 1
				elseif not times or times > 0 then
				-- case2 , normal
					ph_chk = cur_t
					tct = tct + 1
				end
			end
		end
		Scl.Operation_Info[e] = {sg, tct, ph_chk}
		sg, tct, ph_chk = table.unpack(Scl.Operation_Info[e])
		local rst, op_able = false, false
		local rg = sg:Filter(s.phase_operate_filter, nil, fid)
		if #rg <= 0 then 
			rst = true
		end
		--case1, every phase
		if not times then
			op_able = true 
		end
		-- case2, next phase
		if times and times == 0 then
			if tct == 1 then
				op_able = true
			elseif tct > 1 then
				rst = true
			end
		end
		-- case3, 1+ phase
		if times and times>0 and times == tct then
			op_able = true 
		elseif times and times>0 and tct > times then
			rst = true
		end
		if rst then
			sg:DeleteGroup() 
			e:Reset() 
			return  
		end
		return op_able and (not ex_con or ex_con(e, tp, ...))
	end
end
function s.phase_opearte_op(fun_obj, fid)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local sg, tct, ph_chk = table.unpack(Scl.Operation_Info[e])
		local c = e:GetOwner()
		Scl.HintCard(c:GetOriginalCode())
		local rg = sg:Filter(s.phase_operate_filter, nil, fid)
		local typ = type(fun_obj)
		if typ == "function" then 
			fun_obj(rg, e, tp, eg, ep, ev, re, r, rp)
		elseif typ == "string" then
			s.operate_selected_objects(rg, fun_obj, REASON_EFFECT, 1, e, tp, eg, ep, ev, re, r, rp)()
		end
	end
end
--Create or get the a global trigger effect.
--the global effect with the same event will be created only once, if you try to use this function to create a same event global effect once more, it won't create but will return the first created global effect, and will insert con and op to that first created global effect.
--same_code is the distinguishing mark, if event and same_code are all the same, it will only insert the first con and op into the global effect with that event, ignore the subsequent calls.
--//return that event's global effect
-->>eg1. Scl.SetGlobalFieldTriggerEffect(0, EVENT_TO_GRAVE, id, s.con, s.op)
-->>create (or get, if you have used this function to create a global effect with EVENT_TO_GRAVE) a global effect, each time a card(s) is sent to GY and meets s.con, do s.op.
function Scl.SetGlobalFieldTriggerEffect(reg_player, event, same_code, con, op)
	if type(reg_player) ~= "number" then 
		Debug.Message("The firt param of Scl.SetGlobalFieldTriggerEffect must be player (number).")
		return 
	end
	if not Scl.Global_Effet_List[reg_player] then
		Scl.Global_Effet_List[reg_player] = { }
	end
	if not Scl.Global_Effet_List[reg_player][event] then 
		local ge1 = Scl.CreateFieldTriggerContinousEffect({true, reg_player}, event)
		ge1:SetOperation(s.set_global_effect_op(reg_player,event))
		Scl.Global_Effet_List[reg_player][event] = { ["effect"] = ge1, ["array"] = { } }
	end
	if not Scl.Global_Effet_List[reg_player][event]["array"][same_code] then
		Scl.Global_Effet_List[reg_player][event]["array"][same_code] = { con or aux.TRUE, op or aux.TRUE }
	end
	return Scl.Global_Effet_List[reg_player][event]["effect"]
end
function s.set_global_effect_op(reg_player,event)
	return function(e, tp, ...)
		local con, op 
		local arr = Scl.Global_Effet_List[reg_player][event]["array"]
		for _, val in pairs(arr) do  
			con, op = val[1], val[2]
			if not con or con(e, tp, ...) then
				op(e, tp, ...)
			end   
		end
	end
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<Summon and SpSummon<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

--Normal summon sum_card, same as Duel.Summon, but switch the sequences of the parama "sum_pl" and "sum_card"
--//return summon count, summon group, first summon card
function s.normal_summon(sum_card, sum_pl, ignore_ct, sum_eff, min_tri_ct, zone)
	local g = Scl.Mix2Group(sum_card)
	local tc = g:GetFirst()
	if Scl.Operate_Check == 0 then
		return tc:IsSummonable(ignore_ct, sum_eff, min_tri_ct, zone)
	end
	local res = tc:IsSummonable(ignore_ct, sum_eff, min_tri_ct, zone)
	if zone then
		Duel.Summon(sum_pl, tc, ignore_ct, sum_eff, min_tri_ct, zone)
	else
		Duel.Summon(sum_pl, tc, ignore_ct, sum_eff, min_tri_ct)
	end
	return res and 1 or 0, res and Group.CreateGroup() or g, res and tc or nil
end
--Check if tp is affected by "Blue - Eyes Spirit Dragon" (cannot summon 2+ the same time)
--//return boolean
function Scl.IsAffectedByBlueEyesSpiritDragon(tp)
	return Duel.IsPlayerAffectedByEffect(tp, 59822133)
end
--Special summon a card in step, call Scl.AddSingleBuff and Scl.AddSingleBuff2Self
--use the same as Duel.SpecialSummonStep.
--//return successfully, summon monster 
function Scl.SpecialSummonStep(sum_card, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone) 
	local sum_res = false
	sum_typ = sum_typ or 0
	if not sum_pl then
		local _, _, p = Scl.GetCurrentEffectInfo()
		sum_pl = p
	end
	zone_pl = zone_pl or sum_pl
	ignore_con = ignore_con or false
	ignore_revie = ignore_revie or false
	pos = pos or POS_FACEUP
	if zone then
		sum_res = Duel.SpecialSummonStep(sum_card, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone)
	else
		sum_res = Duel.SpecialSummonStep(sum_card, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos)
	end
	if sum_res then
		--monsters in summon step is be treated as not on the field, this is violation of mechanisms of Scl.AddSingleBuff, need Scl.Global_Zone to fix
		Scl.Global_Zone = "MonsterZone"
		local c = sum_card:GetReasonEffect():GetHandler()
		if #(Scl.Single_Buff_List) > 0 then
			Scl.AddSingleBuff({ c, sum_card, true }, table.unpack(Scl.Single_Buff_List))
		end
		if #(Scl.Single_Buff_Affect_Self_List) > 0 then
			Scl.AddSingleBuff2Self({ c, sum_card, true }, table.unpack(Scl.Single_Buff_Affect_Self_List))
		end
		Scl.Global_Zone = nil
	end
	return sum_res, sum_card
end
--complete the Scl.SpecialSummonStep, add reset the Scl.Single_Buff_List, Scl.Single_Buff_Affect_Self_List.
function Scl.SpecialSummonComplete()
	Scl.Single_Buff_List = { }
	Scl.Single_Buff_Affect_Self_List = { }
	Duel.SpecialSummonComplete()
end
--Special summon card(s), call Scl.AddSingleBuff and Scl.AddSingleBuff2Self
--use the same as Duel.SpecialSummon.
--//return successfully summon monster count, summon group, first summon monster 
function Scl.SpecialSummon(sum_obj, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone)
	local e = Scl.GetCurrentEffectInfo()
	local sg = Scl.Mix2Group(sum_obj)
	if Scl.Operate_Check == 0 then 
		return sg:CheckSubGroup(s.special_summon_check, #sg, #sg, e, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone) 
	end
	local g = Group.CreateGroup()
	for sum_card in aux.Next(sg) do
		if Scl.SpecialSummonStep(sum_card, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone) then
			g:AddCard(sum_card)
		end
	end
	Scl.SpecialSummonComplete()
	return #g, g, g:GetFirst()
end 
function s.special_summon_check(g, e, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone)
	local arr = { }
	for tc in aux.Next(g) do
		table.insert(arr, tc)
		table.insert(arr, zone or 0x7f)
	end
	return g:FilterCount(Card.IsCanBeSpecialSummoned, nil, e, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos) == #g and Scl.GetMZoneCombine4SummoningFirstMonster(zone_pl, nil, sum_typ, table.unpack(arr)) > 0
end
--special summon and negate card effect
function s.negate_effect_and_special_summon(sum_obj, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone)
	if Scl.Operate_Check == 0 then 
		return Scl.SpecialSummon(sum_obj, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone)
	end
	Scl.AddSingleBuff(nil, "NegateEffect", 1, "NegateActivatedEffect")
	Scl.SpecialSummon(sum_obj, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone)
end
--Special Summon a monster to either player's field in step, call Scl.AddSingleBuff and Scl.AddSingleBuff2Self.
--use nearly same as Duel.SpecialSummonStep.
--but the parama - zone_pl is useless, and be removed.
--also the parama - sum_zone is change to array-format { [0] = number-format zone0, [1] = number-format zone1 }, means can special summon to player 0's zone0, or special summon to player1's zone1 (default == { [0] == 0x1f }, { [1] == 0x1f }). 
--//return successfully, summon monster 
-->>eg1. Scl.SpecialSummon2EitherFieldStep(c, 0, tp, false, false, POS_FACEUP, { [0] = 0x2, [1] = 0x1 }) 
-->>special summon c in step to your 0x2 zone or your opponent's 0x1 zone.
function Scl.SpecialSummon2EitherFieldStep(sum_card, sum_typ, sum_pl, ignore_con, ignore_revie, pos, sum_zone) 
	local sum_eff = Scl.GetCurrentEffectInfo()
	local tp = sum_pl
	local zone = { }
	local flag = { }
	sum_zone = sum_zone or { [0] = 0x1f, [1] = 0x1f }
	local ava_zone = 0
	for p = 0, 1 do
		zone[p] = sum_zone[p] & 0xff
		local _, flag_tmp = Duel.GetLocationCount(p, LOCATION_MZONE, tp, LOCATION_REASON_TOFIELD, zone[p])
		flag[p] = (~flag_tmp) & 0x7f
	end
	for p = 0, 1 do
		if sum_card:IsCanBeSpecialSummoned(sum_eff, sum_typ, sum_pl, ignore_con, ignore_revie, pos, p, zone[p]) then
			ava_zone = ava_zone | (flag[p] << (p == tp and 0 or 16))
		end
	end
	if ava_zone <= 0 then return 0, nil end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
	local sel_zone = Duel.SelectDisableField(tp, 1, LOCATION_MZONE, LOCATION_MZONE, 0x00ff00ff & ( ~ ava_zone))
	local zone_pl = 0
	if sel_zone & 0xff > 0 then
		zone_pl = tp
	else
		zone_pl = 1 - tp
		sel_zone = sel_zone >> 16
	end
	return Scl.SpecialSummonStep(sum_card, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, sel_zone)
end
--Special Summon a monster to either player's field, call Scl.AddSingleBuff and Scl.AddSingleBuff2Self.
--use nearly same as Duel.SpecialSummon.
--but the parama - zone_pl is useless, it is replaced by sum_eff (summon effect), to check whether the card(s) can be special summoned.
--also the parama - sum_zone is change to array-format { [0] = number-format zone0, [1] = number-format zone1 }, means can special summon to player 0's zone0, or special summon to player1's zone1 (default == { [0] == 0x1f }, { [1] == 0x1f }). 
--//return successfully summon monster count, summon group, first summon monster
-->>eg1. Scl.SpecialSummon2EitherField(c, 0, tp, e, false, false, POS_FACEUP, { [0] = 0x2, [1] = 0x1 }) 
-->>special summon c in step to your 0x2 zone or your opponent's 0x1 zone.
function Scl.SpecialSummon2EitherField(sum_obj, sum_typ, sum_pl, sum_eff, ignore_con, ignore_revie, pos, sum_zone) 
	local g = Group.CreateGroup()
	for sum_card in aux.Next(Scl.Mix2Group(sum_obj)) do 
		local res, c = Scl.SpecialSummon2EitherFieldStep(sum_card, sum_typ, sum_pl, sum_eff, ignore_con, ignore_revie, pos, sum_zone)
		if res then
			g:AddCard(c)
		end
	end
	Duel.SpecialSummonComplete()
	return #g, g, g:GetFirst()
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Value<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Nested function
--value for "this card cannot be special summoned from extra, except by Scl.Summon_Type_List[sum_str][1]"
--usually use in EFFECT_SPSUMMON_CONDITION.
-->>eg1. scl.value_special_summon_from_extra("LinkSummon")(e, se, sp, st)
-->>"This card cannot be special summoned from extra, except by Link Summon".
function scl.value_special_summon_from_extra(sum_str)
	return function(e, se, sp, st)
		local st2 = Scl.Summon_Type_List[sum_str]
		return not e:GetHandler():IsLocation(LOCATION_EXTRA) or st & st2 == st2
	end
end
--Value for "this card can only be special summoned by card effect".
--usually use in EFFECT_SPSUMMON_CONDITION.
function scl.value_special_summon_by_card_effects(e, se, sp, st)
	--ygocore's official script has bug when VS EFFECT_SPSUMMON_PROC
	--return se:IsHasType(EFFECT_TYPE_ACTIONS)
	return not se:IsHasProperty(EFFECT_FLAG_UNCOPYABLE)
end
--Nested function
--value for "include a reason (battle/cost/material/effect ...)"
--will call Scl.IsReason(nil, ...) to check if "r" include your point reason(s), paramas see Scl.IsReason
-->>eg1. scl.value_check_r(0, REASON_BATTLE/"Battle")
-->>check if r include REASON_BATTLE
function scl.value_check_r(...)  
	local arr = { ... }
	return function(e, re, r, rp)
		local c = e:GetHandler()
		Scl.Global_Reason = r
		local res = Scl.IsReason(nil, table.unpack(arr))
		Scl.Global_Reason = nil
		return res
	end
end
--Nested function
--value for "once per turn, Card(s) cannot be destroyed by XXX-REASON"..
--will call Scl.IsReason(nil, ...) to check if "r" include your point reason(s), paramas see Scl.IsReason
-->>eg1. scl.value_indestructable_count(0, REASON_BATTLE/"Battle")
-->>the value for "once per turn, this card cannot be destroyed by battle"
function scl.value_indestructable_count(...)
	local arr = { ... }
	return function(e, re, r, rp)
		local ct = 0
		Scl.Global_Reason = r
		if Scl.IsReason(nil, table.unpack(arr)) then
			ct = 1
		else
			ct = 0 
		end
		Scl.Global_Reason = nil
		return ct
	end
end
--value for "immune to your opponent's card effects".
function scl.value_unaffected_by_opponents_card_effects(e, re)
	return e:GetOwnerPlayer() ~= re:GetHandlerPlayer()
end
--value for "immune to other card's effects".
function scl.value_unaffected_by_other_card_effects(e, re)
	return re:GetOwner() ~= e:GetOwner()
end
--value for "immune to other card's effects that do not target this card".
function scl.value_unaffected_by_other_untarget_effects(e, re)
	local c = e:GetHandler()
	local ec = re:GetHandler()
	if re:GetOwner() == e:GetOwner() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--value for "immune to your opponent's card's effects that do not target this card".
function scl.value_unaffected_by_opponents_untarget_self_effects(e, re)
	local c = e:GetHandler()
	local ec = re:GetHandler()
	if re:GetHandlerPlayer() == e:GetHandlerPlayer() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--Nested function
--value for "this effect's /this effect's activation cannot be negated"
--the effect must meet filter(e, tp, ct, re, rp, target_group, activate_zone, activate_zone_sequence, activate_card_controler)
-->>eg1. scl.value_cannot_be_negated(aux.TRUE)
-->>any activate-effects/or their activations cannot be negated
function scl.value_cannot_be_negated(filter)
	return function(e, ct)
		filter = filter or aux.TRUE 
		local tp = e:GetHandlerPlayer()
		local tg = Duel.GetChainInfo(ct, CHAININFO_TARGET_CARDS) or Group.CreateGroup()
		local re, rp, rng, seq, cp = Duel.GetChainInfo(ct, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER, CHAININFO_TRIGGERING_LOCATION, CHAININFO_TRIGGERING_SEQUENCE, CHAININFO_TRIGGERING_CONTROLER)
		return filter(e, tp, ct, re, rp, tg, rng, seq, cp) 
	end
end
--value for "this card cannot be fusion summon material"
function scl.value_cannot_be_used_as_material_for_a_fusion_summon(e, c, sum_typ)
	return sum_typ and sum_typ & SUMMON_TYPE_FUSION == SUMMON_TYPE_FUSION 
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Operate Part<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Field buff target: the current effect don't target this card.
--use for field buff EFFECT_IMMUNE_EFFECT
function scl.target_untarget_status(e, c)
	local te, g = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TARGET_CARDS)
	return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end 
--Add token code into the Scl.Token_List, and do aux.AddCodeList(c, code)
--If your cards' text include tokens, use this function can simplify the special-summon-token check.
function Scl.AddTokenList(c, tk_code1, ...)
	local tk_code_list = { tk_code1, ... }
	for _, tk_code in pairs(tk_code_list) do
		if c then
			aux.AddCodeList(c, tk_code)
		end
		if not Scl.Token_List[tk_code] then 
			Scl.Token_List[tk_code] = { } 
			local ge1 = Scl.SetGlobalFieldTriggerEffect(0, EVENT_ADJUST, tk_code, nil, s.add_token_list_op(tk_code))
		end
	end
end
function s.add_token_list_op(tk_code)
	return function(e, tp) 
		if not Scl.Token_List[tk_code][1] then 
			Scl.Token_List[tk_code] = { [0] = Duel.CreateToken(0, tk_code), [1]= Duel.CreateToken(1, tk_code) }
		end
	end
end
--Target: special summon a number of (ct) token(s), that meet the condition tk_code_or_fun, in sum_pos position (default == POS_FACEUP), to tg_p's field (default == 0, means you, == 1 means your opponent).
--tk_code_or_fun can be card code, OR can be a card-attribute list { token's code, token's series, token's ATK, token's DEF, token's level, token's race, token's attribute, token's summon position (will replace sum_pos), token's summon target (will replace tg_p), token's summon type }
--OR can be function, call tk_code_or_fun(e, tp, ...) to get above variables.
--leave_obj can be card or group， means if have the enough zone to special summon token(s) after the leave_obj leave the field.
-->>eg1. scl.target_special_summon_token(114514)
-->>check if you can special summon 114514 on your field.
-->>eg2. scl.target_special_summon_token(s.tokenfun, 2, POS_FACEUP_ATTACK, 1)
-->>check if you can special summon 2 tokens meets s.tokenfun to your opponent's field, in faceup attack position.
function scl.target_special_summon_token(tk_code_or_fun, ct, sum_pos, tg_p, leave_obj)
	local error_code = s.get_error_card_id()
	if type(tk_code_or_fun) == "number" and not Scl.Token_List[tk_code_or_fun] then 
		Debug.Message(error_code .. "-- Token: " .. tk_code_or_fun .. " hasn't been registered by 'Scl.AddTokenList'")
	end
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		tg_p = tg_p or 0
		local sp = tg_p == 0 and tp or 1 - tp
		local res = Scl.IsCanSpecialSummonToken(e, tp, tk_code_or_fun, sum_pos, sp, nil, eg, ep, ev, re, r, rp, 0)
		local ft = Duel.GetMZoneCount(sp, leave_obj, tp)	 
		if Scl.IsAffectedByBlueEyesSpiritDragon(tp) and type(ct) == "number" and ct > 1 then res = false end
		if type(ct) == "number" and ft < ct then res = false end
		if chkc then return true end
		if chk == 0 then return res end
		Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, spct, 0, 0)
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, spct, 0, 0)
	end
end
--Check if tp can special summon a token meets condition - tk_code_or_fun, in sum_pos position(default == POS_FACEUP), to tg_p's field (default == tp), in the sum_zone (default == 0x1f).
--tk_code_or_fun can be card code, OR can be a card-attribute list { token's code, token's series, token's ATK, token's DEF, token's level, token's race, token's attribute, token's summon position (will replace sum_pos), token's summon target (will replace tg_p), token's summon type }
--OR can be function, call tk_code_or_fun(e, tp, ...) to get above variables.
--//return bool 
-->>eg1. Scl.IsCanSpecialSummonToken(e, tp, 114514)
-->>check if you can speical summon token 114514
-->>eg2. Scl.IsCanSpecialSummonToken(e, tp, s.tokenfun, POS_FACEUP_ATTACK, 1-tp)
-->>check if you can special summon token meets condition s.tokenfun, to your opponent's field, in faceup attack position.
function Scl.IsCanSpecialSummonToken(e, tp, tk_code_or_fun, sum_pos, tg_p, sum_zone, ...)
	local tk
	local tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_typ
	if type(tk_code_or_fun) == "number" then
		if not Scl.Token_List[tk_code_or_fun] then 
			local ge1 = Scl.SetGlobalFieldTriggerEffect(0, EVENT_ADJUST, tk_code_or_fun, nil, s.add_token_list_op(tk_code_or_fun))
			Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
		end
		tk = Scl.Token_List[tk_code_or_fun][tp]
	elseif type(tk_code_or_fun) == "function" then
		tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_typ = tk_att_fun(e, tp, ...)
	else
		tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_typ = table.unpack(tk_code_or_fun)
	end
	ct = ct or 1 
	sp = sp or tg_p or tp 
	sum_pos = sum_pos2 or sum_pos or POS_FACEUP
	sum_typ = sum_typ or 0 
	if not tk and 
		not Duel.IsPlayerCanSpecialSummonMonster(tp, tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos, sp, sum_typ) then
		return false
	end
	if tk then
		if not sum_zone then 
			return tk:IsCanBeSpecialSummoned(e, sum_typ or 0, tp, false, false, sum_pos, sp)
		else
			return tk:IsCanBeSpecialSummoned(e, sum_typ or 0, tp, false, false, sum_pos, sp, sum_zone)
		end
	end
	return true
end
--Check if tp can special summon minct ~ maxct token(s) meets condition - tk_code_or_fun, in sum_pos position(default == POS_FACEUP), to tg_p's field (default == tp), in the sum_zone (default == 0x1f), if can, speical summon it.
--parama see Scl.IsCanSpecialSummonToken
function Scl.SpecialSummonToken(e, tp, tk_code_or_fun, minct, maxct, sum_pos, tg_p, sum_zone, ...)
	local res_ct = 0
	local res = Scl.IsCanSpecialSummonToken(e, tp, tk_code_or_fun, sum_pos, tg_p, sum_zone, ...)
	if not res then return res_ct end
	local tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_typ
	if type(tk_code_or_fun) == "number" then
		tk_code = tk_code_or_fun
	elseif type(tk_code_or_fun) == "function" then
		tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_typ = tk_code_or_fun(e, tp, ...)
	else 
		tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_typ = table.unpack(tk_code_or_fun)
	end
	sp = sp or tg_p or tp 
	sum_pos = sum_pos2 or sum_pos or POS_FACEUP
	sum_typ = sum_typ or 0 
	local ft = Duel.GetLocationCount(sp, LOCATION_MZONE, tp)   
	if ft <= 0 then return res_ct end
	if Scl.IsAffectedByBlueEyesSpiritDragon(tp) and type(minct) == "number" and minct > 1 then return res_ct end
	if type(minct) == "number" and ft < minct then return res_ct end
	local sum_min, sum_max
	sum_min = Scl.CheckBoolean(minct) and ft or (minct or 1)
	sum_max = math.min(maxct or sum_min, ft)
	if Scl.IsAffectedByBlueEyesSpiritDragon(tp) then 
		sum_min, sum_max = 1, 1
	end
	if sum_min > sum_max then return res_ct end
	local would_hint, need_break = Scl.Extra_Operate_Parama_Check_Hint, Scl.Extra_Operate_Parama_Need_Break
	Scl.SetExtraSelectAndOperateParama(nil, nil, nil)
	if would_hint and not Scl.SelectYesNo(sp, would_hint) then 
		return 0, Group.CreateGroup()
	end 
	if need_break then
		Duel.BreakEffect()
	end
	local sp_ct = sum_min
	if sum_max > sum_min then 
		local list = { }
		for idx = sum_min, sum_max do 
			table.insert(list, idx)
		end
		sp_ct = Duel.AnnounceNumber(tp, table.unpack(list))
	end
	for idx = 1, sp_ct do 
		tk = Duel.CreateToken(tp, tk_code)
		if type(tk_code_or_fun) ~= "number" then 
			local e1, e2, e3, e4, e5, e6 = Scl.AddSingleBuff({e:GetHandler(), tk, true}, "type", tk_type, "batk", tk_atk, "bdef", tk_def, "lv", tk_lv, "race", tk_race, "att", tk_att,"rst",RESETS_SCL_ntf)
		end
		if Scl.SpecialSummonStep(tk, sum_typ, tp, sp, false, false, sum_pos, sum_zone) then
			res_ct = res_ct + 1
		end
	end
	Duel.SpecialSummonComplete()
	local og = Duel.GetOperatedGroup()
	return res_ct, og, og:GetFirst()
end
--Get effect cost/target/operation paramas form list, for quick set the effect cost/target/operation (scl.list_format_cost_or_target_or_operation(list))
--"scl.list_format_cost_or_target_or_operation" will first check if all lists is meet their condition, if the effect pass all lists' checks, you can activate/solve that effect, then do some different operations, depending on each list's first parama - list_typ
--[[
	the first parama in the list always be list_typ, it means that list's kind.
	list_typ == "Cost", means it is a cost-list (using in Effect.SetCost), when you activate the effect, you must select a number of cards (depending the list's "minct" and "maxct" prarmas) form the card groups that meet the condition, then immediately do cost on them. If a cost indicated by one of the lists cannot be operated correctly, the remainder costs indicated by the remainder lists will be immediately termination of operation.
	list_typ == "PlayerCost", means it is a cost-list (using in Effect.SetCost), differ from "Cost", it only valid in the cost that targets a player(s), like "Discard", "SendDeckTop2GY", "Damage", "GainLP" and "Draw".
	list_typ == "~Target", means it is a target-check-list (using in Effect.SetTarget), if you activate the effect, you will register the operation infomation due to this list, but no need to select card-targets.
	list_typ == "Target", means it is a target-check-list (using in Effect.SetTarget), the effect will additional check whether the card(s) prepare for checking can be that effect's correct target(s), and if you activate the effect, you will select a number of cards (depending the list's "minct" and "maxct" prarmas) form the card groups that meet the condition, then immediately set them as the card targets and register the operation infomation due to them.
	list_typ == "PlayerTarget", means it is a target-check-list (using in Effect.SetTarget), differ from "Cost", it only valid in the cost that targets a player(s), like "Discard", "SendDeckTop2GY", "Damage", "GainLP" and "Draw". When you activate the effect, you will do "Duel.SetTargetPlayer" and "Duel.SetTargetParam" depending on the list.
	list_typ == "Operation", means it is a operation-list (using in Effect.SetOperation), beacuse operation is different from cost and target (some effects process from part1 to last part in sequence, until cannot process, but for other effects, if their later parts cannot be processed, the whole effects will become unprocessable), so I don't recommended to use this kind of arrays, please use functions to register the operation.
	list_typ == "ExtraCheck", means the effect cost/target will do an extra check due to the check function this kind of lists point to.
	list_typ == "ExtraOperation", means the effect cost/target will do an extra operation due to the operate function this kind of lists point to.
]]--
--the list can be the follow formats 
--[[1. 
	{ 1.list_typ == "Cost/Target/~Target/Operation", 2.card filter or { card filter, group filter }, 
		3.string-format categroy or {string-format categroy, repalce_operation}, 4.self's zonse, 5.opponent's zones,
		6.min count, 7.max count, 8.cannot check/select card or card group, 9.reuseable index }
		Paramas explain:
			2.card filter (default == aux.TRUE): the checked/selected card(s) must meet the conditions this filter points to. If the filter is be defined by official "Card" or "aux" metatable, the function will call filter(c) to check, otherwise will call filter(c, e, tp, ...).
			  group filter (default == aux.TRUE): if check/select 2+ cards as a group at the same time, that group must meet the conditions this filter points to. If the filter is be defined by official "Group" or "aux" metatable, the function will call filter(g) to check, otherwise will call filter(g, e, tp, ...).
			3.string-format categroy: the function will use this string as index to find the corresponding category(s), select hint and the default operate function.
			  repalce_operation: If you set this parama, the repalce_operation will replace the default operate function to do operation on the selected card(s), call repalce_operation(current list's selected card(s), all above lists's selected card(s), e, tp, eg, ... )
			4.self's zone: Define the check/select cards's exist zone. 
				If == nil, means check/select the activate effect's handler. 
				If == true, means check/select card(s) form effect group(eg).
			5.opponent's zone (default == 0): Define the check/select cards's exist zone.
			6.min count (default == 1): Define the min check/select count. 
				If == true, means check/select the all cards that meet conditions (black hole).
			7.max count (default == min count): Define the max check/select count.
			8.cannot check/select card or card group (default == nil): when you check/select card(s), the card or group determined by this parama cannot participate the check/select.
			9.reuseable index (default == 0), if list-A with a reuseable index pass the check, the other lists with same index cannot duplicate check list-A's checked card(s). 
				Example A, "You can send 1 monster on the field to GY, and if you do, banish 1 monster on the field" - If there is only one card on the field, and that card can either be sent to GY or banished, obviously, you cannot activate this effect, you cannot check that card twice, so you should set a same reuseable index in both 2 lists, to prevent the duplicate check.
				Example B, "You can negate the effects of 1 face-up monster on the field, and if you do, increase 1000 ATK to 1 face-up monster on the field." - If their is only 1 face-up card on the field, and that card's effects can be negated, obviously, you activate this effect, you can check that card twice, so you should set different reuseable indexes in that 2 lists, to allow the duplicate check.
		//return list_typ, card_filter, group_filter, category_str, category, category_arr, category_str_arr, replace_operation, zone_self, zone_oppo, minct, maxct, except_group, reuse_idx
	 2.
	 { 1.list_typ == "PlayerCost/PlayerTarget", 2.string-format categroy or {string-format categroy, repalce_operation},
		3.self min count, 4.opponent min count, 5.self max count, 6.opponent max count}
		Paramas explain: 
			2.string-format categroy or {string-format categroy, repalce_operation}: same to the above list_typ.
			3.self min count: your min operate count.
			4.oppo min count (default == 0): your opponent's min operate count.
			5.self max count (default == self min count): your max operate count.
			6.oppo max count (default == oppo min count): your opponent's max operate count.
		//return list_typ, category_str, category, category_arr, category_str_arr, replace_operation, self_minct, self_maxct, oppo_minct, oppo_maxct
	 3.
	 { 1.list_typ == "ExtraCheck", 2.extra_check_function }  
		Paramas explain: 
			2.extra_check_function: add an additional check to the effect cost/target, call extra_check_function(e, tp, eg, ...) to check.
		//return list_typ, extra_check_function
	 4.
	 { 1.list_typ == "ExtraOperation", 2.extra_operate_function }	 
		Paramas explain: 
			2.extra_operate_function: add an additional operate to the effect cost/target, call extra_operate_function(current list's selected card(s), all above lists's selected card(s),e, tp, eg, ...) to operate.
		//return list_typ, extra_operate_function
]]-- 
function s.get_cost_or_target_or_operation_paramas(arr, e, tp, eg, ep, ev, re, r, rp)
	--1.list type  ("Cost", "~Target", "Target","PlayerTarget","Operation","ExtraCheck","ExtraOperation")
	local list_typ = arr[1]
	if list_typ ~= "PlayerTarget" and list_typ ~= "PlayerCost" and list_typ ~= "ExtraCheck" and list_typ ~= "ExtraOperation" then
		--2.card and group filter
		local filter = arr[2] or { aux.TRUE, aux.TRUE }
		filter = type(filter) == "table" and filter or { filter }
		local card_filter, group_filter = filter[1] or aux.TRUE, filter[2] or aux.TRUE
		--3.category string, replace operation
		local category_obj = type(arr[3]) == "table" and arr[3] or { arr[3] }
		local category_str, replace_operation = table.unpack(category_obj)
		local category, category_arr, category_str_arr = Scl.GetNumFormatCategory(category_str)
		--4.select zones
		--if zone_self == nil, means do operate to activate card self 
		--if zone_self == true, means do operate to effect-group(eg).
		local zone_self,  zone_oppo = arr[4],  arr[5]
		zone_self = type(zone_self) == "string" and Scl.GetNumFormatZone(zone_self) or zone_self
		zone_oppo = type(zone_oppo) == "string" and Scl.GetNumFormatZone(zone_oppo) or zone_oppo
		if type(zone_self) == "number" and not zone_oppo then 
			zone_oppo = 0 
		end
		--5.min count
		--if min == true, means do operate to all cards meet condition
		local minct, maxct = arr[6], arr[7]
		minct = type(minct) == "nil" and 1 or minct
		minct = type(minct) == "function" and minct(e, tp, eg, ep, ev, re, r, rp) or minct
		minct = minct == 0 and 999 or minct
		--6.max Count
		maxct = type(maxct) == "nil" and minct or maxct 
		maxct = type(maxct) == "function" and maxct(e, tp, eg, ep, ev, re, r, rp) or maxct
		--7.except object 
		local except_group = Scl.Mix2Group(arr[8])
		local reuse_idx = arr[9] or 0
		return list_typ, card_filter, group_filter, category_str, category, category_arr, category_str_arr, replace_operation, zone_self, zone_oppo, minct, maxct, except_group, reuse_idx
	elseif list_typ == "PlayerTarget" or list_typ == "PlayerCost" then 
		local category_obj = type(arr[2]) == "table" and arr[2] or { arr[2] }
		local category_str, replace_operation = table.unpack(category_obj)
		local category, category_arr, category_str_arr = Scl.GetNumFormatCategory(category_str)
		local self_minct = type(arr[3]) == "function" and arr[3](e, tp, eg, ep, ev, re, r, rp) or arr[3]
		local oppo_minct = type(arr[4]) == "function" and arr[4](e, tp, eg, ep, ev, re, r, rp) or arr[4] or 0
		local self_maxct = type(arr[5]) == "function" and arr[5](e, tp, eg, ep, ev, re, r, rp) or arr[5] or self_minct
		local oppo_maxct = type(arr[6]) == "function" and arr[6](e, tp, eg, ep, ev, re, r, rp) or arr[6] or oppo_minct  
		return list_typ, category_str, category, category_arr, category_str_arr, replace_operation, self_minct, self_maxct, oppo_minct, oppo_maxct
	else
		local extra_fun = arr[2]
		return list_typ, extra_fun
	end
end
--Change a list-format effect cost/target/operation to function-format, using in Scl.CreatexxxEffect.
--list format and eg see s.get_cost_or_target_or_operation_paramas
function scl.list_format_cost_or_target_or_operation(obj)
	if type(obj) == "function" then
		return obj
	else
		return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
			Scl.Card_Target_Count_Check = 0
			Scl.Player_Cost_And_Target_Value = { }
			local arr = Scl.CloneArray(obj)
			arr = type(arr[1]) ~= "table" and { arr } or arr
			local used_arr = { }
			if chkc or chk == 0 then 
				return s.cost_or_target_or_operation_feasibility_check(e, tp, eg, ep, ev, re, r, rp, chk, chkc, used_arr, table.unpack(arr))
			end
			if eg then 
				for tc in aux.Next(eg) do 
					tc:CreateEffectRelation(e)
				end
			end
			local current_sel_group, total_sel_group = Group.CreateGroup(), Group.CreateGroup()
			return s.do_cost_or_target_or_operation(e, tp, eg, ep, ev, re, r, rp, current_sel_group, total_sel_group, used_arr, table.unpack(arr))
		end
	end
end
--Effect target: Check chkc & chk
function s.cost_or_target_or_operation_feasibility_check(e, tp, eg, ep, ev, re, r, rp, chk, chkc, used_arr, arr1, arr2, ...)
	--step1 no more arrays need to check.
	if not arr1 then 
		return true 
	end
	local c = e:GetHandler()
	--step2 get current array's attribute
	local list_typ, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20 = s.get_cost_or_target_or_operation_paramas(arr1, e, tp, eg, ep, ev, re, r, rp)
	local card_filter, group_filter, category_str, category, category_arr, category_str_arr, replace_operation, zone_self, zone_oppo, minct, maxct, except_group, reuse_idx
	local category_str, category, category_arr, category_str_arr, replace_operation, self_minct, self_maxct, oppo_minct, oppo_maxct
	local extra_fun
	if list_typ ~= "PlayerTarget" and list_typ ~= "PlayerCost" and list_typ ~= "ExtraCheck" and list_typ ~= "ExtraOperation" then 
		card_filter, group_filter, category_str, category, category_arr, category_str_arr, replace_operation, zone_self, zone_oppo, minct, maxct, except_group, reuse_idx = v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
	elseif list_typ == "PlayerTarget" or list_typ == "PlayerCost" then 
		category_str, category, category_arr, category_str_arr, replace_operation, self_minct, self_maxct, oppo_minct, oppo_maxct = v2, v3, v4, v5, v6, v7, v8, v9, v10
	else
		extra_fun = v2
	end
	local reason = (list_typ == "Cost" or list_typ == "PlayerCost") and REASON_COST or REASON_EFFECT
	--step3 chkc check
	if chkc then
		if list_typ == "Target" then 
			Scl.Card_Target_Count_Check = Scl.Card_Target_Count_Check + (type(minct) == "number" and minct or 1)
			--case1 Scl.Operate_Mandatory_Group not contains chkc 
			if Scl.Operate_Mandatory_Group and not Group.IsContains(Scl.Operate_Mandatory_Group, chkc) then 
				return false
			end
			--case2 2+ targets, or check twice
			if Scl.Card_Target_Count_Check > 1 then 
				return false
			end
			--case3 zone_self and zone_oppo check 
			if type(zone_self) == "number" and zone_self > 0 and zone_oppo == 0 and chkc:IsControler(1 - tp) then 
				return false
			end
			if type(zone_oppo) == "number" and zone_oppo > 0 and zone_self == 0 and chkc:IsControler(tp) then 
				return false
			end
			if type(zone_oppo) == "number" and not chkc:IsLocation(zone_self | zone_oppo) then 
				return false 
			end
			--case4 not meet card_filter
			if not s.operate_filter(card_filter, e)(chkc, e, tp, e, tp, eg, ep, ev, re, r, rp) then 
				return false 
			end
			--case5 not meet group_filter
			if group_filter and not s.operate_filter(group_filter)(Scl.Mix2Group(chkc), e, tp, e, tp, eg, ep, ev, re, r, rp) then 
				return false
			end
		end
		return s.cost_or_target_or_operation_feasibility_check(e, tp, eg, ep, ev, re, r, rp, chk, chkc, arr2, ...)
	end 
	--step4 chk == 0 check
	if chk == 0 then 
		--case1 extra check 
		if list_typ == "ExtraOperation" then
			return s.cost_or_target_or_operation_feasibility_check(e, tp, eg, ep, ev, re, r, rp, chk, chkc, used_arr, arr2, ...)
		elseif list_typ == "ExtraCheck" then 
			if not extra_fun(e, tp, eg, ep, ev, re, r, rp, 0) then 
				return false
			else 
				return s.cost_or_target_or_operation_feasibility_check(e, tp, eg, ep, ev, re, r, rp, chk, chkc, used_arr, arr2, ...)
			end
		--case2 player target effect check
		elseif list_typ == "PlayerTarget" or list_typ == "PlayerCost" then 
			local op_arr = { [tp] = self_minct, [1 - tp] = oppo_minct, [tp + 2] = self_maxct, [3 - tp] = oppo_maxct }
			Scl.Player_Cost_And_Target_Value[category_str] = Scl.CloneArray(op_arr)
			if not s.operate_selected_objects(Scl.Player_Cost_And_Target_Value[category_str], category_str, reason, 0, e, tp, eg, ep, ev, re, r, rp)() then
				return false
			else 
				return s.cost_or_target_or_operation_feasibility_check(e, tp, eg, ep, ev, re, r, rp, chk, chkc, used_arr, arr2, ...)
			end
		--case3 target effect check
		elseif list_typ == "Target" or list_typ == "~Target" or list_typ == "Cost" or list_typ == "Operation" then
			local target_effect = list_typ == "Target" and e or nil
			local used_arr2, used_group_this_reuse_idx = s.cost_or_target_or_operation_reuse_cards_check(used_arr, reuse_idx, nil, except_group)
			--case1 cost check 
			if (list_typ == "Cost" or list_typ == "PlayerCost") and not e:IsCostChecked() then
				return s.cost_or_target_or_operation_feasibility_check(e, tp, eg, ep, ev, re, r, rp, chk, chkc, used_arr, arr2, ...)
			end
			--case2 minct <= 0
			if type(minct) == "number" and minct <= 0 then 
				return false 
			end
			--case3 zone_self = nil, means do operation to the effect handler self.
			local mandatory_group = Group.CreateGroup()
			if not zone_self then 
				mandatory_group = Group.FromCards(c)
				if not s.operate_filter(card_filter, target_effect)(c, e, tp, eg, ep, ev, re, r, rp) or used_group_this_reuse_idx:IsContains(c) then
					return false 
				end
			--case4 zone_self = true, means do operation to the effect group (eg).
			elseif Scl.CheckBoolean(zone_self, true) then 
				mandatory_group = eg:Filter(s.operate_filter(card_filter, target_effect), used_group_this_reuse_idx, e, tp, eg, ep, ev, re, r, rp)
			--case5 other check 
			else
				--case5.1 extra tribute check 
				if list_typ == "Cost" and category & CATEGORY_RELEASE ~= 0 then
					local rg = s.get_tribute_group(tp, zone_self, zone_oppo, e)
					mandatory_group = rg:Filter(s.operate_filter(card_filter), used_group_this_reuse_idx, e, tp, eg, ep, ev, re, r, rp)
				--case5.2 normal check
				else
					mandatory_group = Duel.GetMatchingGroup(s.operate_filter(card_filter, target_effect), tp, zone_self, zone_oppo, used_group_this_reuse_idx, e, tp, eg, ep, ev, re, r, rp)
				end
			end
			if #mandatory_group == 0 then 
				return false
			end
			--case6 black hole check (minct == true)
			local chk_minct, chk_maxct = minct, maxct
			if Scl.CheckBoolean(minct, true) then 
				chk_minct, chk_maxct = #mandatory_group, #mandatory_group
			end
			return mandatory_group:CheckSubGroup(s.cost_or_target_or_operation_group_check, chk_minct, chk_maxct, {e, tp, eg, ep, ev, re, r, rp, reuse_idx, used_arr2, group_filter}, arr2, ...)
		end
	end
end
--operate 
function s.do_cost_or_target_or_operation(e, tp, eg, ep, ev, re, r, rp, current_sel_group, total_sel_group, used_arr, arr1, arr2, ...)
	--step1 no more arrays need to check.
	if not arr1 then 
		return true 
	end
	local c = e:GetHandler()
	--step2 get current array's attribute
	local list_typ, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20 = s.get_cost_or_target_or_operation_paramas(arr1, e, tp, eg, ep, ev, re, r, rp)
	local card_filter, group_filter, category_str, category, category_arr, category_str_arr, replace_operation, zone_self, zone_oppo, minct, maxct, except_group, reuse_idx
	local category_str, category, category_arr, category_str_arr, replace_operation, self_minct, self_maxct, oppo_minct, oppo_maxct
	local extra_fun
	if list_typ ~= "PlayerTarget" and list_typ ~= "PlayerCost" and list_typ ~= "ExtraCheck" and list_typ ~= "ExtraOperation" then 
		card_filter, group_filter, category_str, category, category_arr, category_str_arr, replace_operation, zone_self, zone_oppo, minct, maxct, except_group, reuse_idx = v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14
	elseif list_typ == "PlayerTarget" or list_typ == "PlayerCost" then 
		category_str, category, category_arr, category_str_arr, replace_operation, self_minct, self_maxct, oppo_minct, oppo_maxct = v2, v3, v4, v5, v6, v7, v8, v9, v10
	else
		extra_fun = v2
	end
	local reason = (list_typ == "Cost" or list_typ == "PlayerCost") and REASON_COST or REASON_EFFECT
	--step3 no cost
	if (list_typ == "Cost" or list_typ == "PlayerCost") and not e:IsCostChecked() then
		return s.do_cost_or_target_or_operation(e, tp, eg, ep, ev, re, r, rp, current_sel_group, total_sel_group, used_arr, arr2, ...)
	--step4 extra operate
	elseif list_typ == "ExtraCheck" then	
		return s.do_cost_or_target_or_operation(e, tp, eg, ep, ev, re, r, rp, current_sel_group, total_sel_group, used_arr, arr2, ...)
	elseif list_typ == "ExtraOperation" then 
		if not extra_fun(current_sel_group, total_sel_group, e, tp, eg, ep, ev, re, r, rp) then 
			return false
		else 
			return s.do_cost_or_target_or_operation(e, tp, eg, ep, ev, re, r, rp, current_sel_group, total_sel_group, used_arr, arr2, ...)
		end
	--step5 player cost operate
	elseif list_typ == "PlayerCost" then
		local op_arr = { [tp] = self_minct, [1 - tp] = oppo_minct, [tp + 2] = self_maxct, [3 - tp] = oppo_maxct }
		if not s.operate_selected_cost_or_operat_objects(op_arr, total_sel_group, category_str, replace_operation, reason, e, tp, eg, ep, ev, re, r, rp) then 
			return false 
		else
			return s.do_cost_or_target_or_operation(e, tp, eg, ep, ev, re, r, rp, current_sel_group, total_sel_group, used_arr, arr2, ...)
		end
	--step6 player target 
	elseif list_typ == "PlayerTarget" then 
		local dp = PLAYER_NONE
		if self_minct > 0 and oppo_minct > 0 then 
			dp = PLAYER_ALL
		elseif self_minct > 0 then 
			dp = tp
		elseif oppo_minct > 0 then 
			dp = 1- tp
		end
		local player_parama = math.max(self_minct, oppo_minct)
		Duel.SetTargetPlayer(dp)
		Duel.SetTargetParam(player_parama)  
		for _, ctgy in pairs(category_arr) do
			Duel.SetOperationInfo(0, categroy, nil, 0, dp, player_parama)
		end
	--step7 cost and operation and ~target
	elseif list_typ == "Cost" or list_typ == "Operation" or list_typ == "Target" or list_typ == "~Target" then
		local need_sel = (list_typ == "Cost" or list_typ == "Operation" or list_typ == "Target") and type(minct) == "number"
		local need_reg = list_typ == "Target" or list_typ == "~Target"
		local need_operate = list_typ == "Cost" or list_typ == "Operation"
		local target_effect = list_typ == "Target" and e or nil
		local used_arr2, used_group_this_reuse_idx = s.cost_or_target_or_operation_reuse_cards_check(used_arr, reuse_idx, nil, except_group)
		local current_sel_group2 = current_sel_group:Clone()
		--case1 zone_self = nil, means do operation to the effect handler self.
		local mandatory_group = Group.CreateGroup()
		if not zone_self then 
			mandatory_group = Group.FromCards(c)
		--case2 zone_self = true, means do operation to the effect group (eg).
		elseif Scl.CheckBoolean(zone_self, true) then 
			local eg2 = eg:Filter(s.operate_filter(card_filter, target_effect), used_group_this_reuse_idx, e, tp, eg, ep, ev, re, r, rp)
			mandatory_group:Merge(eg2)
		--case3 zone_self = number  
		else
			--case3.1 extra tribute check 
			if list_typ == "Cost" and category & CATEGORY_RELEASE ~= 0 then 
				local rg = s.get_tribute_group(tp, zone_self, zone_oppo, e)
				mandatory_group = rg:Filter(s.operate_filter(card_filter), used_group_this_reuse_idx, e, tp, eg, ep, ev, re, r, rp)
			--case3.2 normal check
			else
				mandatory_group = Duel.GetMatchingGroup(s.operate_filter(card_filter, target_effect), tp, zone_self, zone_oppo, used_group_this_reuse_idx, e, tp, eg, ep, ev, re, r, rp)
			end
		end
		--case4 black hole or do operation on self (no more need to select)
		local reg_ct
		if Scl.CheckBoolean(minct, true) or not zone_self then
			reg_ct = #mandatory_group
		--case5 normal select
		else 
			if need_sel then
				Scl.SelectHint(tp, category_str)
				mandatory_group = mandatory_group:SelectSubGroup(tp, s.cost_or_target_or_operation_group_check, false, minct, maxct, {e, tp, eg, ep, ev, re, r, rp, reuse_idx, used_arr2, group_filter}, arr2, ...)
			end
		end
		--case6 no more cards
		if #mandatory_group == 0 then 
			return false
		else 
			used_arr2[reuse_idx] = Scl.MixArrays(used_arr2[reuse_idx], Scl.Group2CardList(mandatory_group))
		end
		--case7 cards be target
		if list_typ == "Target" then 
			Duel.SetTargetCard(mandatory_group)
		end
		--case8 need register operation info 
		local reg_zone = 0
		if need_reg then 
			local dp = 0
			if type(zone_self) == "number" then
				if zone_self > 0 and zone_oppo > 0 then 
					dp = PLAYER_ALL
				elseif zone_self > 0 then 
					dp = tp
				elseif zone_oppo > 0 then 
					dp = 1- tp
				end
				reg_zone = zone_self | zone_oppo
			end
			for _, ctgy in pairs(category_arr) do
				Duel.SetOperationInfo(0, category, mandatory_group, reg_ct or minct, dp, reg_zone)
			end
		end
		--case9 do operate
		local total_sel_group2 = total_sel_group:Clone()
		total_sel_group2:Merge(mandatory_group)
		if need_operate then
			if not s.operate_selected_cost_or_operat_objects(mandatory_group, total_sel_group2, category_str, replace_operation, reason, e, tp, eg, ep, ev, re, r, rp) then
				return false
			end
		end
		return s.do_cost_or_target_or_operation(e, tp, eg, ep, ev, re, r, rp, mandatory_group, total_sel_group2, used_arr2, arr2, ...)
	end
end
function s.cost_or_target_or_operation_group_check(g, parama, arr1, ...)
	--for some shenbi reasons, koshipro will lost paramas during the spell/trap card call this function, so I must use a table to protect the paramas, but original edition ygopro don't have this problem.
	local e, tp, eg, ep, ev, re, r, rp, reuse_idx, used_arr, group_filter = table.unpack(parama)
	local used_arr2, used_group_this_reuse_idx = s.cost_or_target_or_operation_reuse_cards_check(used_arr, reuse_idx, g)
	if not s.operate_filter(group_filter)(g, e, tp, eg, ep, ev, re, r, rp) then 
		return false 
	end
	return s.cost_or_target_or_operation_feasibility_check(e, tp, eg, ep, ev, re, r, rp, 0, nil, used_arr2, arr1, ...)
end
--For official "Card", "Group" and "aux" filter, force the function only call filter(c/g)
--for other custom filters, call filter(c/g, e, tp, eg, ...)
--why? like Card.IsAbleToHand(), it has 2 paramas Card.IsAbleToHand(card, owner), if you call Card.IsAbleToHand(card, e, tp, eg, ...), then the bugs will come. What, you need to call Card.IsAbleToHand(card, owner)? PLZ change it to your own custom filter. 
function s.record_official_filter()
	for _, fun in pairs(Card) do
		Scl.Official_Filter[fun] = true
	end
	for _, fun in pairs(Group) do
		Scl.Official_Filter[fun] = true
	end
	for _, fun in pairs(aux) do
		Scl.Official_Filter[fun] = true
	end
end
function s.operate_filter(filter, target_effect)
	return function(obj, e, tp, ...)
		if target_effect and not obj:IsCanBeEffectTarget(target_effect) then 
			return false
		end
		if not Scl.Official_Filter[filter] then 
			return filter(obj, e, tp, ...)
		else
			return filter(obj)
		end
	end
end
--get tribute cards group for cost
--//return group
function s.get_tribute_group(tp, zone_self, zone_oppo, re)
	local rg = Group.CreateGroup()
	if zone_self > 0 then 
		rg = Duel.GetReleaseGroup(tp, zone_self & LOCATION_HAND > 0 and true or false):Filter(s.get_tribute_group_filter, nil, zone_self, tp, re)
	end
	local g2 = Duel.GetMatchingGroup(Card.IsReleasable, tp, zone_self, zone_oppo, nil)
	return rg + g2
end
function s.get_tribute_group_filter(c, zone_self, tp, re)
	if c:IsControler(tp) and c:IsLocation(zone_self) then 
		return true 
	end
	local arr = { c:IsHasEffect(EFFECT_EXTRA_RELEASE_NONSUM) }
	for _, e in pairs(arr) do 
		local val = e:GetValue() or aux.TRUE
		if val(e, re, REASON_COST, tp) then 
			return true
		end
	end
	return false
end
function s.cost_or_target_or_operation_reuse_cards_check(used_arr, reuse_idx, used_group, except_group)
	local used_arr2 = Scl.CloneArray(used_arr)
	used_arr2[reuse_idx] = used_arr[reuse_idx] or { }
	used_arr2[reuse_idx] = Scl.MixArrays(Scl.CloneArray(used_arr2[reuse_idx]), Scl.Group2CardList(used_group or Group.CreateGroup()))
	return used_arr2, Scl.Mix2Group(used_arr2[reuse_idx]) + (except_group or Group.CreateGroup())
end
function s.operate_selected_cost_or_operat_objects(current_sel_object, total_sel_group, category_str, replace_operation, reason, e, tp, eg, ep, ev, re, r, rp)
	if replace_operation then 
		return replace_operation(current_sel_object, total_sel_group, e, tp, eg, ep, ev, re, r, rp) 
	else
		return s.operate_selected_objects(current_sel_object, category_str, reason, 1, e, tp, eg, ep, ev, re, r, rp)()
	end
end
--some functions like Scl.SelectAndOperateCards, you cannot transfer parama "e" and "tp" to s.operate_selected_objects, so you first need to use this function to get the current checking/solving effect "e".
--//return the current checking/solving effect.
function Scl.GetCurrentEffectInfo()
	if not Scl.Token_List[4392470] or not Scl.Token_List[4392470][1] then
		return nil, true, 0, true, "Global Effect"
	end
	Duel.IsPlayerCanSpecialSummon(0, 0, POS_FACEUP, 0, Scl.Token_List[4392470][1])
	e = Scl.Current_Effect
	Scl.Current_Effect = nil
	local c1 = e:GetHandler()
	local c2 = e:GetOwner()
	local handler = aux.GetValueType(c1) == "Card" and c1 or true
	local handler_pl = e:GetHandlerPlayer()
	local owner = aux.GetValueType(c2) == "Card" and c2 or handler
	local owner_id = aux.GetValueType(owner) == "Card" and owner:GetOriginalCode() or "Global Effect"
	return e, handler, handler_pl, owner, owner_id
end
function s.add_current_effect_check()
	Scl.AddTokenList(nil, 4392470)
	local e1 = Scl.CreatePlayerBuffEffect({true, 0}, "!SpecialSummon", 1, s.add_current_effect_check_target, { 1, 1 })
end
function s.add_current_effect_check_target(e, c, sump, sumtype, sumpos, targetp, se)
	Scl.Current_Effect = se
	return false
end
--Nested function
--Do sth. on the sel_obj, by use ctgy_str as index to find the operate function in Scl.Category_List.
--if chk == 0, this function won't do operation, but check whether it can be operated successfully.
-- ... is the parama of the operate function, if you don't set those parama(s), it will use the default parama (see Scl.Category_List)
--//return that operate function's return.,
function s.operate_selected_objects(sel_obj, ctgy_str, reason, chk, e, tp, eg, ep, ev, re, r, rp)
	return function(...)
		local ex_para_arr =  { ... }
		local op_arr = Scl.Category_List[ctgy_str][6]
		local e2, c, tp2 = Scl.GetCurrentEffectInfo()
		e = e or e2
		tp = tp or tp2
		Scl.Operate_Check = chk  
		Scl.Operate_Check_Effect = e 
		Scl.Operate_Check_Player = tp 
		local solve_arr = { }
		local op_fun = chk == 0 and aux.TRUE or function()
			return 0, Group.CreateGroup()
		end
		local para_len = 0
		local str_arr = { "solve_parama", "activate_player", "activate_effect", "reason" }
		if op_arr then
			op_fun = op_arr[1]
			para_len = op_arr[2]
			local val, val2
			for idx = 3, para_len + 2 do
				val = op_arr[idx]
				if type(val) == "string" and Scl.IsArrayContains_Single(str_arr, val) then
					if val == "solve_parama" then
						val2 = sel_obj
					elseif val == "activate_player" then
						val2 = tp
					elseif val == "activate_effect" then
						val2 = e
					elseif val == "reason" then
						val2 = reason 
					end
				elseif type(val) == "function" and Scl.Reason_List[val] then
					val2 = val(reason)
				else
					val2 = val
				end
				solve_arr[idx - 2] = val2
			end
			if para_len > 1 then
				local val_ex
				for idx = 1, para_len - 1 do 
					val_ex = ex_para_arr[idx]
					if type(val_ex) ~= "nil" then 
						solve_arr[idx + 1] = val_ex
					end
				end
			end
		end
		local sl = solve_arr
		local res = { op_fun(sl[1], sl[2], sl[3], sl[4], sl[5], sl[6], sl[7], 
			sl[8], sl[9], sl[10], sl[11], sl[12]) }
		Scl.Operate_Check = 1
		Scl.Operate_Check_Effect = nil
		Scl.Operate_Check_Player = 0
		return table.unpack(res)
	end
end
--cost: remove a number of ct_typ counters (minct ~ maxct) from this card.
--minct default == 1, maxct default == minct 
--if minct == true, means remove all ct_typ counters from this card.
--the removed count will be record in Scl.Cost_Count[e]
-->>eg1. scl.cost_remove_counter(0x1, 1)
-->>remove 1 0x1 from this card.
-->>eg2. scl.cost_remove_counter(0x1, 2, 5)
-->>remove 2 ~ 5 0x1 from this card.
-->>eg3. scl.cost_remove_counter(0x1, true)
-->>remove all 0x1 from this card.
function scl.cost_remove_counter(ct_typ, minct, maxct)
	minct = minct or 1
	maxct = maxct or minct
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		local minct2= Scl.CheckBoolean(minct) and c:GetCounter(ct_typ) or minct
		local maxct2= Scl.CheckBoolean(maxct) and c:GetCounter(ct_typ) or maxct
		local rmct = 0
		if chk == 0 then 
			return c:IsCanRemoveCounter(tp, ct_typ, minct2, REASON_COST)
		end
		if maxct2 > minct2 then
		   local arr = { }
		   for ct = minct2, maxct2 do
			   table.insert(arr, ct)
		   end
		   Scl.Hint(tp, HINTMSG_OPERATE_COUNT_SCL)
		   rmct = Duel.AnnounceNumber(tp, table.unpack(arr))
		end
		c:RemoveCounter(tp, ct_typ, rmct, REASON_COST)
		Scl.Cost_Count[e] = rmct
	end
end
--cost: remove a number of ct_typ counters (minct ~ maxct) from self_zone and/or oppo_zone.
--self_zone default == 1, oppo_zone default == 0.
--minct default == 1, maxct default == minct 
--if minct == true, means remove all ct_typ counters from this card.
--the removed count will be record in Scl.Cost_Count[e]
-->>eg1. scl.cost_remove_counter_from_field(0x1, 1, 0, 1)
-->>remove 1 0x1 from your field.
-->>eg2. scl.cost_remove_counter(0x1, 1, 1, 2, 5)
-->>remove 2 ~ 5 0x1 from either player's field.
-->>eg3. scl.cost_remove_counter(0x1, 1, 0, true)
-->>remove all 0x1 from your field.
function scl.cost_remove_counter_from_field(ct_typ, self_zone, oppo_zone, minct, maxct)
	self_zone = self_zone or 1
	oppo_zone = oppo_zone or 0
	minct = minct or 1
	maxct = maxct or minct
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local minct2= Scl.CheckBoolean(minct) and Duel.GetCounter(self_zone, oppo_zone, ct_typ) or minct
		local maxct2= Scl.CheckBoolean(maxct) and Duel.GetCounter(self_zone, oppo_zone, ct_typ) or maxct
		local rmct = minct2
		if chk == 0 then 
			return Duel.IsCanRemoveCounter(tp, self_zone, oppo_zone, ct_typ, minct2, REASON_COST) 
		end
		if maxct2 > minct2 then
			local arr = { }
			for ct = minct2, maxct2 do
			   table.insert(arr, ct)
			end
			Scl.Hint(tp, HINTMSG_OPERATE_COUNT_SCL)
			rmct = Duel.AnnounceNumber(tp, table.unpack(arr))
		end
		Duel.RemoveCounter(tp, self_zone, oppo_zone, ct_typ, rmct, REASON_COST)
		Scl.Cost_Count[e] = rmct
	end
end
--cost: detach minct ~ maxct materials from this card.
--minct default == 1, maxct default == minct 
--if minct == true, means deatch all materials from this card.
--the detached count will be record in Scl.Cost_Count[e]
-->>eg1. scl.cost_detach_xyz_material(1)
-->>"deatch 1 material from this card"
-->>eg2. scl.cost_detach_xyz_material(1, 3)
-->>"detach up to 3 materials from this card"
-->>eg3. scl.cost_detach_xyz_material(true)
-->>"detach all materials from this card"
function scl.cost_detach_xyz_material(minct, maxct)
	minct = minct or 1
	maxct = maxct or minct
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		local minct2= Scl.CheckBoolean(minct) and c:GetOverlayCount() or minct
		local maxct2= Scl.CheckBoolean(maxct) and c:GetOverlayCount() or maxct
		if chk == 0 then 
			return c:CheckRemoveOverlayCard(tp, minct2, REASON_COST) 
		end
		c:RemoveOverlayCard(tp, minct2, maxct2, REASON_COST)
		Scl.Cost_Count[e] = Duel.GetOperatedGroup():GetCount()
	end
end
--Set label as the dummy cost. 
--there are some effects, that their real costs will affect their operations. If you register their costs by Effect.SetCost directly, it will cause bug when the effects are copied by other copy effects, because the copy effects only copy the effect targets and operations, ignore costs. To avoid the bugs, use Effect.SetLabel as a dummy cost, and register the real cost in effect target.
--code default == 100
function scl.cost_check_copy_status(code)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		e:SetLabel(code or 100)
		return true
	end
end
--cost: pay LP
--if pay_ct == true, means "pay half your LP"
--is_directly default == false, if == true, means "pay LP so that you only have "pay_ct" left"
--the paid count will be record in Scl.Cost_Count[e]
-->>eg1. scl.cost_pay_lp(1000)
-->>"pay 1000 LP"
-->>eg2. scl.cost_pay_lp(true)
-->>"pay half you LP"
-->>eg2. scl.cost_pay_lp(1000, true)
-->>"pay LP so that you only have 1000 left"
function scl.cost_pay_lp(pay_ct, is_directly)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local pay_lp = pay_ct
		if Scl.CheckBoolean(lp) then 
			pay_lp = math.floor(Duel.GetLP(tp) / 2) 
		end
		if is_directly then 
			pay_lp = Duel.GetLP(tp) - pay_lp 
		end
		if chk == 0 then 
			return pay_lp > 0 and Duel.CheckLPCost(tp, pay_lp)
		end
		Duel.PayLPCost(tp, pay_lp)   
		Scl.Cost_Count[e] = pay_lp
	end
end
--cost: pay LP in multiples of "base_pay" (max. "max_pay")
--max_pay default == your current LP
--the paid count will be record in Scl.Cost_Count[e]
-->>eg1. scl.cost_pay_lp_in_multiples(1000)
-->>"pay LP in multiples of 1000"
-->>eg2. scl.cost_pay_lp_in_multiples(500, 4000)
-->>"pay LP in multiples of 1000 (max. 4000)"
function scl.cost_pay_lp_in_multiples(base_pay, max_pay)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local max_lp = Duel.GetLP(tp)
		if type(max_pay) == "number" then
			max_lp = math.min(max_lp, max_pay)
		end
		if chk == 0 then 
			return Duel.CheckLPCost(tp, base_pay) 
		end
		local max_multiple = math.floor(max_lp / base_pay)
		local pay_list = { }
		for idx = 1, max_multiple do
			pay_list[idx] = idx * base_pay
		end
		local pay_lp = Duel.AnnounceNumber(tp, table.unpack(pay_list))
		Duel.PayLPCost(tp, pay_lp)
		Scl.Cost_Count[e] = pay_lp 
	end
end
--cost: once per chain
--flag_code default == the effect handler's original code.
--player_lim default == false, == true means "you can only use xxx's effect once per chain"
-->>eg1. scl.cost_once_per_chain(114514)
-->>"Once per Chain: XXXXXXXX"
-->>eg2. scl.cost_once_per_chain(114514, true)
-->>"you can only use 114514 once per chain"
function scl.cost_once_per_chain(flag_code, player_lim)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		flag_code = flag_code or c:GetOriginalCode()
		local b1 = not player_lim and c:GetFlagEffect(flag_code) == 0
		local b2 = player_lim and Duel.GetFlagEffect(tp, flag_code) == 0
		if chk == 0 then 
			return b1 or b2 
		end
		if b1 then
			c:RegisterFlagEffect(flag_code, RESET_CHAIN, 0, 1)
		elseif b2 then
			Duel.RegisterFlagEffect(tp, flag_code, RESET_CHAIN, 0, 1)
		end
	end
end 
--Nested function
--condition: if player_idx == 0, check rp == tp, else check rp ~= tp
function scl.cond_check_rp(player_idx)
	return function(e, tp, eg, ep, ev, re, r, rp)
		if player_idx == 0 then 
			return rp == tp 
		elseif player_idx == 1 then
			return rp ~= tp
		end
		return false
	end
end
--Nested function
--will call Scl.IsReason(nil, ...) to check if "r" include your point reason(s), paramas see Scl.IsReason
-->>eg1. scl.cond_check_r(0, REASON_EFFECT/"Effect")
-->>check if "r" has REASON_EFFECT
function scl.cond_check_r(...)
	local arr = { ... }
	return function(e, tp, eg, ep, ev, re, r, rp)
		Scl.Global_Reason = r
		local res = Scl.IsReason(nil, table.unpack(arr))
		Scl.Global_Reason = nil
		return res
	end
end
--condition: during your turn
function scl.cond_during_your_turn(e)
	return Duel.GetTurnPlayer() == e:GetHandlerPlayer()
end 
--condition: during your opponent's turn
function scl.cond_during_opponents_turn(e)
	return Duel.GetTurnPlayer() ~= e:GetHandlerPlayer()
end 
--condition: previous faceup
function scl.cond_previous_faceup(e)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
--Nested function
--condition: in XXX Phase
--the format of ... : phase_str1, player1, phase_str2, player2, ... ("Or" check)
--OR can be {  phase_str1, player1, phase_str2, player2, ...  }, { phase_strA, playerA, phase_strB, playerB, ... }, ... ("And" check)
--phase_str can be string-fromat (like "MP" or "MP,BP"), the function will split phase_obj to single phase strings and use them as index to find the corresponding number or function format phase in Scl.Phase_List.
--you can add "~" as prefix to the phase_str, the function will turn to mean "excpet in XXX Phase".
--player (default == nil): if == 0, means in your turn, if == 1, means in your opponent's turn, if == nil, means in any player's turn.
-->>eg1. scl.cond_in_phase("M1")
-->>check the current phase is the Main Phase1 or not.
-->>eg2. scl.cond_in_phase("M1,BP")
-->>check the current phase is the Main Phase1 or Battle Phase, or not.
-->>eg3. scl.con_phase("~MP")
-->>check the current phase is not Main Phase.
-->>eg4. scl.con_phase("~MP", 0, "BP", 1)
-->>check the current phase is not in your turn's Main Phase, or in your opponent's Battle Phase.
-->>eg4. scl.con_phase({"~MP", 0}, {"~BP", 1})
-->>check the current phase is not in your turn's Main Phase, and not in your opponent's Battle Phase.
function scl.cond_during_phase(...)
	local arr = { }
	if type(({ ... })[1]) ~= "table" then 
		arr = { { ... } }
	end
	return function(e)
		local tp = e:GetHandlerPlayer()
		local current_ph = Duel.GetCurrentPhase()
		for _, and_arr in pairs(arr) do 
			local res = true
			local phase_arr, player_arr = Scl.SplitArrayByParity(and_arr)
			for idx, phase_str in pairs(phase_arr) do 
				local p = player_arr[idx]
				local no_symbol_str, symbol = Scl.RemoveStringSymbol(phase_str, "~")
				local ph = Scl.Phase_List[no_symbol_str]
				res = false
				if type(ph) == "function" then  
					res = ph(current_ph)
					if symbol == "~" then  
						res = not res 
					end
				else
					res = ph & current_ph == ( symbol == "~" and 0 or current_ph )
				end
				res = res and (not p or (p == 0 and p == tp) or (p == 1 and p ~= tp))
			end
			if not res then 
				return false 
			end
			return true
		end
	end
end
--Nested function
--condition: If this card is XXX summoned
--will use typ_str as index to find the number-format summon type from Scl.Summon_Type_List.
--if field_check(default == false) == true, means check is "eg" contains at least 1 monster meets summon type.
-->>eg1. scl.cond_is_summon_type("LinkSummon")
-->>check whether this card is link summoned.
-->>eg1. scl.cond_is_summon_type("LinkSummon", true)
-->>check whether eg include a monster that is link summoned.
function scl.cond_is_summon_type(typ_str, field_check)
	return function(e, tp, eg)
		local f = function(c)
			return c:GetSummonType() & Scl.Summon_Type_List[typ_str] == Scl.Summon_Type_List[typ_str]
		end
		if field_check then 
			return eg:IsExists(f, 1, nil)
		else
			return f(e:GetHandler())
		end
	end
end 
--Nested function
--condition: is special summoned from "zone_obj"
--player (default == nil): if == 0, means from your zone(s), if == 1, means from your opponent's zone(s), if == nil, means from any player's zone(s).
-->>eg1. scl.cond_is_special_summon_from("Hand")
-->>check if this card is special summon from hand.
function scl.cond_is_special_summon_from(zone_obj, player)
	return function(e)
		local c = e:GetHandler()
		return c:IsSummonType(SUMMON_TYPE_SPECIAL) and Scl.IsPreviouslyInZone(c, zone_obj) and (not player or (player == 0 and c:IsPreviousControler(tp)) or (player == 1 and c:IsPreviousControler(1 - tp)))
	end
end
--Nested function
--condition: if you/your opponent controls xxx, except "except_obj".
--xxx must meet card_filter(c, ...)
--self_zone default == LOCATION_MZONE
--oppo_zone default == 0
--ct default == 1
-->>eg1. scl.cond_is_card_exists(aux.TRUE)
-->>check if you control a card(s)
-->>eg2. scl.cond_is_card_exists(s.filter, 0, "GY", 5)
-->>check if there are 5 cards meet s.filter(c) in your opponent's GY.
function scl.cond_is_card_exists(card_filter, self_zone, oppo_zone, ct, except_obj, ...)
	local arr = { ... }
	return function(e)
		local self_zone2 = Scl.GetNumFormatZone(self_zone or LOCATION_MZONE)
		local oppo_zone2 = Scl.GetNumFormatZone(oppo_zone or 0)
		return Duel.IsExistingMatchingCard(s.operate_filter(card_filter), e:GetHandlerPlayer(), self_zone2 , oppo_zone2, ct or 1, except_obj, table.unpack(arr))
	end
end
--Nested function
--condition: if you/your opponent controls xxx, except "except_obj".
--explains see scl.cond_is_card_faceup_exists
--this function will additional check if the card(s) is faceup.
-->>eg1. scl.cond_is_card_faceup_exists(s.filter)
-->>check if you control a face-up card(s) meet s.filter(c)
-->>eg2. scl.cond_is_card_faceup_exists(s.filter, 0, "Banished", 5)
-->>check if your opponent's banish cards have 5 cards meet s.filter(c).
function scl.cond_is_card_faceup_exists(card_filter, self_zone, oppo_zone, ct, except_obj, ...)
	local card_filter2 = aux.AND(card_filter, Card.IsFaceup)
	return scl.cond_is_card_exists(card_filter2, self_zone, oppo_zone, ct, except_group, ...)
end
--outer case function for Scl.SelectCards/Scl.SelectAndOperateCards
--would_hint: if you set would_hint, the select will be a optional, and will show would_hint as the YES OR NO option.
--need_break: if == true, means the operation has a different timing than the earlier operations (Duel.BreakEffect)
--sel_hint: if you set the sel_hint, it will replace the default select hint message.
-->>eg1. Scl.SetExtraSelectAndOperateParama("Add2Hand", true)
-->>system will ask you whether you wolud add a card to your hand (if possible), and before you adding, system will do Duel.BreakEffect
function Scl.SetExtraSelectAndOperateParama(would_hint, need_break, sel_hint)
	if would_hint then
		would_hint = s.switch_hint_object_format(would_hint, "WouldSelect")
	end
	Scl.Extra_Operate_Parama_Check_Hint = would_hint
	Scl.Extra_Operate_Parama_Need_Break = need_break
	Scl.Extra_Operate_Parama_Select_Hint = sel_hint
	return true
end
--Nearly same as Duel.GetMatchingGroup.
--zone_self and zone_oppo can be string-format (see Scl.Zone_List)
--//return group
-->>eg1. Scl.GetMatchingGroup(Card.IsAbleToHand, tp, "Deck", 0, nil)
-->>check whether there is a card in your deck that can be added to the hand, return that group
function Scl.GetMatchingGroup(filter_obj, tp, zone_self, zone_oppo, except_obj, ...)
	local filter_arr = type(filter_obj) == "table" and filter_obj or { filter_obj }
	local card_filter, group_filter = table.unpack(filter_arr)
	card_filter = card_filter or aux.TRUE 
	group_filter = group_filter or aux.TRUE
	local self_zone2 = Scl.GetNumFormatZone(self_zone)
	local oppo_zone2 = Scl.GetNumFormatZone(oppo_zone)
	return Duel.GetMatchingGroup(card_filter, tp, self_zone2, oppo_zone2, except_obj, ...)
end
--Nearly same as Duel.IsExistingMatchingCard, but has follow changes.
--filter_obj can be card_filter or { card_filter, group_filter }
--zone_self and zone_oppo can be string-format (see Scl.Zone_List)
--//return is existing
-->>eg1. Scl.IsExistingMatchingCard(Card.IsAbleToHand, tp, "Deck", 0, 1, nil)
-->>check whether there is a card in your deck that can be added to the hand.
-->>eg2. Scl.IsExistingMatchingCard({ Card.IsAbleToHand, aux.dncheck }, tp, "Deck", 0, 2, nil)
-->>check whether there are 2 cards in your deck that have different names and can be added to the hand.
function Scl.IsExistingMatchingCard(filter_obj, tp, zone_self, zone_oppo, ct, except_obj, ...)
	local g = Scl.GetMatchingGroup(filter_obj, tp, zone_self, zone_oppo, except_obj, ...)
	return g:CheckSubGroup(group_filter, ct, #g, ...)
end
--Nearly same as Group.IsExists, but has follow changes.
--filter_obj can be card_filter or { card_filter, group_filter }
--//return is existing
-->>eg1. Scl.IsExists(g, Card.IsAbleToHand, 1, nil)
-->>check whether there is a card in group g that can be added to the hand.
-->>eg2. Scl.IsExists(g, { Card.IsAbleToHand, aux.dncheck }, 2, nil)
-->>check whether there are 2 cards in group g that have different names and can be added to the hand.
function Scl.IsExists(chk_obj, filter_obj, ct, except_obj, ...)
	local chkg = Scl.Mix2Group(chk_obj)
	local filter_arr = type(filter_obj) == "table" and filter_obj or { filter_obj }
	local card_filter, group_filter = table.unpack(filter_arr)
	card_filter = card_filter or aux.TRUE 
	group_filter = group_filter or aux.TRUE
	return chkg:CheckSubGroup(group_filter, ct, #chkg, ...)
end
--Select minct ~ maxct cards that meets filter_obj, from self_zone and/or oppo_zone, except except_obj.
--use sel_hint as select hint (see Scl.SelectHint)
--filter_obj can be single card_filter, or be { card_filter, group_filter }, the selected cards must meet card_filter(c, ...), and the selected group must meet group_filter(g, ...)
--//return select group, the first select card
-->>eg1. Scl.SelectCards("Add2Hand", tp, s.thfilter, tp, "Deck,GY", 0, 1, 1, nil)
-->>select from your Deck or GY, 1 card meets s.thfilter(c), and use "Add2Hand" as select hint.
-->>eg2. Scl.SelectCards("Send2GY", tp, {s.tgfilter, aux.dncheck}, tp, "Deck", 0, 2, 3, nil)
-->>Select from your Deck, 2 ~ 3 cards with different names and meet s.tgfilter(c), and use "Send2GY" as select hint.
function Scl.SelectCards(sel_hint, sp, filter_obj, tp, self_zone, oppo_zone, minct, maxct, except_obj, ...)
	local filter_arr = type(filter_obj) == "table" and filter_obj or { filter_obj }
	local card_filter, group_filter = table.unpack(filter_arr)
	card_filter = card_filter or aux.TRUE 
	local self_zone2 = Scl.GetNumFormatZone(self_zone)
	local oppo_zone2 = Scl.GetNumFormatZone(oppo_zone)
	local g = Duel.GetMatchingGroup(card_filter, tp, self_zone2, oppo_zone2, except_obj, ...)
	return Scl.SelectCardsFromGroup(sel_hint, g, sp, { aux.TRUE, group_filter }, minct, maxct, except_obj, ...)  
end
--Nested function
--Select minct ~ maxct cards that meets filter_obj, from self_zone and/or oppo_zone, except except_obj, and do operation on the selected cards.
--use sel_hint as select hint, and find the operate-function (see Scl.Category_List)
--the nested paramas ... is the operate-function's paramas.
--other paramas fromat: see Scl.SelectCards
-->>return operated count, operated group, first operated card
-->>eg1. Scl.SelectAndOperateCards("Add2Hand", tp, s.thfilter, tp, "Deck,GY", 0, 1, 1, nil)()
-->>add from your Deck or GY, 1 card meets s.thfilter(c) to your hand.
-->>eg2. Scl.SelectAndOperateCards("Send2GY", tp, {s.tgfilter, aux.dncheck}, tp, "Deck", 0, 2, 3, nil)(REASON_COST)
-->>send from your Deck to GY as cost, 2 ~ 3 cards with different names and meet s.tgfilter(c).
function Scl.SelectAndOperateCards(sel_hint, sp, filter_obj, tp, self_zone, oppo_zone, minct, maxct, except_obj, ...)
	local sel_list = { ... }
	return function(...)
		local op_arr = { ... }
		local sg = Scl.SelectCards(sel_hint, sp, filter_obj, tp, self_zone, oppo_zone, minct, maxct, except_obj, table.unpack(sel_list))
		if #sg == 0 then
			--reset special summon buff
			Scl.Single_Buff_List = { }
			Scl.Single_Buff_Affect_Self_List = { }
			return 0, #sg
		else
			return s.operate_selected_objects(sg, sel_hint, REASON_EFFECT, 1)(table.unpack(op_arr))
		end
	end
end
--Select minct ~ maxct cards that meets filter_obj, from group "g", except except_obj.
--other paramas formats: see Scl.SelectCards
--//return select group, the first select card
-->>eg1. Scl.SelectCardsFromGroup("Add2Hand", g, tp, s.thfilter, 1, 1, nil)
-->>select from your g or GY, 1 card meets s.thfilter(c), and use "Add2Hand" as select hint.
-->>eg2. Scl.SelectCardsFromGroup("Send2GY", g, tp, {s.tgfilter, aux.dncheck}, 2, 3, nil)
-->>Select from your g, 2 ~ 3 cards with different names and meet s.tgfilter(c), and use "Send2GY" as select hint.
function Scl.SelectCardsFromGroup(sel_hint, g, sp, filter_obj, minct, maxct, except_obj, ...)
	minct = minct or 1
	maxct = maxct or minct
	local would_hint, need_break, sel_hint2 = Scl.Extra_Operate_Parama_Check_Hint, Scl.Extra_Operate_Parama_Need_Break, Scl.Extra_Operate_Parama_Select_Hint
	Scl.SetExtraSelectAndOperateParama(nil, nil, nil)
	local filter_arr = type(filter_obj) == "table" and filter_obj or { filter_obj }
	local card_filter, group_filter = table.unpack(filter_arr)
	card_filter = card_filter or aux.TRUE 
	local tg = g:Filter(card_filter, except_obj, ...)
	-- case1 , no suit group for card_filter
	if #tg <= 0 or (type(minct) == "number" and #tg < minct) or (type(maxct) == "number" and maxct <= 0) then
		return Group.CreateGroup()
	end
	if would_hint and not Scl.SelectYesNo(sp, would_hint) then 
		return Group.CreateGroup()
	end 
	if not Scl.CheckBoolean(minct) then
		Scl.SelectHint(sp, sel_hint2 or sel_hint)
		if not group_filter then 
			tg = tg:Select(sp, minct, maxct, except_obj, ...)
		else
			tg = tg:Filter(aux.TRUE,except_obj)
			tg = tg:SelectSubGroup(sp, group_filter, false, minct, maxct, ...)
		end
		if tg:IsExists(Scl.IsInZone, 1, nil, "OnField,GY,Banished") then
			Duel.HintSelection(tg)
		end
	end 
	if need_break then
		Duel.BreakEffect()
	end
	return tg, tg:GetFirst()
end
--Nested function
--Select minct ~ maxct cards that meets filter_obj, from group "g", except except_obj, and do operation on the selected cards.
--use sel_hint as select hint, and find the operate-function (see Scl.Category_List)
--the nested paramas ... is the operate-function's paramas.
--other paramas fromat: see Scl.SelectCards
-->>return operated count, operated group, first operated card
-->>eg1. Scl.SelectAndOperateCardsFromGroup("Add2Hand", g, tp, s.thfilter, 1, 1, nil)()
-->>add from your Deck or GY, 1 card meets s.thfilter(c) to your hand.
-->>eg2. Scl.SelectAndOperateCardsFromGroup("Send2GY", g, tp, {s.tgfilter, aux.dncheck}, 2, 3, nil)(REASON_COST)
-->>send from your Deck to GY as cost, 2 ~ 3 cards with different names and meet s.tgfilter(c).
function Scl.SelectAndOperateCardsFromGroup(sel_hint, g, sp, filter, minct, maxct, except_obj, ...)
	local sel_arr = { ... }
	return function(...)
		local op_arr = { ... }
		local sg = Scl.SelectCardsFromGroup(sel_hint, g, sp, filter, minct, maxct, except_obj, table.unpack(sel_arr))
		if #sg == 0 then
			--reset special summon buff
			Scl.Single_Buff_List = { }
			Scl.Single_Buff_Affect_Self_List = { }
			return 0, #sg
		else
			return s.operate_selected_objects(sg, sel_hint, REASON_EFFECT, 1)(table.unpack(op_arr))
		end
	end
end
--get more return value
--//return operated count, operated group, first operated card
function s.more_returns_operate(fun1, ...)
	local ct, og, tc =  fun1(...)
	if not og then
		og = Duel.GetOperatedGroup()
		tc = og:GetFirst()
	end
	return ct, og ,tc
end
--equip the "equip_obj" as equip card to "equip_target", on "ep"'s (defualt == e's handler player) field.
--"equip_obj" can be card or group, if is a group, and there are not enough zones form all of them to equip, you will select cards witch you want to keep equip. 
--keep_face_up (default == true) == false, means equip with "equip_obj"'s current position.
--if the "equip_obj" don't have EFFECT_EQUIP_LIMIT buff, this function will auto register to it.
--this function can call Scl.AddEquipBuff to add equip buffs to the "equip_obj" 
--//return equiped count, equiped group, first equiped card
-->>eg1. Scl.Equip(tc, c)
-->>equip tc to c.
-->>eg2. Scl.Equip(g, c, 1 - tp )
-->>equip g to c, on your opponent's field.
function Scl.Equip(equip_obj, equip_target, ep, keep_face_up)
	local e, c, tp = Scl.GetCurrentEffectInfo()
	ep = ep or tp
	keep_face_up = keep_face_up or true
	local equip_group = Scl.Mix2Group(equip_obj):Filter(s.equip_filter, equip_target, tp, ep, equip_target)
	local ft = Scl.GetSZoneCount(ep)
	if #equip_group > ft then 
		Scl.SelectHint(HINTMSG_EQUIP)
		equip_group = equip_group:Select(tp, ft, ft, nil)
	end
	local success_group = Group.CreateGroup()
	for equip_card in aux.Next(equip_group) do
		if Duel.Equip(ep, equip_card, equip_target, keep_face_up, true) then 
			success_group:AddCard(equip_card)
			if not equip_card:IsHasEffect(EFFECT_EQUIP_LIMIT) then 
				local e1 = Scl.AddSingleBuff({ c, equip_card, true }, "EquipLimit", s.equip_limit)  
				e1:SetLabelObject(equip_target)
			end
		end
	end
	if #(Scl.Equip_Buff_List) > 0 then 
		for equip_card in aux.Next(success_group) do
			Scl.AddEquipBuff({ c, equip_card, true }, table.unpack(Scl.Equip_Buff_List))
		end
	end
	Duel.EquipComplete()
	return s.dummy_operate(success_group)
end
function s.equip_filter(c, tp, ep, equip_target)
	if c:IsControler(tp) and tp ~= ep and not c:IsAbleToChangeControler() then 
		return false
	end
	if c:IsType(TYPE_EQUIP) and not equip_target:CheckEquipTarget(c) then
		return false
	end
	return c:CheckUniqueOnField(equip_oppo_side and 1 - tp or tp, LOCATION_SZONE)
end
function s.equip_limit(e, c)
	return e:GetLabelObject() == c
end
--Get correctly operated group, the operated card(s) must in "zone_obj"
--//return group
-->>eg1. Scl.Banish(g, REASON_EFFECT)
-->>Scl.GetCorrectlyOperatedGroup("Banished")
-->>return the card group successfully be banished by the above function.
function Scl.GetCorrectlyOperatedGroup(zone_obj)
	return Duel.GetOperatedGroup():Filter(Scl.IsInZone, nil, zone_obj)
end
--Get correctly operated cards' count, the operated card(s) must in "zone_obj"
--//return ct
-->>eg1. Scl.Banish(g, REASON_EFFECT)
-->>Scl.GetCorrectlyOperatedCount("Banished")
-->>return the count of the cards successfully be banished by the above function.
function Scl.GetCorrectlyOperatedCount(zone_obj)
	return #(Scl.GetCorrectlyOperatedGroup(zone_obj))
end
--Check whether the last operate-function has operated the card(s) correctly (the operated card(s) must in "zone_obj)
--if you set the parama - chk_ct (default == nil), the function will do an additional check that whether the correctly operated cards's count is equal to chk_ct.
--//return bool
-->>eg1. Scl.Banish(g, REASON_EFFECT)
-->> Scl.IsCorrectlyOperated("Banished")
-->>check whether you have banished a card(s) successfully.
-->>eg2. Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
-->> Scl.IsCorrectlyOperated("Deck,Extra", 3)
-->>check whether you successfully send 3 cards to the Deck and/or Extra.
function Scl.IsCorrectlyOperated(zone_obj, chk_ct)
	local g = Scl.GetCorrectlyOperatedGroup(zone_obj)
	return (chk_ct and #g == chk_ct) or (not chk_ct and #g > 0)
end 
--Send card(s) to the Deck, and if you do, player "dp" draw "dct" count.
--params from "obj" to "reason" is same as Duel.SendtoDeck
--if need_break (default == false) == true, turn the "and if you do" to "then".
--if you send card to your Deck, 
--if you set the parama chk_ct (default == false), the function will do an additional check that whether the correctly sent cards's count is equal to chk_ct, only they are equal so that you can draw. 
--//return draw count, draw group, first draw card
-->>eg1. Scl.ShuffleIn2DeckAndDraw(g, nil, 2, REASON_EFFECT, tp, 2)
-->>shuffle obj into the Deck/Extra, and if you do, draw 2 cards.
-->>eg1. Scl.ShuffleIn2DeckAndDraw(g, nil, 2, REASON_EFFECT, tp, 2, true, 5)
-->>shuffle all 5 obj into the Deck/Extra, then, draw 2 cards.
function Scl.ShuffleIn2DeckAndDraw(obj, tp, seq, dp, dct, reason, need_break, chk_ct)
	local g = Group.CreateGroup()
	if Scl.Send2Deck(obj, tp, seq, reason) == 0 then
		return 0, g
	end
	if not Scl.IsCorrectlyOperated("Deck,Extra", chk_ct) then 
		return 0, g 
	end
	if g:IsExists(s.send_to_deck_check, 1, nil, dp) then
		Duel.ShuffleDeck(dp)
		if g:IsExists(s.send_to_deck_check, 1, nil, 1 - dp) then 
			Duel.ShuffleDeck(1 - dp)
		end
	end
	if need_break then
		Duel.BreakEffect()
	end
	return s.more_returns_operate(Duel.Draw, dp, dct, reason)
end 
function s.send_to_deck_check(c, dp)
	return c:IsInZone("Deck") and c:IsControler(dp)
end
--Operation: Destroy
--use same as Duel.Destroy 
function Scl.Destroy(card_obj, reason, loc)
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		local f = reason & REASON_REPLACE ~= 0 and Scl.IsDestructableForReplace or Card.IsDestructable
		return #sg >0 and sg:FilterCount(f, nil, Scl.Operate_Check_Effect) == #sg 
	end
	return s.more_returns_operate(Duel.Destroy, sg, reason, loc)
end
--Operation: Tribute
--use same as Duel.Release 
function Scl.Tribute(card_obj, reason)
	reason= reason or REASON_EFFECT 
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		local f = reason & REASON_EFFECT ~= 0 and Card.IsReleasableByEffect or Card.IsReleasable
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end
	if #sg <= 0 then return 0, nil end
	local f = function(c)
		return (c:IsType(TYPE_SPELL + TYPE_TRAP) and not c:IsOnField()) or c:IsLocation(LOCATION_DECK + LOCATION_EXTRA)
	end
	if sg:IsExists(f, 1, nil, LOCATION_DECK + LOCATION_EXTRA + LOCATION_HAND) then
		return s.more_returns_operate(Duel.SendtoGrave, sg, reason | REASON_RELEASE)
	else
		return s.more_returns_operate(Duel.Release, sg, reason)
	end
end
--Operation: Banish
--use same as Duel.Remove 
function Scl.Banish(card_obj, pos, reason)
	pos = pos or POS_FACEUP 
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		return #sg >0 and sg:FilterCount(Card.IsAbleToRemove, nil, Scl.Operate_Check_Player, pos, reason) == #sg
	end
	return s.more_returns_operate(Duel.Remove, sg, pos, reason)
end
--Operation: Send to hand and confirm 
--use same as Duel.SendtoHand
--if confirm (default == true) == true, means the added player should confirm the added card.
function Scl.Send2Hand(card_obj, p, reason, confirm)
	confirm = confirm or true
	local sg = Scl.Mix2Group(card_obj)
	reason= reason or REASON_EFFECT 
	if Scl.Operate_Check == 0 then
		if #sg <= 0 then return false end
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToHandAsCost or Card.IsAbleToHand 
		return sg:FilterCount(f, nil) == #sg or sg:Filter(Scl.IsInZone, nil, "Hand") == #sg
	end
	local ct, og, tc = s.more_returns_operate(Duel.SendtoHand, sg, p, reason)
	local og2 = Duel.GetOperatedGroup():Filter(Scl.IsInZone, nil, "Hand")
	if #og2 > 0 and confirm then
		for cp = 0, 1 do
			local cg = og2:Filter(Card.IsControler, nil, cp)
			if #cg > 0 then 
				Duel.ConfirmCards(1 - cp, cg)
			end
		end
	end
	return ct, og, tc
end
--Operation: Send to deck
--use same as Duel.SendtoDeck
function Scl.Send2Deck(card_obj, tp, seq, reason)
	seq = seq or 2 
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToDeckAsCost or Card.IsAbleToDeck 
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end
	return s.more_returns_operate(Duel.SendtoDeck, sg, tp, seq, reason)
end
--Operation: look and send to deck
--for to deck cost
--use same as Duel.SendtoDeck
function Scl.LookAndSend2Deck(card_obj, tp, seq, reason)
	seq = seq or 2 
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToDeckAsCost or Card.IsAbleToDeck 
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end
	Scl.Look(sg)
	return s.more_returns_operate(Duel.SendtoDeck, sg, tp, seq, reason)
end
--Operation: Send to extra
--use same as Duel.SendtoDeck
function Scl.Send2Extra(card_obj, tp, seq, reason)
	seq = seq or 2 
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToExtraAsCost or Card.IsAbleToExtra
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end
	return s.more_returns_operate(Duel.SendtoDeck, sg, tp, seq, reason)
end
--Operation: Send to main and extra as cost
--use same as Duel.SendtoDeck
function Scl.Send2DeckOrExtraAsCost(card_obj, tp, seq, reason)
	seq = seq or 2 
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToDeckOrExtraAsCost or Card.IsAbleToDeck
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end
	return s.more_returns_operate(Duel.SendtoDeck, sg, tp, seq, reason)
end
--Operation: add pendulumn to extra faceup 
--use same as Duel.SendtoExtraP
function Scl.Send2ExtraP(card_obj, tp, reason)
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then
		local f = reason & REASON_COST ~= 0 and aux.TRUE or Card.IsAbleToExtra
		return #sg >0 and sg:FilterCount(f, nil) == #sg and sg:FilterCount(Card.IsForbidden, nil) == 0
	end
	return s.more_returns_operate(Duel.SendtoDeck, sg, tp, seq, reason)
end
--Operation: Send to grave
--use same as Duel.SendtoGrave
function Scl.Send2Grave(card_obj, reason)
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		local f 
		if reason & REASON_RETURN ~= 0 then return sg:FilterCount(Scl.IsInZone, nil, LOCATION_REMOVED) == #sg end
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToGraveAsCost or Card.IsAbleToGrave
		return #sg >0 and sg:FilterCount(f, nil) == #sg 
	end
	return s.more_returns_operate(Duel.SendtoGrave, sg, reason)
end
--Discard card, using in scl.list_format_cost_or_target_or_operation 
--selected_obj : { [0] = player 0's min count, [1] = player 1's min count, [2] = player 0's max count, [3] = player 1's max count } 
--//return discarded count, discarded group, first discarded card
function s.discard_hand_special(selected_obj, reason)
	if Scl.Operate_Check == 0 then 
		for p = 0, 1 do 
			if not Duel.IsPlayerCanDraw(p, selected_obj[p]) then 
				return false 
			end 
		end
		return true 
	end
	local og = Group.CreateGroup()
	local ct = 0
	for p = 0, 1 do 
		ct = ct + Duel.DiscardHand(p, aux.TRUE, selected_obj[p], selected_obj[p + 2], reason, nil)
		og:Merge(Duel.GetOperatedGroup())
	end
	return ct, og, og:GetFirst()
end
--draw, using in scl.list_format_cost_or_target_or_operation 
--selected_obj : { [0] = player 0's min count, [1] = player 1's min count, [2] = player 0's max count, [3] = player 1's max count }
function s.draw_special(selected_obj, reason)
	if Scl.Operate_Check == 0 then 
		for p = 0, 1 do 
			if not Duel.IsPlayerCanDraw(p, selected_obj[p]) then 
				return false 
			end
		end
		return true 
	end
	local ct = 0
	local og = Group.CreateGroup()
	for p = 0, 1 do 
		local minct = selected_obj[p]
		local maxct = selected_obj[p + 2]
		local dct = minct
		if maxct < minct then return nil, 0 end 
		if maxct > minct then 
			local ct_list = { }
			for i = minct, maxct do 
				if Duel.IsPlayerCanDraw(p, i) then
					table.insert(ct_list, i)
				end
			end
			Scl.SelectHint(p, HINTMSG_OPERATE_COUNT_SCL)
			dct = Duel.AnnounceNumber(p, table.unpack(ct_list))
		end
		if dct > 0 then
			ct = ct + Duel.Draw(p, dct, reason)
		end 
		og:Merge(Duel.GetOperatedGroup())
	end
	return ct, og, og:GetFirst()
end
--send deck top to graveyard, using in scl.list_format_cost_or_target_or_operation 
--selected_obj : { [0] = player 0's min count, [1] = player 1's min count, [2] = player 0's max count, [3] = player 1's max count } 
function s.discard_deck_special(selected_obj, reason)
	if Scl.Operate_Check == 0 then 
		for p = 0, 1 do 
			if reason == REASON_COST and not Duel.IsPlayerCanDiscardDeckAsCost(p, selected_obj[p]) then 
				return false 
			end 
			if reason ~= REASON_COST and not Duel.IsPlayerCanDiscardDeck(p, selected_obj[p]) then 
				return false 
			end 
		end
		return true 
	end
	local og = Group.CreateGroup()
	local ct = 0
	for p = 0, 1 do 
		local minct = selected_obj[p]
		local maxct = selected_obj[p + 2]
		local dct = minct
		if maxct < minct then return nil, 0 end 
		if maxct > minct then 
			local ct_list = { }
			for i = minct, maxct do 
				if ( reason == REASON_COST and Duel.IsPlayerCanDiscardDeckAsCost(p, i) ) 
					or ( reason ~= REASON_COST and Duel.IsPlayerCanDiscardDeck(p, i) ) then
					table.insert(ct_list, i)
				end
			end
			Scl.SelectHint(p, HINTMSG_OPERATE_COUNT_SCL)
			dct = Duel.AnnounceNumber(p, table.unpack(ct_list))
		end
		if dct > 0 then
			ct = ct + Duel.DiscardDeck(p, dct, reason)
			og:Merge(Duel.GetOperatedGroup())
		end 
	end
	return ct, og, og:GetFirst()
end
--Operation: Change position
--use same as Duel.ChangePosition
function Scl.ChangePosition(card_obj, p1, p2, p3, p4, ...)
	local sg = Scl.Mix2Group(card_obj)
	local f
	if Scl.Operate_Check == 0 then 
		if not p2 then 
			if p1 == POS_FACEDOWN_DEFENSE then 
				f = Card.IsCanTurnSet 
			elseif p1 == POS_FACEUP_ATTACK then
				f = aux.AND(Card.IsCanChangePosition, Card.IsDefensePos)
			elseif p1 == POS_FACEUP_DEFENSE then
				f = aux.AND(Card.IsCanChangePosition, aux.OR(Card.IsAttackPos, Card.IsFacedown))
			elseif p1 == POS_DEFENSE then
				f = aux.OR(Card.IsCanTurnSet, aux.AND(Card.IsCanChangePosition, aux.OR(Card.IsFacedown, Card.IsAttackPos)))
			end
		else
			f = Card.IsCanChangePosition
		end
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end 
	if p1 == POS_DEFENSE then 
		local pos = 0
		local ct, og = 0, Group.CreateGroup()
		local ct2, og2
		for tc in aux.Next(sg) do 
			if tc:IsCanTurnSet() then pos = pos | POS_FACEDOWN_DEFENSE end
			if tc:IsCanChangePosition() and (tc:IsAttackPos() or tc:IsFacedown()) then 
				pos = pos | POS_FACEUP_DEFENSE 
			end
			pos = Duel.SelectPosition(tp, tc, pos)
			ct2, og2 = s.more_returns_operate(Duel.ChangePosition, tc, pos)
			ct = ct + ct2 
			og:Merge(og2)
		end
		return ct, og, og:GetFirst()
	elseif p2 then
		return s.more_returns_operate(Duel.ChangePosition, sg, p1, p2, p3, p4, ...)
	else
		return s.more_returns_operate(Duel.ChangePosition, sg, p1, p1, p1, p1, ...)
	end
end
--Operation: Get control
--use same as Duel.GetControl
function Scl.GetControl(card_obj, p, rst_ph, rst_tct, zone)
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		return #sg >0 and sg:FilterCount(Card.IsControlerCanBeChanged, nil, false, zone) == #sg
	end 
	return s.more_returns_operate(Duel.GetControl, sg, p, rst_ph, rst_tct, zone)
end
--Operation : look "card_obj"
--//return look count, look group, first look card
function Scl.Look(card_obj)
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then  
		return sg:FilterCount(Card.IsPublic, nil) == 0
	end 
	local cg
	local f = function(c, tp)
		return c:IsControler(tp) and c:IsLocation(LOCATION_HAND)
	end
	for p = 0, 1 do
		cg = sg:Filter(f, nil, p)
		if #cg > 0 then
			Duel.ConfirmCards(1 - p, cg)
			Duel.ShuffleHand(p)
		end
	end
	return #sg, sg, sg:GetFirst()
end
--Operation : reveal "card_obj", until "rst_arr" (default == RESETS_SCL )
--//return revealed count, revealed group, first revealed card
-->>eg1. Scl.RevealCards(g, RESETS_SCL)
function Scl.RevealCards(card_obj, rst_obj)
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then  
		return sg:FilterCount(Card.IsPublic, nil) == 0
	end
	local _, c = Scl.GetCurrentEffectInfo()
	for tc in aux.Next(sg) do
		local e1 = Scl.AddSingleBuff({ c, tc, true }, "Reveal", true, "Reset", rst_obj or RESETS_SCL)
	end
	return #sg, sg, sg:GetFirst()
end
--Operation: MoveToField
--use nearly same as Duel.MoveToField, but switch the sequence of the format "card_obj" and "movep", and can do operation on a group.
--if you want to place to field zone, and there is a card currently in the field zone, this function will first send that card to GY.
--//return placed count, placed group, first placed card
function Scl.Place2Field(card_obj, movep, targetp, zone, pos, enable, lim_zone)
	local g = Scl.Mix2Group(card_obj)
	local zone2 = Scl.GetNumFormatZone(zone)
	if Scl.Operate_Check == 0 then 
		return g:FilterCount(Card.IsForbidden, nil) == 0 and Duel.GetLocationCount(targetp, zone2, movep, LOCATION_REASON_TOFIELD, lim_zone) >= #g
	end
	if #g <= 0 then return 0, nil end
	local correctg = Group.CreateGroup()
	for tc in aux.Next(g) do 
		local fc = Duel.GetFieldCard(targetp, LOCATION_FZONE, 0)
		if fc and zone2 == LOCATION_FZONE then
			Duel.SendtoGrave(fc, REASON_RULE)
			Duel.BreakEffect()
		end
		local bool = false
		if lim_zone then
			bool = Duel.MoveToField(tc, movep, targetp, zone2, pos, enable, lim_zone)
		else
			bool = Duel.MoveToField(tc, movep, targetp, zone2, pos, enable)
		end
		if bool then
			correctg:AddCard(tc)
		end
	end
	local facedowng = correctg:Filter(Card.IsFacedown, nil)
	if #facedowng > 0 and targetp == movep then
		Duel.ConfirmCards(1 - targetp, facedowng)
	end
	return #correctg, correctg, correctg:GetFirst()
end
--Operation: activate "tc" to field.
--if you want to activate a field spell, and there is a card currently in the field zone, this function will first send that card to GY, and will raise an event for "Ancient Pixie Dragon" after activated.
--it will do the cost of the activated effect
--if apply_effect == true (default == false), it will do the target and operation of the activated effect.
--//return activated count, activated group, first activated card
-->>eg1. Scl.ActivateSepllOrTrap(tc, tp)
-->>activate tc, not apply effect.
-->>eg2. Scl.ActivateSepllOrTrap(tc, 1 - tp, true)
-->>your opponent activate tc and apply its effect immediately.
function Scl.ActivateSepllOrTrap(tc, actp, apply_effect, lim_zone)
	if aux.GetValueType(tc) == "Group" then
		tc = tc:GetFirst()
	end
	local zone = LOCATION_SZONE
	if tc:IsType(TYPE_FIELD) then
		zone = LOCATION_FZONE 
	elseif tc:IsType(TYPE_PENDULUM) then
		zone = LOCATION_PZONE
	end
	if Scl.Operate_Check == 0 then 
		return tc and tc:GetActivateEffect() and tc:GetActivateEffect():IsActivatable(actp,true,true) 
	end
	if not tc then 
		return 0 
	end
	local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
	if fc and zone == LOCATION_FZONE then
		Duel.SendtoGrave(fc, REASON_RULE)
		Duel.BreakEffect()
	end
	local bool = false
	if lim_zone then 
		bool = Duel.MoveToField(tc, actp, actp, zone, POS_FACEUP, true, lim_zone)
	else
		bool = Duel.MoveToField(tc, actp, actp, zone, POS_FACEUP, true)
	end
	if bool then
		local te, ceg, cep, cev, cre, cr, crp = tc:CheckActivateEffect(false, false, true)
		if te then
			te:UseCountLimit(tp, 1, true)
			local tep = tc:GetControler()
			local cost = te:GetCost() or aux.TRUE
			cost(te, actp, ceg, cep, cev, cre, cr, crp, 1)
		end
		if apply_effect then
			local tg = te:GetTarget() or aux.TRUE
			local op = te:GetOperation() or aux.TRUE
			tg(te, actp, ceg, cep, cev, cre, cr, crp, 1)
			op(te, actp, ceg, cep, cev, cre, cr, crp)		   
		end
		if zone == LOCATION_FZONE then
			Duel.RaiseEvent(tc, 4179255, te, 0, tp, tp, Duel.GetCurrentChain())
		end
		
		return 1, Group.FromCards(tc), tc
	end
	return 0
end
--Operation: Return the temporary banished "card_obj" to "zone"(default == 0x1f), in "pos" position (default == previous position)
--if the returned player's zone count is less than his returned monster count, that player must pick a number of monsters from "card_obj" to return to his field, equal to his zone count.
--//return returned count, returned group, first returned card
-->>eg1. Scl.Return2Field(g)
-->>return the temporary banished cards from g to their owner's field.
-->>eg2. Scl.Return2Field(tc, POS_FACEUP_ATTACK, 0x1)
-->>return the temporary banished card tc to it's owner's field (zone number 0x1), in attack position.
function Scl.Return2Field(card_obj, pos, zone)
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		return # sg > 0
	end
	local rg,rg2,ft = Group.CreateGroup(), Group.CreateGroup(), 0
	for p = 0, 1 do
		rg = sg:Filter(aux.FilterEqualFunction(Card.GetPreviousControler, p), nil)
		if #rg > 0 then
			ft = Duel.GetLocationCount(p, LOCATION_MZONE, p, LOCATION_REASON_TOFIELD, zone or 0x1f)
			rg2 = rg:Clone()
			if #rg2 > ft then
				rg2 = rg:Select(p, ft, ft, nil)
			end
			rg:Sub(rg2)
			for tc in aux.Next(rg2) do 
				Duel.ReturnToField(tc, pos or tc:GetPreviousPosition(), zone or 0x1f)
			end
			for tc in aux.Next(rg) do
				Duel.ReturnToField(tc, pos or tc:GetPreviousPosition())
			end
		end
	end
	return #rg, rg, rg:GetFirst()
end
--Operation: SSet
--use nearly same as Due.SSet, but switch the sequence of the prama "card_obj" and "sp"
--return set count, set group, first set card
function Scl.SetSpellOrTrap(card_obj, sp, tp, confirm) 
	if type(confirm) == "nil" then confirm = true end
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then 
		if tp == Scl.Operate_Check_Player then
			return #sg > 0 and sg:FilterCount(Card.IsSSetable, nil) == #sg
		else
			return #sg > 0 and sg:FilterCount(Card.IsSSetable, nil, true) == #sg and Duel.GetSZoneCount(tp) >= #sg
		end
	end
	if not sp then
		local _, _, p = Scl.GetCurrentEffectInfo()
		sp = p
	end
	tp = tp or sp
	return s.more_returns_operate(Duel.SSet, sp, sg, tp, confirm)
end
--Operation: Set any card(s)
--to spell and trap, use Duel.SSet, to monster, special summon them in facedown defense position 
--Bug in set extra deck monsters
--return set count, set group, first set card
function Scl.SetCards(card_obj, sp, tp, confirm) 
	local e, _, p = Scl.GetCurrentEffectInfo()
	sp = sp or p
	tp = tp or sp
	if type(confirm) == "nil" then 
		confirm = true 
	end
	local sg = Scl.Mix2Group(card_obj)
	local mg = sg:Clone()
	local stg = sg:Filter(Card.IsSSetable, nil, true)
	mg:Sub(stg)
	mg = mg:Filter(Card.IsCanBeSpecialSummoned, nil, e, 0, sp, false, false, POS_FACEDOWN_DEFENSE, tp)
	local sft = Scl.GetSZoneCount(tp, nil, sp)
	local mft = Scl.GetMZoneCount4Summoning(tp, nil, sp)
	if Scl.Operate_Check == 0 then 
		return #stg + #mg == #sg and stg <= sft and #mg <= mft
	end
	local ct, og = 0, Group.CreateGroup()
	if #stg > sft then 
		Scl.SelectHint(sp, HINTMSG_SET)
		sg = stg:Select(sp, sft, sft, nil)
	end
	if #sg > 0 then 
		local ct2, og2 = s.more_returns_operate(Duel.SSet, sp, sg, tp, false)
		ct = ct + ct2
		og:Merge(og2)
	end
	if #mg > mft then 
		Scl.SelectHint(sp, HINTMSG_SET)
		sg = mg:Select(sp, mft, mft, nil)
	end
	if #sg > 0 then 
		local ct2, og2 = s.more_returns_operate(Duel.SpecialSummon, sg, 0, sp, tp, false, false, POS_FACEDOWN_DEFENSE)
		ct = ct + ct2
		og:Merge(og2)
	end
	if confirm and #og > 0 then 
		Duel.ConfirmCards(1-tp, og)
	end
	return ct, og, og:GetFirst()
end
function s.set_filter(c, sp, tp)
	c:IsSSetable()
end
--Operation: negate the effects of "card_obj".
--if force (default == false) == true, means ignore effect immune of "card_obj".
--reset default == RESETS_SCL
--//return negated cards count, negated group, first negated card, effect "EFFECT_DISABLE_EFFECT", effect "EFFECT_DISABLE", effect "EFFECT_DISABLE_TRAPMONSTER"
-->>eg1. Scl.NegateCardEffects(tc)
-->>negate tc's effects.
-->>eg2. Scl.NegateCardEffects(g, nil, RESETS_EP_SCL)
-->>negate effects of the cards in g, until end phase
function Scl.NegateCardEffects(card_obj, force, reset)
	local e, neg_owner = Scl.GetCurrentEffectInfo()
	force = force or false
	reset = reset or RESETS_SCL
	local sg = Scl.Mix2Group(card_obj)
	local dg = Group.CreateGroup()
	if Scl.Operate_Check == 0 then 
		return #sg > 0 and sg:FilterCount(aux.NegateAnyFilter, nil) == #sg
	end 
	for tc in aux.Next(sg) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1,e2 = Scl.AddSingleBuff({neg_owner, tc, force}, "NegateEffect,NegateActivatedEffect", 1, "Reset", reset)
		if not force then
			e2:SetValue(RESET_TURN_SET)
		end
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3 = Scl.AddSingleBuff({neg_owner, tc, force}, "NegateTrapMonster", 1, "Reset", reset)
		end
		if force or not tc:IsImmuneToEffect(e) then 
			dg:AddCard(tc)
		end
	end
	return #dg, dg, dg:GetFirst(), e1, e2, e3
end
--Operation: dummy operation
function s.dummy_operate(card_obj)
	local sg = Scl.Mix2Group(card_obj)
	if Scl.Operate_Check == 0 then
		return #sg > 0 
	end
	return #sg, sg, sg:GetFirst()
end
--Operation: sort "card_obj"'s sequence in deck.
--if seq == 0, means place to the deck top in any order, == 1 means place to the deck bottom in any order.
--confirm (default == false) == true means confirm "card_obj" before sort their sequence.
--//return the sort count, sort group, first sort card
-->>eg1. Scl.PlaceOnDeckTopOrBottom(g, 0)
-->>place cards in g to the top of your deck in any order
function Scl.PlaceOnDeckTopOrBottom(card_obj, seq, confirm)
	local g = Scl.Mix2Group(card_obj)   
	if Scl.Operate_Check == 0 then 
		return #g > 0
	end
	local p = g:GetFirst():GetControler()
	if confirm then
		Duel.ConfirmCards(1 - p, g)
	end
	Duel.ShuffleDeck(p)
	for tc in aux.Next(g) do
		Duel.MoveSequence(tc, 0)
	end
	if #g > 1 then
		Duel.SortDecktop(p, p, #g)
	end
	if seq == 1 then
		for i=1, #g do
			local mg=Duel.GetDecktopGroup(p, 1)
			Duel.MoveSequence(mg:GetFirst(), 1)
		end
	end
	return #g, g, g:GetFirst()
end
--Operation: attach obj as xyz materials to the xyz monster "xyzc".
--if set_sum_mat (default == false) == true, means set the attached cards as "xyzc"'s xyz summon material.
--if ex_over (default == false) == true, means transfer the xyz materials attached on the obj's cards to xyz monster "xyzc" too (otherwise will send them to GY)
--//return attached count, attached group, first attached card.
-->>eg1. Scl.AttachAsXyzMaterial(c, xyzc)
-->>attach c to xyzc as material
-->>eg1. Scl.AttachAsXyzMaterial(g, xyzc, true, true)
-->>attach g to xyzc as material, and set g as xyzc's xyz summon materials, transfer xyz materials attached on the cards in g to xyzc as xyz material too.
function Scl.AttachAsXyzMaterial(obj, xyzc, set_sum_mat, ex_over)
	local e = Scl.GetCurrentEffectInfo()
	local g = Scl.Mix2Group(obj):Filter(s.attach_xyz_material_filter, nil, e)
	if not xyzc or not xyzc:IsType(TYPE_XYZ) or #g <= 0 then 
		return 0, nil 
	end
	local tg = Group.CreateGroup()
	for tc in aux.Next(g) do
		tg:Merge(tc:GetOverlayGroup())
	end
	if #tg > 0 then
		if ex_over then
			Duel.Overlay(xyzc, tg)
		else
			Duel.SendtoGrave(tg, REASON_RULE) 
		end
	end
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) and (tc:IsOnField() or tc:IsStatus(STATUS_ACTIVATE_DISABLED)) then
			tc:CancelToGrave()
		end
	end
	if set_sum_mat then
		xyzc:SetMaterial(g)
	end
	Duel.Overlay(xyzc, g)
	return #g, g, g:GetFirst()
end
function s.attach_xyz_material_filter(c, e)
	if not e then return c:IsCanOverlay() 
	else
		return not c:IsImmuneToEffect(e) and c:IsCanOverlay(e:GetHandlerPlayer())
	end
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Zone <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Get player "tp"'s pendulumn zone count after leave_obj leave the field.
--//return zone count
function Scl.GetPZoneCount(tp, leave_obj)
	local ft = 0
	if Duel.CheckLocation(tp, LOCATION_PZONE, 0) then ft = ft + 1 end
	if Duel.CheckLocation(tp, LOCATION_PZONE, 1) then ft = ft + 1 end
	local g = Scl.Mix2Group(leave_obj)
	for tc in aux.Next(g) do
		if tc:IsControler(tp) and tc:IsLocation(LOCATION_SZONE) and tc:IsType(TYPE_PENDULUM) then
			ft = ft + 1 
		end
	end
	return ft
end 
--get the cout of the zone in player "p1"'s field, for summoning card "c", after "leave_obj" leaves the field
--combine the "Duel.GetMZoneCount" and "Duel.GetLocationCountFromEx" as this 1 function, so paramas same to that 2 functions.
--//return zone count
function Scl.GetMZoneCount4Summoning(p1, leave_obj, p2, c, zone)
	p2 = p2 or p1
	zone = zone or 0xff
	if (aux.GetValueType(c) == "Card" and c:IsLocation(LOCATION_EXTRA)) or type(c) == "number" then 
		return Duel.GetLocationCountFromEx(p1, p2, leave_obj, c, zone)
	else
		return Duel.GetMZoneCount(p1, leave_obj, p2, LOCATION_REASON_TOFIELD, zone)
	end
end
--zone filter: get summonable zone combine for multiple monsters
--if you want to summon several monsters by one effect, and the zone check of those monsters is chaos (like special summon Main Deck monsters and Extra monsters at the same time), you can use this function to check zone count (if not chaos, use Duel.GetMZoneCount/Duel.GetLocationCountFromEx ... directly).
--after "leave_obj" leaves the field, player p1 wants to special summon "m1" to "zone1" in player "p2"'s field, and wants to special summon "m2" to "zone2" in player "p2"'s field, ...
--check if there is a usable summon zone's combination that can special summon all the monsters and return the monster "m1"'s usable zone count, then you can easily special summon "m1" to those zones. And for the left monsters, you can use this function once more, until all monsters is checked.
--in fact, "Duel.SpecialSummon" is automatic has functions of this function, so that, for some effects that special summon monsters at a same timing (like "Supreme Rage"), you only need to call this function to check whether you have enough zones to speical summon them, then you only need to call Duel.SpecialSummon and let that function to select corresponding zones, you have no need to call this function several times to check and special summon each monster in step.
--like "Chaos Alchemy" cards (Scl's custom cards), they special summon 2 monsters in one effect but different timing, you cannot use "Duel.SpecialSummon" to simply the check and special summon processes, you must use this function to pick monsters that can be special summoned, and before they speical summon in effect's operation, you also need to use this function to get each monster's usable summon zones, then call "Duel.SpecialSummon" to each monster.
--but in fact, you only need to use this function to check each until to the penultimate monster's summon zones, you can use "Duel.SpecialSummon" to the last monster to simplify the processes.
--//return combine zone for monster "m1"
function Scl.GetMZoneCombine4SummoningFirstMonster(p1, leave_obj, p2, m1, zone1, m2, zone2, ... )
	local combine = 0
	local usable_zarr =  Scl.SplitNumber2PowerOf2(zone1)
	for _, usable_z in pairs(usable_zarr) do
		if Scl.GetMZoneCount4Summoning(p1, leave_obj, p2, m1, usable_z) > 0 and 
			s.get_monster_zone_combine_for_multiple_monsters(p1, leave_obj, p2, usable_z, m2, zone2, ...) then
			combine = combine | usable_z
		end
	end
	return combine
end
function s.get_monster_zone_combine_for_multiple_monsters(p1, leave_obj, p2, used_z, m2, zone2, m3, zone3, ...)
	local used_z2 = used_z
	if not m2 then 
		return true 
	end
	local usable_zarr =  Scl.SplitNumber2PowerOf2(zone2 - (zone2 & used_z2))
	if #usable_zarr == 0 then 
		return false 
	end
	for _, usable_z in pairs(usable_zarr) do
		local used_z3 = used_z2 | usable_z
		if Scl.GetMZoneCount4Summoning(p1, leave_obj, p2, m2, usable_z) > 0 and 
			s.get_monster_zone_combine_for_multiple_monsters(p1, leave_obj, p2, used_z3, m3, zone3, ...) then
			return true
		end
	end
	return false
end
--Get player p1's spell&trap zone count (limit by "zone"), that used by player "p2", after "leave_obj" leave the field.
--//return count, useless zone 
function Scl.GetSZoneCount(p1, leave_obj, p2, zone)
	zone = zone or 0x1f
	local ct, useless_zone = Duel.GetLocationCount(p1, LOCATION_SZONE, p2, LOCATION_REASON_TOFIELD, zone)
	local g = Scl.Mix2Group(leave_obj)
	local eg, zone2
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_MZONE) then
			eg = tc:GetEquipGroup() 
			for ec in aux.Next(eg) do 
				zone2 = aux.SequenceToGlobal(p1, LOCATION_SZONE, ec:GetSequence()) / 0x100
				if ec:IsLocation(LOCATION_SZONE) and ec:IsControler(p1) and zone2 & zone > 0 then
					ct = ct + 1
				else
					useless_zone = useless_zone | zone2
				end
			end
		elseif tc:IsLocation(LOCATION_SZONE) then 
			zone2 = aux.SequenceToGlobal(p1, LOCATION_SZONE, tc:GetSequence()) / 0x100
			if tc:GetSequence() < 5 and zone2 & zone > 0 then
				ct = ct + 1
			else
				useless_zone = useless_zone | zone2
			end
		end
	end
	return ct, useless_zone
end
--Get surrounding zone (up, down, left & right zone)
--obj: can be card or group, or zone index (if you want to transfer zone index, you can use aux.SequenceToGlobal to get that zone index).
--lim_zone_obj (defult == "OnField"): can be "OnField", "MonsterZone" or "Spell&TrapZone", means get which kind of surrounding zones.
--tp: use this player's camera to see the zone index
--contain_self (default == false): include itself's zone (mid)
--//return zones
-->>eg1. Scl.GetSurroundingZone(c, "OnField", tp, true)
-->>get zones that surround to card c on the field, include c's zone.
-->>eg2. Scl.GetSurroundingZone(0x100, "MonsterZone", tp)
-->>get monster zones that surround to the zone "0x100"
function s.switch_zone_camera(base_zone, tp)
	local _, _, p = Scl.GetCurrentEffectInfo()
	if tp == p then
		return base_zone
	end
	local zone_arr = Scl.SplitNumber2PowerOf2(base_zone)
	local zone = 0
	for _, sgl_zone in pairs(zone_arr) do
		if sgl_zone >= 0x10000 then
			zone = zone | (sgl_zone / 0x10000)
		else
			zone = zone | (sgl_zone * 0x10000)
		end
	end
	return zone
end
function Scl.GetSurroundingZone(obj, lim_zone_obj, tp, contain_self)
	local zone_arr = { }
	if aux.GetValueType(obj) == "Card" or aux.GetValueType(obj) == "Group" then 
		local g = Scl.Mix2Group(obj):Filter(Scl.IsInZone, nil, "OnField")
		for tc in aux.Next(g) do
			table.insert(zone_arr, aux.SequenceToGlobal(tc:GetControler(), tc:GetLocation(), tc:GetSequence()))
		end
	elseif type(obj) == "number" then
		zone_arr = Scl.SplitNumber2PowerOf2(obj)	
	end
	local srd_zone = 0
	for idx, zone in pairs(zone_arr) do
		local bool, idx2 = Scl.IsArrayContains_Single(Scl.Zone_Map, zone)
		if zone > 0 and bool then
			--up 
			srd_zone = srd_zone | Scl.Zone_Map[idx2 - 13]
			--down
			srd_zone = srd_zone | Scl.Zone_Map[idx2 + 13]
			--left
			srd_zone = srd_zone | Scl.Zone_Map[idx2 - 1]
			--right
			srd_zone = srd_zone | Scl.Zone_Map[idx2 + 1]
			--mid
			if contain_self then
				srd_zone = srd_zone | zone
			end
		end
	end 
	--ex monster zone 
	local ex_arr = { 0x20, 0x40, 0x200000, 0x400000 }
	local ex_arr2 = { 0x400000, 0x200000, 0x40, 0x20 }
	for idx, ex_zone in pairs(ex_arr) do
		if srd_zone & ex_zone ~= 0 then
			srd_zone = srd_zone | ex_arr2[idx]
		end
	end
	local lim_zone = Scl.GetNumFormatZone(lim_zone_obj)
	if lim_zone == LOCATION_SZONE then 
		srd_zone = srd_zone & (0x1f001f00)
	end
	if lim_zone == LOCATION_MZONE then 
		srd_zone = srd_zone & (0x7f007f)
	end
	if tp then
		srd_zone = s.switch_zone_camera(srd_zone, tp)
	end
	return srd_zone
end
--Get pervious surrounding zone (up, down, left & right zone)
--paramas see Scl.GetSurroundingZone
--//return zone
function Scl.GetPreviousSurroundingZone(obj, lim_zone_obj, tp, contain_self)
	local g = Scl.Mix2Group(obj):Filter(Scl.IsPreviouslyInZone, nil, "OnField")
	local zone = 0
	for tc in aux.Next(g) do
		zone = zone | aux.SequenceToGlobal(tc:GetPreviousControler(), tc:GetPreviousLocation(), tc:GetPreviousSequence())
	end
	return Scl.GetSurroundingZone(zone, lim_zone_obj, tp, contain_self)
end
--Get adjacent zone (left & right zone)
--obj: can be card or group, or zone index (if you want to transfer zone index, you can use aux.SequenceToGlobal to get that zone index).
--lim_zone_obj (defult == "OnField"): can be "OnField", "MonsterZone" or "Spell&TrapZone", means get which kind of adjacent zones.
--tp: use this player's camera to see the zone index
--contain_self (default == false): include itself's zone (mid)
--//return zones
-->>eg1. Scl.GetAdjacentZone(c, "OnField", tp, true)
-->>get zones that adjacent to card c on the field, include c's zone.
-->>eg2. Scl.GetAdjacentZone(0x100, "MonsterZone", tp)
-->>get monster zones that adjacent to the zone "0x100"
function Scl.GetAdjacentZone(obj, lim_zone_obj, tp, contain_self)
	local zone_arr = { }
	if aux.GetValueType(obj) == "Card" or aux.GetValueType(obj) == "Group" then 
		local g = Scl.Mix2Group(obj):Filter(Scl.IsInZone, nil, "OnField")
		for tc in aux.Next(g) do
			table.insert(zone_arr, aux.SequenceToGlobal(tc:GetControler(), tc:GetLocation(), tc:GetSequence()))
		end
	elseif type(obj) == "number" then
		zone_arr = Scl.SplitNumber2PowerOf2(obj)
	end
	local ajt_zone = 0
	for idx, zone in pairs(zone_arr) do
		local bool, idx2 = Scl.IsArrayContains_Single(Scl.Zone_Map, zone)
		if zone > 0 and bool then
			--left
			ajt_zone = ajt_zone | Scl.Zone_Map[idx2 - 1]
			--right
			ajt_zone = ajt_zone | Scl.Zone_Map[idx2 + 1]
			--mid
			if contain_self then
				ajt_zone = ajt_zone | zone
			end
		end
	end
	local lim_zone = Scl.GetNumFormatZone(lim_zone_obj)
	if lim_zone == LOCATION_SZONE then 
		ajt_zone = ajt_zone & (0x1f001f00)
	end
	if lim_zone == LOCATION_MZONE then 
		ajt_zone = ajt_zone & (0x7f007f)
	end
	ajt_zone = s.switch_zone_camera(ajt_zone, tp)
	return ajt_zone
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Card&Group<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Get the xyz materials attach on the obj before obj leaves the field.
--//return xyz materials group
function Scl.GetPreviousXyzMaterials(obj)
	local g = Scl.Mix2Group(obj)
	local og = Group.CreateGroup()
	for tc in aux.Next(g) do
		if Scl.Previous_Xyz_Material_List[tc] then
			og:Merge(Scl.Previous_Xyz_Material_List[tc])
		end
	end
	return og
end
function s.previous_xyz_material_record()
	local ge1 = Scl.SetGlobalFieldTriggerEffect(0, EVENT_LEAVE_FIELD_P, FLAG_PREVIOUS_XYZ_MATERIAL_SCL, nil, s.previous_xyz_material_record_operation)
end
function s.previous_xyz_material_record_operation(e,tp,eg)
	local rg = eg:Filter(Card.IsType, nil, TYPE_XYZ)
	for tc in aux.Next(rg) do 
		Scl.Previous_Xyz_Material_List[tc] = Scl.Previous_Xyz_Material_List[tc] or Group.CreateGroup()
		Scl.Previous_Xyz_Material_List[tc]:KeepAlive()
		local mat = tc:GetOverlayGroup()
		Scl.Previous_Xyz_Material_List[tc]:Merge(mat)
	end
end
--Get cards surround to obj (up, down, left & right zone)
--obj: can be card or group, or zone index (if you want to transfer zone index, you can use aux.SequenceToGlobal to get that zone index).
--contains (default = false): Include itself (mid)
--//return group
-->>eg1. Scl.GetSurroundingGroup(c, true)
-->>return cards surround to card c, include c self.
-->>eg2. Scl.GetSurroundingGroup(0x1000)
-->>return cards surround to zone 0x1000
function Scl.GetSurroundingGroup(obj, contains)
	local srd_zone = Scl.GetSurroundingZone(obj, "OnField", nil, contains)
	return Duel.GetMatchingGroup(s.get_matching_zone_group_filter, 0, LOCATION_ONFIELD, LOCATION_ONFIELD, nil, srd_zone)
end
function s.get_matching_zone_group_filter(c, srd_zone)
	local zone = aux.SequenceToGlobal(c:GetControler(), c:IsOnField() and c:GetLocation() or c:GetPreviousLocation(), c:IsOnField() and c:GetSequence() or c:GetPreviousSequence())
	return zone & srd_zone == zone
end
--Get cards surround to obj while obj is leaves the field (up, down, left & right zone)
--paramas see Scl.GetSurroundingGroup
--//return group
function Scl.GetPreviousSurroundingGroup(obj, contains)
	local srd_zone = Scl.GetPreviousSurroundingZone(obj, "OnField", nil, contains)
	return Duel.GetMatchingGroup(s.get_matching_zone_group_filter, 0, LOCATION_ONFIELD, LOCATION_ONFIELD, nil, srd_zone)
end
--Get cards adjacent to obj (left & right zone)
--obj: can be card or group, or zone index (if you want to transfer zone index, you can use aux.SequenceToGlobal to get that zone index).
--contains (default = false): Include itself (mid)
--//return group
-->>eg1. Scl.GetAdjacentGroup(c, true)
-->>return cards adjacent to card c, include c self.
-->>eg2. Scl.GetAdjacentGroup(0x1000)
-->>return cards adjacent to zone 0x1000
function Scl.GetAdjacentGroup(obj, contains)
	local ajt_zone = Scl.GetAdjacentZone(obj, "OnField", nil, contains)
	return Duel.GetMatchingGroup(s.get_matching_zone_group_filter, 0, LOCATION_ONFIELD, LOCATION_ONFIELD, nil, ajt_zone)
end 
--Mix cards or groups into a new group.
--the ... format: can be card, group, or table contains card or group.
--//return the mixed group.
-->>eg1. Scl.Mix2Group(c, tc1, tc2)
-->>return a group contains c, tc1 and tc2, that group's length
-->>eg2. Scl.Mix2Group(c, g1)
-->>return a group contains c and group g1's card(s), that group's length
function Scl.Mix2Group(...)
	local g = Group.CreateGroup()
	for _, obj in pairs({ ... }) do
		local typ = aux.GetValueType(obj)
		if typ == "Card" then 
			g:AddCard(obj)
		elseif typ == "Group" then
			g:Merge(obj)
		elseif typ == "table" then
			for _, obj2 in pairs(obj) do 
				local typ2 = aux.GetValueType(obj2)
				if typ2 == "Card" then 
					g:AddCard(obj2)
				elseif typ2 == "Group" then
					g:Merge(obj2)
				end
			end
		end
	end
	return g, #g
end
--Mix cards or groups into the base_g group.
--the ... format: see Scl.Mix2Group(...)
-->>eg1. Scl.MixIn2Group(g, tc1, tc2)
-->>g = g + tc1 + tc2 
-->>eg1. Scl.MixIn2Group(g, g2, tc)
-->>g = g + g2 + tc 
function Scl.MixIn2Group(base_g, ...)
	base_g:Merge(Scl.Mix2Group(...))
end
--local s and id set "inside_series_str" as the inside series for this "s".
--inside_series_str can be "ABCD", "AB,CD", "AB_CD", "AB_CD,EF" ...
--//return s, id
-->>eg1. Scl.SetID(114514)
-->>eg2. Scl.SetID(114514, "Scl_XCard")
function Scl.SetID(code, inside_series_str)
	if not _G["c"..code] then _G["c"..code] = { }
		setmetatable(_G["c"..code], Card)
		_G["c"..code].__index = _G["c"..code]
	end
	local ccodem = _G["c"..code]   
	if inside_series_str and not ccodem.scl_inside_series then
		local series_arr = { }
		local arr = Scl.SplitString(inside_series_str)
		for _, str in pairs(arr) do 
			local arr2 = Scl.SplitString(str, "_")
			for _, str2 in pairs(arr2) do 
				table.insert(series_arr, str2)
			end
		end
		ccodem.scl_inside_series = series_arr
	end
	return ccodem, code
end
--Create check inside series function series_mata.IsXSetXX
--"series_mata": inside series matatable
--"series_str": inside series string
--"typ_idx"(default == nil): use "typ_idx" to differ different check functions with the same series_mata
--[[
	>>eg1. Scl.DefineInsideSeries(Love, "YiFanJiang")
	will create those functions:
	1. Love.IsSeries(c)   -- equal to Scl.IsSeries(c, "YiFanJiang") 
	2. Love.IsFusionSeries(c)   -- equal to Scl.IsFusionSeries(c, "YiFanJiang") 
	3. Love.IsLinkSeries(c)  -- equal to Scl.IsLinkSeries(c, "YiFanJiang") 
	4. Love.IsPreviousSeries(c) -- equal to Scl.IsPreviousSeries(c, "YiFanJiang")
	5. Love.IsOriginalSeries(c) -- equal to Scl.IsOriginalSeries(c, "YiFanJiang")
	6~10 Love.IsXXXXSeriesMonster(c) (XXXX can be "", "Fusion", "Link" ……, see above)	 -- equal to Scl.IsXXXXSeries(c, "YiFanJiang") and c:IsType(TYPE_MONSTER)
	11~15 Love.IsXXXXSeriesSpell(c) (XXXX can be "", "Fusion", "Link" ……, see above)		-- equal to Scl.IsXXXXSeries(c, "YiFanJiang") and c:IsType(TYPE_SPELL)
	16~20 Love.IsXXXXSeriesTrap(c) (XXXX can be "", "Fusion", "Link" ……, see above)   -- equal to Scl.IsXXXXSeries(c, "YiFanJiang") and c:IsType(TYPE_TRAP)
	21~25 Love.IsXXXXSeriesSpellOrTrap(c) (XXXX can be "", "Fusion", "Link" ……, see above)  -- equal to Scl.IsXXXXSeries(c, "YiFanJiang") and c:IsType(TYPE_SPELL + TYPE_TRAP)
	>>eg2. Scl.DefineInsideSeries(Love, "YiFanJiang", 1)
		   Scl.DefineInsideSeries(Love, "PlayGame", 2)
	will use the suffix 1 and 2 to differ 2 inside series check functions with the same series_mata "Love", like:
	Love.IsSeries1(c)   -- equal to Scl.IsSeries(c, "YiFanJiang") 
	Love.IsSeries2(c)   -- equal to Scl.IsSeries(c, "PlayGame") 
	Love.IsPreviousSeriesMonster1(c)	-- equal to Scl.IsPreviousSeries(c, "YiFanJiang") and c:IsPreviousType(TYPE_MONSTER) 
	Love.IsPreviousSeriesMonster2(c)	-- equal to Scl.IsPreviousSeries(c, "PlayGame") and c:IsPreviousType(TYPE_MONSTER) 
]]--
function Scl.DefineInsideSeries(series_mata, series_str, typ_idx)
	local prefixlist = { "", "Fusion", "Link", "Previous", "Original" }
	local suffixlist = { "", "Monster", "Spell", "Trap", "SpellOrTrap" } 
	for idx1, prefix1 in pairs(prefixlist1) do 
		for idx2, suffix2 in pairs(suffixlist) do
			series_mata[ "Is" .. prefix1 .. "Series" .. suffix2 .. typ_idx or "" ] = s.define_inside_series(prefixlist[idx1], suffixlist[idx2], series_str)
		end
	end
end
function Scl.define_inside_series(prefix, suffix, series_str)
	return function(c, ...)
		if not Scl["Is" .. prefix .. "Series"](c, series_str) then
			return false
		end
		if suffix == "SpellOrTrap" then
			return s.is_card_type(c, prefix, 0, TYPE_SPELL, TYPE_TRAP)
		else
			return not suffix or s.is_card_type(c, prefix, 0, Scl.Card_Type_List[suffix])
		end
	end
end
--Get the activate effect's handler, and if it is relate to chain
--For continous effects, PLZ use Effect.GetHandler, don't use this function
--//return self, self releate to chain or nil
function Scl.GetActivateCard() 
	local e = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT)
	local c = e:GetHandler()
	return c, c:IsRelateToChain() and c or nil
end
--Get the effect's handler that is in faceup position, and if it is relate to chain
--For continous effects, PLZ use Effect.GetHandler, don't use this function
--//return faceup self, faceup self releate to chain or nil
-->>eg1. Scl.GetFaceupActivateCard(e)
function Scl.GetFaceupActivateCard() 
	local c1, c2 = Scl.GetActivateCard()
	return c1:IsFaceup() and c1 or nil, (c2 and c2:IsFaceup()) and c2 or nil
end
--Get effect target(s) that is releate to chain and meets filter(c, ...)
--//return target group, first target card
-->>eg1. Scl.GetTargetsReleate2Chain()
-->>return tg, tc
-->>eg2. Scl.GetTargetsReleate2Chain(Card.IsFaceup)
-->>return tg with faceup cards, faceup tc or nil.
function Scl.GetTargetsReleate2Chain(filter, ...)
	filter = card_filter or aux.TRUE
	if not Duel.GetFirstTarget() then
		return Group.CreateGroup()
	else
		local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS):Filter(s.get_target_releate_filter, nil, filter, ...)
		return g, g:GetFirst()
	end
end
function s.get_target_releate_filter(c, filter, ...)
	filter = filter or aux.TRUE
	if not c:IsRelateToChain() then return false end
	return filter(c, ...)
end
--Get target player and that num-format value for an effect that register player target information in Effect.SetTarget
--//return target player, target value
--[[
	>>eg1. 	Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(1000)
			Scl.GetPlayerTargetParamas()
	>> return tp, 1000
--]]
function Scl.GetPlayerTargetParamas()
	local player, value = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
	return player, value
end
--Add normal summon or set procedure
--parama see Scl.AddNormalSummonProcedure and Scl.AddNormalSetProcedure
--//return summon effect
function Scl.AddSummonProcedure(reg_obj, code, limit, con, tg, op, desc_obj, lim_obj, val, pos, tg_player, flag, rst_obj)
	local _, handler = Scl.GetRegisterInfo(reg_obj)
	desc_obj = desc_obj or DESC_SPSUMMON_BY_SELF_PROC_SCL 
	local flag2 = Scl.GetNumFormatProperty(flag)
	local flag3 = limit and "!NegateEffect,Uncopyable" or "Uncopyable" 
	if pos or tg_player then 
		flag3 = flag3 .. ",SummonParama"
	end
	flag3 = Scl.GetNumFormatProperty(flag3)
	local val2 = type(val) ~= "string" and val or Scl.Summon_Type_List[val]
	local e1 = Scl.CreateEffect(reg_obj, EFFECT_TYPE_SINGLE, code, desc_obj, lim_obj, nil, flag2 | flag3, nil, s.add_summon_procedure_con(con), nil, tg, op, val2, nil, nil, rst_obj)
	if pos or tg_player then
		e1:SetTargetRange(pos, tg_player)
	end
	return e1
end
function s.add_summon_procedure_con(con)
	return function(e, c, minct)
		if c == nil then 
			return true 
		end
		return con(e, c, c:GetControler(), minct)
	end
end
--Add normal summon procedure
--if the parama "limit" (defualt == false) == true, means force that monster's normal summon procedure by this function, it cannot be normal summoned by other ways, and the summon procedure will auto set property "!NegateEffect,Uncopyable".
--this function will also auto add c == nil check to "con", and add the parama "tp" to "con" check (return con(e, c, tp, minct))
--//return summon effect
-->>eg1. Scl.AddNormalSummonProcedure(c, false, s.con)
-->>card "c" can be normal summoned when meet s.con
-->>eg2. Scl.AddNormalSummonProcedure(c, false, s.con, nil, s.op, nil, { 1, id, "Oath" })
-->>if meet s.con(e, c, tp, minct), once per turn, card with same name as "c" can be normal summoned by do s.op(e, tp, eg, ep, ev, re, r, rp, c).
-->>eg3. Scl.AddNormalSummonProcedure(c, true, s.con, nil, s.op, nil, { 1, id, "Oath" }, SUMMON_TYPE_ADVANCE, POS_FACEUP_DEFENSE, 1)
-->>card with same name as "c" can only be normal summoned by the follow way: once per turn, if meet s.con(e, c, tp, minct), once per turn, advance summon to your opponent's field in faceup defense position to your by do s.op(e, tp, eg, ep, ev, re, r, rp, c).
function Scl.AddNormalSummonProcedure(reg_obj, limit, con, tg, op, desc_obj, lim_obj, val, pos, tg_player, flag, rst_obj)
	return Scl.AddSummonProcedure(reg_obj, not limit and EFFECT_SUMMON_PROC or EFFECT_LIMIT_SUMMON_PROC, limit, con, tg, op, desc_obj, lim_obj, val, pos, tg_player, flag, rst_obj)
end
--Add normal set procedure
--if the parama "limit" (defualt == false) == true, means force that monster's normal summon procedure by this function, it cannot be normal summoned by other ways, and the summon procedure will auto set property "!NegateEffect,Uncopyable".
--this function will also auto add c == nil check to "con", and add the parama "tp" to "con" check (return con(e, c, tp, minct))
--//return summon effect
-->>eg1. Scl.AddNormalSetProcedure(c, false, s.con)
-->>card "c" can be normal set when meet s.con
-->>eg2. Scl.AddNormalSetProcedure(c, false, s.con, nil, s.op, nil, { 1, id, "Oath" })
-->>if meet s.con(e, c, tp, minct), once per turn, card with same name as "c" can be normal set by do s.op(e, tp, eg, ep, ev, re, r, rp, c).
-->>eg3. Scl.AddNormalSetProcedure(c, true, s.con, nil, s.op, nil, { 1, id, "Oath" }, SUMMON_TYPE_ADVANCE, POS_FACEUP_DEFENSE, 1)
-->>card with same name as "c" can only be normal set by the follow way: once per turn, if meet s.con(e, c, tp, minct), once per turn, advance set to your opponent's field in faceup defense position to your by do s.op(e, tp, eg, ep, ev, re, r, rp, c).
function Scl.AddNormalSetProcedure(reg_obj, limit, con, tg, op, desc_obj, lim_obj, val, pos, tg_player, flag, rst_obj)
	return Scl.AddSummonProcedure(reg_obj, not limit and EFFECT_SET_PROC or EFFECT_LIMIT_SET_PROC, limit, con, tg, op, desc_obj, lim_obj, val, pos, tg_player, flag, rst_obj)
end
--Add special summon procedure
--if the register handler isn't a summonable card, the summon procedure will auto set property "!NegateEffect,Uncopyable".
--if you set the parama "pos" or "tg_player", the summon procedure will auto set property "SummonParama".
--if con == nil, this function will auto check whether there are enough zones for handler's special summon.
--this function will also auto add c == nil check to "con", and add the parama "tp" to "con" check (return con(e, c, tp))
--//return summon effect
-->>eg1. Scl.AddSpecialSummonProcedure(c, "Hand")
-->>card "c" can be speical summoned from hand
-->>eg2. Scl.AddSpecialSummonProcedure(c, "Extra", s.con, s.tg, s.op, nil, { 1, id, "Oath" }, "LinkSummon")
-->>if meet s.con(e, c, tp), once per turn, card with same name as "c" can be special summoned from extra by do s.tg(e, tp, eg, ep, ev, re, r, rp, chk, c) and s.op(e, tp, eg, ep, ev, re, r, rp, c), and treat that summon as a link summon.
-->>eg3. Scl.AddSpecialSummonProcedure(c, "Deck", s.con, s.tg, s.op, nil, { 1, id, "Oath" }, nil, POS_FACEUP_ATTACK, 1)
-->>if meet s.con(e, c, tp), once per turn, card with same name as "c" can be special summoned from deck to your opponent's field in attack position by do s.tg(e, tp, eg, ep, ev, re, r, rp, chk, c) and s.op(e, tp, eg, ep, ev, re, r, rp, c).
function Scl.AddSpecialSummonProcedure(reg_obj, zone, con, tg, op, desc_obj, lim_obj, val, pos, tg_player, flag, rst_obj)
	local _, handler = Scl.GetRegisterInfo(reg_obj)
	desc_obj = desc_obj or DESC_SPSUMMON_BY_SELF_PROC_SCL 
	local flag2 = Scl.GetNumFormatProperty(flag)
	local flag3 = not handler:IsSummonableCard() and "!NegateEffect,Uncopyable" or "Uncopyable" 
	if pos or tg_player then 
		flag3 = flag3 .. ",SummonParama"
	end
	flag3 = Scl.GetNumFormatProperty(flag3)
	local val2 = type(val) ~= "string" and val or Scl.Summon_Type_List[val]
	local e1 = Scl.CreateEffect(reg_obj, EFFECT_TYPE_FIELD, EFFECT_SPSUMMON_PROC, desc_obj, lim_obj, nil, flag2 | flag3, zone, s.add_special_summon_procedure_con(con), nil, tg, op, val2, nil, nil, rst_obj)
	if pos or tg_player then
		e1:SetTargetRange(pos, tg_player)
	end
	return e1
end
function s.add_special_summon_procedure_con(con)
	return function(e, c)
		if c == nil then 
			return true 
		end
		local tp = c:GetControler()
		if not con then 
			return Scl.GetMZoneCount4Summoning(tp, nil, tp, c) > 0
		else
			return con(e, c, tp)
		end
	end
end
--Set normal/special summon condition to reg_obj
--if revive (default == false) == true, will do handler:EnableReviveLimit()
--if spsum_lim (default == nil) ~= nil, will set spsum_lim as value to the "EFFECT_SPSUMMON_CONDITION" effect.
--lim_ct_sum_typ can be "SpecialSummon", "RitualSummon", ... (see Scl.Summon_Type_List), if you set this parama, means handler can only be special summoned once per turn, by the summon type that "lim_ct_sum_typ" points to.
-->>eg1. Scl.SetSummonCondition(c, false, aux.FALSE)
-->>this card cannot be Special Summoned
-->>eg2. Scl.SetSummonCondition(c, true, scl.value_spsummon_from_extra("FusionSummon"), "FusionSummon")
-->>this card cannot be special summoned from extra, except by Fusion Summon, and cards with this card's card code can only be FusionSummoned once per turn.
function Scl.SetSummonCondition(reg_obj, revive, spsum_lim, lim_ct_sum_typ)
	local _, handler = Scl.GetRegisterInfo(reg_obj)
	if handler:IsStatus(STATUS_COPYING_EFFECT) then 
		return 
	end
	if Scl.CheckBoolean(revive, true) then
		 handler:EnableReviveLimit()
	end
	local e1, e2
	if spsum_lim then 
		e1 = Scl.CreateSingleBuffCondition(reg_obj, EFFECT_SPSUMMON_CONDITION, spsum_lim)
	end
	if lim_ct_sum_typ then 
		e2 = Scl.CreateSingleTriggerContinousEffect(reg_obj, EVENT_SPSUMMON_SUCCESS, nil, nil, "!NegateEffect,Uncopyable", scl.cond_is_summon_type(lim_ct_sum_typ), s.summon_count_limit_op(lim_ct_sum_typ))
	end
	return e1, e2
end 
function s.summon_count_limit_op(sum_typ)
	return function(e, tp)
		local e1 = Scl.CreatePlayerBuffEffect({ e:GetHandler(), tp }, "!SpecialSummon", nil, s.summon_count_limit_tg(sum_typ), { 1, 0 }, nil, nil, RESETS_EP_SCL)
	end
end
function s.summon_count_limit_tg(sum_typ_str)
	return function(e, c, sump, sum_typ, sum_pos, tg_tp, se)
		local sum_typ2 = Scl.Summon_Type_List[sum_typ_str]
		return c:IsCode(e:GetHandler():GetOriginalCodeRule()) and sum_typ & sum_typ2 == sum_typ2
	end
end
--Special add fusion material record
--now equal to Auxiliary.AddFusionProcMixRep + EnableReviveLimit()
-->>eg1. Scl.SetFusionMaterial(c, false, false, 114514, 1, 3, s.filter, 2, 2)
-->>this fusion monster needs 1~3 monsters witch name is 114514, and 2 other monsters meets s.filter(c, fc) as materials to fusion summon it.
function Scl.SetFusionMaterial(c, instant_fusion_able, replace_name_able, ...)
	c:EnableReviveLimit()
	return aux.AddFusionProcMixRep(c, instant_fusion_able, replace_name_able, ...)
end
--Speical "aux.AddSynchroMixProcedure"
--can call some scl's custom functions in the procedure, like extra synchro material, dark synchro, custom level synchro, custom synchro material action, and so on
--return summon effect
function Scl.AddSynchroProcedure(c, f1, f2, f3, f4, minc, maxc, gc)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.SynMixCondition(f1, f2, f3, f4, minc, maxc, gc))
	e1:SetTarget(s.SynMixTarget(f1, f2, f3, f4, minc, maxc, gc))
	e1:SetOperation(s.SynMixOperation(f1, f2, f3, f4, minc, maxc, gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	return e1
end
function s.GetSynMaterials(tp, syncard)
	local mg1 = Scl.GetSynMaterials_R(tp, syncard)
	local mg2 = Duel.GetMatchingGroup(s.SExtraFilter, tp, 0xff, 0xff, mg1, syncard, tp)
	return mg1 + mg2
end
function s.SExtraFilter(c, sc, tp)
	if c:IsOnField() and c:IsFacedown() then return false end
	if not c:IsCanBeSynchroMaterial(sc) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_SYNCHRO_MATERIAL_SCL,tp)}
	for _,te in pairs(le) do
		local tf = te:GetValue()
		local related, valid=tf(te, sc, nil, c, tp)
		if related then return true end
	end
	return false
end
function s.SUncompatibilityFilter(c, sg, sc, tp)
	local mg = sg:Filter(aux.TRUE, c)
	return not s.SCheckOtherMaterial(c, mg, sc, tp)
end
function s.SCheckOtherMaterial(c, mg, sc, tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_SYNCHRO_MATERIAL_SCL,tp)}
	local res1=false
	local res2=true
	for _, te in pairs(le) do
		local f = te:GetValue()
		local related, valid = f(te,sc,mg,c,tp)
		if related then res2 = false end
		if related and valid then res1 = true end
	end
	return res1 or res2
end
function s.SynMixCheckGoal(tp, sg, minc, ct, syncard, sg1, smat, gc, mgchk)
	local mg = Scl.Mix2Group(sg, sg1)
	--step 1,  check extra material
	if mg:IsExists(s.SUncompatibilityFilter, 1, nil, mg, syncard, tp) then return false end
	--step 2,  check level fo dark_synchro and non - level_synchro 
	local f = Card.GetLevel
	local darktunerg = mg:Filter(Card.IsType, nil, TYPE_TUNER)
	local darktunerlv = darktunerg:GetSum(Card.GetSynchroLevel, syncard)
	Card.GetLevel = function(sc)
		if syncard.scl_dark_synchro and syncard == sc then
			return darktunerlv * 2-f(sc)
		end
		if sc.rs_synchro_level then return sc.rs_synchro_level
		else return f(sc)
		end
	end
	--step 3,  check Ladian 1,  use material's custom lv (if any)
	local f2 = Card.GetSynchroLevel
	Card.GetSynchroLevel = function(c, sc2)
		local lvcheck = syncard.rs_synchro_ladian 
		if lvcheck then
			local lvable, lv = syncard.rs_synchro_ladian(c, sc2, tp)
			return lvable and lv or f2(c, sc2)
		else
			return f2(c, sc2)
		end
	end
	local bool1 = s.SynMixCheckGoal_R(tp, sg, minc, ct, syncard, sg1, smat, gc, mgchk)
	Card.GetSynchroLevel = f2
	--step 4,  check Ladian 2,  use material's base lv
	local bool2 = s.SynMixCheckGoal_R(tp, sg, minc, ct, syncard, sg1, smat, gc, mgchk)
	Card.GetLevel = f
	return bool1 or bool2
end
function s.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)
	return  function(e,c,smat,mg1,min,max)
				Scl.GetSynMaterials_R = aux.GetSynMaterials
				aux.GetSynMaterials = s.GetSynMaterials
				s.SynMixCheckGoal_R = aux.SynMixCheckGoal
				aux.SynMixCheckGoal = s.SynMixCheckGoal
				local res = aux.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)(e,c,smat,mg1,min,max)
				aux.GetSynMaterials = Scl.GetSynMaterials_R 
				aux.SynMixCheckGoal = s.SynMixCheckGoal_R 
				return res
			end
end
function s.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				Scl.GetSynMaterials_R = aux.GetSynMaterials
				aux.GetSynMaterials = s.GetSynMaterials
				s.SynMixCheckGoal_R = aux.SynMixCheckGoal
				aux.SynMixCheckGoal = s.SynMixCheckGoal
				local res = aux.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc)(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				aux.GetSynMaterials = Scl.GetSynMaterials_R 
				aux.SynMixCheckGoal = s.SynMixCheckGoal_R 
				return res
			end
end
function s.SynMixOperation(f1, f2, f3, f4, minct, maxc, gc)
	return  function(e, tp, eg, ep, ev, re, r, rp, c, smat, mg, min, max)
				local mg = e:GetLabelObject()
				s.SExtraMaterialCount(mg, c, tp)
				local res
				--case 1,  Summon Effect Custom
				if Scl.CustomSynchroMaterialAction then
					res = Scl.CustomSynchroMaterialAction(mg, c, e, tp)
					Scl.CustomSynchroMaterialAction = nil
				--case 2,  Summon Procedure Custom 
				elseif c.scl_custom_synchro_material_action then
					res = c.scl_custom_synchro_material_action(mg, c, e, tp)
				--case 3,  Base Summon Procedure
				else
					c:SetMaterial(mg)
					res = Duel.SendtoGrave(mg, REASON_SYNCHRO + REASON_MATERIAL)
				end
				mg:DeleteGroup()
				return res
			end
end
function s.SExtraMaterialCount(mg, sc, tp)
	for tc in aux.Next(mg) do
		local le = { tc:IsHasEffect(EFFECT_EXTRA_SYNCHRO_MATERIAL_SCL, tp) }
		for _, te in pairs(le) do
			local sg=mg:Filter(aux.TRUE, tc)
			local f = te:GetValue()
			local related,valid=f(te, sc, sg, tc, tp)
			if related and valid then
				te:UseCountLimit(tp)
			end
		end
	end
end
--enable reg_obj's dark synchro attribute
--//return "EFFECT_ADD_TYPE" effect
function Scl.EnableDarkSynchroAttribute(reg_obj, rst_obj)
	local owner, handler = Scl.GetRegisterInfo(reg_obj)
	if not rst_obj and owner == handler and not handler:IsStatus(STATUS_COPYING_EFFECT) and not owner.scl_dark_synchro then 
		local mt = getmetatable(handler) 
		mt.scl_dark_synchro = true
	end
	local e1 = Scl.CreateSingleBuffEffect(reg_obj, "+Type", "TYPE_DARKSYNCHRO", 0xff, nil, rst_obj, DESC_DARK_SYNCHRO_SCL)
	return e1
end
--enable reg_obj's dark tuner attribute
--//return "EFFECT_ADD_TYPE" effect
function Scl.EnableDarkTunerAttribute(reg_obj, rst_obj)
	local owner, handler = Scl.GetRegisterInfo(reg_obj)
	if not rst_obj and owner == handler and not handler:IsStatus(STATUS_COPYING_EFFECT) and not owner.scl_dark_tuner then 
		local mt = getmetatable(handler) 
		mt.scl_dark_tuner = true
	end
	local e1 = Scl.CreateSingleBuffEffect(reg_obj, "+Type", "TYPE_DARKSYNCHRO", 0xff, nil, rst_obj, DESC_DARK_TUNER_SCL)
	return e1
end
--Card filter: Is Dark Synchro
function Scl.IsDarkSynchro(c)
	return c.scl_dark_synchro == true
end
--Card filter: Is Dark Tuner 
function Scl.IsDarkTuner(c)
	return Scl.DarkTuner(nil)(c)
end
--Card filter: Dark Tuner for Dark Synchro Summon
function Scl.DarkTuner(f, ...)
	local ex_paramas = { ... }
	return  function(c)
				local type_list = { c:IsHasEffect(EFFECT_ADD_TYPE) }
				local bool = false
				for _, e in pairs(type_list) do
					if Scl.String_Value[e] == "TYPE_DARKTUNER" then
						bool = true
					break 
					end
				end
				return (c.scl_dark_tuner or bool) and aux.Tuner(f, table.unpack(ex_paramas))(c)
			end
end
--speical "aux.AddXyzProcedureLevelFree"
--can call some scl's custom functions in the procedure, like extra xyz material, custom xyz material action, utility xyz material, and so on
--return summon effect
function Scl.AddlXyzProcedure(c, f, gf, minc, maxc, alterf, desc, op)
	c:EnableReviveLimit()
	f = type(f) == "number" and aux.FilterBoolFunction(Card.IsXyzLevel, f) or f
	gf = gf or aux.TRUE
	alterf = alterf or aux.FALSE 
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	--if alterf then
		maxc= maxc or minc
		e1:SetCondition(s.XyzLevelFreeConditionAlter(f, gf, minc, maxc, alterf, desc, op))
		e1:SetTarget(s.XyzLevelFreeTargetAlter(f, gf, minc, maxc, alterf, desc, op))
		e1:SetOperation(s.XyzLevelFreeOperationAlter(f, gf, minc, maxc, alterf, desc, op))
	--[[else
		e1:SetCondition(Auxiliary.XyzLevelFreeCondition(f, gf, minc, maxc))
		e1:SetTarget(Auxiliary.XyzLevelFreeTarget(f, gf, minc, maxc))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperation(f, gf, minc, maxc))--]]
	--end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	return e1
end
function s.GetXyzMaterials_X(tp, xyzc)
	return function(...)
		return s.GetXyzMaterials(tp, xyzc)
	end
end
function s.GetXyzMaterials(tp, xyzc)
	local mg1 = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_MZONE, 0, nil)
	local mg2 = Duel.GetMatchingGroup(s.XExtraFilter, tp, 0xff, 0xff, mg1, xyzc, tp)
	return (mg1 + mg2):Filter(s.IsCanBeXyzMaterial,nil,xyzc)
end
function s.XExtraFilter(c, xc, tp)
	if c:IsOnField() and c:IsFacedown() then return false end
	if not s.IsCanBeXyzMaterial(c, xc) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_XYZ_MATERIAL_SCL,tp)}
	for _,te in pairs(le) do
		local tf = te:GetValue()
		local related, valid = tf(te, xc, nil, c, tp)
		if related then return true end
	end
	return false
end
function s.IsCanBeXyzMaterial(c, xyzc)
	if c:IsType(TYPE_TOKEN) then return false end
	if c:IsType(TYPE_MONSTER) then return c:IsCanBeXyzMaterial(xyzc) end
	if c:IsType(TYPE_SPELL + TYPE_TRAP) then
		local elist = { c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL) }
		for _, e in pairs(elist) do
			local val = e:GetValue()
			if not val or val(e, xyzc) then return false end
		end
	end
	return true
end
function s.XyzLevelFreeFilter(c, xyzc, f)
	return (not c:IsOnField() or c:IsFaceup()) and s.IsCanBeXyzMaterial(c, xyzc) and (not f or f(c, xyzc))
end
function s.XyzLevelFreeConditionAlter(f, gf, minct, maxct, alterf, desc, op)
	return  function(e, c, og, min, max)
				Scl.Group_XyzLevelFreeGoal_R = aux.XyzLevelFreeGoal
				aux.XyzLevelFreeGoal = s.XyzLevelFreeGoal(minct, maxct, og)
				Scl.Group_GetFieldGroup_R = Duel.GetFieldGroup
				Duel.GetFieldGroup = s.GetXyzMaterials_X(e:GetHandlerPlayer(), c)
				Scl.Card_XyzLevelFreeFilter_R = aux.XyzLevelFreeFilter
				aux.XyzLevelFreeFilter = s.XyzLevelFreeFilter
				local res = aux.XyzLevelFreeConditionAlter(f, gf, 1, maxct, alterf, desc, op)(e, c, og, min, max)
				aux.XyzLevelFreeGoal = Scl.Group_XyzLevelFreeGoal_R
				Duel.GetFieldGroup = Scl.Group_GetFieldGroup_R 
				aux.XyzLevelFreeFilter = Scl.Card_XyzLevelFreeFilter_R
				return res 
			end
end
function s.XyzLevelFreeGoal(minct, maxct, og)
	return function(g, tp, xyzc, gf)
		--case 1,  extra material check
		if g:IsExists(s.XUncompatibilityFilter, 1, nil, g, xyzc, tp) then return false end
		--case 2,  normal check
		if not ((not gf or gf(g, og, tp, xyzc)) and Duel.GetLocationCountFromEx(tp, tp, g, xyzc)>0) then return false end
		--case 3
		if #g > maxct then return false end
		--case 4, utility check
		local ug = g:Filter(Card.IsHasEffect, nil, EFFECT_UTILITY_XYZ_MATERIAL_SCL, tp)
		local mg = g:Clone()
		mg:Sub(ug)
		local totalreducelist = { }
		local sumlist = { #mg }
		for tc in aux.Next(ug) do 
			local ct = 0
			local sumlist2 = Scl.CloneArray(sumlist)
			local _, reducelist = s.XCheckUtilityMaterial(tc, g, xyzc, tp)
			for i, reduce in pairs(reducelist) do 
				ct = ct + 1
				for j, prereduce in pairs(sumlist2) do 
					if j > 1 then
						ct = ct + 1
					end
					sumlist[ct] = prereduce + reduce
				end
			end
		end
		for _, matct in pairs(sumlist) do
			if matct >= minct and matct <= maxct then 
				return true 
			end
		end
		return false
	end
end
function s.XUncompatibilityFilter(c, sg, xc, tp)
	local mg = sg:Filter(aux.TRUE, c)
	return not s.XCheckOtherMaterial(c, mg, xc, tp)
end
function s.XCheckOtherMaterial(c, mg, xc, tp)
	local le={ c:IsHasEffect(EFFECT_EXTRA_XYZ_MATERIAL_SCL, tp) }
	local res1=false
	local res2=true
	for _, te in pairs(le) do
		local f = te:GetValue()
		local related, valid = f(te, xc, mg, c, tp)
		if related then res2 = false end
		if related and valid then res1 = true end
	end
	return res1 or res2
end
function s.XCheckUtilityMaterial(c, mg, xyzc, tp)
	local le = { c:IsHasEffect(EFFECT_UTILITY_XYZ_MATERIAL_SCL, tp) }
	if #le == 0 then return 1, { 1 } end
	local max_reduce = 1
	local reduce_arr = { 1 }
	for _, te in pairs(le) do
		local val = te:GetValue()
		local reduce = 1
		if type(val) == "number" then reduce = val end
		if type(val) == "function" then reduce = val(te, xyzc, mg, tp) end
		max_reduce = math.max(max_reduce, reduce or 2) 
		table.insert(reduce_arr, reduce or 2)
	end
	table.sort(reduce_arr)
	return max_reduce, reduce_arr
end
function s.XyzLevelFreeTargetAlter(f, gf, minct, maxct, alterf, desc, op)
	return  function(e, tp, eg, ep, ev, re, r, rp, chk, c, og, min, max)
				Scl.Group_XyzLevelFreeGoal_R = aux.XyzLevelFreeGoal
				aux.XyzLevelFreeGoal = s.XyzLevelFreeGoal(minct, maxct, og)
				Scl.Group_GetFieldGroup_R = Duel.GetFieldGroup
				Duel.GetFieldGroup = s.GetXyzMaterials_X(tp, c)
				Scl.Card_XyzLevelFreeFilter_R = aux.XyzLevelFreeFilter
				aux.XyzLevelFreeFilter = s.XyzLevelFreeFilter
				local res = aux.XyzLevelFreeTargetAlter(f, gf, 1, maxct, alterf, desc, op)(e, tp, eg, ep, ev, re, r, rp, chk, c, og, min, max)
				aux.XyzLevelFreeGoal = Scl.Group_XyzLevelFreeGoal_R
				Duel.GetFieldGroup = Scl.Group_GetFieldGroup_R 
				aux.XyzLevelFreeFilter = Scl.Card_XyzLevelFreeFilter_R
				return res 
			end
end
function s.XyzLevelFreeOperationAlter(f, gf, minct, maxct, alterf, desc, op)
	return  function(e, tp, eg, ep, ev, re, r, rp, c, og, min, max)
			local res
			local mg = e:GetLabelObject()
			s.XExtraMaterialCount(mg, c, tp)
			if not Scl.CustomXyzMaterialAction and not c.scl_custom_xyz_material_action then
				res = aux.XyzLevelFreeOperationAlter(f, gf, 1, maxct, alterf, desc, op)(e, tp, eg, ep, ev, re, r, rp, c, og, min, max)
			else
				if Scl.CustomXyzMaterialAction then
					res = Scl.CustomXyzMaterialAction(mg, c, e, tp)
					Scl.CustomXyzMaterialAction = nil
				elseif c.scl_custom_xyz_material_action then
					res = c.scl_custom_xyz_material_action(mg, c, e, tp)
				end
			end
			local sf = function(hc, hp)
				return hc:IsPreviousLocation(LOCATION_HAND) and hc:IsPreviousControler(hp)
			end
			for hp = 0, 1 do 
				if mg:IsExists(sf, 1, nil, hp) then
					Duel.ShuffleHand(hp)
				end
			end
			mg:DeleteGroup()
			return res
	end
end
function s.XExtraMaterialCount(mg, xc, tp)
	for tc in aux.Next(mg) do
		local le = { tc:IsHasEffect(EFFECT_EXTRA_XYZ_MATERIAL_SCL, tp) }
		for _, te in pairs(le) do
			local sg=mg:Filter(aux.TRUE, tc)
			local f = te:GetValue()
			local related,valid=f(te, xc, sg, tc, tp)
			if related and valid then
				te:UseCountLimit(tp)
			end
		end
	end
end
--speical "aux.AddLinkProcedure"
--can call some scl's custom functions in the procedure, like extra link material, custom link material action, and so on
--return summon effect
function Scl.AddlLinkProcedure(c, f, min, max, gf)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if max == nil then max = c:GetLink() end
	e1:SetCondition(Auxiliary.LinkCondition(f, min, max, gf))
	e1:SetTarget(Auxiliary.LinkTarget(f, min, max, gf))
	e1:SetOperation(s.LinkOperation(f, min, max, gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	return e1
end
function s.LinkOperation(f, minc, maxc, gf)
	return  function(e, tp, eg, ep, ev, re, r, rp, c, og, lmat, min, max)
				local g=e:GetLabelObject()
				Auxiliary.LExtraMaterialCount(g,c,tp)
				local res
				--case 1,  Summon Effect Custom
				if Scl.CustomLinkMaterialAction then
					res = Scl.CustomLinkMaterialAction(g, c, e, tp)
					Scl.CustomLinkMaterialAction = nil
				--case 2,  Summon Procedure Custom 
				elseif c.scl_custom_link_material_action then
					res = c.scl_custom_link_material_action(g, c, e, tp)
				--case 3,  Base Summon Procedure
				else
					c:SetMaterial(g)
					res = Duel.SendtoGrave(g, REASON_LINK + REASON_MATERIAL)
				end
				g:DeleteGroup()
			end
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Filter<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Filter
--check if obj is surrounding to tc 
--//return bool
function Scl.IsSurrounding(obj, tc)
	if not tc:IsOnField() then 
		return false
	end
	local g = Scl.Mix2Group(obj):Filter(Card.IsOnField, nil)
	local sg = Scl.GetSurroundingGroup(tc, true)
	return g:IsExists(aux.IsInGroup, 1, nil, sg)
end
--Filter
--check if obj is surrounding to tc while obj is leaves the field
--//return bool
function Scl.IsPreviouslySurrounding(obj, tc)
	if not tc:IsOnField() then 
		return false
	end 
	local g = Scl.Mix2Group(obj):Filter(Scl.IsPreviouslyInZone, nil, "OnField")
	for tc2 in aux.Next(g) do
		local sg = Scl.GetPreviousSurroundingGroup(tc2, true)
		if sg:IsContains(tc) then
			return true
		end
	end
	return false
end
--Filter 
--check is player "tp" can special summon obj to his field in faceup position, won't check whether there are enough zones.
--//return bool
function Scl.IsCanBeSpecialSummonedNormaly(obj, e, tp)
	local f = function(c, e, tp)
		return c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and c:GetOriginalType() & TYPE_MONSTER > 0
	end
	local g = Scl.Mix2Group(obj)
	return g:IsExists(f, 1, nil, e, tp)
end
--Filter 
--check is player "tp" can special summon obj to his field in faceup position, and check whether there are enough zones.
--//return bool
function Scl.IsCanBeSpecialSummonedNormaly2(obj, e, tp)
	local f = function(c, e, tp)
		return c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and c:GetOriginalType() & TYPE_MONSTER > 0 and Scl.GetMZoneCount4Summoning(tp, nil, tp, c) > 0
	end
	local g = Scl.Mix2Group(obj)
	return g:IsExists(f, 1, nil, e, tp) 
end
--Filter
--check whether obj is face-up banished, or not be banished
--//return bool
function Scl.FaceupOrNotBeBanished(obj)
	local f = function(c)
		return not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()
	end
	local g = Scl.Mix2Group(obj)
	return g:IsExists(f, 1, nil) 
end 
--Filter
--check whether obj is face-up on field, or not on field
--//return bool
function Scl.FaceupOrNotOnField(obj)
	local f = function(c)
		return not c:IsOnField() or c:IsFaceup()
	end
	local g = Scl.Mix2Group(obj)
	return g:IsExists(f, 1, nil) 
end 
--Filter
--check whether obj can replace destroy
--//return bool
function Scl.IsDestructableForReplace(obj)
	local e = Scl.GetCurrentEffectInfo()
	local f = function(c)
		return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
	end
	local g = Scl.Mix2Group(obj)
	return g:IsExists(f, 1, nil) 
end
--Filter
--check different player 
--//return bool
function Scl.IsDifferentControler(obj)
	local g = Scl.Mix2Group(obj)
	return g:GetClassCount(Card.GetControler) == #g
end
--Switch different formats typ_obj to number-format.
--typ_obj can be number-format (like TYPE_SPELL), or can be string-format (Like "Spell" or "Spell,Trap")
--//return number-format card type, array contains each number-format card type
-->>eg1. Scl.GetNumFormatCardType(TYPE_SPELL)
-->>return TYPE_SPELL, { TYPE_SPELL }
-->>eg2. Scl.GetNumFormatCardType("Monster,Spell")
-->>return TYPE_MONSTER + TYPE_SPELL, { TYPE_MONSTER, TYPE_MONSTER }
function Scl.GetNumFormatCardType(typ_obj)
	if type(typ_obj) == "number" then 
		return typ_obj, Scl.SplitNumber2PowerOf2(typ_obj)
	else
		local ctyp, ctyp2, ctyp_arr = 0, 0, { }
		for _, chk_typ in pairs(Scl.SplitString(typ_obj)) do 
			ctyp2 = Scl.Card_Type_List[chk_typ]
			ctyp = ctyp | ctyp2
			table.insert(ctyp_arr, zone2)
		end
		return ctyp, ctyp_arr
	end
end
--Filter
--check card type
--paramas see the below functions
--//return bool
function s.is_card_type(c, typ_str, public_typ, ...)
	local type_fun = Card.GetType
	if typ_str == "Original" 
		then type_fun = Card.GetOriginalType
	elseif typ_str == "Previous" 
		then type_fun = Card.GetPreviousTypeOnField
	end
	local typ_arr = { ... }
	local num_public_typ = Scl.GetNumFormatCardType(public_typ)
	for _, ctype in pairs(typ_arr) do 
		local num_ctype = Scl.GetNumFormatCardType(ctype)
		if type_fun(c) & (num_ctype | num_public_typ) == (num_ctype | num_public_typ) then 
			return true 
		end
	end 
	return false
end
--Filter
--check whether obj is has a type
--the format of ... : public type, check type1, check type2, ...
--public type and check type can be number-format (like TYPE_SPELL), or be string-format (like "Monster", see Scl.Card_Type_List)
--obj must fully include the check type1 or check type2 ...
--if public type > 0, means obj must fully include the public type + check type1, or public type + check type2 ...
--//return bool
-->>eg1. Scl.IsType(c, 0, "Monster")
-->>check card c is a monster.
-->>eg2. Scl.IsType(c, 0, "Monster,Fusion", "Spell,QuickPlay")
-->>check card c is a fusion monster, or a quickplay spell
-->>eg3. Scl.IsType(c, "Monster", "Fusion", "Xyz")
-->>check card c is a fusion monster, or a xyz monster
function Scl.IsType(obj , ...)
	local g = Scl.Mix2Group(obj)
	return g:IsExists(s.is_card_type, 1, nil, nil, ...)
end
--Filter
--check whether obj is has a type while it leaves the field
--paramas see Scl.IsType
--//return bool
function Scl.IsPreviousType(obj, ...)
	local g = Scl.Mix2Group(obj)
	return g:IsExists(s.is_card_type, 1, nil, "Previous", ...)
end
--Filter
--check whether obj is has an original type
--paramas see Scl.IsType
--//return bool
function Scl.IsOriginalType(obj, ...)
	local g = Scl.Mix2Group(obj)
	return g:IsExists(s.is_card_type, 1, nil, "Original", ...)
end
--Filter
--check whether obj is has a reason
--the format of ... : public reason, check reason1, check reason2, ...
--public reason and check reason can be number-format (like REASON_DRAW), or be string-format (like "Material", see Scl.Reason_List)
--obj must fully include the check reason1 or check reason2 ...
--if public reason > 0, means obj must fully include the public reason + check reason1, or public reason + check reason2 ...
--//return bool
-->>eg1. Scl.IsReason(c, 0, "Effect")
-->>check card c is has a reason by card effect
-->>eg2. Scl.IsReason(c, 0, "Effect", "Battle")
-->>check card c is has a reason by card effect or by battle
-->>eg3. Scl.IsReason(c, "Destroy", "Effect", "Battle")
-->>check card c is has a reason by effect destroyed or by battle destroyed
function Scl.IsReason(obj, public_reason, ...)
	local g = Scl.Mix2Group(obj)
	public_reason = public_reason or 0
	local num_public_rsn = Scl.GetNumFormatCardType(public_reason)
	local res_arr = { ... }
	if Scl.Global_Reason then 
		for _, reason in pairs(res_arr) do
			local num_reason = Scl.GetNumFormatCardType(reason)
			if Scl.Global_Reason & (num_reason | num_public_rsn) == (num_reason | num_public_rsn) then 
				return true 
			end
		end
	else
		for _, reason in pairs(res_arr) do
			local num_reason = Scl.GetNumFormatCardType(reason)
			if g:IsExists(s.is_reason_check, 1, nil, num_reason, num_public_rsn) then 
				return true 
			end
		end
	end
	return false 
end
function s.is_reason_check(c, reason, public_reason)
	return c:GetReason() & (reason | public_reason) == (reason | public_reason)
end
--this function use to record the previous inside series.
function s.record_previous_inside_series()
	local ge1 = Scl.SetGlobalFieldTriggerEffect(0, EVENT_LEAVE_FIELD_P, FLAG_PREVIOUS_SERIES_SCL, nil, s.previous_inside_series_record)
end
function s.previous_inside_series_record(e, tp, eg)
	for tc in aux.Next(eg) do
		Scl.Previous_Series_List[tc] = { tc:IsHasEffect(EFFECT_ADD_SETCODE) } 
	end
end
--check if card c has inside series defined by chk_typ (of course, can check official series too.)
--//return bool
function s.check_series(c, chk_typ, ...) 
	local official_arr = { }
	local custom_arr = { }
	for _, series in pairs({ ... }) do 
		if type(series) == "number" then
			table.insert(official_arr, series) 
		else
			table.insert(custom_arr, series) 
		end
	end
	if #official_arr > 0 and Card["Is" .. chk_typ .. "SetCard"](c, ...) then
		return true
	end
	if #custom_arr == 0 then 
		return false 
	end
	local code_arr = { }
	local effect_arr = { }
	local extra_series_arr = { }
	if chk_typ == "" then
		code_arr = { c:GetCode() } 
		effect_arr = { c:IsHasEffect(EFFECT_ADD_SETCODE) } 
	elseif chk_typ == "Fusion" then
		code_arr = { c:GetFusionCode() }
		effect_arr = Scl.MixArrays({ c:IsHasEffect(EFFECT_ADD_FUSION_SETCODE) }, { c:IsHasEffect(EFFECT_ADD_SETCODE) })
	elseif chk_typ == "Link" then
		code_arr = { c:GetLinkCode() }
		effect_arr = Scl.MixArrays({ c:IsHasEffect(EFFECT_ADD_LINK_SETCODE) }, { c:IsHasEffect(EFFECT_ADD_SETCODE) })
	elseif chk_typ == "Original" then
		code_arr = { c:GetOriginalCode() }
		effect_arr = { }
	elseif chk_typ == "Previous" then
		code_arr = { c:GetPreviousCodeOnField() }
		effect_arr = Scl.Previous_Series_List
	end
	for _, effect in pairs(effect_arr) do
		local str = Scl.String_Value[effect]
		if str then 
			table.insert(extra_series_arr, str)
		end
	end
	for _, code in ipairs(code_arr) do 
		local inside_series_arr  
		local res = not _G["c"..code] and true or false
		if res then _G["c"..code] = { } end
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			inside_series_arr = _G["c"..code].scl_inside_series
		end
		if res then 
			_G["c"..code] = nil 
		end
		if inside_series_arr then
			if Scl.IsArraysHasIntersection(inside_series_arr, custom_arr) then 
				return true
			end
		end
	end
	if #extra_series_arr > 0 then
		if Scl.IsArraysHasIntersection(extra_series_arr, custom_arr) then 
			return true
		end
	end
	return false 
end 
--Filter
--check if the obj has 1 of the inside series ... (of course, can check official series too.)
--//return bool
-->>eg1. Scl.IsSeries(c, "WoAiJiangYiFan")
--check whether card c has an inside series "WoAiJiangYiFan"
-->>eg2. Scl.IsSeries(c, "WoAiJiangYiFan", "JiangYiFanAiWo")
--check whether card c has inside series "WoAiJiangYiFan" or "JiangYiFanAiWo"
function Scl.IsSeries(obj, ...) 
	local g = Scl.Mix2Group(obj)
	return g:IsExists(s.check_series, 1, nil, "", ...)
end
--Filter
--check if the obj has 1 of the inside fusion series ... (of course, can check official series too.)
--//return bool
-->>eg1. Scl.IsFusionSeries(c, "WoAiJiangYiFan")
--check whether card c has an inside fusion series "WoAiJiangYiFan"
-->>eg2. Scl.IsFusionSeries(c, "WoAiJiangYiFan", "JiangYiFanAiWo")
--check whether card c has inside fusion series "WoAiJiangYiFan" or "JiangYiFanAiWo"
function Scl.IsFusionSeries(obj, ...) 
	local g = Scl.Mix2Group(obj)
	return g:IsExists(s.check_series, 1, nil, "Fusion", ...)
end
--Filter
--check if the obj has 1 of the inside link series ... (of course, can check official series too.)
--//return bool
-->>eg1. Scl.IsLinkSeries(c, "WoAiJiangYiFan")
--check whether card c has an inside link series "WoAiJiangYiFan"
-->>eg2. Scl.IsLinkSeries(c, "WoAiJiangYiFan", "JiangYiFanAiWo")
--check whether card c has inside link series "WoAiJiangYiFan" or "JiangYiFanAiWo"
function Scl.IsLinkSeries(obj, ...) 
	local g = Scl.Mix2Group(obj)
	return g:IsExists(s.check_series, 1, nil, "Link", ...)
end
--Filter
--check if the obj has 1 of the inside original series ... (of course, can check official series too.)
--//return bool
-->>eg1. Scl.IsOriginalSeries(c, "WoAiJiangYiFan")
--check whether card c has an inside original series "WoAiJiangYiFan"
-->>eg2. Scl.IsOriginalSeries(c, "WoAiJiangYiFan", "JiangYiFanAiWo")
--check whether card c has inside original series "WoAiJiangYiFan" or "JiangYiFanAiWo"
function Scl.IsOriginalSeries(obj, ...) 
	local g = Scl.Mix2Group(obj)
	return g:IsExists(s.check_series, 1, nil, "Original", ...)
end
--Filter
--check if the obj has 1 of the inside pervious series ... (of course, can check official series too.)
--//return bool
-->>eg1. Scl.IsPreviousSeries(c, "WoAiJiangYiFan")
--check whether card c has an inside pervious series "WoAiJiangYiFan"
-->>eg2. Scl.IsPreviousSeries(c, "WoAiJiangYiFan", "JiangYiFanAiWo")
--check whether card c has inside pervious series "WoAiJiangYiFan" or "JiangYiFanAiWo"
function Scl.IsPreviousSeries(obj, ...) 
	local g = Scl.Mix2Group(obj)
	return g:IsExists(s.check_series, 1, nil, "Previous", ...)
end
--Filter
--check if obj is in zone_obj
--zone_obj can be number format (like LOCATION_SZONE, LOCATION_MZONE + LOCATION_HAND), or be string format (see Scl.Zone_List)
--//return bool
-->>eg1. Scl.IsInZone(c, "Hand,Deck")
--check whether c is in hand or deck.
function Scl.IsInZone(obj, zone_obj)
	local g = Scl.Mix2Group(obj)
	return g:IsExists(s.is_in_zone_check, 1 ,nil, zone_obj)
end 
function s.is_in_zone_check(c, zone_obj)
	local zone = Scl.GetNumFormatZone(zone_obj)
	return c:IsLocation(zone)
end
--Filter
--check if obj is perviously in zone_obj
--zone_obj can be number format (like LOCATION_SZONE, LOCATION_MZONE + LOCATION_HAND), or be string format (see Scl.Zone_List)
--//return bool
-->>eg1. Scl.IsPreviouslyInZone(c, "Hand,Deck")
--check whether c is perviously in hand or deck.
function Scl.IsPreviouslyInZone(obj, zone_obj)
	for tc in aux.Next(Scl.Mix2Group(obj)) do 
		if type(zone_obj) == "number" then 
			return c:IsPreviousLocation(zone_obj)
		end
		local zone_arr = Scl.SplitString(zone_obj)
		for _, zone_str in pairs(zone_arr) do
			if tc:IsPreviousLocation(Scl.Zone_List[zone_str]) then 
				return true
			end
		end
	end
	return false
end 


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Hint<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Switch different format hint_obj into the same format.
--hint_obj can be number, array, or string format, unifiedly switch to number-format.
--to an array, it switch to aux.Stringid(array[1], array[2])
--to a string, it use this string as index to find the correct hint in Scl.Category_List.
--[[str_pfx takes effect only when the hint_obj is in string-format.
	 str_pfx == nil or "", find normal hint, commonly used for Effect.SetDescription.
	 str_pfx == "s", find select card hint, commonly used for any select-cards operation.
	 str_pfx == "w", find hint "would you want to do sth.", commonly used for Duel.SelectYesNo and Duel.SelectOption
--]]
--//return the number-format hint 
-->>eg1. s.switch_hint_object_format({114514, 1})
-->>return aux.Stringid(114514, 1)
-->>eg2. s.switch_hint_object_format("Add2Hand",'WouldSelect')
-->>return a number-format hint that show "Would you want to add to hand?"
function s.switch_hint_object_format(hint_obj, str_pfx)
	str_pfx = str_pfx or ""
	local str_pfx_arr = { [""] = 4, ["Select"] = 3, ["WouldSelect"] = 5 }
	local hint = 0
	local obj_typ = type(hint_obj)
	if obj_typ == "table" then 
		hint = aux.Stringid(hint_obj[1], hint_obj[2])
	elseif obj_typ == "number" then
		hint = hint_obj 
	elseif obj_typ == "string" then
		local str_idx = str_pfx_arr[str_pfx]
		hint = Scl.Category_List[hint_obj][str_idx] or 0
		if type(hint) == "table" then
			hint = aux.Stringid(hint[1], hint[2])
		end
	end
	return hint
end
--Show the hint for the next selective operation 
function Scl.SelectHint(p, hint_obj)
	local hint_str = nil
	local vtyp = type(hint_obj)
	if vtyp == "string" then 
		hint_str =  s.switch_hint_object_format(hint_obj, "Select") 
	elseif vtyp == "number" then
		hint_str = vtyp
	elseif vtyp == "table" then
		hint_str = aux.Stringid(hint_obj[1], hint_obj[2])
	else
		hint_str = 0
	end
	Duel.Hint(HINT_SELECTMSG, p, hint_str) 
end
--Show card flashing animation
function Scl.HintCard(code)
	Duel.Hint(HINT_CARD, 0, code) 
end
--Show hint that obj is become target.(official Duel.HintSelection can only be use to Group, toooo bad)
function Scl.HintSelection(obj)
	Duel.HintSelection(Scl.Mix2Group(obj))
end
--Select yes or no
--hint_par's parama: see s.switch_hint_object_format
--if you set hint_code (defualt == nil), will show hint_code card's flashing animation.
--//return true (select yes) or false (select no)
-->>eg1. Scl.SelectYesNo(tp, "SpecialSummon")
-->>show the hint "Would you want to Special Summon?"
-->>eg1. Scl.SelectYesNo(tp, "Add2Hand", 114514)
-->>show the hint "Would you want to add to hand?" and show the 114514's flashing animation.
function Scl.SelectYesNo(p, hint_par, hint_code)
	local string = s.switch_hint_object_format(hint_par, "WouldSelect")
	local res = Duel.SelectYesNo(p, string)
	if res and type(hint_code) == "number" then
		Scl.HintCard(hint_code)
	end
	return res
end
--Select 1 from 2+ options
--... params format: boolean1(feasible), hint1, boolean2, hint2, ...
--if boolean = false, it can't be selected (and will not be displayed)
--//return the selected option's real index
-->>eg1: Scl.SelectOption(p, true, "Add2Hand", false, "Send2Deck", true, "Banish")
-->>if you select "Add2Hand", it will return 1, "Banish" will return 3, and you can't select "Send2Deck".
function Scl.SelectOption(p, ...)
	local res_arr, hint_arr = Scl.SplitArrayByParity({ ... })
	local sel_idx = 1
	local sel_arr, idx_arr = { }, { }
	for idx, obj in pairs(res_arr) do
		if obj then
			sel_arr[ sel_idx ] = s.switch_hint_object_format(hint_arr[ idx ])
			idx_arr[sel_idx - 1] = idx 
			sel_idx = sel_idx + 1
		end
	end
	if #sel_arr <= 0 then 
		return nil
	else
		local opt = Duel.SelectOption(p, table.unpack(sel_arr))
		return idx_arr[ opt ]
	end
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Other<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--Return any "true" out, for registing some default effect values
--//return 1st true, 2nd true, ..., ct-th true.
-->>eg. Scl.ReturnTrue(3)
-->>return true, true, true
function Scl.ReturnTrue(ct)
	return function()
		local arr = { }
		for idx = 1, ct do 
			arr[idx] = true
		end
		return table.unpack(arr)
	end
end
--Print debug message in the game window and the error.log
--if an element is "0x", this element will not be print, but the next element will be print by HEX form (if feasible).
-->>eg. Scl.Debug("0x",16," abcd ",16," def ","0x",11) 
-->>print "0x10 abcd 16 def, 0xa"
function Scl.Debug(...)
	local arr = { ... }
	local hint = ""
	for idx, val in pairs(arr) do 
		if type(val) == "string" then
			hint = hint .. val == "0x" and "" or val
		elseif type(val) == "number" then
			if arr[idx - 1] and type(arr[idx - 1]) == "string" and arr[idx - 1] == "0x" then
				hint = hint .. Scl.Dec2Hex(val)
			else
				hint = hint .. val
			end
		else
			hint = hint .. tostring(val) 
		end
	end
	Debug.Message(hint)
end
--transfer 10 DEC to 16 HEX
--//return string
-->>eg1. Scl.Dec2Hex(16)
-->>return "0x10"
function Scl.Dec2Hex(num)
	return string.format("0x%0X", num)
end
--transfer 16 HEX to 2 BIN
--//return string
-->>eg1. Scl.Hex2Bin(ff)
-->>return "11111111"
function Scl.Hex2Bin(hex_str)
	local bin_str = ""
	for idx = 1, #hex_str do 
		bin_str = bin_str .. Scl.Hex_Bin_Map[string.sub(hex_str,idx,idx)]
	end 
	return bin_str
end
--use to split the BIG ARRAY to 2 subset arrays, by the parity of the element's indexs as the grouping method.
--the BIG ARRAY must be successive.
--//return the odd array and the even array.
-->>eg1 Scl.SplitArrayByParity( 1, 2, 3, 4 )
-->>return { 1, 3 }, { 2, 4 }
function Scl.SplitArrayByParity(arr)
	local odd, even = { }, { }
	for idx, obj in pairs(arr) do
		if idx & 1 == 1 then
			table.insert(odd, obj)
		else 
			table.insert(even, obj)
		end
	end
	return odd, even
end
--use to split the BIG ARRAY to 3 subset arrays, index 1/4/7/... in first group, index 2/5/8/... in second group, index 3/6/9/... in third group
--the BIG ARRAY must be successive.
--//return first array, second array, third array
-->>eg1. Scl.SplitArrayByMultipleOf3({ "a", "b", "c", "d", "e", "f" })
-->>return { "a", "d" }, { "b", "e" }, { "c", "f" }
function Scl.SplitArrayByMultipleOf3(arr)
	local res_arr = { { }, { }, { } }
	local arr_idx = 0
	for idx, obj in pairs(arr) do
		arr_idx = arr_idx + 1
		if arr_idx == 4 then
			arr_idx = 1
		end
		table.insert(res_arr[arr_idx], obj)
	end
	return res_arr[1], res_arr[2], res_arr[3]
end
--Split the string by dlmt(delimiter)
--default ues ", " as delimiter
--//return the array contains every split subset strings.
-->>eg1. Scl.SplitString("I,love,JYF")
-->>return { I, love, JYF }  
--specially, if you use "_" as delimiter, it is use for spliting the inside series, the returned value will be different.
-->>eg2. Scl.SplitString("ABC_DEF","_")
-->>return { ABC_DEF, ABC, DEF }, means that card has 3 inside series - "ABC_DEF", "ABC" and "DEF".
function Scl.SplitString(str_input, dlmt)  
	str_input = string.gsub(str_input, " ", "")
	dlmt = dlmt or ',' 
	local pos, arr = 0,  { }  
	--case string list 
	if dlmt == ',' then
		for st, sp in function() return string.find(str_input,  dlmt,  pos,  true) end do  
			table.insert(arr,  string.sub(str_input,  pos,  st - 1))  
			pos = sp + 1  
		end  
		table.insert(arr,  string.sub(str_input,  pos)) 
		return arr
	--case inside series
	elseif dlmt == '_' then
		for st, sp in function() return string.find(str_input,  dlmt,  pos,  true) end do  
			table.insert(arr,  string.sub(str_input,  pos,  st - 1))  
			pos = sp + 1  
		end  
		table.insert(arr,  string.sub(str_input,  pos)) 
		local arr2 = { }
		local str2 = arr[1]
		for idx, val in ipairs(arr) do 
			if idx == 1 then table.insert(arr2,  str2) 
			else
				str2 = str2 .. "_" .. val
				table.insert(arr2,  str2)
			end
		end
		return arr2
	end 
end  
--Remove the prefix symbol or suffix symbol from a string.
--//return the new string, symbol.
-->>eg1. Scl.RemoveStringSymbol("~MP", "~")
-->>return "MP", "~"
function Scl.RemoveStringSymbol(str, symbol)
	--case1 suffix 
	local str_arr = Scl.SplitString(str, symbol)
	local str2 = str_arr[1]
	if len(str) == len(str2) + 1 then 
		return str2, symbol
	else
		return "", ""
	end
end
--Switch some different formats strings or string-arrays to a same fromat string-array.
--you can use "a, b, c" or { "a, b, c" } or { "a", "b", "c" } as a same.
--//return the same array
-->>eg1. Scl.UniformSclParamaFormat("asd,bff,ghh")
-->>return { "asd", "bff", "ghh" }
-->>eg2. Scl.UniformSclParamaFormat({ "asd,bff,ghh" })
-->>return { "asd", "bff", "ghh" }
function Scl.UniformSclParamaFormat(obj)
	local arr = { }
	if type(obj) == "string" then
		arr = Scl.SplitString(obj)
	elseif type(obj) == "number" then
		arr = { obj }
	elseif type(obj) == "table" then
		for _, val in ipairs(obj) do
			if type(val) == "string" then
				for _, val2 in ipairs(Scl.SplitString(val)) do
					table.insert(arr, val2) 
				end
			else 
				table.insert(arr, val)
			end
		end
	end
	return arr
end
--Match 2(or 3) arrays
--for each string in obj1, find its index in obj2, and use this index to find the ELEMENT1 in obj3 and the ELEMENT2 in obj4 (obj4 is an optional parama).
--if obj4 only have 1 element A, but the obj1 has 2+ strings, that element A will corresponding to all strings.
--//return the ELEMENT1-array, ELEMENT2-array, first ELEMENT1, first ELEMENT2 
--[[>>eg1.  obj1 = { "fmat~,lmat~" }
			obj2 = { "fmat", "smat~", "xmat~", "lmat~" }
			obj3 = { EFFECT_CANNOT_BE_FUSION_MATERIAL, EFFECT_CANNOT_BE_SYNCHRO_MATERIAL, EFFECT_CANNOT_BE_XYZ_MATERIAL, EFFECT_CANNOT_BE_LINK_MATERIAL }
			obj4 = 1 
			Scl.MatchArrays(obj1, obj2, obj3, obj4)
	>>return { EFFECT_CANNOT_BE_FUSION_MATERIAL, EFFECT_CANNOT_BE_LINK_MATERIAL }, { 1, 1 }, EFFECT_CANNOT_BE_FUSION_MATERIAL, 1
--]]
function Scl.MatchArrays(obj1, obj2, obj3, obj4)
	local arr1 = Scl.UniformSclParamaFormat(obj1)
	local arr2 = Scl.UniformSclParamaFormat(obj2)
	local arr3 = obj3
	local arr4 = obj4
	if type(obj4) ~= "arr" then
		arr4 = { obj4 }
	end
	local res_arr1, res_arr2 = { }, { }
	for idx1, obj1 in ipairs(arr1) do
		for idx2, obj2 in ipairs(arr2) do
			if obj1 == obj2 then
				table.insert(res_arr1, obj3[idx2]) 
				if #arr4 == 1 then
				   table.insert(res_arr2, arr4[1])
				else
				   table.insert(res_arr2, arr4[idx1])
				end
			end
		end
	end
	return res_arr1, res_arr2, res_arr1[1], res_arr2[1]
end
--Check is the array has an secified element.
--//return is exist, that element's index in the array(if not exist, return 0).
-->>eg1. Scl.IsArrayContains_Single({a,b,c,d}, c)
-->>return true, 3
--other function: Find correct element in table
function s.IsArrayContains_Base(chk_typ, base_arr, ...)
	local res_arr = { }
	for idx, chk_obj in pairs({ ... }) do 
		local exist_res, exist_idx = Scl.IsArrayContains_Single(base_arr, chk_obj)
		if chk_typ == "normal" then
			table.insert(res_arr, exist_res)
			table.insert(res_arr, exist_idx)
		elseif chk_typ == "or" then
			if exist_res then
				return true
			end
		elseif chk_typ == "and" then
			if not exist_res then
				return false
			end
		end 
	end
	if chk_typ == "normal" then
		return table.unpack(res_arr)
	elseif chk_typ == "or" then 
		return false 
	elseif chk_typ == "and" then
		return true
	end
end
function Scl.IsArrayContains_Single(base_arr, chk_obj)
	local exist_res, exist_idx = false, 0
	for idx, obj in pairs(base_arr) do 
		if obj == chk_obj then
			exist_res = true
			exist_idx = idx 
			break
		end
	end
	return exist_res, exist_idx
end
--Check is the array has an secified element(s).
--//return is the 1st element exist, that element's index in the array(if not exist, return 0), is the 2nd element exist, that element's index in the array(if not exist, return 0), and so on ...
-->>eg1. Scl.IsArrayContains({a,b,c,d}, a,c,f)
-->>return true, 1, true, 3, false, 0
function Scl.IsArrayContains(...)
	return s.IsArrayContains_Base("normal", ...)
end
--Check is the array has any 1 secified element(s).
--//return is exist.
-->>eg1. Scl.IsArrayContains({a,b,c,d}, a,f,g)
-->>return true
-->>eg2. Scl.IsArrayContains({a,b,c,d}, f,g)
-->>return false
function Scl.IsArrayContains_OR(...)
	return s.IsArrayContains_Base("or", ...)
end
--Check is the array has all secified element(s).
--//return is exist.
-->>eg1. Scl.IsArrayContains({a,b,c,d}, a,c,d)
-->>return true
-->>eg2. Scl.IsArrayContains({a,b,c,d}, a,b,c,f)
-->>return false
function Scl.IsArrayContains_AND(...)
	return s.IsArrayContains_Base("and", ...)
end
--Find if 2 arrays has an intersection.
--//return is has, the intersection.
-->>eg1. Scl.IsArraysHasIntersection({ 1,2,3,4 },  { 1,3,5,7 })
-->>return true, { 1, 3 }
function Scl.IsArraysHasIntersection(arr1, arr2)
	local istn = { }
	for _,  elm1 in pairs(arr1) do 
		for _, elm2 in pairs(arr2) do
			if elm1 == elm2 then
				table.insert(istn,  elm1)
			end
		end
	end
	return #istn > 0,  istn
end
--Clone an array, the base array won't be changed by this function.
--//return the new array.
-->>eg1. Scl.CloneArray({1,2,3})
-->>return {1,2,3}
function Scl.CloneArray(arr)
	local arr2 = { }
	if not arr then
		local e, c1, tp, c2, id = Scl.GetCurrentEffectInfo()
		Debug.Message(id .. "error - nil array, scl test.")
		return { }
	end
	for idx, elm in pairs(arr) do
		if type(elm) == "table" then
			arr2[idx] = Scl.CloneArray(elm)
		else
			arr2[idx] = elm
		end
	end
	return arr2
end
--Mix 2+ arrays in to a new array.
--//return the new array.
--error at "nil" value !!!!!!!!!
--error at no number key !!!!!!!!!
-->>eg. Scl.MixArrays({1,2,3,4}, {1,4,5,6}, {"a","b","c"})
-->>return {1,2,3,4,1,4,5,6,"a","b","c"}
function Scl.MixArrays(...)
	local res_arr = { }
	local big_arr = { ... }
	local len = 0
	for _, arr in pairs(big_arr) do
		for _, elm in pairs(arr) do 
			--table.insert(res_list, val)
			
			len = len + 1
			res_arr[len] = elm
		end
	end
	return res_arr
end
--Check is the chk_obj is a boolean-type element, and is equal to bool.
--bool default true.
--//return is equal 
-->>eg1. Scl.CheckBoolean("false")
-->>return false
-->>eg2. Scl.CheckBoolean(true)
-->>return true
-->>eg3. Scl.CheckBoolean(true, false)
-->>return false
function Scl.CheckBoolean(chk_obj, bool)
	if type(bool) == "nil" or bool == true then return 
		type(chk_obj) == "boolean" and chk_obj == true
	else
		return type(chk_obj) == "boolean" and chk_obj == false
	end
end 
--Split a number to different power-of-2 number's sum. 
--//return the splitted array.
-->>eg1. Scl.SplitNumber2PowerOf2(3) 1111
-->>return { 1, 2 }
-->>eg1. Scl.SplitNumber2PowerOf2(15)
-->>return { 1, 2, 4, 8 }
function Scl.SplitNumber2PowerOf2(num)
	local arr = { }
	local dec_str = Scl.Dec2Hex(num)
	dec_str = string.sub(dec_str, 3)
	local bin_str = Scl.Hex2Bin(dec_str)
	local digit = 0
	local sgl_num_str
	for len = string.len(bin_str), 1, -1 do
		sgl_num_str = string.sub(bin_str, len, len)
		if sgl_num_str == "1" then 
			table.insert(arr, 0x0001<<(digit))
		end
		digit = digit + 1
	end
	return arr
end
--Get elements in a number-index array (base_arr), from base_arr[st_idx] to base_arr[fns_idx].
--//return base_arr[start], base_arr[start + 1], ..., base_arr[fns]
-->>eg1. Scl.GetArrayElementsByNumIndex({ 1, 2, "a", 3, "b" }, 2, 4)
-->>return 2, "a", 3, "b"
function Scl.GetArrayElementsByNumIndex(base_arr, start, fns)
	local new_arr = { }
	for idx = start, fns do
		table.insert(new_arr, base_arr[idx])
	end
	return table.unpack(new_arr)
end
--Add cards from a card group into an array
--//return that array 
-->>eg1. Scl.Group2CardList(Group.FromCards(c1, c2, c3, c4))
-->>return { c1, c2, c3, c4 }
function Scl.Group2CardList(g)
	local arr = { }
	for tc in aux.Next(g) do 
		table.insert(arr, tc)
	end
	return arr
end 
--Get the kinds of elements in array
--//return kinds number
-->>eg1. Scl.GetValuesKindsFromArray({ 1, 1, 4, 5, 1, 4 })
-->>return 3 (1/4/5)
function Scl.GetValuesKindsFromArray(arr)
	local arr2 = { }
	for _, val in pairs(arr) do
		table.insert(arr2, val)
	end
	local kind = 0
	for idx, val in pairs(arr2) do
		if idx == #arr2 then 
			kind = kind + 1
		else
			local res = true
			for idx2 = idx + 1, #arr2 do
				if arr2[idx2] == val then
					res = false
					break
				end
			end
			if res then
				kind = kind + 1
			end
		end
	end
	return kind
end


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<< Enable Global Effects <<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

s.create_timing_list()
s.create_category_list()
s.create_buff_list()
s.record_previous_inside_series()
s.previous_xyz_material_record()
s.record_official_filter()
s.add_current_effect_check()
s.add_type_normal_spell_or_trap_scl()
Scl.RaiseGlobalSetEvent()


--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<< Custom Cards <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

--[[

10100000 -- Scl's library		  QQ852415212

60152900 -- LaiBill's library	  QQ529508379
			B2Sayaka -- "Miki Sayaka"
			

]]--

--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<< Update Log <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


--[[

2022.12.25 fix Scl.CreateFieldTriggerContinousEffect_PhaseOpearte
			Turn the wrong flag string "IgnoreImmune" to the right string "IgnoreUnaffected".
			
2022.12.28 fix EFFECT_ACTIVATE_SPELL_AND_TRAP_FROM_ANY_ZONE_SCL
			Add an zone check (current zone == activate zone) before cost check. (due to 130006007 "决斗者的最后之日" can activate in any zone.)
			
2022.02.09 fix some format error cause the library cannot be correct read.

--]]