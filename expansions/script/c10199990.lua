--This is real scl's old library, it is out of support.
--I have try my best to transferred meaning of the old scripts to the new scripts. 
--New scripts is in my new library, c10100000.lua, its much more easy-reading and easy-using than this f*ck old library.
--If a card scripted by using this old library is need be fixed bugs or changed effects, I will use the new library to rescript that card, instead of continuing to use this old library.
--There are still many bugs that I haven't found, so if you find any, its welcome to call my QQ/VX 852415212, or email me: 15161685390@163.com, PLZ note sth. about YGO while you add me, otherwise I will reject your friend request.

local Version_Number = "2022.11.02"


if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
if rsv then return end
local s = {}
rsv = { }  --"Base Function"
rscf = { }   --"Card Function"
rsgf = { }   --"Group Function"
rsef = { }   --"Effect Function"
rszsf = { }  --"Zone Sequence Function"
rsof = { }   --"Other Function"
rssf = { }   --"Summon Function"
rscode = { }   --"Code Function"
rsval = { }  --"Value Function"
rscon = { }  --"Condition Function"
rscost = { }   --"Cost Function"
rstg = { }   --"Target Function"
rsop = { }   --"Operation Function"
rscate = { }   --"Category Function"
rsflag = { }   --"Property Function"
rsrst = { }   --"Reset Function"
rshint = { }   --"Hint Function"
rsloc = { } --"Location Function"

rsrst.ep  =   RESET_EP_SCL
rsrst.sp = RESET_SP_SCL
rsrst.bp = RESET_BP_SCL
rsrst.std  =   RESETS_SCL
rsrst.std_dis   =   RESETS_DISABLE_SCL
rsrst.std_ntf = RESETS_WITHOUT_TO_FIELD_SCL
rsrst.std_ep =   RESETS_EP_SCL
rsrst.ret =   RESETS_REDIRECT_SCL

rscode.Attach_Effect   =   EFFECT_ADDITIONAL_EFFECT_SCL
rscode.Phase_Leave_Flag   =   FLAG_PHASE_OPERATE_SCL
rscode.Extra_Synchro_Material =  EFFECT_EXTRA_SYNCHRO_MATERIAL_SCL
rscode.Extra_Xyz_Material   =   EFFECT_EXTRA_XYZ_MATERIAL_SCL
rscode.Utility_Xyz_Material =   EFFECT_UTILITY_XYZ_MATERIAL_SCL
rscode.Previous_Set_Code    =   FLAG_PREVIOUS_XYZ_MATERIAL_SCL
rscode.Pre_Complete_Proc = EFFECT_COMPLETE_SUMMON_PROC_SCL
rscode.Set  =  EVENT_SET_SCL

rsloc.hd = LOCATION_HAND+LOCATION_DECK 
rsloc.hm = LOCATION_HAND+LOCATION_MZONE 
rsloc.ho = LOCATION_HAND+LOCATION_ONFIELD
rsloc.hg = LOCATION_HAND+LOCATION_GRAVE  
rsloc.dg = LOCATION_DECK+LOCATION_GRAVE 
rsloc.gr = LOCATION_GRAVE+LOCATION_REMOVED 
rsloc.dgr = LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED 
rsloc.hdg = LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE 
rsloc.de = LOCATION_DECK+LOCATION_EXTRA 
rsloc.mg = LOCATION_MZONE+LOCATION_GRAVE 
rsloc.og = LOCATION_ONFIELD+LOCATION_GRAVE 
rsloc.hmg = LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE 
rsloc.hog = LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE 
rsloc.all = 0xff 

s.sum_list = {

        ["sp"] = "SpecialSummon", ["adv"] = "TributeSummon", ["rit"] = "RitualSummon"
      , ["fus"] = "FusionSummon", ["syn"] = "SynchroSummon", ["xyz"] = "XyzSummon"
      , ["link"] = "LinkSummon", ["pen"] = "PendulumSummon"

}

s.flag_list =   { 
    
        ["tg"] = "Target", ["ptg"] = "PlayerTarget", ["de"] = "Delay", ["dsp"] = "DamageStep" 
      , ["dcal"] = "DamageCalculation", ["ii"] = "IgnoreImmune", ["sa"] = "SetAvailable", ["ir"] = "IgnoreZone" 
      , ["sr"] = "BuffZone", ["bs"] = "BothSide", ["uc"] = "Uncopyable" 
      , ["ch"] = "ClientHint", ["lz"] = "LimitActivateZone", ["atg"] = "AbsoluteTarget" 
      , ["sp"] = "SummonParama", ["ep"] = "EventPlayer", ["oa"] = "Oath" , ["ntr"] = "NoTurnReset" 
      , ["neg~"] = "!NegateActivation" 
      , ["cn"] = "!NegateEffect", ["dise~"] = "!NegateEffect2" 
      , ["cd"] = "!NegateEffect" , ["dis~"] = "!NegateEffect" 

}   


s.ctgy_list =   {

        ["des"] = "Destroy"
      , ["rdes"] = "DestroyReplace"
      , ["res"] = "Tribute"
      , ["rm"] = "Banish"
      , ["rmd"] = "BanishFacedown"
      , ["se"] = "Search"
      , ["th"] = "Add2Hand"
      , ["rth"] = "Return2Hand"
      , ["td"] = "ShuffleIn2Deck"
      , ["tdt"] = "ShuffleIn2DeckTop"
      , ["tdb"] = "ShuffleIn2DeckBottom"
      , ["ptdt"] = "PlaceOnDeckTop"
      , ["ptdb"] = "PlaceOnDeckBottom"
      , ["te"] = "Return2Extra"
      , ["tde"] = "ShuffleIn2Deck/ExtraAsCost"
      , ["pte"] = "Add2ExtraFaceup"
      , ["tg"] = "Send2GY"
      , ["rtg"] = "Return2GY"
      , ["dtg"] = "Discard2GY"
      , ["dish"] = "Discard"
      , ["dh"] = "Discard"
      , ["dishf"] = "DiscardWithFilter"
      , ["dhf"] = "DiscardWithFilter"
      , ["disd"] = "SendDeckTop2GY"
      , ["dd"] = "SendDeckTop2GY"
      , ["dr"] = "Draw"
      , ["dam"] = "Damage"
      , ["rec"] = "GainLP"
      , ["sum"] = "NormalSummon"
      , ["tk"] = "Token"
      , ["sp"] = "SpecialSummon"
      , ["cp"] = "ChangePosition"
      , ["pos"] = "ChangePosition"
      , ["upa"] = "Change2AttackPosition"
      , ["upd"] = "Change2FaceupDefensePosition"
      , ["dpd"] = "Change2FacedownDefensePosition"
      , ["posd"] = "Change2DefensePosition"
      , ["ctrl"] = "ChangeControl"
      , ["con"] = "ChangeControl"
      , ["sctrl"] = "SwitchControl"
      , ["dis"] = "NegateEffect"
      , ["diss"] = "NegateSummon"
      , ["neg"] = "NegateActivation"
      , ["eq"] = "Equip"
      , ["atk"] = "ChangeATK"
      , ["def"] = "ChangeDEF"
      , ["ct"] = "PlaceCounter"
      , ["pct"] = "PlaceCounter"
      , ["rmct"] = "RemoveCounter"
      , ["coin"] = "TossCoin"
      , ["dice"] = "TossDice"
      , ["an"] = "AnnounceCard"
      , ["lv"] = "ChangLevel"
      , ["fus"] = "FusionSummon"
      , ["ga"] = "GYAction"
      , ["gsp"] = "SpecialSummonFromGY"
      , ["lg"] = "LeaveGY"
      , ["cf"] = "Look"
      , ["rv"] = "Reveal"
      , ["rvep"] = "RevealUntilEP"
      , ["tf"] = "PlaceOnField"
      , ["act"] = "ActivateCard"
      , ["rf"] = "Return2Field"
      , ["rtf"] = "Return2Field"
      , ["ae"] = "ApplyEffect"
      , ["set"] = "SetSpell/Trap"
      , ["sset"] = "SetSpell/Trap"
      , ["xmat"] = "AttachXyzMaterial"
      , ["axmat"] = "AttachXyzMaterial"
      , ["rxmat"] = "DetachXyzMaterial"
      , ["rmxmat"] = "DetachXyzMaterial"
      , ["ms"] = "MoveZone"
      , ["dum"] = "Dummy"
      , ["self"] = "Self"
      , ["oppo"] = "Opponent"

}

s.buff_code_list = {

		["atk"] = "=ATK", 
		["def"] = "=DEF", 
		["batk"] = "=BaseATK", 
		["bdef"] = "=BaseDEF", 
		["fatk"] = "=FinalATK", 
		["fdef"] = "=FinalDEF", 
		["atkf"] = "=FinalATK", 
		["deff"] = "=FinalDEF", 
		["lv"] = "=Level", 
		["rk"] = "=Rank", 
		["ls"] = "=LeftScale", 
		["rs"] = "=RightScale", 
		["code"] = "=Name", 
		["att"] = "=Attribute", 
		["race"] = "=Race", 
		["type"] = "=Type", 
		["fatt"] = "=FusionAttribute", 
		["datk"] = "=BattleATK", 
		["ddef"] = "=BattleDEF", 
		["atk+"] = "+ATK", 
		["def+"] = "+DEF", 
		["lv+"] = "+Level", 
		["rk+"] = "+Rank", 
		["ls+"] = "+LeftScale", 
		["rs+"] = "+RightScale", 
		["code+"] = "+Name", 
		["att+"] = "+Attribute", 
		["race+"] = "+Race", 
		["set+"] = "+Series", 
		["type+"] = "+Type", 
		["fatt+"] = "+FusionAttribute", 
		["fcode+"] = "+FusionName", 
		["fset+"] = "+FusionSeries", 
		["latt+"] = "+LinkAttribute", 
		["lrace+"] = "+LinkRace", 
		["lcode+"] = "+LinkName", 
		["lset+"] = "+LinkSeries", 
		["type-"] = "-Type", 
		["race-"] = "-Race", 
		["att-"] = "-Attribute", 
		["indb"] = "!BeDestroyedByBattle", 
		["inde"] = "!BeDestroyedByEffect", 
		["indct"] = "!BeDestroyedCountPerTurn", 
		["ind"] = "!BeDestroyed", 
		["im"] = "ImmuneEffect", 
		["fmat~"] = "!BeUsedAsFusionMaterial", 
		["fsmat~"] = "!BeUsedAsMaterial4FusionSummon", 
		["smat~"] = "!BeUsedAsSynchroMaterial", 
		["ssmat~"] = "!BeUsedAsMaterial4SynchroSummon", 
		["xmat~"] = "!BeUsedAsXyzMaterial", 
		["xsmat~"] = "!BeUsedAsMaterial4XyzSummon", 
		["lmat~"] = "!BeUsedAsLinkMaterial", 
		["lsmat~"] = "!BeUsedAsMaterial4LinkSummon", 
		["tgb~"] = "!BeBattleTarget", 
		["tge~"] = "!BeEffectTarget", 
		["dis"] = "NegateEffect", 
		["dise"] = "NegateActivatedEffect", 
		["tri~"] = "!Activated", 
		["atk~"] = "!Attack", 
		["atkan~"] = "!AttackAnnounce", 
		["atkd~"] = "!AttackDirectly", 
		["ress~"] = "!BeTributed4TributeSummon", 
		["resns~"] = "!BeTributedExcept4TributeSummon", 
		["td~"] = "!Return2Deck", 
		["th~"] = "!Add2Hand", 
		["cost~"] = "!BeUsedAsCost", 
		["rm~"] = "!Banish", 
		["ctrl~"] = "!SwitchControl", 
		["distm"] = "NegateTrapMonster", 
		["pos~"] = "!ChangePosition", 
		["pose~"] = "!ChangePositionByEffect", 
		["cp~"] = "!ChangePosition", 
		["cpe~"] = "!ChangePositionByEffect", 
		["act~"] = "!Activate", 
		["sum~"] = "!NormalSummon", 
		["sp~"] = "!SpecialSummon", 
		["dr~"] = "!Draw", 
		["tg~"] = "!Send2GY", 
		["res~"] = "!Tribute", 
		["sset~"] = "!SetSpell&Trap", 
		["mset~"] = "!NormalSet", 
		["dh~"] = "!Discard", 
		["dd~"] = "!SendDeckTop2GY", 
		["fp~"] = "!FilpSummon", 
		["tgc~"] = "!BeSent2GYAsCost", 
		["sbp"] = "SkipBP", 
		["sm1"] = "SkipM1", 
		["sm2"] = "SkipM2", 
		["sdp"] = "SkipDP", 
		["ssp"] = "SkipSP", 
		["rtg"] = "Instead2GY", 
		["rtd"] = "Instead2Deck", 
		["rth"] = "Instead2Hand", 
		["rlf"] = "InsteadLeaveField", 
		["rlve"] = "InsteadLeaveField", 
		["leave"] = "InsteadLeaveField", 
		["qah"] = "ActivateQuickPlaySpellFromHand", 
		["qas"] = "ActivateQuickPlaySpellInSetTurn", 
		["tah"] = "ActivateTrapFromHand", 
		["tas"] = "ActivateTrapInSetTurn", 
		["atkex"] = "+AttackCount", 
		["atkexm"] = "+AttackMonsterCount", 
		["atka"] = "AttackAll", 
		["pce"] = "Pierce", 
		["atkd"] = "AttackDirectly", 
		["atkpd"] = "AttackInDefensePosition", 
		["dis~"] = "!NegateEffect", 
		["dsum~"] = "!NegateNormalSummon", 
		["dsp~"] = "!NegateSpecialSummon", 
		["dfp~"] = "!NegateFlipSummon", 
		["rdam"] = "OpponentTakeDamageInstead", 
		["rdamb"] = "OpponentTakeBattleDamageInstead", 
		["dise~"] = "!NegateActivatedEffect", 
		["neg~"] = "!NegateActivation", 
		["mat"] = "SetMaterial", 
		["ormat"] = "XyzMaterial4ExtraRitualTribute", 
		["grmat"] = "ExtraRitualTribute", 
		["fmat"] = "ExtraFusionMaterial" 

}

--Old functions
rsef.CreatEvent = Scl.RaiseGlobalEvent
rsef.CreatEvent_Set = Scl.RaiseGlobalSetEvent
rsef.SetChainLimit= Scl.SetChainLimit
s.clone_list = {

	["code"] = "Code", 	["desc"] = "Description", 	["flag"] = "Property", ["cate"] = "Category", 
	["reset"] = "Reset", ["type"] = "Type", ["con"] = "Condition", ["tg"] = "Target", ["cost"] = "Cost",
	["op"] = "Operation", ["value"] = "Value", ["loc"] = "Zone", ["tgrng"] = "TargetRange"
}
function rsef.RegisterClone(...)
	local new_arr = { }
	for _, elm in pairs({ ... }) do
		if type(elm) == "string" then
			table.insert(new_arr, s.clone_list[elm])
		else
			table.insert(new_arr, elm)
		end
	end
	return Scl.CloneEffect(table.unpack(new_arr))
end
rsef.RegisterOPTurn = Scl.CloneEffectAsQucikEffect
rsef.QO_OPPONENT_TURN = Scl.CloneEffectAsQucikEffect
rsef.RegisterSolve = Scl.RegisterSolvePart
Effect.RegisterSolve = Scl.RegisterSolvePart
function s.get_default_range(reg_obj)
    local reg_range
    local reg_owner, reg_handler = Scl.GetRegisterInfo(reg_obj)
    if aux.GetValueType(reg_handler) ~= "Card" then return nil end
    --(TYPE_PENDULUM , LOCATION_PZONE must manual input)
    local type_list = { TYPE_MONSTER, TYPE_FIELD, TYPE_SPELL + TYPE_TRAP }
    local reg_obj = { LOCATION_MZONE, LOCATION_FZONE, LOCATION_SZONE }
    for idx, card_type in pairs(type_list) do
        if reg_handler:IsType(card_type) then 
            reg_range = reg_obj[idx]
            break 
        end
    end
    --after begain duel 
    --if Duel.GetTurnCount() > 0 then reg_range = reg_handler:GetLocation() end
    return reg_range 
end
function s.switch_old_string(desc_obj, ctgy, flag, buff_code)
	local desc_obj2 = type(desc_obj) == "string" and s.ctgy_list[desc_obj] or desc_obj
	local ctgy2
	if ctgy then
		ctgy2 = ""
		if type(ctgy) == "string" then
			local arr = Scl.SplitString(ctgy)
			for idx, str in pairs(arr) do 
				if idx > 1 then 
					ctgy2 = ctgy2 .. ","
				end
				ctgy2 = ctgy2 .. s.ctgy_list[str]
			end
		else
			ctgy2 = ctgy
		end
	end
	local flag2
	if flag then
		flag2 = ""
		if type(flag) == "string" then
			local arr = Scl.SplitString(flag)
			for idx, str in pairs(arr) do 
				if idx > 1 then 
					flag2 = flag2 .. ","
				end
				flag2 = flag2 .. s.flag_list[str]
			end
		else
			flag2 = flag
		end
	end
	local buff_code2 
	if buff_code then
		buff_code2 = ""
		if type(buff_code) == "string" then
			local arr = Scl.SplitString(buff_code)
			for idx, str in pairs(arr) do 
				if idx > 1 then 
					buff_code2 = buff_code2 .. ","
				end
				buff_code2 = buff_code2 .. s.buff_code_list[str]
			end
		elseif type(buff_code) == "table" then
			for idx, buff_str in pairs(buff_code) do
				if idx > 1 then
					buff_code2 = buff_code2 .. ","
				end
				--buff_code2 = buff_code2 .. buff_str
				buff_code2 = buff_code2 .. s.buff_code_list[buff_str]
			end
		else
			buff_code2 = buff_code
		end
	end
	return desc_obj2, ctgy2, flag2, buff_code2
end
function s.switch_old_count_limit(lim_obj)
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
					 (type(val) == "string" and val == "s") then
					lim_code = EFFECT_COUNT_CODE_SINGLE 
				else
					lim_code = lim_obj[2]
				end
			elseif #lim_obj == 3 then
				lim_ct = lim_obj[1]
				lim_code = lim_obj[2] or 0
				local val = lim_obj[3]
				if (type(val) == "number" and val == 1) or
					 (type(val) == "string" and val == "o") then 
					lim_code = lim_code + EFFECT_COUNT_CODE_OATH 
				elseif (type(val) == "number" and val == 1) or
					 (type(val) == "string" and val == "d") then
					lim_code = lim_code + EFFECT_COUNT_CODE_DUEL 
				elseif (type(val) == "number" and val == 3) or
					 (type(val) == "string" and val == "s") then
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
		if lim_code then
			return { lim_ct, lim_code }
		else
			return lim_ct
		end
	else
		return nil
	end
end
function rsef.GetRegisterCategory(reg, ctgy)
	local _, ctgy2 = s.switch_old_string(0, ctgy)
	return Scl.GetNumFormatCategory(ctgy2)
end
function rsef.GetRegisterProperty(reg, flag)
	local _, _, flag2 = s.switch_old_string(0, 0, flag)
	return Scl.GetNumFormatProperty(flag2)
end
function rsef.SV_ActivateDirectly_Special(reg_obj, act_loc, con, rst_obj, desc_obj, timing_list)
	return Scl.CreateSingleBuffCondition(reg_obj, "ActivateCardFromAnyZone", act_loc, 0xff, con, rst_obj, desc_obj)
end
function rsef.SV_CannotDisable_NoEffect()
	return Scl.CreateSingleBuffCondition(reg_obj, "!NegateEffect,!NegateActivatedEffect", 1)
end
function rsef.SV_Card(reg_obj, att_obj, val_obj, flag, range, con, rst_obj, desc_obj, lim_obj, affect_self)
	local _, _, flag2, att_obj2 = s.switch_old_string(0, 0, flag, att_obj)
	local flag3 = Scl.GetNumFormatProperty(flag2)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	if flag3 & EFFECT_FLAG_UNCOPYABLE ~= 0 then
		return Scl.CreateSingleBuffCondition(reg_obj, att_obj2, val_obj, range, con, rst_obj, desc_obj2, lim_obj2, flag2)
	else
		return Scl.CreateSingleBuffEffect(reg_obj, att_obj2, val_obj, range, con, rst_obj, desc_obj2, lim_obj2, flag2)
	end
end
function rsef.EQ_Card(reg_obj, att_obj, val_obj, flag, con, rst_obj, desc_obj, lim_obj, affect_self)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	local _, _, flag2, att_obj2 = s.switch_old_string(0, 0, flag, att_obj)
	return Scl.CreateEquipBuffEffect(reg_obj, att_obj2, val_obj, con, rst_obj, desc_obj, lim_obj2, flag2)
end
function rsef.FV_Card(reg_obj, att_obj, val_obj, tg, tgrng_obj, flag, range, con, rst_obj, desc_obj, lim_obj)
	if not range and not rst_obj and aux.GetValueType(reg_obj) == "Card" then
		range = s.get_default_range(reg_obj)
	end
	local _, _, flag2, att_obj2 = s.switch_old_string(0, 0, flag, att_obj)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	local list = Scl.SplitString(att_obj2)
	if Scl.Effect_Buff_Code_List[list[1]] then
		return Scl.CreateEffectBuffEffect(reg_obj, att_obj2, val_obj, range, con, rst_obj, desc_obj, lim_obj, flag)
	else
		return Scl.CreateFieldBuffEffect(reg_obj, att_obj2, val_obj, tg, tgrng_obj, range, con, rst_obj, desc_obj, lim_obj2, flag2)
	end
end
function rsef.FV_Player(reg_obj, att_obj, val_obj, tg, tgrng_obj, flag, range, con, rst_obj, desc_obj, lim_obj)
	if not range and not rst_obj and aux.GetValueType(reg_obj) == "Card" then
		range = s.get_default_range(reg_obj)
	end
	local _, _, flag2, att_obj2 = s.switch_old_string(0, 0, flag, att_obj)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreatePlayerBuffEffect(reg_obj, att_obj2, val_obj, tg, tgrng_obj, range, con, rst_obj, desc_obj, lim_obj2, flag2)
end
function rsef.FV_ExtraMaterial(reg_obj, mat, val_obj, tg, tgrng_obj, con, rst_obj, flag, desc_obj, lim_obj, range)
	local att
	if mat == "xyz" then 
		att = "ExtraXyzMaterial"
	elseif mat == "link" then
		att = "ExtraLinkMaterial"
	end
	local _, _, flag2 = s.switch_old_string(0, 0, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateFieldBuffEffect(reg_obj, att, val_obj, tg, tgrng_obj, 0xff, con, rst_obj, desc_obj, lim_obj2, flag2)
end
function rsef.FV_ExtraMaterial_Self(reg_obj, mat, val_obj, tg, tgrng_obj, con, rst_obj, flag, desc_obj, lim_obj)
	local att
	if mat == "xyz" then 
		att = "ExtraXyzMaterial"
	elseif mat == "link" then
		att = "ExtraLinkMaterial"
	end
    local val_obj2 = val_obj or { function(e, c, mg) return c == e:GetHandler(), true end }
	local _, _, flag2 = s.switch_old_string(0, 0, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateFieldBuffEffect(reg_obj, att, val_obj2, tg, tgrng_obj, LOCATION_EXTRA, con, rst_obj, desc_obj, lim_obj2, flag2)
end
function rsef.FV_UTILITY_XYZ_MATERIAL(reg_obj, val_obj, tg, tg_range_list, con, rst_obj, flag, desc_obj, lim_obj, range)
	local _, _, flag2 = s.switch_old_string(0, 0, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateFieldBuffEffect(reg_obj, "UtilityXyzMaterial", val_obj, tg, tg_range_list, 0xff, con, rst_obj, desc_obj, lim_obj2, flag2)
end
function rsef.A(reg_obj, code, desc_obj, lim_obj, ctgy, flag, con, cost, tg, op, tmg_obj, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateActivateEffect(reg_obj, code, desc_obj2, lim_obj2, ctgy2, flag2, con, cost, tg, op, tmg_obj, rst_obj)
end
function rsef.A_NegateEffect(reg_obj, op_str, lim_obj, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	local desc_obj2, ex_ctgy2, ex_flag2 = s.switch_old_string(desc_obj, ex_ctgy, ex_flag)
	local op_str2 = s.ctgy_list[op_str]
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateActivateEffect_NegateEffect(reg_obj, op_str2, lim_obj2, con, cost, ex_ctgy2, ex_flag2, ex_tg, ex_op, desc_obj2, rst_obj)
end
function rsef.A_NegateActivation(reg_obj, op_str, lim_obj, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	local desc_obj2, ex_ctgy2, ex_flag2 = s.switch_old_string(desc_obj, ex_ctgy, ex_flag)
	local op_str2 = s.ctgy_list[op_str]
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateActivateEffect_NegateActivation(reg_obj, op_str2, lim_obj2, con, cost, ex_ctgy2, ex_flag2, ex_tg, ex_op, desc_obj2, rst_obj)
end
rsef.A_Equip = Scl.CreateActivateEffect_Equip
function rsef.STO(reg_obj, code, desc_obj, lim_obj, ctgy, flag, con, cost, tg, op, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateSingleTriggerOptionalEffect(reg_obj, code, desc_obj2, lim_obj2, ctgy2, flag2, con, cost, tg, op, rst_obj)
end
function rsef.STF(reg_obj, code, desc_obj, lim_obj, ctgy, flag, con, cost, tg, op, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateSingleTriggerMandatoryEffect(reg_obj, code, desc_obj2, lim_obj2, ctgy2, flag2, con, cost, tg, op, rst_obj)
end
function rsef.STO_Flip(reg_obj, desc_obj, lim_obj, ctgy, flag, con, cost, tg, op, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateFlipOptionalEffect(reg_obj, desc_obj2, lim_obj2, ctgy2, flag2, con, cost, tg, op, rst_obj)				
end
function rsef.STF_Flip(reg_obj, desc_obj, lim_obj, ctgy, flag, con, cost, tg, op, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateFlipMandatoryEffect(reg_obj, desc_obj2, lim_obj2, ctgy2, flag2, con, cost, tg, op, rst_obj)				
end
function rsef.FTO(reg_obj, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateFieldTriggerOptionalEffect(reg_obj, code, desc_obj2, lim_obj2, ctgy2, flag2, rng, con, cost, tg, op, rst_obj)
end
function rsef.FTF(reg_obj, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateFieldTriggerMandatoryEffect(reg_obj, code, desc_obj2, lim_obj2, ctgy2, flag2, rng, con, cost, tg, op, rst_obj)
end
function rsef.I(reg_obj, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateIgnitionEffect(reg_obj, desc_obj2, lim_obj2, ctgy2, flag2, rng, con, cost, tg, op, rst_obj)
end
function rsef.QO(reg_obj, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, tmg_obj, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateQuickOptionalEffect(reg_obj, code, desc_obj2, lim_obj2, ctgy2, flag2, rng, con, cost, tg, op, tmg_obj, rst_obj)
end
function rsef.QO_NegateEffect(reg_obj, op_str, lim_obj, rng, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	local desc_obj2, ex_ctgy2, ex_flag2 = s.switch_old_string(desc_obj, ex_ctgy, ex_flag)
	local op_str2 = not op_str and "Dummy" or s.ctgy_list[op_str]
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateQuickOptionalEffect_NegateEffect(reg_obj, op_str2, lim_obj2, rng, con, cost, ex_ctgy2, ex_flag2, ex_tg, ex_op, desc_obj2, rst_obj)
end
function rsef.QO_NegateActivation(reg_obj, op_str, lim_obj, rng, con, cost, ex_ctgy, ex_flag, ex_tg, ex_op, desc_obj, rst_obj)
	local desc_obj2, ex_ctgy2, ex_flag2 = s.switch_old_string(desc_obj, ex_ctgy, ex_flag)
	local op_str2 = not op_str and "Dummy" or s.ctgy_list[op_str]
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateQuickOptionalEffect_NegateActivation(reg_obj, op_str2, lim_obj2, rng, con, cost, ex_ctgy2, ex_flag2, ex_tg, ex_op, desc_obj2, rst_obj)
end
function rsef.QF(reg_obj, code, desc_obj, lim_obj, ctgy, flag, rng, con, cost, tg, op, tmg_obj, rst_obj)
	local desc_obj2, ctgy2, flag2 = s.switch_old_string(desc_obj, ctgy, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateQuickMandatoryEffect(reg_obj, code, desc_obj2, lim_obj2, ctgy2, flag2, rng, con, cost, tg, op, tmg_obj, rst_obj)
end
function rsef.FC(reg_obj, code, desc_obj, lim_obj, flag, rng, con, op, rst_obj)
	local _, _, flag2 = s.switch_old_string(0, 0, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateFieldTriggerContinousEffect(reg_obj, code, desc_obj, lim_obj2, flag2, rng, con, op, rst_obj)
end
function rsef.FC_DestroyReplace(reg_obj, lim_obj, range, repfilter, tg, op, con, flag, rst_obj)
	local _, _, flag2 = s.switch_old_string(0, 0, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateFieldTriggerContinousEffect_DestroyReplace(reg_obj, lim_obj2, range, repfilter, tg, op, con, false, flag2, rst_obj)
end
function rsef.FC_PhaseOpearte(reg_obj, op_obj, times, whos, phase, ex_con, fun_obj)
	local _, fun_obj2 = s.switch_old_string(0, fun_obj)
	return Scl.CreateFieldTriggerContinousEffect_PhaseOpearte(reg_obj, op_obj, times, whos, phase, ex_con, fun_obj2)
end
rsef.FC_Global = Scl.SetGlobalFieldTriggerEffect
function rsef.FC_Easy(reg_obj, code, flag, range, con, op, rst_obj)
	return rsef.FC(reg_obj, code, nil, nil, flag, range, con, op, rst_obj)
end
function rsef.SC(reg_obj, code, desc_obj, lim_obj, flag, con, op, rst_obj)
	local _, _, flag2 = s.switch_old_string(0, 0, flag)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateSingleTriggerContinousEffect(reg_obj, code, desc_obj, lim_obj2, flag2, con, op, rst_obj)
end
function rsef.SC_Easy(reg_obj, code, flag, con, op, reset_obj)
    return rsef.SC(reg_obj, code, nil, nil, flag, con, op, reset_obj)
end
function rsef.SC_DestroyReplace(reg_obj, lim_obj, repfilter, tg, op, con, flag, rst_obj)
	local _, _, flag2 = s.switch_old_string(0, 0, flag)
	local rng2 = s.get_default_range(reg_obj)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.CreateSingleTriggerContinousEffect_DestroyReplace(reg_obj, lim_obj2, rng2, repfilter, tg, op, con, rst_obj, flag2)
end
rssf.CheckBlueEyesSpiritDragon = Scl.IsAffectedByBlueEyesSpiritDragon
function rssf.SpecialSummon(sum_obj, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone, card_fun, group_fun)
	local e = Scl.GetCurrentEffectInfo()
	local sg = Scl.Mix2Group(sum_obj)
	if Scl.Operate_Check == 0 then 
		return sg:CheckSubGroup(s.special_summon_check, #sg, #sg, e, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone) 
	end
	local g = Group.CreateGroup()
	for sum_card in aux.Next(sg) do
		if rssf.SpecialSummonStep(sum_card, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone, card_fun) then
			g:AddCard(sum_card)
		end
	end
	Scl.SpecialSummonComplete()
	return #g, g, g:GetFirst()
end
function rssf.SpecialSummonStep(sum_card, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone, card_fun)
	local res, sc = Scl.SpecialSummonStep(sum_card, sum_typ, sum_pl, zone_pl, ignore_con, ignore_revie, pos, zone) 
	local e = Scl.GetCurrentEffectInfo()
	if res and sc then
		if type(card_fun) == "function" then
			card_fun(sc, e, e:GetHandlerPlayer())
		elseif type(card_fun) == "table" then
			Scl.Global_Zone = "MonsterZone"
			rscf.QuickBuff({ e:GetHandler(), sc, true }, table.unpack(card_fun))
			Scl.Global_Zone = nil
		end
	end
	return res, sc
end 
function rssf.SpecialSummonEither(sum_card, sum_eff, sum_typ, sum_pl, loc_pl, ignore_con, ignore_revie, pos, sum_zone)
	return Scl.SpecialSummon2EitherFieldStep(sum_card, sum_typ, sum_pl, ignore_con, ignore_revie, pos, sum_zone) 
end
rsval.spconfe = scl.value_spsummon_from_extra("SpecialSummon")
rsval.spconbe = scl.value_spsummon_by_card_effects
function rsval.indbae(str1, str2)
	if not str1 and not str2 then 
		str1 = "Battle"
		str2 = "Effect"
	end
	if str1 and str1 == "battle" then
		str1 = "Battle"
	elseif str1 and str1 == "effect" then
		str1 = "Effect"
	end
	if str2 and str2 == "battle" then
		str2 = "Battle"
	elseif str2 and str2 == "effect" then
		str2 = "Effect"
	end
	return function(...)
		return scl.value_reason(0, str1, str2 )(...)
	end
end
function rsval.indct(str1, str2)
	if not str1 and not str2 then 
		str1 = "Battle"
		str2 = "Effect"
	end
	if str1 and str1 == "battle" then
		str1 = "Battle"
	elseif str1 and str1 == "effect" then
		str1 = "Effect"
	end
	if str2 and str2 == "battle" then
		str2 = "Battle"
	elseif str2 and str2 == "effect" then
		str2 = "Effect"
	end
	return function(...)
		return scl.value_indestructable_count(str1, str2)(...)
	end
end
rsval.imoe = scl.value_unaffected_by_opponents_card_effects
rsval.imes = scl.value_unaffected_by_other_card_effects
rsval.imntges = scl.value_unaffected_by_other_untarget_effects
rsval.imntgoe = scl.value_unaffected_by_opponents_untarget_effects
rsval.fusslimit = scl.value_cannot_be_used_as_material_for_a_fusion_summon
rstg.imntg = scl.target_untarget_status
rscf.AddTokenList = Scl.AddTokenList
rstg.token = scl.target_special_summon_token
rssf.CheckTokenSummonable = Scl.IsCanSpecialSummonToken
rssf.SpecialSummonToken = Scl.SpecialSummonToken
function rstg.neg(dn_str, ex_tg)
    return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
        dn_str = dn_str or "dum"
        local c = e:GetHandler()
        local rc = re:GetHandler()
        if chkc then return ex_tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc) end
        if chk == 0 then return (dn_str ~= "rm" or aux.nbcon(tp, re)) and (ex_tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)) end
        local op_cate = rscate.cate_selhint_list[dn_str][2]
        if op_cate and op_cate ~= 0 and rc:IsRelateToEffect(re) then
            local res = rsop.Operation_Solve(eg, dn_str, REASON_EFFECT, { }, 0, e, tp, eg, ep, ev, re, r, rp) 
            if res then 
                Duel.SetOperationInfo(0, op_cate, eg, 1, 0, 0)
            end
        end
        ex_tg(e, tp, eg, ep, ev, re, r, rp, 1)
    end
end
function rsop.neg(dn_str, ex_op)
	return function(...)
		return s.negate_activation_or_effect_op("NegateActivation", s.ctgy_list[dn_str], ex_op)(...)
	end
end
function rsop.dis(dn_str, ex_op)
	return function(...)
		return s.negate_activation_or_effect_op("NegateEffect", s.ctgy_list[dn_str], ex_op)(...)
	end
end
function s.get_effect_array(checkfun, endfun, list_typ, a1, a2, a3, ...)
	local arr = { }
    if type(a1) == "table" and (not a2 or (type(a2) == "table" )) and (not a3 or type(a3) == "table") then
        arr = { a1, a2, a3, ... }
    else
        arr = { { a1, a2, a3, ... } }
    end
	local cache_arr = Scl.CloneArray(arr)
	--boom nil
	for idx, arr2 in pairs(arr) do
		if type(arr2[1]) == "string" then
			if not arr2[3] and arr2[4] then
				cache_arr[idx][3] = "dum"
			end
		else
			if not arr2[2] and arr2[3] then
				cache_arr[idx][2] = "dum"
			end
		end
	end
	--insert list type
	for idx, arr2 in pairs(arr) do
		if type(arr2[1]) ~= "string" then
			table.insert(cache_arr[idx], 1, list_typ)
		else
			if arr2[1] == "cost" then
				cache_arr[idx][1] = "Cost"
			elseif arr2[1] == "tg" then
				cache_arr[idx][1] = "Target"
			elseif arr2[1] == "opc" then
				cache_arr[idx][1] = "~Target"
			end
		end
	end
	if checkfun then
		table.insert(cache_arr, 1, { "ExtraCheck", checkfun })
	end
	if endfun then
		table.insert(cache_arr,{ "ExtraOperation", s.end_fun(endfun) })
	end
	local cache_arr2 = Scl.CloneArray(cache_arr)
	--switch string
	for idx, arr2 in pairs(cache_arr) do
		if arr2[3] then
			local v1 = arr2[3]
			if type(v1) == "string" then
				cache_arr2[idx][3] = s.ctgy_list[v1]
			elseif type(v1) == "table" then
				cache_arr2[idx][3][1] = s.ctgy_list[v1[1]]
			end
		end
	end
	--"dh,dish,dhf,dishf"
	for idx, arr2 in pairs(cache_arr) do
		local v0, v1, v2 = arr2[1], arr2[2], arr2[3]
		if v2 == "dh" or v2 == "dish" or v2 == "dhf" or v2 == "dishf" then
			if type(v1) == "number" and v1 == 0 then
				cache_arr2[idx][2] = Card.IsDiscardable
				cache_arr2[idx][3] = "DiscardWithFilter"
			elseif type(v1) == "number" and v1 < 0 then
				if v0 == "Cost" then
					cache_arr2[idx][1] = "PlayerCost"
				elseif v0 == "~Target" then
					cache_arr2[idx][1] = "PlayerTarget"
				end
				cache_arr2[idx][2] = cache_arr2[idx][3]
				cache_arr2[idx][3] = 0
				cache_arr2[idx][4] = -v1
			elseif type(v1) == "number" and v1 > 0 then
				if v0 == "Cost" then
					cache_arr2[idx][1] = "PlayerCost"
				elseif v0 == "~Target" then
					cache_arr2[idx][1] = "PlayerTarget"
				end
				cache_arr2[idx][2] = cache_arr2[idx][3]
				cache_arr2[idx][3] = v1
			elseif type(v1) ~= "number" then
				cache_arr2[idx][3] = "DiscardWithFilter"
			end
		end
	end
	--"dd,disd,dr,rec,dam"
	for idx, arr2 in pairs(cache_arr) do
		local v0, v1, v2 = arr2[1], arr2[2], arr2[3]
		if v2 == "dd" or v2 == "disd" or v2 == "dr" or v2 == "rec" or v2 == "dam" then
			if type(v1) == "number" and v1 < 0 then
				if v0 == "Cost" then
					cache_arr2[idx][1] = "PlayerCost"
				elseif v0 == "~Target" then
					cache_arr2[idx][1] = "PlayerTarget"
				end
				cache_arr2[idx][2] = cache_arr2[idx][3]
				cache_arr2[idx][3] = 0
				cache_arr2[idx][4] = -v1
			elseif type(v1) == "number" and v1 > 0 then
				if v0 == "Cost" then
					cache_arr2[idx][1] = "PlayerCost"
				elseif v0 == "~Target" then
					cache_arr2[idx][1] = "PlayerTarget"
				end
				cache_arr2[idx][2] = cache_arr2[idx][3]
				cache_arr2[idx][3] = v1
			end
		end
	end
	return cache_arr2
end
function s.end_fun(endfun)
	return function(g1, g2, ...)
		return endfun(g1, ...)
	end
end
function rstg.target0(checkfun,  endfun,  ...)
	local effect_arr = s.get_effect_array(checkfun, endfun, "Target", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rstg.target(...)
	local effect_arr = s.get_effect_array(nil, nil, "Target", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rstg.target2(endfun, ...)
	local effect_arr = s.get_effect_array(nil, endfun, "Target", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rstg.target3(checkfun, ...)
	local effect_arr = s.get_effect_array(checkfun, nil, "Target", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rsop.target0(checkfun,  endfun,  ...)
	local effect_arr = s.get_effect_array(checkfun, endfun, "~Target", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rsop.target(...)
	local effect_arr = s.get_effect_array(nil, nil, "~Target", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rsop.target2(endfun, ...)
	local effect_arr = s.get_effect_array(nil, endfun, "~Target", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rsop.target3(checkfun, ...)
	local effect_arr = s.get_effect_array(checkfun, nil, "~Target", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rscost.cost0(checkfun,  endfun,  ...)
	local effect_arr = s.get_effect_array(checkfun, endfun, "Cost", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rscost.cost(...)
	local effect_arr = s.get_effect_array(nil, nil, "Cost", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rscost.cost2(endfun, ...)
	local effect_arr = s.get_effect_array(nil, endfun, "Cost", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rscost.cost3(checkfun, ...)
	local effect_arr = s.get_effect_array(checkfun, nil, "Cost", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
function rsop.cost(...)
	local effect_arr = s.get_effect_array(checkfun, nil, "Operation", ...)
	return scl.list_format_cost_or_target_or_operation(effect_arr)
end
rsop.list = function(...)
	return {"~Target", ...}
end
rstg.list = function(...)
	return {"Target", ...}
end
rscost.list = function(...)
	return {"Cost", ...}
end
rscost.rmct = scl.cost_remove_counter
rscost.rmct2 = scl.cost_remove_counter_from_field
rscost.rmxmat = scl.cost_detach_xyz_material
rscost.setlab = scl.cost_check_copy_status
rscost.paylp = scl.cost_pay_lp
rscost.paylp2 = scl.cost_pay_lp_in_multiples
rscost.chnlim = scl.cost_once_per_chain
rscon.turns = scl.cond_during_your_turn
rscon.turno = scl.cond_during_opponents_turn
rscon.phmp = scl.cond_during_phase("M1,M2")
rscon.phbp = scl.cond_during_phase("BP")
rscon.prepup = scl.cond_faceup_leaves()
function rstg.chnlim(sp, op)
	return function(g, e, tp)
		Duel.SetChainLimit(rsval.chainlimit(sp, op, g))
	end
end
function rsval.chainlimit(sp, op, g)
	return function(e, rp, tp)
		if type(sp) == "nil" and type(op) == "nil" then 
			sp = "s,t,m"
			op = "s,t,m"
		end  
		if sp and rp == tp and rstg.chainlimit_check(sp, g, e, rp, tp)
			then return false 
		end
		if op and rp ~= tp and rstg.chainlimit_check(op, g, e, rp, tp)
			then return false 
		end
		return true 
	end
end
function rstg.chainlimit_check(p_val, g, e, rp, tp)
	local c = e:GetHandler()
	if type(p_val) == "string" then
		return rsef.Effect_Type_Check(p_val, e)
	elseif type(p_val) == "function" then 
		return not p_val(e, rp, tp, g)
	end
end
function rscon.sumtyps(typ)
	return function(e, tp)
		return scl.cond_is_summon_type(s.sum_list[typ], false)(e, tp)
	end
end
function rscon.sumtypf(typ)
	return function(e, tp, eg)
		return scl.cond_is_summon_type(s.sum_list[typ], true)(e, tp, eg)
	end
end
s.effect_type_list = {

	["s"] = "Spell", ["t"] = "Trap", ["a"] = "Activate", ["m"] = "Monster",
	["sa"] = "SpellActivate", ["ta"] = "TrapActivate"

}
function rscon.dis(dn_filter, pl_fun)
	if type(dn_filter) == "string" then
		local new_str = s.effect_type_list[dn_filter]
		return scl.negate_activation_or_effect_con("NegateEffect" ,{new_str, pl_fun })
	else
		local f = function(e, tp, ev, re, rp, tg, loc, seq, cp)
			return dn_filter(e, tp, re, rp, tg, loc, seq, atp)
		end
		return scl.negate_activation_or_effect_con("NegateEffect", { f, pl_fun })
	end
end
function rscon.neg(dn_filter, pl_fun)
	if type(dn_filter) == "string" then
		local new_str = s.effect_type_list[dn_filter]
		return scl.negate_activation_or_effect_con("NegateActivation" ,{new_str, pl_fun })
	else
		local f = function(e, tp, ev, re, rp, tg, loc, seq, cp)
			return dn_filter(e, tp, re, rp, tg, loc, seq, atp)
		end
		return scl.negate_activation_or_effect_con("NegateActivation", { f, pl_fun })
	end
end
rscon.excard = scl.cond_is_card_exists
rscon.excard2 = scl.cond_is_card_faceup_exists
function rscon.sumtolz(link_filter, sum_filter)
    return function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local zone = 0
        local link_group = Group.CreateGroup()
        if rsof.Check_Boolean(link_filter) then
            link_group = rsgf.Mix2(c)
        else
            link_group = Duel.GetMatchingGroup(link_filter, tp, LOCATION_MZONE, LOCATION_MZONE, nil, e, tp, eg, ep, ev, re, rp)
        end
        for tc in aux.Next(link_group) do
            zone = zone | tc:GetLinkedZone(tp)
        end
        return eg:IsExists(rscon.sumtolz_filter, 1, nil, zone, sum_filter, e, tp, eg, ep, ev, re, rp)
    end
end 
function rscon.sumtolz_filter(c, zone, sum_filter, e, tp, eg, ep, ev, re, rp)
    if sum_filter and not sum_filter(c, e, tp, eg, ep, ev, re, rp) then return false end
    local seq = c:GetSequence()
    if c:IsLocation(LOCATION_MZONE) then
        if c:IsControler(1 - tp) then seq = seq + 16 end
    else
        seq = c:GetPreviousSequence()
        if c:GetPreviousControler() == 1 - tp then seq = seq + 16 end
    end
    return bit.extract(zone, seq) ~= 0
end
function rsop.SelectExPara(a1, ...) 
	return Scl.SetExtraSelectAndOperateParama(s.ctgy_list[a1], ...)
end
function rsop.SelectCards(a1, ...)
	return Scl.SelectCards(s.ctgy_list[a1], ...)
end
function rsop.OperateCards(a1, ...)
	local list = { ... }
	return function(...)
		return Scl.SelectAndOperateCards(s.ctgy_list[a1], table.unpack(list))(...)
	end
end
function rsgf.SelectCards(a1, ...)
	return Scl.SelectCardsFromGroup(s.ctgy_list[a1], ...)
end
function rsgf.OperateCards(a1, ...)
	local list = { ... }
	return function(...)
		return Scl.SelectAndOperateCardsFromGroup(s.ctgy_list[a1], table.unpack(list))(...)
	end
end
function rsop.Equip(e, equip_card, equip_target, keep_face_up, equip_oppo_side, equip_quick_buff)
	local tp = e:GetHandlerPlayer()
	if equip_quick_buff then
		local arr = s.switch_old_buff_list(equip_quick_buff)
		Scl.AddEquipBuff(nil, table.unpack(arr))
	end
	local ct =  Scl.Equip(equip_card, equip_target, equip_oppo_side and 1 - tp or tp, keep_face_up)
	return ct > 0
end
rsop.GetOperatedCorrectlyCount = Scl.GetCorrectlyOperatedCount
rsop.CheckOperateCorrectly = Scl.IsCorrectlyOperated
function rsop.ToDeckDraw(dp, dct, is_break, check_count) 
    local res, ct, g = rsop.CheckOperateCorrectly(rsloc.de, check_count)
    if not res then return 0 end
    if g:IsExists(Card.IsLocation, 1, nil, LOCATION_DECK) then
        Duel.ShuffleDeck(dp)
    end
    if is_break then
        Duel.BreakEffect()
    end
    return Duel.Draw(dp, dct, REASON_EFFECT)
end 
rsop.SendtoHand = Scl.Send2Hand
function rsop.MoveToField_Activate(tc, movep, targetp, zone, pos, enable, zone)
	return Scl.Activate2Field(tc, actp)
end
function rsop.DisableCards(card_obj, neg_eff, force, reset)
	return Scl.NegateCardEffects(card_obj, force, reset)
end
function rsop.Overlay(e, xyzc, obj, set_sum_mat, ex_over)
	return Scl.AttachAsXyzMaterial(obj, xyzc, set_sum_mat, ex_over)
end
rszsf.GetMZoneCount = Scl.GetMZoneCount4Summoning
rszsf.GetMZoneCombineForFirstMonster = Scl.GetMZoneCombine4SummoningFirstMonster
rszsf.GetSZoneCount = Scl.GetSZoneCount
function rszsf.GetSurroundingZone(c, p, truezone, contain_self)
	return Scl.GetSurroundingZone(c, "MonsterZone", p, contain_self), Scl.GetSurroundingZone(c, "Spell&TrapZone", p, contain_self), Scl.GetSurroundingZone(c, "OnField", p, contain_self)
end
rsgf.dnpcheck = Scl.IsDifferentControler
rsgf.GetSurroundingGroup = Scl.GetSurroundingGroup
function rsgf.GetSurroundingGroup2(seq, loc, cp, contains)
	local zone = aux.SequenceToGlobal(cp, loc, seq)
	return Scl.GetSurroundingGroup(zone, contains)
end
rsgf.GetAdjacentGroup = Scl.GetAdjacentGroup
function rsgf.GetAdjacentGroup2(seq, loc, cp, contains)
	local zone = aux.SequenceToGlobal(cp, loc, seq)
	return Scl.GetAdjacentGroup(zone, contains)
end
function rsgf.GetTargetGroup(...)
	local g,_ = Scl.GetTargetsReleate2Chain(...)
	return g
end
rsgf.Mix = Scl.MixIn2Group
rsgf.Mix2 = Scl.Mix2Group
function rscf.DefineCard(code, inside_series_str)
	local cm, m = Scl.SetID(code, inside_series_str)
	return m, cm 
end
function rscf.DefineSet(setmeta, seriesstring, type_int)
    local prefixlist1 = { "", "Fus", "Link", "Pre", "Ori" } 
    local prefixlist1_fun = { "", "Fusion", "Link", "Previous", "Original" }
    local prefixlist2 = { "", "M", "S", "T", "ST" } 
    local prefixlist2_fun = { nil, TYPE_MONSTER, TYPE_SPELL, TYPE_TRAP, TYPE_SPELL + TYPE_TRAP }
    local suffixlist1 = { "", "_th", "_tg", "_td", "_rm", "_sp1", "_sp2" }
    local suffixlist1_fun = { nil, Card.IsAbleToHand, Card.IsAbleToGrave, Card.IsAbleToDeck, Card.IsAbleToRemove, rscf.spfilter(), rscf.spfilter2() }
    type_int = type_int or "" 
    for idx1, prefix1 in pairs(prefixlist1) do 
        for idx2, prefix2 in pairs(prefixlist2) do
            for idx3, suffix1 in pairs(suffixlist1) do 
                setmeta["Is"..prefix1.."Set"..prefix2..type_int..suffix1] = rscf.DefineSet_Fun(prefixlist1_fun[idx1], prefixlist2_fun[idx2], suffixlist1_fun[idx3], seriesstring)
            end
        end
    end
end
function rscf.DefineSet_Fun(prefix1, prefix2, suffix1, seriesstring)
    return function(c, ...)
        return rscf["Check"..prefix1.."SetCard"](c, seriesstring) and (not prefix2 or c:IsType(prefix2))
            and (not suffix1 or suffix1(c, ...))
    end
end
function s.get_quick_buff_new_arr(...)
	local arr = { ... }
	local new_arr = { }
	for idx, elm in pairs(arr) do
		if type(elm) == "string" then
			if elm == "reset" or elm == "rst" then
				table.insert(new_arr, "Reset")
				table.insert(new_arr, arr[idx + 1])
			else
				local str_arr = Scl.SplitString(elm)
				for _, elm2 in pairs(str_arr) do
					table.insert(new_arr, s.buff_code_list[elm2])
					if idx ~= #arr and type(arr[idx + 1]) ~= "string" then
						table.insert(new_arr, arr[idx + 1])
					else
						table.insert(new_arr, 1)
					end
				end
			end
		end
	end
	return new_arr
end
function rscf.QuickBuff(reg_obj, ...)
	local new_arr = s.get_quick_buff_new_arr(...)
	if aux.GetValueType(reg_obj) == "Card" or (type(reg_obj) == "table" and reg_obj[1] == reg_obj[2]) then
		return Scl.AddSingleBuff2Self(reg_obj, table.unpack(new_arr))
	else
		return Scl.AddSingleBuff(reg_obj, table.unpack(new_arr))
	end
end
function rscf.QuickBuff_ND(reg_obj, ...)
	local new_arr = s.get_quick_buff_new_arr(...)
	return Scl.AddSingleBuff(reg_obj, table.unpack(new_arr))
end
function rscf.GetSelf(e)
	local c1, c2 = Scl.GetActivateCard()
	return c2
end 
function rscf.GetFaceUpSelf(e)
	local c1, c2 = Scl.GetFaceupActivateCard()
	return c2
end
function rscf.AddSpecialSummonProcdure(reg_obj, zone, con, tg, op, desc_obj, lim_obj, val, rst_obj)
	local lim_obj2 = s.switch_old_count_limit(lim_obj)
	return Scl.AddSpecialSummonProcedure(reg_obj, zone, con, tg, op, desc_obj, lim_obj2, val, nil, nil, nil, rst_obj)
end
rscf.SetSummonCondition = Scl.SetSummonCondition
rscf.CheckSetCard = Scl.IsSeries
Card.CheckSetCard = Scl.IsSeries
rscf.CheckFusionSetCard = Scl.IsFusionSeries
Card.CheckFusionSetCard = Scl.IsFusionSeries
rscf.CheckLinkSetCard = Scl.IsLinkSeries
Card.CheckLinkSetCard = Scl.IsLinkSeries
rscf.CheckOriginalSetCard = Scl.IsOriginalSeries
Card.CheckOriginalSetCard = Scl.IsOriginalSeries
rscf.CheckPreviousSetCard = Scl.IsPreviousSeries
Card.CheckPreviousSetCard = Scl.IsPreviousSeries
rssf.AddSynchroProcedureSpecial = Scl.AddSynchroProcedure
rscf.AddXyzProcedureSpecial = Scl.AddlXyzProcedure
rscf.AddLinkProcedureSpecial = Scl.AddlLinkProcedure
rscf.IsSurrounding = Scl.IsSurrounding
rscf.IsPreviousSurrounding = Scl.IsPreviouslySurrounding
function rscf.GetTargetCard(...)
	local _, tc = Scl.GetTargetsReleate2Chain(...)
	return tc
end
rscf.EnableDarkSynchroAttribute = Scl.EnableDarkSynchroAttribute
rscf.EnableDarkTunerAttribute = Scl.EnableDarkTunerAttribute
rscf.IsDarkSynchro = Scl.IsDarkSynchro
rscf.IsDarkTuner = Scl.IsDarkTuner
rscf.DarkTuner = Scl.DarkTuner
function rscf.fufilter(f, ...)
    local ext_paramms = { ... }
    return  function(target)
                return f(target, table.unpack(ext_paramms)) and target:IsFaceup()
            end
end
function rscf.spfilter(f1, ...)
	local list = { ... }
	return function(c, e, tp, ...)
		return Scl.IsCanBeSpecialSummonedNormaly(c, e, tp) and (not f1 or f1(c, table.unpack(list)))
	end
end
function rscf.spfilter2(f1, ...)
	local list = { ... }
	return function(c, e, tp, ...)
		return Scl.IsCanBeSpecialSummonedNormaly2(c, e, tp) and (not f1 or f1(c, table.unpack(list)))
	end
end
rscf.RemovePosCheck = Scl.FaceupOrNotBeBanished
Card.RemovePosCheck = Scl.FaceupOrNotBeBanished
rscf.FieldPosCheck = Scl.FaceupOrNotOnField
Card.FieldPosCheck = Scl.FaceupOrNotOnField
function rscf.rdesfilter(f1, ...)
	local list = { ... }
	return function(c, e, tp, ...)
		return Scl.IsDestructableForReplace(c) and (not f1 or f1(c, table.unpack(list)))
	end
end
function rscf.IsComplexType(c, type1, type2, ...)
	if type(type2) == "boolean" then
		return Scl.IsType(c, type1, ...)
	else
		return Scl.IsType(c, 0, type1, type2, ...)
	end
end
Card.IsComplexType = rscf.IsComplexType
function rscf.IsPreviousComplexType(c, type1, type2, ...)
	if type(type2) == "boolean" then
		return Scl.IsPreviousType(c, type1, ...)
	else
		return Scl.IsPreviousType(c, 0, type1, type2, ...)
	end
end
Card.IsPreviousComplexType = rscf.IsPreviousComplexType
function rscf.IsOriginalComplexType(c, type1, type2, ...)
	if type(type2) == "boolean" then
		return Scl.IsOriginalType(c, type1, ...)
	else
		return Scl.IsOriginalType(c, 0, type1, type2, ...)
	end
end
Card.IsOriginalComplexType = rscf.IsOriginalComplexType
function rscf.IsComplexReason(c, re1, re2, ...)
	if type(re2) == "boolean" then
		return Scl.IsReason(c, re1, ...)
	else
		return Scl.IsReason(c, 0, re1, re2, ...)
	end
end
Card.IsComplexReason = rscf.IsComplexReason
function rshint.Select(p, hint_obj)
	if type(hint_obj) == "string" then
		hint_obj = s.ctgy_list[hint_obj]
	end
	return Scl.SelectHint(p, hint_obj)
end
rshint.Card = Scl.HintCard
function rshint.SelectYesNo(v1, v2, ...)
	local new_hint = v2
	if type(v2) == "string" then
		new_hint = s.ctgy_list[v2]
	end
	return Scl.SelectYesNo(v1, new_hint, ...)
end
function rshint.SelectOption(...)
	local new_arr = { }
	for _, elm in pairs({ ... }) do
		if type(elm) == "string" then
			table.insert(new_arr, s.ctgy_list[elm])
		else
			table.insert(new_arr, elm)
		end
	end
	return Scl.SelectOption(table.unpack(new_arr))
end

rsreset = rsrst
rsrst.est  =   rsrst.std
rsrst.est_d   =   rsrst.std_dis
rsrst.pend  =   rsrst.ep
rsrst.est_pend =   rsrst.std_ep
rsrst.ered  =   rsrst.ret 
rszsf.GetUseAbleMZoneCount = function(c, p1, leave_val, p2, zone)
	return rszsf.GetMZoneCount(p1, leave_val, p2, c, zone)
end
rszsf.GetUseAblePZoneCount = rszsf.GetPZoneCount
rscf.FilterFaceUp =  rscf.fufilter
rscf.GetRelationThisCard = rscf.GetFaceUpSelf

rsval.imntg1 = rsval.imntges
rsval.imntg2 = rsval.imntgoe

--//

rscost.reglabel = rscost.setlab
rscost.rmxyz = rscost.rmxmat
rscost.lpcost = rscost.paylp 
rscost.lpcost2 = rscost.paylp2 
rscost.regflag = rscost.chnlim
rscost.regflag2 = function(flag_code)
	return function(...)
		return rscost.chnlim(flag_code, true)(...)
	end
end

--//
rscon.sumtype = rscon.sumtyps
rscon.sumtypes = rscon.sumtyps

rscon.bsdcheck = rssf.CheckBlueEyesSpiritDragon

--//

rstg.chainlimit = rstg.chnlim

--//
rsop.SelectYesNo = rshint.SelectYesNo 
rsop.SelectOption = rshint.SelectOption
rsop.eqop = rsop.Equip
rsop.SelectOC = Scl.SetExtraSelectAndOperateParama

rsop.CheckOperateSuccess = rsop.CheckOperateCorrectly

rsef.SV_UTILITY_XYZ_MATERIAL = rsef.SV_UtilityXyzMaterial
rsef.SV_ACTIVATE_SPECIAL = rsef.SV_ActivateDirectly_Special
rsef.SV_CANNOT_DISABLE_S = rsef.SV_CannotDisable_NoEffect
rsef.SV_EXTRA_MATERIAL =   rsef.SV_ExtraMaterial
rsef.FV_EXTRA_MATERIAL =   rsef.FV_ExtraMaterial
rsef.FV_EXTRA_MATERIAL_SELF =   rsef.FV_ExtraMaterial_Self
rsef.ACT_EQUIP  =   rsef.A_Equip
rsef.STO_FLIP   =   rsef.STO_Flip
rsef.STF_FLIP   =   rsef.STF_Flip

rsef.FC_PHASELEAVE = rsef.FC_PhaseLeave

rsef.FC_PhaseLeave = function(reg_list, leave_val, times, whos, phase, leaveway, val_reset_list, ex_con)
	return rsef.FC_PhaseOpearte(reg_list, leave_val, times, whos, phase, nil, leaveway, val_reset_list)
end

rsef.ACT = rsef.A 

rscon.negcon = function(dn_filter, pl_fun)
	return function(...)
		local dn_list = { [0] = "s,t,m", [1] = "a,m", [2] = "m", [3] = "a", [4] = "s,t" }
		if type(dn_filter) == "number" then
			dn_filter = dn_list[dn_filter]
		end
		if pl_fun then pl_fun = pl_fun and 1 or 0 end
		return rscon.disneg("neg", dn_filter, pl_fun)(...)
	end
end
rscon.discon = function(dn_filter, pl_fun)
	return function(...)
		local dn_list = { [0] = "s,t,m", [1] = "a,m", [2] = "m", [3] = "a", [4] = "s,t" }
		if type(dn_filter) == "number" then
			dn_filter = dn_list[dn_filter]
		end
		if pl_fun then pl_fun = pl_fun and 1 or 0 end
		return rscon.disneg("dis", dn_filter, pl_fun)(...)
	end
end
rsef.QO_NEGATE = function(reg_list, dn_type, lim_list, dn_str, range, con, cost, desc_list, cate, flag, reset_list)
	if dn_type == "neg" then
		return rsef.QO_NegateActivation(reg_list, dn_str, lim_list, range, con, cost, cate, flag, nil, nil, desc_list, reset_list)
	elseif dn_type == "dis" then
		return rsef.QO_NegateEffect(reg_list, dn_str, lim_list, range, con, cost, cate, flag, nil, nil, desc_list, reset_list)
	end
end

rstg.negtg = rstg.neg
rstg.distg = rstg.neg
rsop.negop = rsop.neg
rsop.negop = rsop.dis

--//
rscf.SetSpecialSummonProduce = function(reg_list,range,con,op,desc_list,lim_list,reset_list)
	return rscf.AddSpecialSummonProcdure(reg_list,range,con,nil,op,desc_list,lim_list,nil,reset_list)
end

--//
rsop.SelectSolve = function(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_list, ...)
	solve_list = type(solve_list) == "table" and solve_list or { solve_list }
	local para1 = solve_list[1]
	if #solve_list == 0 then return 
		rsop.SelectCards(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, ...)
	elseif para1 and type(para1) == "function" then 
		local g = rsop.SelectCards(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, ...)
		if #g <= 0 then
			return 0, g
		end
		local para_list = { }
		local total_list = Scl.MixArrays(solve_list, { ... })
		for idx, val in pairs(total_list) do 
			if idx > 1 then 
				table.insert(para_list, val)
			end
		end
		return para1(g, table.unpack(para_list))
	else
		return rsop.SelectOperate(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_list, ...)
	end
end
rsgf.SelectSolve = function(g, sel_hint, sp, filter, minct, maxct, except_obj, solve_list, ...)
	solve_list = type(solve_list) == "table" and solve_list or { solve_list }
	local para1 = solve_list[1]
	if #solve_list == 0 then return 
		rsgf.SelectCards(sel_hint, g, sp, filter, minct, maxct, except_obj, ...)
	elseif para1 and type(para1) == "function" then 
		local g = rsgf.SelectCards(sel_hint, g, sp, filter, minct, maxct, except_obj, ...)
		if #g <= 0 then
			return 0, g
		end
		local para_list = { }
		local total_list = rsof.Table_Mix(solve_list, { ... })
		for idx, val in pairs(total_list) do 
			if idx > 1 then 
				table.insert(para_list, val)
			end
		end
		return para1(g, table.unpack(para_list))
	else
		return rsgf.SelectOperate(sel_hint, g, sp, filter, minct, maxct, except_obj, solve_list, ...)
	end
end
local selectfun_list = {
	["ToHand"] = "th", ["ToGrave"] = "tg", ["Release"] = "res", ["ToDeck"] = "td", ["Destroy"] = "des", ["Remove"] = "rm", 
	["SpecialSummon"] = "sp", ["MoveToField"] = "tf", ["MoveToField_Activate"] = "act", ["SSet"] = "sset"
}
for str_idx, str_val in pairs(selectfun_list) do 
	rsop["Select"..str_idx] = function(sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_parama, ...)
		return rsop.SelectOperate(str_val, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_parama or {}, ...)
	end
	rsgf["Select"..str_idx] = function(g, sp, filter, minct, maxct, except_obj, solve_parama, ...)
		return rsgf.SelectOperate(str_val, g, sp, filter, minct, maxct, except_obj, solve_parama or {}, ...)
	end
end
--//

--Function: Select and solve 
function rsop.SelectOperate(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_arr, ...)
	return rsop.OperateCards(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, ...)(table.unpack(solve_arr))
end

function rsgf.SelectOperate(sel_hint, g, sp, filter, minct, maxct, except_obj, solve_arr, ...)
	return rsgf.OperateCards(sel_hint, g, sp, filter, minct, maxct, except_obj, ...)(table.unpack(solve_arr))
end

function rsef.INDESTRUCTABLE_List(inds_list)
    local inds_list2 = string.gsub(inds_list, "battle", "indb")
    inds_list2 = string.gsub(inds_list2, "effect", "inde")
    inds_list2 = string.gsub(inds_list2, "ct", "indct")
    inds_list2 = string.gsub(inds_list2, "all", "ind")
    return inds_list2
end
--Single Val Effect: Cannot destroed 
function rsef.SV_INDESTRUCTABLE(reg_list, inds_list, val_list, con, reset_list, flag, desc_list, lim_list)
    local inds_list2 = rsef.INDESTRUCTABLE_List(inds_list)
    return rsef.SV_Card(reg_list, inds_list2, val_list, nil, flag, con, reset_list, desc_list, lim_list)
end
--Field Val Effect: Cannot destroed 
function rsef.FV_INDESTRUCTABLE(reg_list, inds_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
    local inds_list2 = rsef.INDESTRUCTABLE_List(inds_list)
    return rsef.FV_Card(reg_list, inds_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list, lim_list)
end
--Single Val Effect: Immue effects
function rsef.SV_IMMUNE_EFFECT(reg_list, val, con, reset_list, flag, desc_list)
    return rsef.SV_Card(reg_list, "im", val, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Immue effects
function rsef.FV_IMMUNE_EFFECT(reg_list, val, tg, tg_range_list, con, reset_list, flag, desc_list)
    return rsef.FV_Card(reg_list, "im", val, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Directly set ATK & DEF 
function rsef.SV_SET(reg_list, set_list, val_list, con, reset_list, flag, desc_list)
    return rsef.SV_Card(reg_list, set_list, val_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Directly set other card attribute, except ATK & DEF
function rsef.SV_CHANGE(reg_list, change_list, val_list, con, reset_list, flag, desc_list)
    return rsef.SV_Card(reg_list, change_list, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Directly set other card attribute, except ATK & DEF
function rsef.FV_CHANGE(reg_list, change_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
    return rsef.FV_Card(reg_list, change_list, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Update attribute 
function rsef.SV_UPDATE(reg_list, up_list, val_list, con, reset_list, flag, desc_list)
    local str_list = Scl.UniformSclParamaFormat(up_list)
	local str = ""
    for idx, string in pairs(str_list) do
		if idx > 1 then
			str = str .. ","
		end
		str = str .. string .. "+"
    end
    return rsef.SV_Card(reg_list, str, val_list, flag, nil, con, reset_list, desc_list)
end 
--Field Val Effect: Updata some card attributes
function rsef.FV_UPDATE(reg_list, up_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
    local str_list = Scl.UniformSclParamaFormat(up_list)
	local str = ""
    for idx, string in pairs(str_list) do
		if idx > 1 then
			str = str .. ","
		end
		str = str .. string .. "+"
    end
    return rsef.FV_Card(reg_list, str, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Add attribute
function rsef.SV_ADD(reg_list, add_list, val_list, con, reset_list, flag, desc_list)
    return rsef.SV_UPDATE(reg_list, add_list, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Directly set other card attribute, except ATK & DEF
function rsef.FV_ADD(reg_list, add_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
    return rsef.FV_UPDATE(reg_list, add_list, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Material lim_
function rsef.SV_CANNOT_BE_MATERIAL(reg_list, mat_list, val_list, con, reset_list, flag, desc_list)
    local flag2 = rsef.GetRegisterProperty(nil, flag)
    flag2 = flag2 | (EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE) 
    local str_list = Scl.UniformSclParamaFormat(mat_list)
    local str_list2 = { }
    local string2
    for _, string in pairs(str_list) do
        string2 = string.sub(string,1,1)
        table.insert(str_list2, string2.."mat~")
    end
    return rsef.SV_Card(reg_list, str_list2, val_list, flag2, nil, con, reset_list, desc_list)
end
--Single Val Effect: Cannot be battle or card effect target
function rsef.SV_CANNOT_BE_TARGET(reg_list, tg_list, val_list, con, reset_list, flag, desc_list)
    local tg_list2 = string.gsub(tg_list, "battle", "tgb~")
    tg_list2 = string.gsub(tg_list2, "effect", "tge~")
    return rsef.SV_Card(reg_list, tg_list2, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Cannot be battle or card effect target
function rsef.FV_CANNOT_BE_TARGET(reg_list, tg_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
    local tg_list2 = string.gsub(tg_list, "battle", "tgb~")
    tg_list2 = string.gsub(tg_list2, "effect", "tge~")
    return rsef.FV_Card(reg_list, tg_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Cannot disable 
function rsef.CANNOT_DISABLE_List(dis_list)
    local compare_list = { ["dise"] = "dise~", ["dis"] = "dis~", ["act"] = "neg~", ["sum"] = "dsum~", ["sp"] = "dsp~", ["fp"] = "dfp", ["neg"] = "neg~" }
    local dis_list2 = Scl.SplitString(dis_list,",")
    local dis_list3 = ""
    for _, str in pairs(dis_list2) do 
        dis_list3 = dis_list3 .. compare_list[str] .. ","
    end
    dis_list3 = string.sub(dis_list3, 1, -2)
    return dis_list3
end
--Single Val Effect: Cannot disable 
function rsef.SV_CANNOT_DISABLE(reg_list, dis_list, val_list, con, reset_list, flag, desc_list, range)
    local dis_list2 = rsef.CANNOT_DISABLE_List(dis_list)
    return rsef.SV_Card(reg_list, dis_list2, val_list, flag, range, con, reset_list, desc_list)
end
function rsef.SV_CANNOT_DISABLE_val(e, ct)
    local te = Duel.GetChainInfo(ct, CHAININFO_TRIGGERING_EFFECT)
    return te:GetHandler() == e:GetHandler()
end
--Field Val Effect: Cannot Disable 
function rsef.FV_CANNOT_DISABLE(reg_list, dis_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list) 
    local dis_list2 = rsef.CANNOT_DISABLE_List(dis_list)
    return rsef.FV_Card(reg_list, dis_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Limit List 
function rsef.LIMIT_List(lim_list) 
    local str_list = Scl.UniformSclParamaFormat(lim_list)
    local str_list2 = { }
    for _, string in pairs(str_list) do
        if string ~= "dis" and string ~= "distm" and string ~= "dise"
            and  string ~= "sbp" and string ~= "sm1" and string ~= "sm2" 
                and string ~= "sdp" and  string ~= "ssp" then
            string = string.."~"
        end
        string = string.gsub(string, "datk~", "atkd~")
        table.insert(str_list2, string)
    end 
    return str_list2
end
--Single Val Effect: Other Limit
function rsef.SV_LIMIT(reg_list, lim_list, val_list, con, reset_list, flag, desc_list)
    local str_list2 = rsef.LIMIT_List(lim_list)
    return rsef.SV_Card(reg_list, str_list2, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Other Limit
function rsef.FV_LIMIT(reg_list, lim_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list) 
    local str_list2 = rsef.LIMIT_List(lim_list)
    return rsef.FV_Card(reg_list, str_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Other Limit (affect Player)
function rsef.FV_LIMIT_PLAYER(reg_list, lim_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list) 
    local str_list2 = rsef.LIMIT_List(lim_list)
    return rsef.FV_Player(reg_list, str_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Leave field list
function rsef.REDIRECT_LIST(leave_list)
    local str_list = Scl.UniformSclParamaFormat(leave_list)
    local str_list2 = { }
    for _, string in pairs(str_list) do
        if string == "leave" then 
            table.insert(str_list2, "rlf")  
        else
            table.insert(str_list2, "r"..string)
        end
    end
    return str_list2
end
--Single Val Effect: Leave field redirect 
function rsef.SV_REDIRECT(reg_list, leave_list, val_list, con, reset_list, flag, desc_list) 
    local str_list2 = rsef.REDIRECT_LIST(leave_list)
    return rsef.SV_Card(reg_list, str_list2, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Leave field redirect 
function rsef.FV_REDIRECT(reg_list, leave_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list) 
    local str_list2 = rsef.REDIRECT_LIST(leave_list)
    local flag2 = rsef.GetRegisterProperty(nil, flag) | (EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE) 
    if tg_range_list and (tg_range_list[1] == 0xff and tg_range_list[2] == 0xff) then 
        flag2 = flag2 | EFFECT_FLAG_IGNORE_RANGE 
    end
    return rsef.FV_Card(reg_list, str_list2, val_list, tg, tg_range_list, flag2, nil, con, reset_list, desc_list)
end
--Single Val Effect: Activate Trap / Quick Spell immediately
function rsef.SV_ACTIVATE_IMMEDIATELY(reg_list, act_list, con, reset_list, flag, desc_list) 
    local act_list2 
    local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
    if reg_handler:IsComplexType(TYPE_QUICKPLAY + TYPE_SPELL) then
        act_list2 = string.gsub(act_list, "hand", "qah")
        act_list2 = string.gsub(act_list2, "set", "qas")
    elseif reg_handler:IsComplexType(TYPE_TRAP) then
        act_list2 = string.gsub(act_list, "hand", "tah")
        act_list2 = string.gsub(act_list2, "set", "tas")
    end
    return rsef.SV_Card(reg_list, act_list2, flag, nil, con, reset_list, desc_list)
end
--cost: tribute self 
function rscost.releaseself(check_mzone, check_exzone)
    return function(e, tp, eg, ep, ev, re, r, rp, chk)
        local c = e:GetHandler()
        if chk == 0 then return c:IsReleasable() and (not check_mzone or Duel.GetMZoneCount(tp, c, tp) > 0) and (not check_exzone or Duel.GetLocationCountFromEx(tp, tp, c, exmzone) > 0) end
        Duel.Release(c, REASON_COST)
    end
end
rsof.Table_List = Scl.IsArrayContains_Single