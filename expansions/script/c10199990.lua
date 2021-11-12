--Scl_Lib
if not pcall(function() require("expansions/script/c10199991") end) then require("script/c10199991") end
local m = 10199990
local vm = 10199991
local Version_Number = 20210618
if rsv.Library_Switch then return end
rsv.Library_Switch = true 
-----------------------"Part_Effect_Base"-----------------------
--Creat Event 
function rsef.CreatEvent(event_code, event1, con1, ...)
	rsef.CreatEvent_Switch = rsef.CreatEvent_Switch or { }
	if rsef.CreatEvent_Switch[event_code] then return end
	rsef.CreatEvent_Switch[event_code] = true
	local creat_list = { event1, con1, ... }
	local eff_list = { }
	for idx, val in pairs(creat_list) do 
		if type(val) == "number" then 
			local e1 = rsef.FC({ true, 0 }, val)
			e1:SetOperation(rsop.CreatEvent(creat_list[idx + 1], event_code))
			table.insert(eff_list, e1)
		end
	end
	return table.unpack(eff_list)
end
function rsop.CreatEvent(con, event_code)
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
--Creat "EVENT_SET"
function rsef.CreatEvent_Set()
	return rsef.CreatEvent(rscode.Set, EVENT_MSET, nil, EVENT_SSET, nil, EVENT_SPSUMMON_SUCCESS, rscon.CreatEvent_Set, EVENT_CHANGE_POS, rscon.CreatEvent_Set)
end
function rscon.CreatEvent_Set(e, tp, eg, ep, ev, re, r, rp)
	local sg = eg:Filter(Card.IsFacedown, nil)
	return #sg > 0, sg
end
--Effect: Operation info , for rstg.target2 and rsop.target2
function rstg.opinfo(cate_str, info_count, pl, info_loc_or_paramma )
	local _, cate_list = rsef.GetRegisterCategory(nil, cate_str)
	local info_player = 0
	return function(info_group_or_card, e, tp)
		if not pl then info_player = 0 
		elseif pl == 0 then info_player = tp
		elseif pl == 1 then info_player = 1 - tp 
		else 
			info_player = pl
		end
		for _, cate in pairs(cate_list) do
			Duel.SetOperationInfo(0, cate, nil, info_count or 0, info_player, info_loc_or_paramma or 0)
		end
	end
end
--Effect: String check effect type (for rstg.chainlimit & rstg.disneg )
function rsef.Effect_Type_Check(eff_str, e)
	local str_list = rsof.String_Split(eff_str) 
	local type_list 
	local etype, etype2 
	local res1, res2 = false, false
	for _, str in pairs(str_list) do 
		type_list = rsef.type_list[str]
		etype = type_list[1]
		etype2 = type_list[2]
		res1 = not etype or e:IsActiveType(etype)
		res2 = not etype2 or e:IsHasType(etype2)
		if res1 and res2 then return true end
	end
	return false
end
--Effect: Chain Limit , for rstg.target2 and rsop.target2
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
--Effect: Set chain limit for effect 
function rsef.SetChainLimit(e, sp, op)
	local tg = e:GetTarget() or aux.TRUE 
	e:SetTarget(rstg.chainlimit_tg(tg, sp, op))
end
Effect.SetChainLimit = rsef.SetChainLimit 
function rstg.chainlimit_tg(tg, sp, op)
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		if chkc or chk == 0 then return tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc) end
		tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS) or Group.CreateGroup()
		Duel.SetChainLimit(rsval.chainlimit(sp, op, g))
	end
end
--Switch {} to aux.Stringid 
function rshint.SwitchHintFormat(string_prefix, hint_val1, hint_val2, ...)
	string_prefix = string_prefix or ""
	local string_prefix_list = { [""] = 4, ["s"] = 3, ["w"] = 5 }
	local hint_val_list = { hint_val1, hint_val2, ... }
	local hint, res_list = 0, { }
	local str_idx, cate_selhint_list, cate_selhint= 0, { }, 0
	for idx, hint_val in pairs(hint_val_list) do 
		if type(hint_val) == "table" then 
			hint = aux.Stringid(hint_val[1], hint_val[2])
		elseif type(hint_val) == "number" then
			hint = hint_val 
		elseif type(hint_val) == "string" then
			str_idx = string_prefix_list[string_prefix]
			hint = rshint[string_prefix .. hint_val] or rscate.cate_selhint_list[hint_val][str_idx] or 0
		end
		table.insert(res_list, hint)
	end
	return table.unpack(res_list)
end
--Effect: Get default hint string for Duel.Hint ,use in effect target
function rsef.GetDefaultSelectHint(cate_val, loc_self, loc_oppo, hint_val)
	if hint_val then 
		return rshint.SwitchHintFormat("s", hint_val) 
	end
	local total_cate, total_cate_list, cate_str_list, sel_hint_list  = rsef.GetRegisterCategory(nil, cate_val)
	local hint = sel_hint_list[1] or 0
	if hint == 0 then
		--if istarget then hint = HINTMSG_TARGET end 
		if (type(loc_self) ~= "number" or (loc_self and loc_self > 0)) and (not loc_oppo or loc_oppo == 0) then hint = HINTMSG_SELF end
		if (type(loc_oppo) == "number" and loc_oppo > 0) and (not loc_self or loc_self == 0) then hint = HINTMSG_OPPO end
	end
	-- destroy and remove 
	if rsof.Table_List_OR(cate_str_list, "des_rm", "des, rm") or rsof.Table_List_AND(cate_str_list, "des", "rm") then
		hint = HINTMSG_DESTROY 
	end
	-- return to hand
	if rsof.Table_List(cate_str_list, "th") and
		((type(loc_self) == "number" and loc_self & LOCATION_ONFIELD ~=0) or (loc_oppo and loc_oppo & LOCATION_ONFIELD ~=0)) then
		hint = HINTMSG_RTOHAND 
	end
	-- return to grave
	if rsof.Table_List(cate_str_list, "tg") and
		((type(loc_self) == "number" and loc_self & LOCATION_REMOVED ~=0) or (loc_oppo and loc_oppo & LOCATION_REMOVED ~=0)) then
		hint = rshint.srtg
	end
	-- return to hand 
	if rsof.Table_List(cate_str_list, "th") and
		((type(loc_self) == "number" and loc_self & (rsloc.og + LOCATION_REMOVED) ~=0) or (loc_oppo and loc_oppo & (rsloc.og + LOCATION_REMOVED) ~=0)) then
		hint = rshint.srth
	end
	return hint 
end
--Effect: Get register card
function rsef.GetRegisterCard(reg_list)
	reg_list = type(reg_list) == "table" and reg_list or { reg_list }
	local reg_owner = reg_list[1] 
	local reg_handler = reg_list[2] or reg_list[1]
	local reg_ignore = reg_list[3] or false
	return reg_owner, reg_handler, reg_ignore
end
--Effect: Get default activate or apply range
function rsef.GetRegisterRange(reg_list)
	local reg_range
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	if aux.GetValueType(reg_handler) ~= "Card" then return nil end
	--(TYPE_PENDULUM , LOCATION_PZONE must manual input)
	local type_list = { TYPE_MONSTER, TYPE_FIELD, TYPE_SPELL + TYPE_TRAP }
	local reg_list = { LOCATION_MZONE, LOCATION_FZONE, LOCATION_SZONE }
	for idx, card_type in pairs(type_list) do
		if reg_handler:IsType(card_type) then 
			reg_range = reg_list[idx]
			break 
		end
	end
	--after begain duel 
	--if Duel.GetTurnCount() > 0 then reg_range = reg_handler:GetLocation() end
	return reg_range 
end
--Effect: Get Flag for SetProperty 
function rsef.GetRegisterProperty(reg_list, flag_param)
	local reg_code = 0
	if reg_list then
		local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
		reg_code = aux.GetValueType(reg_owner) == "Card" and reg_owner:GetOriginalCode()
	end
	local current_flag, total_flag, total_flag_list = 0, 0, { }
	if type(flag_param) == "number" then return flag_param 
	elseif type(flag_param) == "string" then
		local str_list = rsof.String_Split(flag_param)
		for _, flag_str in pairs(str_list) do 
			current_flag = rsflag.list[flag_str] 
			if not current_flag then
				Debug.Message(reg_code.." has an incorrect flag string \""..flag_str.."\" for rsef.GetRegisterProperty.")
			end
			total_flag = total_flag | current_flag
			table.insert(total_flag_list, current_flag)
		end
	end
	return total_flag, total_flag_list
end
rsflag.GetRegisterProperty = rsef.GetRegisterProperty
--Effect: Get Category for SetCategory or SetOperationInfo
function rsef.GetRegisterCategory(reg_list, cate_param)
	local reg_code = 0
	if reg_list then
		local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
		reg_code = aux.GetValueType(reg_owner) == "Card" and reg_owner:GetOriginalCode()
	end
	local current_cate, total_cate, total_cate_list, total_str_list, total_selhint_list = 0, 0, { }, { }, { }
	if type(cate_param) == "number" then 
		total_cate = cate_param 
		for cate_str, cate_list in pairs(rscate.cate_selhint_list) do
			if cate_list[2] &  total_cate ~= 0 then 
				table.insert(total_cate_list, cate_list[2])
				table.insert(total_str_list, cate_str)
				table.insert(total_selhint_list, cate_list[3])
			end
		end
	elseif type(cate_param) == "string" then
		local str_list = rsof.String_Split(cate_param)
		for _, cate_str in pairs(str_list) do 
			if not rscate.cate_selhint_list[cate_str] then
				Debug.Message(reg_code.." has an incorrect categroy string \""..cate_str.."\" for rsef.GetRegisterCategory.")
			end
			current_cate = rscate.cate_selhint_list[cate_str][2]
			if not current_cate then
				Debug.Message(reg_code.." has an incorrect categroy string \""..cate_str.."\" for rsef.GetRegisterCategory.")
			end
			total_cate = total_cate | current_cate
			table.insert(total_cate_list, current_cate)
			table.insert(total_str_list, cate_str)
			table.insert(total_selhint_list, rscate.cate_selhint_list[cate_str][3])
		end
	end
	return total_cate, total_cate_list, total_str_list, total_selhint_list
end
rscate.GetRegisterCategory = rsef.GetRegisterCategory
--Effect: Clone Effect 
function rsef.RegisterClone(reg_list, base_eff, ...)
	local clone_list = { ... }
	local clone_eff = base_eff:Clone()
	for idx, val1 in pairs(clone_list) do 
		if idx & 1 == 1 and type(val1) == "string" then
			local val2 = clone_list[idx + 1]
			local clone_param_list = { "code", "type", "loc", "con", "cost", "tg", "op", "lab", "labobj", "val" }
			local effect_set_list = { Effect.SetCode, Effect.SetType, Effect.SetRange, Effect.SetCondition, Effect.SetCost, Effect.SetTarget, Effect.SetOperation, Effect.SetLabel, Effect.SetLabelObject, Effect.SetValue }
			local bool, idx2 = rsof.Table_List(clone_param_list, val1)
			if bool and idx2 then
				effect_set_list[idx2](clone_eff, val2)
			end
			if val1 == "desc" then 
				rsef.RegisterDescription(clone_eff, val2)
			elseif val1 == "flag" then 
				clone_eff:SetProperty(rsflag.GetRegisterProperty(reg_list, val2))
			elseif val1 == "cate" then 
				clone_eff:SetCategory(rscate.GetRegisterCategory(reg_list, val2)) 
			elseif val1 == "rst" then 
				rsef.RegisterReset(clone_eff, val2) 
			elseif val1 == "timg" then
				rsef.RegisterTiming(clone_eff, val2) 
			elseif val1 == "tgrng" then
				rsef.RegisterTargetRange(clone_eff, val2) 
			end
		end
	end
	local _, clone_fid = rsef.RegisterEffect(reg_list, clone_eff)
	return clone_eff, clone_fid
end 
--Effect: Make Ignition Effect Become Quick Effect
function rsef.RegisterOPTurn(reg_list, base_eff, quick_con, timing_list)
	timing_list = timing_list or { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE }
	local quick_eff, quick_fid = rsef.RegisterClone(reg_list, base_eff, "type", EFFECT_TYPE_QUICK_O, "code", EVENT_FREE_CHAIN, "timing", timing_list)
	base_con = base_eff:GetCondition() or aux.TRUE 
	base_eff:SetCondition(aux.AND(base_con, aux.NOT(quick_con)))
	quick_eff:SetCondition(aux.AND(base_con, quick_con))
	return quick_eff, quick_fid
end 
rsef.QO_OPPONENT_TURN = rsef.RegisterOPTurn
--Effect: Register Condition,  Cost,  Target and Operation 
function rsef.RegisterSolve(reg_eff, con, cost, tg, op)
	local code = reg_eff:GetOwner():GetCode()
	if con then
		if type(con) ~= "function" then
			Debug.Message(code .. " RegisterSolve con must be function")
		end
		reg_eff:SetCondition(con)
	end
	if cost then
		if type(cost) ~= "function" then
			Debug.Message(code .. " RegisterSolve cost must be function")
		end
		reg_eff:SetCost(cost)
	end
	if tg then
		if type(tg) ~= "function" then
			Debug.Message(code .. " RegisterSolve tg must be function")
		end
		reg_eff:SetTarget(tg)
	end
	if op then
		if type(op) ~= "function" then
			Debug.Message(code .. " RegisterSolve op must be function")
		end
		reg_eff:SetOperation(op)
	end
end
Effect.RegisterSolve = rsef.RegisterSolve
--Effect: Register Property and Category
function rsef.RegisterCateFlag(reg_list, reg_eff, cate, flag)
	if cate then
		local cate2 = rsef.GetRegisterCategory(reg_list, cate)
		if cate2 > 0 then
			reg_eff:SetCategory(cate2) 
		end
	end
	if flag then
		local flag2 = rsef.GetRegisterProperty(reg_list, flag)
		if flag2 > 0 then
			reg_eff:SetProperty(flag2) 
		end
	end
end
--Effect: Register Effect Description
function rsef.RegisterDescription(reg_eff, desc_list, cate_val, is_return)
	--default desc(nil for desc and string for cate)
	if not desc_list and cate_val then 
		desc_list = (rsof.String_Split(cate_val))[1]
	end
	desc_list = desc_list or 0
	local hint = rshint.SwitchHintFormat(nil, desc_list)
	if is_return then return hint end
	reg_eff:SetDescription(hint)
end
--Effect: Register Effect Count limit
function rsef.RegisterCountLimit(reg_eff, lim_list, is_return)
	if lim_list then
		local lim_count, lim_code = 0, 0
		if type(lim_list) == "table" then
			if #lim_list == 1 then
				if lim_list[1] <= 100 then
					lim_count = lim_list[1]
				else
					lim_count = 1
					lim_code = lim_list[1]
				end
			elseif #lim_list == 2 then
				lim_count = lim_list[1]
				local value = lim_list[2]
				if (type(value) == "number" and (value == 3 or value == 0x1)) or
					 (type(value) == "string" and value == "s") then
					lim_code = EFFECT_COUNT_CODE_SINGLE 
				else
					lim_code = lim_list[2]
				end
			elseif #lim_list == 3 then
				lim_count = lim_list[1]
				lim_code = lim_list[2] or 0
				local value = lim_list[3]
				if (type(value) == "number" and value == 1) or
					 (type(value) == "string" and value == "o") then 
					lim_code = lim_code + EFFECT_COUNT_CODE_OATH 
				elseif (type(value) == "number" and value == 1) or
					 (type(value) == "string" and value == "d") then
					lim_code = lim_code + EFFECT_COUNT_CODE_DUEL 
				elseif (type(value) == "number" and value == 3) or
					 (type(value) == "string" and value == "s") then
					lim_code = lim_code + EFFECT_COUNT_CODE_SINGLE 
				else
					lim_code = lim_code + value
				end
			end
		else
			if lim_count <= 100 then
				lim_count = lim_list
			else
				lim_count = 1
				lim_code = lim_list
			end
		end
		if is_return then return lim_count, lim_code end
		reg_eff:SetCountLimit(lim_count, lim_code)
	end
end
--Effect: Register Effect Target range
function rsef.RegisterTargetRange(reg_eff, tg_range_list)
	if tg_range_list then
		if type(tg_range_list) == "table" then
			if #tg_range_list == 1 then
				reg_eff:SetTargetRange(tg_range_list[1], tg_range_list[1]) 
			else
				reg_eff:SetTargetRange(tg_range_list[1], tg_range_list[2])
			end
		else
			reg_eff:SetTargetRange(tg_range_list) 
		end
	end
end
--Effect: Register Effect Timing 
function rsef.RegisterTiming(reg_eff, timing_list)
	if timing_list then
		if type(timing_list) == "table" then
			if #timing_list == 1 then
				reg_eff:SetHintTiming(timing_list[1]) 
			else
				reg_eff:SetHintTiming(timing_list[1], timing_list[2])
			end
		else
			reg_eff:SetHintTiming(timing_list) 
		end
	end
end
--Effect: Register Effect Reset way 
function rsef.RegisterReset(reg_eff, reset_list, is_return)
	if reset_list then 
		if type(reset_list) == "table" then
			if #reset_list == 1 then
				if is_return then return reset_list[1], 1 end
				reg_eff:SetReset(reset_list[1]) 
			else
				if is_return then return reset_list[1], reset_list[2] end
				reg_eff:SetReset(reset_list[1], reset_list[2])
			end
		else
			if is_return then return reset_list, 1 end
			reg_eff:SetReset(reset_list) 
		end
	end
end
--Effect: Register Effect Final
function rsef.RegisterEffect(reg_list, reg_eff)
	if rsef.effet_no_register then
		--rsef.effet_no_register = false
		return reg_eff, -1 
	end
	local reg_owner, reg_handler, reg_ignore = rsef.GetRegisterCard(reg_list)
	if type(reg_handler) == "number" and (reg_handler == 0 or reg_handler == 1) then
		Duel.RegisterEffect(reg_eff, reg_handler)
	else
		reg_handler:RegisterEffect(reg_eff, reg_ignore)
	end
	return reg_eff, reg_eff:GetFieldID()
end
--Effect: Register Effect Attributes
function rsef.Register(reg_list, eff_type, eff_code, desc_list, lim_list, cate, flag, range, con, cost, tg, op, val, tg_range_list, timing_list, reset_list)
	local reg_owner, reg_handler, reg_ignore = rsef.GetRegisterCard(reg_list)
	local reg_eff
	if rsof.Check_Boolean(reg_owner, true) then
		reg_eff = Effect.GlobalEffect()
	else
		reg_eff = Effect.CreateEffect(reg_owner)
	end
	if eff_type then
		reg_eff:SetType(eff_type)
	end
	if eff_code then
		reg_eff:SetCode(eff_code)
	end
	rsef.RegisterDescription(reg_eff, desc_list, cate, false)
	rsef.RegisterCountLimit(reg_eff, lim_list)
	rsef.RegisterCateFlag(reg_list, reg_eff, cate, flag)
	if range then
		reg_eff:SetRange(range)
	end
	rsef.RegisterSolve(reg_eff, con, cost, tg, op)
	if val then
		reg_eff:SetValue(val)
	end
	rsef.RegisterTargetRange(reg_eff, tg_range_list)
	rsef.RegisterTiming(reg_eff, timing_list)
	rsef.RegisterReset(reg_eff, reset_list)
	local _, reg_fid = rsef.RegisterEffect(reg_list, reg_eff)
	return reg_eff, reg_fid
end

-------------------"Part_Effect_SingleValue"-------------------

--Single Val Effect: Base set
function rsef.SV(reg_list, code, val, range, con, reset_list, flag, desc_list, lim_list)
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	local flag2 = rsef.GetRegisterProperty(reg_list, flag)
	local flag_list1 = { EFFECT_IMMUNE_EFFECT, EFFECT_CANNOT_BE_BATTLE_TARGET, EFFECT_CANNOT_BE_EFFECT_TARGET, EFFECT_CHANGE_CODE, EFFECT_ADD_CODE, EFFECT_CHANGE_RACE, EFFECT_ADD_RACE, EFFECT_CHANGE_ATTRIBUTE, EFFECT_ADD_ATTRIBUTE, EFFECT_UPDATE_ATTACK, EFFECT_UPDATE_DEFENSE, rscode.Utility_Xyz_Material, rscode.Extra_Synchro_Material, rscode.Extra_Xyz_Material, EFFECT_EXTRA_LINK_MATERIAL, EFFECT_INDESTRUCTABLE, EFFECT_INDESTRUCTABLE_BATTLE, EFFECT_INDESTRUCTABLE_COUNT, EFFECT_INDESTRUCTABLE_EFFECT }
	local flag_list2 = { EFFECT_CHANGE_LEVEL, EFFECT_CHANGE_RANK, EFFECT_UPDATE_LEVEL, EFFECT_UPDATE_RANK }
	local tf1 = rsof.Table_List(flag_list1, code)
	local tf2 = rsof.Table_List(flag_list2, code)
	if (tf1 and reg_owner == reg_handler and not reset_list) or (tf2 and not reset_list and reg_owner ~= reg_handler) then 
		flag2 = flag2 | EFFECT_FLAG_SINGLE_RANGE 
	end
	if desc_list then flag2 = flag2 | EFFECT_FLAG_CLIENT_HINT end
	return rsef.Register(reg_list, EFFECT_TYPE_SINGLE, code, desc_list, lim_list, nil, flag2, range, con, nil, nil, nil, val, nil, nil, reset_list)
end

--Single Val Effect: Activate NS as QPS,  or activate S / T from other location 
function rsef.SV_ActivateDirectly_Special(reg_list, act_loc, con, reset_list, desc_list, timing_list)
	act_loc = act_loc or LOCATION_DECK 
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	local aelist = { reg_handler:GetActivateEffect() }
	if #aelist == 0 then return end
	for _, ae in pairs(aelist) do 
		local te = ae:Clone()
		te:SetType(EFFECT_TYPE_QUICK_O)
		te:SetRange(act_loc)
		te:SetCode(ae:GetCode())
		te:SetCondition(rscon.SV_ActivateDirectly_Special0(ae, con))
		te:SetTarget(rstg.SV_ActivateDirectly_Special0(ae))
		if desc_list then
			rsef.RegisterDescription(te, desc_list)
		end
		rsef.RegisterReset(te, reset_list)
		if not reg_handler:IsType(TYPE_QUICKPLAY) and not reg_handler:IsType(TYPE_TRAP) then
			timing_list = timing_list or { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE }
		end
		if timing_list then 
			rsef.RegisterTiming(te, timing_list)
		end 
		reg_handler:RegisterEffect(te, true)
		local ce = Effect.CreateEffect(reg_handler)
		ce:SetType(EFFECT_TYPE_FIELD)
		ce:SetCode(EFFECT_ACTIVATE_COST)
		ce:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_SET_AVAILABLE)
		ce:SetTargetRange(1, 1)
		ce:SetCost(aux.TRUE)
		ce:SetTarget(rstg.SV_ActivateDirectly_Special)
		ce:SetOperation(rsop.SV_ActivateDirectly_Special)
		ce:SetLabelObject(te)
		ce:SetRange(act_loc)
		rsef.RegisterReset(ce, reset_list)
		reg_handler:RegisterEffect(ce, true) 
	end
end
function rscon.SV_ActivateDirectly_Special0(ae, con2)
	return function(e, tp, ...)
		local con = ae:GetCondition()
		return (not con2 or con2(e, tp, ...)) and (ae:IsActivatable(tp, true) or ( ae:CheckCountLimit(tp) and (not con or con(e, tp, ...)) ) )
	end
end 
function rstg.SV_ActivateDirectly_Special0(ae)
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc, ...)
		local tg = ae:GetTarget() or aux.TRUE 
		if chkc or chk == 0 then return tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc, ...) end
		e:SetType(EFFECT_TYPE_ACTIVATE)
		tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc, ...)
	end
end
function rstg.SV_ActivateDirectly_Special(e, te)
	return te == e:GetLabelObject() 
end
function rsop.SV_ActivateDirectly_Special(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local te = e:GetLabelObject()
	--bug in Ygomobile , 2020.11.23 , add EFFECT_TYPE_QUICK_O will not cause bug , but should add rstg.SV_ActivateDirectly_Special0 to change effect type back.
	--if don't use mobile,  only needs set type to EFFECT_TYPE_ACTIVATE
	--te:SetType(EFFECT_TYPE_ACTIVATE)
	te:SetType(EFFECT_TYPE_ACTIVATE + EFFECT_TYPE_QUICK_O)
	local loc = LOCATION_SZONE 
	if c:IsType(TYPE_PENDULUM) then loc = LOCATION_PZONE 
	elseif c:IsType(TYPE_FIELD) then loc = LOCATION_FZONE 
	end
	Duel.MoveToField(c, tp, tp, loc, POS_FACEUP, true)
end

--Single Val Effect: Cannot disable (Special edition, for UnEffect text)
function rsef.SV_CannotDisable_NoEffect(reg_list, con, reset_list, flag, desc_list, range)
	local e1 = rsef.SV_CANNOT_DISABLE(reg_list, "dis", nil, con, reset_list, "sa,cd,uc", desc_list, 0xff)
	local e2 = rsef.SV_CANNOT_DISABLE(reg_list, "dise", nil, con, reset_list, "sa,cd,uc", desc_list, 0xff)
	return e1, e2
end
--Single Val Effect: Utility Procedure Materials
function rsef.SV_UtilityXyzMaterial(reg_list, val, con, reset_list, flag, desc_list, lim_list, range)
	rssf.EnableSpecialXyzProcedure()
	val = val or 2
	range = range or LOCATION_HAND + LOCATION_ONFIELD + LOCATION_EXTRA + LOCATION_DECK + LOCATION_GRAVE 
	local e1 = rsef.SV(reg_list, rscode.Utility_Xyz_Material, val, range, con, reset_list, flag, desc_list, lim_list)
	return e1
end
--Single Val Effect: Extra Procedure Materials
function rsef.SV_ExtraMaterial(reg_list, mat_list, val_list, con, reset_list, flag, desc_list, lim_list, range)
	local code_list_1 = { "syn", "xyz", "link" }
	local code_list_2 = { rscode.Extra_Synchro_Material, rscode.Extra_Xyz_Material, EFFECT_EXTRA_LINK_MATERIAL } 
	range = range or LOCATION_HAND 
	val_list = val_list or { aux.TRUE } 
	local code_list, val_list2 = rsof.Table_Suit(mat_list, code_list_1, code_list_2, val_list)
	local eff_list = { }
	for idx, eff_code in ipairs(code_list) do 
		local e1 = rsef.SV(reg_list, eff_code, val_list2[idx], range, con, reset_list, flag, desc_list, lim_list)
		table.insert(eff_list, e1)
	end
	return table.unpack(eff_list)
end

--Effect: attribute 
function rsef.Attribute(reg_list, eff_type, att_list, val_list, tg, tg_range_list, flag, range, con, reset_list, desc_list, lim_list, affect_self)
	val_list = type(val_list) == "table" and val_list or { val_list }
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	local eff_flag = rsef.GetRegisterProperty(reg_list, flag) or 0
	local att_list2 = rsof.String_Number_To_Table(att_list)
	local eff_list = { }
	local att_list3 = { }
	for idx, att_str in pairs(att_list2) do 
		att_list3 = { }
		-- for card code buff 
		if type(att_str) == "number" then 
			att_list3 = { att_str }
		else
			att_list3 = rsef.value_code_list[att_str]
		end
		if not att_list3 or #att_list3 == 0 then 
			Debug.Message("rsef.Attribute for ".. reg_owner:GetOriginalCodeRule() .. " must have a correct att_list (2nd parama).")
			return 
		end
		local eff_code, eff_defval, eff_defctlimit, eff_exflag_s, eff_exflag_f, eff_exreset = att_list3[1], att_list3[2], att_list3[3], att_list3[4] or 0, att_list3[5] or 0, att_list3[6] or 0
		local eff_val = val_list[idx] or val_list[1] or eff_defval or 1 
		if rsof.Table_List(rsef.value_affect_self_srt_list, eff_code) and eff_type == "sv" and not reset_list then 
			eff_flag = eff_flag | EFFECT_FLAG_SINGLE_RANGE 
		end
		if not range and (not reset_list or eff_flag & EFFECT_FLAG_SINGLE_RANGE ~= 0 or eff_type == "fv") then
			range = rsef.GetRegisterRange(reg_list)
		end
		if reset_list then
			reset_list = type(reset_list) == "table" and reset_list or { reset_list }
			reset_list[1] = reset_list[1] | eff_exreset 
			if affect_self and rsof.Table_List(rsef.value_affect_self_srt_list, eff_code) then
				reset_list[1] = reset_list[1] | RESET_DISABLE 
			end
		end
		local eff_limit = lim_list or eff_defctlimit
		local e1 = nil
		if type(eff_val) ~= "string" then
			if eff_type == "sv" then
				e1 = rsef.SV(reg_list, eff_code, eff_val, range, con, reset_list, eff_flag | eff_exflag_s, desc_list, eff_limit)
			elseif eff_type == "eq" then
				e1 = rsef.EQ(reg_list, eff_code, eff_val, con, reset_list, eff_flag | eff_exflag_f, desc_list, eff_limit)
			elseif eff_type == "fv" then
				e1 = rsef.FV(reg_list, eff_code, eff_val, tg, tg_range_list, range, con, reset_list, eff_flag | eff_exflag_f, desc_list, eff_limit)
			end
		else 
			-- case add inside series
			if eff_type == "sv" then
				e1 = rsef.SV(reg_list, eff_code, 0, range, con, reset_list, eff_flag | eff_exflag_s, desc_list)
			elseif eff_type == "eq" then
				e1 = rsef.EQ(reg_list, eff_code, 0, con, reset_list, eff_flag | eff_exflag_f, desc_list)
			elseif eff_type == "fv" then
				e1 = rsef.FV(reg_list, eff_code, 0, tg, tg_range_list, range, con, reset_list, eff_flag | eff_exflag_f, desc_list)
			end
			rsval.valinfo[e1] = eff_val
			if reg_handler:GetFlagEffect(rscode.Previous_Set_Code) == 0 then
				local e2 = rsef.SC({ reg_handler, true }, EVENT_LEAVE_FIELD_P, nil, nil, "cd, uc", nil, rsef.presetop)
				reg_handler:RegisterFlagEffect(rscode.Previous_Set_Code, 0, 0, 1)
			end
		end
		table.insert(eff_list, e1)
	end
	return table.unpack(eff_list)   
end 
--Single Val Effect: attribute base set (new)
function rsef.SV_Card(reg_list, att_list, val_list, flag, range, con, reset_list, desc_list, lim_list, affect_self)
	return rsef.Attribute(reg_list, "sv", att_list, val_list, nil, nil, flag, range, con, reset_list, desc_list, lim_list, affect_self)
end 
function rsef.presetop(e, tp)
	local c = e:GetHandler()
	rscf.Previous_Set_Code_List[c] = { c:IsHasEffect(EFFECT_ADD_SETCODE) } 
end

-------------------"Part_Effect_EquipValue"-------------------

--Equip Effect: Base set
function rsef.EQ(reg_list, code, val, con, reset_list, flag, desc_list)
	local flag2 = rsef.GetRegisterProperty(reg_list, flag)
	if desc_list then flag2 = flag2 | EFFECT_FLAG_CLIENT_HINT end
	return rsef.Register(reg_list, EFFECT_TYPE_EQUIP, code, desc_list, nil, nil, flag2, nil, con, nil, nil, nil, val, nil, nil, reset_list) 
end
--Equip Effect: attribute base set (new)
function rsef.EQ_Card(reg_list, att_list, val_list, flag, con, reset_list, desc_list, lim_list, affect_self)
	return rsef.Attribute(reg_list, "eq", att_list, val_list, nil, nil, nil, con, reset_list, flag, desc_list, lim_list, affect_self)
end 
-------------------"Part_Effect_FieldValue"-------------------

--Field Val Effect: Base set
function rsef.FV(reg_list, code, val, tg, tg_range_list, range, con, reset_list, flag, desc_list, lim_list)
	local flag2 = rsef.GetRegisterProperty(reg_list, flag)
	if desc_list then flag2 = flag2 | EFFECT_FLAG_CLIENT_HINT end 
	return rsef.Register(reg_list, EFFECT_TYPE_FIELD, code, desc_list, lim_list, nil, flag2, range, con, nil, tg, nil, val, tg_range_list, nil, reset_list)
end
--Field Val Effect: attribute base set (new)
function rsef.FV_Card(reg_list, att_list, val_list, tg, tg_range_list, flag, range, con, reset_list, desc_list, lim_list)
	return rsef.Attribute(reg_list, "fv", att_list, val_list, tg, tg_range_list, flag, range, con, reset_list, desc_list, lim_list)
end 
--Field Val Effect: attribute base set (new)
function rsef.FV_Player(reg_list, att_list, val_list, tg, tg_range_list, flag, range, con, reset_list, desc_list, lim_list)
	local flag2 = rsef.GetRegisterProperty(reg_list, flag)
	return rsef.Attribute(reg_list, "fv", att_list, val_list, tg, tg_range_list, flag2 | EFFECT_FLAG_PLAYER_TARGET, range, con, reset_list, desc_list, lim_list)
end
--Field Val Effect: Extra Procedure Materials
function rsef.FV_ExtraMaterial(reg_list, mat_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list, lim_list, range) 
	local code_list_1 = { "syn", "xyz", "link" }
	local code_list_2 = { rscode.Extra_Synchro_Material, rscode.Extra_Xyz_Material, EFFECT_EXTRA_LINK_MATERIAL } 
	range = range or rsef.GetRegisterRange(reg_list) 
	val_list = val_list or { aux.TRUE }
	tg_range_list = tg_range_list or { LOCATION_HAND, 0 }
	local flag2 = rsef.GetRegisterProperty(reg_list, flag) | EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE 
	local code_list, val_list2 = rsof.Table_Suit(mat_list, code_list_1, code_list_2, val_list)
	local eff_list = { }
	for idx, eff_code in ipairs(code_list) do
		local e1 = rsef.FV(reg_list, eff_code, val_list2[idx], tg, tg_range_list, range, con, reset_list, flag2, desc_list, lim_list)
		table.insert(eff_list, e1)
	end
	return table.unpack(eff_list)   
end
--Field Val Effect: Extra Procedure Materials for self
function rsef.FV_ExtraMaterial_Self(reg_list, mat_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list, lim_list) 
	local code_list_1 = { "syn", "xyz", "link" }
	local code_list_2 = { rscode.Extra_Synchro_Material, rscode.Extra_Xyz_Material, EFFECT_EXTRA_LINK_MATERIAL } 
	val_list = val_list or { function(e, c, mg) return c == e:GetHandler() end }
	tg_range_list = tg_range_list or { LOCATION_HAND, 0 }
	local flag2 = rsef.GetRegisterProperty(reg_list, flag) | EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE + EFFECT_FLAG_UNCOPYABLE 
	local code_list, val_list2 = rsof.Table_Suit(mat_list, code_list_1, code_list_2, val_list)
	local eff_list = { }
	for idx, eff_code in ipairs(code_list) do
		local e1 = rsef.FV(reg_list, eff_code, val_list2[idx], tg, tg_range_list, LOCATION_EXTRA, con, reset_list, flag2, desc_list, lim_list) 
		table.insert(eff_list, e1)
	end
	return table.unpack(eff_list)   
end
--Field Val Effect: Utility Procedure Materials
function rsef.FV_UTILITY_XYZ_MATERIAL(reg_list, val, tg, tg_range_list, con, reset_list, flag, desc_list, lim_list, range)
	val = val or 2
	tg_range_list = tg_range_list or { LOCATION_MZONE, 0 }
	range = range or rsef.GetRegisterRange(reg_list) 
	local e1 = rsef.FV(reg_list, rscode.Utility_Xyz_Material, val, tg, tg_range_list, range, con, reset_list, flag2, desc_list, lim_list)
	return e1   
end

-------------------"Part_Effect_Activate"-------------------

--Activate Effect: Base set
function rsef.A(reg_list, code, desc_list, lim_list, cate, flag, con, cost, tg, op, timing_list, reset_list)
	local _, reg_handler = rsef.GetRegisterCard(reg_list)
	if reg_handler:IsType(TYPE_TRAP + TYPE_QUICKPLAY) and not timing_list then
		timing_list = { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE }
	end
	if not desc_list then desc_list = rshint.act end
	if not code then code = EVENT_FREE_CHAIN end
	return rsef.Register(reg_list, EFFECT_TYPE_ACTIVATE, code, desc_list, lim_list, cate, flag, nil, con, cost, tg, op, nil, nil, timing_list, reset_list)
end  
--Activate Effect: negate effect
function rsef.A_NegateEffect(reg_list, dis_str, lim_list, con, cost, ex_cate, ex_flag, ex_tg, ex_op, desc_list, reset_list)
	local e1 = rsef.QO_Negate(reg_list, "dis", dis_str, lim_list, nil, con, cost, ex_cate, ex_flag, ex_tg, ex_op, desc_list, reset_list)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	return e1
end
function rsef.A_NegateActivation(reg_list, neg_str, lim_list, con, cost, ex_cate, ex_flag, ex_tg, ex_op, desc_list, reset_list)
	local e1 = rsef.QO_Negate(reg_list, "neg", neg_str, lim_list, nil, con, cost, ex_cate, ex_flag, ex_tg, ex_op, desc_list, reset_list)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	return e1
end
--Activate Effect: Equip Spell
function rsef.A_Equip(reg_list, eqfilter, desc_list, lim_list, con, cost) 
	desc_list = desc_list or rshint.eq
	eqfilter = eqfilter or Card.IsFaceup 
	local eqfilter2 = eqfilter
	eqfilter = function(c, e, tp)
		return c:IsFaceup() and eqfilter2(c, tp)
	end
	local e1 = rsef.A(reg_list, nil, desc_list, lim_list, "eq", "tg", con, cost, rstg.target(eqfilter, "eq", LOCATION_MZONE, LOCATION_MZONE, 1), rsef.A_Equip_Op)
	local e2 = rsef.SV(reg_list, EFFECT_EQUIP_LIMIT, rsef.A_Equip_Val(eqfilter), nil, nil, nil, "cd")
	return e1, e2
end
function rsef.A_Equip_Op(e, tp, eg, ep, ev, re, r, rp) 
	local tc = rscf.GetTargetCard(Card.IsFaceup)
	if e:GetHandler():IsRelateToEffect(e) and tc then
		Duel.Equip(tp, e:GetHandler(), tc)
	end
end
function rsef.A_Equip_Val(eqfilter) 
	return function(e, c)
		local tp = e:GetHandlerPlayer()
		return eqfilter(c, tp)
	end
end
-------------------"Part_Effect_SingleTigger"-------------------

--Self Tigger Effect No Force: Base set
function rsef.STO(reg_list, code, desc_list, lim_list, cate, flag, con, cost, tg, op, reset_list)
	return rsef.Register(reg_list, EFFECT_TYPE_TRIGGER_O + EFFECT_TYPE_SINGLE, code, desc_list, lim_list, cate, flag, nil, con, cost, tg, op, nil, nil, nil, reset_list)
end 
--Self Tigger Effect Force: Base set
function rsef.STF(reg_list, code, desc_list, lim_list, cate, flag, con, cost, tg, op, reset_list)
	return rsef.Register(reg_list, EFFECT_TYPE_TRIGGER_F + EFFECT_TYPE_SINGLE, code, desc_list, lim_list, cate, flag, nil, con, cost, tg, op, nil, nil, nil, reset_list)
end
--Self Flip Effect No Force: Base set
function rsef.STO_Flip(reg_list, desc_list, lim_list, cate, flag, con, cost, tg, op, reset_list)
	return rsef.Register(reg_list, EFFECT_TYPE_TRIGGER_O + EFFECT_TYPE_SINGLE + EFFECT_TYPE_FLIP, nil, desc_list, lim_list, cate, flag, nil, con, cost, tg, op, nil, nil, nil, reset_list)
end 
--Self Flip Effect Force: Base set
function rsef.STF_Flip(reg_list, desc_list, lim_list, cate, flag, con, cost, tg, op, reset_list)
	return rsef.Register(reg_list, EFFECT_TYPE_SINGLE + EFFECT_TYPE_FLIP, nil, desc_list, lim_list, cate, flag, nil, con, cost, tg, op, nil, nil, nil, reset_list)
end
--Field Tigger Effect No Force: Base set
function rsef.FTO(reg_list, code, desc_list, lim_list, cate, flag, range, con, cost, tg, op, reset_list)
	return rsef.Register(reg_list, EFFECT_TYPE_TRIGGER_O + EFFECT_TYPE_FIELD, code, desc_list, lim_list, cate, flag, range, con, cost, tg, op, nil, nil, nil, reset_list)
end
--Field Tigger Effect Force: Base set
function rsef.FTF(reg_list, code, desc_list, lim_list, cate, flag, range, con, cost, tg, op, reset_list)
	return rsef.Register(reg_list, EFFECT_TYPE_TRIGGER_F + EFFECT_TYPE_FIELD, code, desc_list, lim_list, cate, flag, range, con, cost, tg, op, nil, nil, nil, reset_list)
end

---------------------"Part_Effect_Ignition"---------------------

--Ignition Effect: Base set
function rsef.I(reg_list, desc_list, lim_list, cate, flag, range, con, cost, tg, op, reset_list)
	return rsef.Register(reg_list, EFFECT_TYPE_IGNITION, nil, desc_list, lim_list, cate, flag, range, con, cost, tg, op, nil, nil, nil, reset_list)
end

----------------------"Part_Effect_Qucik"-----------------------

--Quick Effect No Force: Base set
function rsef.QO(reg_list, code, desc_list, lim_list, cate, flag, range, con, cost, tg, op, timing_list, reset_list)
	if not code then code = EVENT_FREE_CHAIN end
	if not timing_list and code == EVENT_FREE_CHAIN then timing_list = { 0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE } end
	return rsef.Register(reg_list, EFFECT_TYPE_QUICK_O, code, desc_list, lim_list, cate, flag, range, con, cost, tg, op, nil, nil, timing_list, reset_list)
end 
--Quick Effect: negate effect / activation / summon / spsummon
function rsef.QO_NegateEffect(reg_list, dis_str, lim_list, range, con, cost, ex_cate, ex_flag, ex_tg, ex_op, desc_list, reset_list)
	return rsef.QO_Negate(reg_list, "dis", dis_str, lim_list, range, con, cost, ex_cate, ex_flag, ex_tg, ex_op, desc_list, reset_list)
end
function rsef.QO_NegateActivation(reg_list, neg_str, lim_list, range, con, cost, ex_cate, ex_flag, ex_tg, ex_op, desc_list, reset_list)
	return rsef.QO_Negate(reg_list, "neg", neg_str, lim_list, range, con, cost, ex_cate, ex_flag, ex_tg, ex_op, desc_list, reset_list)
end
function rsef.QO_Negate(reg_list, dn_type, dn_str, lim_list, range, con, cost, ex_cate, ex_flag, ex_tg, ex_op, desc_list, reset_list)
	local reg_cate, reg_flag = 0, 0 
	reg_cate = dn_type == "neg" and CATEGORY_NEGATE or CATEGORY_DISABLE 
	if type(dn_str) == "string" then
		reg_cate = reg_cate | rscate.cate_selhint_list[dn_str][2]
	end
	reg_cate = reg_cate | rsef.GetRegisterCategory(ex_cate or 0)
	reg_flag = reg_flag | rsef.GetRegisterProperty(ex_flag or 0)
	reg_flag = type(dn_type) == "dis" and reg_flag or reg_flag | (EFFECT_FLAG_DAMAGE_CAL + EFFECT_FLAG_DAMAGE_STEP)
	range = range or rsef.GetRegisterRange(reg_list)
	desc_list = desc_list or dn_type 
	con = con or rscon[dn_type]("s,t,m")
	ex_tg = ex_tg or aux.TRUE 
	ex_op = ex_op or aux.TRUE 
	return rsef.QO(reg_list, EVENT_CHAINING, desc_list, lim_list, reg_cate, reg_flag, range, con, cost, rstg[dn_type](dn_str, ex_tg), rsop[dn_type](dn_str, ex_op), nil, reset_list)	  
end 
--Quick Effect Force: Base set
function rsef.QF(reg_list, code, desc_list, lim_list, cate, flag, range, con, cost, tg, op, reset_list)
	return rsef.Register(reg_list, EFFECT_TYPE_QUICK_F, code, desc_list, lim_list, cate, flag, range, con, cost, tg, op, nil, nil, nil, reset_list)
end
-----------------"Part_Effect_FieldContinues"-----------------

--Field Continues: Base set
function rsef.FC(reg_list, code, desc_list, lim_list, flag, range, con, op, reset_list)
	if not reset_list then
		range = range or rsef.GetRegisterRange(reg_list)
	end
	return rsef.Register(reg_list, EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS, code, desc_list, lim_list, nil, flag, range, con, nil, nil, op, nil, nil, nil, reset_list)
end 
--Field Continues: Destroy replace
function rsef.FC_DestroyReplace(reg_list, lim_list, range, repfilter, tg, op, con, flag, reset_list)
	repfilter = repfilter or aux.TRUE 
	local e1 = rsef.FC(reg_list, EFFECT_DESTROY_REPLACE, nil, lim_list, nil, range, con, op, reset_list)
	e1:SetValue(rsval.FC_DestroyReplace(repfilter))
	e1:SetTarget(rstg.FC_DestroyReplace(repfilter, tg))
	local g = Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	return e1, g 
end
function rsval.FC_DestroyReplace(repfilter)
	return function(e, c)
		return e:GetLabelObject():IsContains(c)
	end
end
function rscf.FC_DestroyReplace_Filter(c, repfilter, ...)
	return repfilter(c, ...) and not c:IsReason(REASON_REPLACE)
end
function rstg.FC_DestroyReplace(repfilter, tg)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		local rg = eg:Filter(rscf.FC_DestroyReplace_Filter, nil, repfilter, e, tp, eg, ep, ev, re, r, rp)
		if chk == 0 then 
			return #rg >0 and tg(e, tp, eg, ep, ev, re, r, rp, 0)
		end
		if Duel.SelectEffectYesNo(tp, c, 96) then
			rshint.Card(c:GetOriginalCode())
			local container=e:GetLabelObject()
			container:Merge(rg)
			tg(e, tp, eg, ep, ev, re, r, rp, 1)
			return true
		end
		return false
	end
end

--Field Continues: Attach an extra effect when base effect is activating
function rsef.FC_AttachEffect_Activate(reg_list, desc_list, lim_list, flag, range, attach_con, attach_op, reset_list, force)
	return rsef.FC_AttachEffect(reg_list, force, 0x1, desc_list, lim_list, flag, range, attach_con, attach_op, reset_list) 
end
--Field Continues: Attach an extra effect before the base effect solving
function rsef.FC_AttachEffect_BeforeResolve(reg_list, desc_list, lim_list, flag, range, attach_con, attach_op, reset_list, force)
	return rsef.FC_AttachEffect(reg_list, force, 0x2, desc_list, lim_list, flag, range, attach_con, attach_op, reset_list) 
end
--Field Continues: Attach an extra effect after the base effect solving
function rsef.FC_AttachEffect_Resolve(reg_list, desc_list, lim_list, flag, range, attach_con, attach_op, reset_list, force)
	return rsef.FC_AttachEffect(reg_list, force, 0x4, desc_list, lim_list, flag, range, attach_con, attach_op, reset_list) 
end
function rsef.FC_AttachEffect(reg_list, force, attach_time, desc_list, lim_list, flag, range, attach_con, attach_op, reset_list) 
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	range = range or rsef.GetRegisterRange(reg_list)
	local attach_code = rscode.Extra_Effect_Activate 
	if attach_time == 0x2 then attach_code = rscode.Extra_Effect_BSolve end
	if attach_time == 0x4 then attach_code = rscode.Extra_Effect_ASolve end
	local e0 = rsef.I(reg_list, nil, lim_list, nil, flag, range, aux.FALSE, nil, nil, nil, reset_list)
	local e1 = rsef.FC(reg_list, attach_code, desc_list, nil, flag, range, rsef.FC_AttachEffect_Con(e0, attach_con), rsef.FC_AttachEffect_Op(e0, force), reset_list)
	e1:SetValue(attach_op)
	e1:SetLabelObject(e0)
	local desc = not desc_list and 0 or rsef.RegisterDescription(nil, desc_list, nil, true)
	if aux.GetValueType(reg_handler) == "Card" then
		reg_handler:RegisterFlagEffect(attach_code, reset, EFFECT_FLAG_CLIENT_HINT, reset_tct, e1:GetFieldID(), desc)
	else
		local e1 = Effect.CreateEffect(reg_owner)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(0x10000000 + attach_code)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(desc)
		e1:SetTargetRange(1, 0)
		e1:SetReset(reset, reset_tct)
		Duel.RegisterEffect(e1, reg_handler)
	end
	if rsef.FC_AttachEffect_Switch then return e1 end
	rsef.FC_AttachEffect_Switch = true
	for p = 0, 1 do
		local e2 = Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetOperation(rsef.FC_AttachEffect_ChangeOp)
		e2:SetOwnerPlayer(p)
		Duel.RegisterEffect(e2, p)
	end 
	rsef.ChangeChainOperation = Duel.ChangeChainOperation
	Duel.ChangeChainOperation = rsef.ChangeChainOperation2  
	return e1
end
function rsef.FC_AttachEffect_Con(e0, attach_con)
	return function(e, tp, eg, ep, ev, re, r, rp)
		if not e0:CheckCountLimit(tp) then return false end
		return not attach_con or attach_con(e, tp, eg, ep, ev, re, r, rp)
	end
end
function rsef.FC_AttachEffect_Op(e0, force)
	return function(e, tp, eg, ep, ev, re, r, rp)
		rsef.attacheffect[ev] = rsef.attacheffect[ev] or { }
		rsef.attacheffectf[ev] = rsef.attacheffectf[ev] or { }
		if force then table.insert(rsef.attacheffectf[ev], e)
		else
			table.insert(rsef.attacheffect[ev], e)
		end
	end
end
function rsef.FC_AttachEffect_GetGroup(sel_list)
	local attach_group = Group.CreateGroup()
	local attach_eff_list = { }
	for _, ae in pairs(sel_list) do
		local tc = ae:GetOwner()
		attach_group:AddCard(tc)
		attach_eff_list[tc] = attach_eff_list[tc] or { }
		table.insert(attach_eff_list[tc], ae)
	end
	return attach_group, attach_eff_list
end
function rsef.ChangeChainOperation2(ev, changeop, ischange)
	rsef.ChangeChainOperation(ev, changeop)
	if ischange then return end
	rsop.baseop[ev] = changeop
end
function rsef.FC_AttachEffect_ChangeOp(e, tp, eg, ep, ev, re, r, rp)
	local baseop = re:GetOperation() or aux.TRUE 
	baseop = rsop.baseop[ev] or baseop
	local e1 = rsef.FC({ true, 0 }, EVENT_CHAIN_SOLVED, nil, nil, nil, nil, nil, rsef.FC_AttachEffect_Reset(re, baseop), RESET_CHAIN)
	rsef.ChangeChainOperation2(ev, rsef.FC_AttachEffect_ChangeOp2(baseop), true)
end
function rsef.FC_AttachEffect_Reset(re1, baseop)
	return function(e, tp, eg, ep, ev, re, r, rp)
		if re1 ~= re then return end
		rsef.attacheffect[ev] = nil
		rsef.attacheffectf[ev] = nil
		rsef.solveeffect[ev] = nil
		rsop.baseop[ev] = nil
		local rc = re:GetHandler()
		local res1 = re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsType(TYPE_PENDULUM + TYPE_FIELD + TYPE_CONTINUOUS + TYPE_EQUIP)
		local res2 = #({ rc:IsHasEffect(EFFECT_REMAIN_FIELD) }) > 0
		--what is ev2 ??
		if (res1 or res2) then--and not rsop.baseop[ev2] then
			re:SetOperation(baseop)
			rc:CancelToGrave(true)
		end
	end
end
function rsef.FC_AttachEffect_Solve(solve_eff_list, attach_time, e, tp, eg, ep, ev, re, r, rp)
	local act_use_list = { }
	local ev2 = Duel.GetCurrentChain()
	local attach_code = rscode.Extra_Effect_Activate 
	if attach_time == 0x2 then attach_code = rscode.Extra_Effect_BSolve end
	if attach_time == 0x4 then attach_code = rscode.Extra_Effect_ASolve end
	Duel.RaiseEvent(e:GetHandler(), attach_code, e, 0, tp, tp, ev2)
	local force_list = rsef.attacheffectf[ev2] or { }
	local sel_tab_list = rsef.attacheffect[ev2] or { }
	for _, ae in pairs(force_list) do
		local tc = ae:GetOwner()
		if tc:IsOnField() then
			Duel.HintSelection(rsgf.Mix2(tc))
		else
			Duel.Hint(HINT_CARD, 0, tc:GetOriginalCodeRule())
		end
		Duel.Hint(HINT_OPSELECTED, 1 - tp, ae:GetDescription())
		table.insert(act_use_list, ae)
		ae:GetLabelObject():UseCountLimit(tp, 1)
		if attach_time ~= 0x1 then
			table.insert(solve_eff_list, ae)
			ae:GetValue()(e, tp, eg, ep, ev, re, r, rp)
		end
	end
	local attach_group, attach_eff_list = rsef.FC_AttachEffect_GetGroup(sel_tab_list)
	local sel_hint = 8
	if attach_time == 0x2 then sel_hint = 9 end
	if attach_time == 0x4 then sel_hint = 10 end
	if #attach_group > 0 and Duel.SelectYesNo(tp, aux.Stringid(m, sel_hint)) then
		::Select::
		rshint.Select(tp, HINTMSG_TARGET)
		local tc = attach_group:Select(tp, 1, 1, nil):GetFirst()
		if tc:IsOnField() then
			Duel.HintSelection(rsgf.Mix2(tc))
		else
			Duel.Hint(HINT_CARD, 0, tc:GetOriginalCodeRule())
		end
		local hint_list = { }
		for _, ae in pairs(attach_eff_list[tc]) do
			local hint = ae:GetDescription()
			table.insert(hint_list, hint)
		end
		local opt = Duel.SelectOption(tp, table.unpack(hint_list)) + 1
		local ae = attach_eff_list[tc][opt]
		Duel.Hint(HINT_OPSELECTED, 1 - tp, ae:GetDescription())
		table.insert(act_use_list, ae)
		ae:GetLabelObject():UseCountLimit(tp, 1)
		if attach_time ~= 0x1 then
			table.insert(solve_eff_list, ae)
			ae:GetValue()(e, tp, eg, ep, ev, re, r, rp)
		end
		local _, idx = rsof.Table_List(sel_tab_list, ae)
		table.remove(sel_tab_list, idx)
		attach_group, attach_eff_list = rsef.FC_AttachEffect_GetGroup(sel_tab_list)
		if #attach_group > 0 and Duel.SelectYesNo(tp, aux.Stringid(m, 11)) then goto Select end
	end
	rsef.attacheffect[ev2] = nil
	rsef.attacheffectf[ev2] = nil
	return act_use_list
end
function rsef.FC_AttachEffect_ChangeOp2(baseop)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local ev2 = Duel.GetCurrentChain()
		local c = e:GetHandler()
		if (c:IsType(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS) or c:IsLocation(LOCATION_PZONE)) and not c:IsRelateToEffect(e) then
			return
		end
		rsef.solveeffect[ev2] = { }
		--baseop record
		table.insert(rsef.solveeffect[ev2], baseop)
		--activate select
		local act_use_list = rsef.FC_AttachEffect_Solve(rsef.solveeffect[ev2], 0x1, e, tp, eg, ep, ev, re, r, rp)
		--before solve
		rsef.FC_AttachEffect_Solve(rsef.solveeffect[ev2], 0x2, e, tp, eg, ep, ev, re, r, rp)  
		--baseop solve
		baseop(e, tp, eg, ep, ev, re, r, rp)
		--activate solve 
		for _, ae in pairs(act_use_list) do
			table.insert(rsef.solveeffect[ev2], ae)
			ae:GetValue()(e, tp, eg, ep, ev, re, r, rp)
			ae:GetLabelObject():UseCountLimit(tp, 1)
		end
		--after solve 
		rsef.FC_AttachEffect_Solve(rsef.solveeffect[ev2], 0x4, e, tp, eg, ep, ev, re, r, rp)  
	end
end

--Effect Function:XXX card / group will leave field in XXX Phase , often use in special summon
function rsef.FC_PhaseOpearte(reg_list, leave_val, times, whos, phase, ex_con, leaveway, val_reset_list)
	--times: nil  every phase 
	--   0  next  phase
	--   1 or +  times  phase 
	--whos:  nil  each player 
	--   0  yours phase (tp)
	--   1  your opponent's phase (1 - tp)
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	local cphase = Duel.GetCurrentPhase()
	local atct = Duel.GetTurnCount()
	local turnp = Duel.GetTurnPlayer()
	phase = phase or PHASE_END 
	leaveway = leaveway or "des"   
	local sg = rsgf.Mix2(leave_val)
	local fid = reg_owner:GetFieldID()
	val_reset_list = val_reset_list or rsrst.std
	local reset = rsef.RegisterReset(nil, val_reset_list, true)
	for tc in aux.Next(sg) do 
		tc:RegisterFlagEffect(rscode.Phase_Leave_Flag, reset, 0, 0, fid)
	end
	sg:KeepAlive()
	local e1 = rsef.FC(reg_list, EVENT_PHASE + phase, rshint.epleave, 1, "ii", nil, rsef.FC_PhaseLeave_Con(phase, atct, whos, fid, times, ex_con), rsef.FC_PhaseLeave_Op(leaveway, fid))
	rsop.opinfo[e1] = {sg, 0, 0}
	return e1
end
function rsef.FC_PhaseLeave_Filter(c, fid)
	return c:GetFlagEffectLabel(rscode.Phase_Leave_Flag) == fid
end 
function rsef.FC_PhaseLeave_Con(phase, atct, whos, fid, times, ex_con)
	return function(e, tp, ...)
		local sg, tct, ph_chk = table.unpack(rsop.opinfo[e])
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
		rsop.opinfo[e] = {sg, tct, ph_chk}
		sg, tct, ph_chk = table.unpack(rsop.opinfo[e])
		local reset, solve = false, false
		local rg = sg:Filter(rsef.FC_PhaseLeave_Filter, nil, fid)
		if #rg <= 0 then 
			reset = true
		end
		--case1, every phase
		if not times then
			solve = true 
		end
		-- case2, next phase
		if times and times == 0 then
			if tct == 1 then
				solve = true
			elseif tct > 1 then
				reset = true
			end
		end
		-- case3, 1+ phase
		if times and times>0 and times == tct then
			solve = true 
		elseif times and times>0 and tct > times then
			reset = true
		end
		if reset then
			sg:DeleteGroup() 
			e:Reset() 
			return  
		end
		return solve and (not ex_con or ex_con(e, tp, ...))
	end
end
function rsef.FC_PhaseLeave_Op(solve_str, fid)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local sg, tct, ph_chk = table.unpack(rsop.opinfo[e])
		local c = e:GetOwner()
		Duel.Hint(HINT_CARD, 0, c:GetOriginalCode())
		local rg = sg:Filter(rsef.FC_PhaseLeave_Filter, nil, fid)
		if type(solve_str) == "function" then solve_str(rg, e, tp, eg, ep, ev, re, r, rp)
		else
			rsop.Operation_Solve(rg, solve_str, REASON_EFFECT, { }, 1, e, tp, eg, ep, ev, re, r, rp)
		end
	end
end

--Global Flag Effects 
function rsef.FC_Global(reg_player, event, same_code, con, op)
	if type(reg_player) ~= "number" then 
		Debug.Message("The firt param of rsef.FC_Global must be player (number).")
		return 
	end
	if not rsef.FC_Global_List[reg_player] then
		rsef.FC_Global_List[reg_player] = { }
	end
	if not rsef.FC_Global_List[reg_player][event] then 
		local ge1 = rsef.FC({true,reg_player}, event)
		ge1:SetOperation(rsop.FC_Global(reg_player,event))
		rsef.FC_Global_List[reg_player][event] = { ["effect"] = ge1, ["list"] = { } }
	end
	if not rsef.FC_Global_List[reg_player][event]["list"][same_code] then
		rsef.FC_Global_List[reg_player][event]["list"][same_code] = { con or aux.TRUE, op or aux.TRUE }
	end
	return rsef.FC_Global_List[reg_player][event]["effect"]
end
function rsop.FC_Global(reg_player,event)
	return function(e, tp, ...)
		local con, op 
		local list = rsef.FC_Global_List[reg_player][event]["list"]
		for idx, val in pairs(list) do  
			con, op = val[1], val[2]
			if not con or con(e, tp, ...) then
				op(e, tp, ...)
			end   
		end
	end
end
--Field Continues: Easy Player
function rsef.FC_Easy(reg_list, code, flag, range, con, op, reset_list)
	return rsef.FC(reg_list, code, nil, nil, flag, range, con, op, reset_list)
end
----------------"Part_Effect_SingleContinuous"----------------

--Single Continues: Base set
function rsef.SC(reg_list, code, desc_list, lim_list, flag, con, op, reset_list)
	return rsef.Register(reg_list, EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS, code, desc_list, lim_list, nil, flag, nil, con, nil, nil, op, nil, nil, nil, reset_list)
end 
--Single Continues: Easy 
function rsef.SC_Easy(reg_list, code, flag, con, op, reset_list)
	return rsef.SC(reg_list, code, nil, nil, flag, con, op, reset_list)
end
--Single Continues: Destroy Replace 
function rsef.SC_DestroyReplace(reg_list, lim_list, repfilter, tg, op, con, flag, reset_list)
	local flag2 = rsef.GetRegisterProperty(reg_list, flag)
	local e1 = rsef.SC(reg_list, EFFECT_DESTROY_REPLACE, nil, lim_list, flag2 | EFFECT_FLAG_SINGLE_RANGE, con, op, reset_list)
	e1:SetTarget(rstg.SC_DestroyReplace(repfilter, tg))
	local range = rsef.GetRegisterRange(reg_list)
	e1:SetRange(range)
	return e1
end 
function rstg.SC_DestroyReplace(repfilter, tg)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		if chk == 0 then 
			return rscf.FC_DestroyReplace_Filter(c, repfilter, e, tp, eg, ep, ev, re, r, rp) 
				and tg(e, tp, eg, ep, ev, re, r, rp, 0)
		end
		if Duel.SelectEffectYesNo(tp, c, 96) then
			rshint.Card(c:GetOriginalCode())
			tg(e, tp, eg, ep, ev, re, r, rp, 1)
			return true
		end
		return false
	end
end

-------------------"Part_Summon_Function"---------------------
--Summon check "Blue - Eyes Spirit Dragon"
function rssf.CheckBlueEyesSpiritDragon(tp)
	return Duel.IsPlayerAffectedByEffect(tp, 59822133)
end
--Summon Function: Set Default Parameter
function rssf.GetSSDefaultParameter(sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos)
	sum_type= sum_type or 0 
	sum_pl = sum_pl or Duel.GetChainInfo(0, CHAININFO_TRIGGERING_PLAYER) 
	loc_pl = loc_pl or sum_pl
	ignore_con = ignore_con or false
	ignore_revie = ignore_revie or false
	pos = pos or POS_FACEUP
	return sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos
end
--Summon Function: Duel.SpecialSummon + buff
function rssf.SpecialSummon(sum_obj, sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos, zone, card_fun, group_fun)
	sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos = rssf.GetSSDefaultParameter(sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos)
	local g = Group.CreateGroup()
	local sum_group = rsgf.Mix2(sum_obj)
	if rsop.chk == 0 then 
		return true 
	end
	for sum_card in aux.Next(sum_group) do
		if rssf.SpecialSummonStep(sum_card, sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos, zone, card_fun) then
			g:AddCard(sum_card)
		end
	end
	Duel.SpecialSummonComplete()
	return rssf.RegisterGroupFun(sum_group, group_fun)
end 
--Summon Function: Duel.SpecialSummonStep + buff 
function rssf.SpecialSummonStep(sum_card, sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos, zone, card_fun) 
	sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos = rssf.GetSSDefaultParameter(sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos)
	local sum_res = false
	if zone then
		sum_res = Duel.SpecialSummonStep(sum_card, sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos, zone)
	else
		sum_res = Duel.SpecialSummonStep(sum_card, sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos)
	end
	if sum_res and card_fun then
		local e = sum_card:GetReasonEffect()
		local tp = e:GetHandlerPlayer()
		local c = sum_card:GetReasonEffect():GetHandler()
		if type(card_fun) == "table" then 
			rscf.QuickBuff({ c, sum_card, true }, table.unpack(card_fun))
		elseif type(card_fun) == "function" then
			card_fun(sum_card , e, tp, g)
		end
	end
	return sum_res, sum_card
end
--Summon Function: Duel.SpecialSummon to either player's field + buff
function rssf.SpecialSummonEitherStep(sum_card, sum_eff, sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos, zone2, card_fun) 
	sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos = rssf.GetSSDefaultParameter(sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos)
	if not sum_eff then sum_eff = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT) end
	local tp = sum_pl
	local zone = { }
	local flag = { }
	if not zone2 then
		zone2 = { [0] = 0x1f, [1] = 0x1f }
	end
	local ava_zone = 0
	for p = 0, 1 do
		zone[p] = zone2[p] & 0xff
		local _, flag_tmp = Duel.GetLocationCount(p, LOCATION_MZONE, tp, LOCATION_REASON_TOFIELD, zone[p])
		flag[p] = (~flag_tmp) & 0x7f
	end
	for p = 0, 1 do
		if sum_card:IsCanBeSpecialSummoned(sum_eff, sum_type, sum_pl, ignore_con, ignore_revie, pos, p, zone[p]) then
			ava_zone = ava_zone | (flag[p] << (p == tp and 0 or 16))
		end
	end
	if ava_zone <= 0 then return 0, nil end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
	local sel_zone = Duel.SelectDisableField(tp, 1, LOCATION_MZONE, LOCATION_MZONE, 0x00ff00ff & ( ~ ava_zone))
	local loc_pl = 0
	if sel_zone & 0xff > 0 then
		loc_pl = tp
	else
		loc_pl = 1 - tp
		sel_zone = sel_zone >> 16
	end
	return rssf.SpecialSummonStep(sum_card, sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos, sel_zone, card_fun)
end
--Summon Function: Duel.SpecialSummon to either player's field + buff
function rssf.SpecialSummonEither(sum_obj, sum_eff, sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos, zone2, card_fun, group_fun) 
	sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos = rssf.GetSSDefaultParameter(sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos)
	if not sum_eff then sum_eff = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT) end
	local sum_group = rsgf.Mix2(sum_obj)
	for sum_card in aux.Next(sum_group) do 
		local summ_res, sum_card = rssf.SpecialSummonEitherStep(sum_card, sum_eff, sum_type, sum_pl, loc_pl, ignore_con, ignore_revie, pos, zone2, card_fun)
		if summ_res then
			sum_group:AddCard(sum_card)
		end
	end
	Duel.SpecialSummonComplete()
	return rssf.RegisterGroupFun(sum_group, group_fun)
end
--Summon Function: Reg group_fun
function rssf.RegisterGroupFun(sum_group, group_fun)
	for sum_card in aux.Next(sum_group) do
		if sum_card:GetFlagEffect(rscode.Pre_Complete_Proc) > 0 then
			sum_card:CompleteProcedure()
			sum_card:ResetFlagEffect(rscode.Pre_Complete_Proc)
		end
	end
	local e = sum_group:GetFirst():GetReasonEffect()
	local tp = e:GetHandlerPlayer()
	local c = sum_group:GetFirst():GetReasonEffect():GetHandler()
	if #sum_group > 0 and group_fun then
		if type(group_fun) == "table" then 
			rsef.FC_PhaseLeave({ c, tp }, sum_group, table.unpack(group_fun))
		elseif type(group_fun) == "string" then
			rsef.FC_PhaseLeave({ c, tp }, sum_group, nil, nil, PHASE_END, group_fun)
		elseif type(card_fun) == "function" then
			group_fun(sum_group, c, e, tp)
		end
	end
	return #sum_group, sum_group, sum_group:GetFirst()
end
-------------------"Part_Value_Function"---------------------

--value: SummonConditionValue - can only be special summoned from Extra Deck (if can only be XXX summoned from Extra Deck,  must use aux.OR(xxxval, rsval.spconfe),  but not AND)
function rsval.spconfe(e, se, sp, st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
--value: SummonConditionValue - can only be special summoned by self effects
--because of EnableReviveLimit , this is now uselsee
function rsval.spcons(e, se, sp, st)
	return se:GetHandler() == e:GetHandler() and se:IsHasType(EFFECT_TYPE_ACTIONS) 
end
--value: SummonConditionValue - can only be special summoned by card effects 
function rsval.spconbe(e, se, sp, st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
--value: reason by battle or card effects
function rsval.indbae(string1, string2)  
	return function(e, re, r, rp)
		if not string1 and not string2 then return r & (REASON_BATTLE + REASON_EFFECT) ~=0 end
		return ((string1 == "battle" or string2 == "battle") and r & REASON_BATTLE ~=0 ) or ((string1 == "effect" or string2 == "effect") and r & REASON_EFFECT ~=0 )
	end
end
--value: reason by battle or card effects,  EFFECT_INDESTRUCTABLE_COUNT
function rsval.indct(string1, string2)
	return function(e, re, r, rp)
		if ((string1 == "battle" or string2 == "battle") and r & REASON_BATTLE ~=0 ) or ((string1 == "effect" or string2 == "effect") and r & REASON_EFFECT ~=0 ) or (not string1 and not string2 and r & REASON_BATTLE + REASON_EFFECT ~=0) then
			return 1
		else return 0 
		end
	end
end
--value: unaffected by opponent's card effects
function rsval.imoe(e, re)
	return e:GetOwnerPlayer() ~= re:GetHandlerPlayer()
end
--value: unaffected by other card effects 
function rsval.imes(e, re)
	return re:GetOwner() ~= e:GetOwner()
end
--value: unaffected by other card effects that do not target it
function rsval.imntges(e, re)
	local c = e:GetHandler()
	local ec = re:GetHandler()
	if re:GetOwner() == e:GetOwner() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--value: unaffected by opponent's card effects that do not target it
function rsval.imntgoe(e, re)
	local c = e:GetHandler()
	local ec = re:GetHandler()
	if re:GetHandlerPlayer() == e:GetHandlerPlayer() or ec:IsHasCardTarget(c) or (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re)) then return false
	end
	return true
end
--value: EFFECT_CANNOT_INACTIVATE, EFFECT_CANNOT_DISEFFECT
function rsval.cdisneg(filter)
	return function(e, ct)
		filter = filter or aux.TRUE 
		local p = e:GetHandlerPlayer()
		local te, tp, loc = Duel.GetChainInfo(ct, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER, CHAININFO_TRIGGERING_LOCATION)
		return filter(e, p, te, tp, loc)
	end
end
--value: Cannot be fusion summon material 
function rsval.fusslimit(e, c, sum_type)
	return sum_type and sum_type & SUMMON_TYPE_FUSION == SUMMON_TYPE_FUSION 
end
-------------------"Part_Target_Function"---------------------

--Card target: do not have an effect target it
function rstg.imntg(e, c)
	local te, g = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TARGET_CARDS)
	return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end 
--Effect target: Token 
function rscf.AddTokenList(c,tk_code1,...)
	local tk_code_list = { tk_code1, ... }
	for _, tk_code in pairs(tk_code_list) do
		aux.AddCodeList(c,tk_code)
		if not rstg.tk_list[tk_code] then 
			rstg.tk_list[tk_code] = { } 
			local ge1 = rsef.FC_Global(0, EVENT_ADJUST, tk_code, nil, rsop.AddTokenList_Op(tk_code))
		end
	end
end
function rsop.AddTokenList_Op(tk_code)
	return function(e, tp) 
		if not rstg.tk_list[tk_code][1] then 
			rstg.tk_list[tk_code] = { [0] = Duel.CreateToken(0, tk_code), [1]= Duel.CreateToken(1, tk_code) }
		end
	end
end
function rstg.token(tk_code_or_fun, ct, sum_pos, tg_p)
	if type(tk_code_or_fun) == "number" and not rstg.tk_list[tk_code_or_fun] then 
		Debug.Message("Token " .. tk_code_or_fun .. " hasn't been registered by 'rscf.AddTokenList'")
	end
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		tg_p = tg_p or 0
		local sp = tg_p == 0 and tp or 1 - tp
		local res = rssf.CheckTokenSummonable(e, tp, tk_code_or_fun, sum_pos, sp, nil, eg, ep, ev, re, r, rp, 0)
		local ft = Duel.GetLocationCount(sp, LOCATION_MZONE, tp)	 
		if rssf.CheckBlueEyesSpiritDragon(tp) and type(ct) == "number" and ct > 1 then res = false end
		if type(ct) == "number" and ft < ct then res = false end
		if chkc then return true end
		if chk == 0 then return res end
		Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, spct, 0, 0)
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, spct, 0, 0)
	end
end
function rssf.CheckTokenSummonable(e, tp, tk_code_or_fun, sum_pos, tg_p, sum_zone, ...)
	local tk
	local tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_type
	if type(tk_code_or_fun) == "number" then
		if not rstg.tk_list[tk_code_or_fun] then 
			local ge1 = rsef.FC_Global(0, EVENT_ADJUST, tk_code_or_fun, nil, rsop.token_reg(tk_code_or_fun))
			Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
		end
		tk = rstg.tk_list[tk_code_or_fun][tp]
	elseif type(tk_code_or_fun) == "function" then
		tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_type = tk_att_fun(e, tp, ...)
	else
		tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_type = table.unpack(tk_code_or_fun)
	end
	ct = ct or 1 
	sp = sp or tg_p or tp 
	sum_pos = sum_pos2 or sum_pos or POS_FACEUP
	sum_type = sum_type or 0 
	if not tk and 
		not Duel.IsPlayerCanSpecialSummonMonster(tp, tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos, sp, sum_type) then
		return false
	end
	if tk then
		if not sum_zone then 
			return tk:IsCanBeSpecialSummoned(e, sum_type or 0, tp, false, false, sum_pos, sp)
		else
			return tk:IsCanBeSpecialSummoned(e, sum_type or 0, tp, false, false, sum_pos, sp, sum_zone)
		end
	end
	return true
end
function rssf.SpecialSummonToken(e, tp, tk_code_or_fun, minct, maxct, sum_pos, tg_p, sum_zone, ...)
	local res_ct = 0
	local res = rssf.CheckTokenSummonable(e, tp, tk_code_or_fun, sum_pos, tg_p, sum_zone, ...)
	if not res then return res_ct end
	local ft = Duel.GetLocationCount(sp, LOCATION_MZONE, tp)   
	if ft <= 0 then return false end
	local sum_min, sum_max = minct, math.min(maxct, ft)
	if rssf.CheckBlueEyesSpiritDragon(tp) and type(minct) == "number" and minct > 1 then return res_ct end
	if type(minct) == "number" and ft < minct then return res_ct end
	if rsof.Check_Boolean(minct) then
		sum_min= ft
	end
	if rssf.CheckBlueEyesSpiritDragon(tp) then 
		sum_min, sum_max = 1, 1
	end
	if sum_min > sum_max then return res_ct end
	local sp_ct = sum_min
	if sum_max > sum_min then 
		local list = { }
		for idx = sum_min, sum_max do 
			table.insert(list, idx)
		end
		sp_ct = Duel.AnnounceNumber(tp, table.unpack(list))
	end
	local tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_type
	if type(tk_code_or_fun) == "number" then
		tk_code = tk_code_or_fun
	elseif type(tk_code_or_fun) == "function" then
		tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_type = tk_code_or_fun(e, tp, ...)
	else 
		tk_code, tk_set, tk_type, tk_atk, tk_def, tk_lv, tk_race, tk_att, sum_pos2, sp, sum_type = table.unpack(tk_code_or_fun)
	end
	sp = sp or tg_p or tp 
	sum_pos = sum_pos2 or sum_pos or POS_FACEUP
	sum_type = sum_type or 0 
	for idx = 1, sp_ct do 
		tk = Duel.CreateToken(tp, tk_code)
		if type(tk_code_or_fun) ~= "number" then 
			local e1, e2, e3, e4, e5, e6 = rscf.QuickBuff({e:GetHandler(), tk, true}, "type", tk_type, "batk", tk_atk, "bdef", tk_def, "lv", tk_lv, "race", tk_race, "att", tk_att,"rst",rsrst.std_ntf)
		end
		if rssf.SpecialSummonStep(tk, sum_type, tp, sp, false, false, sum_pos, sum_zone) then
			res_ct = res_ct + 1
		end
	end
	Duel.SpecialSummonComplete()
	local og = Duel.GetOperatedGroup()
	return res_ct, og, og:GetFirst()
end
--Effect Target: Negative Effect / Activate
function rstg.disneg(dn_type, dn_str, ex_tg)
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
function rstg.dis(dn_str, ex_tg)
	return function(...)
		return rstg.disneg("dis", dn_str, ex_tg)(...)
	end
end
function rstg.neg(dn_str, ex_tg)
	return function(...)
		return rstg.disneg("neg", dn_str, ex_tg)(...)
	end
end

--Effect target: Target Cards Main Set 
function rsef.list(list_type_str,  val1,  val2,  val3,  ...)
	local value_list = { }
	if type(val1) == "table" and (not val2 or (type(val2) == "table" )) and (not val3 or type(val3) == "table") then
		value_list = { val1,  val2,  val3,  ... }
	else
		value_list = { { val1,  val2,  val3,  ... } }
	end
	local par_list = { }
	for idx,  val in pairs(value_list) do
		par_list[idx] = { }
		local res = rsef.list_check_divide(val[1],  list_type_str) 
		if not res then
			par_list[idx][1] = list_type_str
		end
		for par_idx = 1,  10 do 
			par_list[idx][res and par_idx or par_idx + 1] = val[par_idx]
		end
	end
	return par_list
end
function rsef.list_check_divide(val,  list_type_str)
	if type(val) ~= "string" then return false, nil end
	local res = val == "cost" or val == "tg" or val == "opc" or val == "ops"
	return res,  val or list_type_str
end
--targetvalue1 = { filter_card, category, loc_self, loc_oppo, minct, maxct, except_fun, sel_hint }
function rsef.target_base(checkfun, target_fun, target_list)
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		if chkc or chk == 0 then 
			return rstg.TargetCheck(e, tp, eg, ep, ev, re, r, rp, chk, chkc, target_list) and (not checkfun or checkfun(e, tp, eg, ep, ev, re, r, rp))
		end
		local target_group = rstg.TargetSelect(e, tp, eg, ep, ev, re, r, rp, target_list)
		if target_fun then
			target_fun(target_group, e, tp, eg, ep, ev, re, r, rp)
		end
		if eg then 
			for tc in aux.Next(eg) do 
				tc:CreateEffectRelation(e)
			end
		end
	end
end
function rsef.target(list_type_str,  ...)
	return rsef.target_base(nil,  nil,  rsef.list(list_type_str,  ...))
end
function rsef.target2(target_fun,  list_type_str,  ...)
	return rsef.target_base(nil,  target_fun,  rsef.list(list_type_str,  ...))
end
function rsef.target3(checkfun,  list_type_str,  ...)
	return rsef.target_base(checkfun,  nil,  rsef.list(list_type_str,  ...))
end
function rstg.target0(checkfun,  endfun,  ...)
	return rsef.target_base(checkfun,  endfun,  rsef.list("tg",  ...))
end
function rstg.target(...)
	return rsef.target_base(nil,  nil,  rsef.list("tg",  ...))
end
function rstg.target2(target_fun,  ...)
	if type(target_fun) ~= "function" then
		Debug.Message("rstg.target2 first Parameter must be function.")
	end
	return rsef.target_base(nil,  target_fun,  rsef.list("tg",  ...))
end
function rstg.target3(checkfun,  ...)
	if type(checkfun) ~= "function" then
		Debug.Message("rstg.target3 first Parameter must be function.")
	end
	return rsef.target_base(checkfun,  nil,  rsef.list("tg",  ...))
end
function rsop.target0(checkfun,  endfun,  ...)
	return rsef.target_base(checkfun,  endfun,  rsef.list("opc",  ...))
end
function rsop.target(...)
	return rsef.target_base(nil,  nil,  rsef.list("opc",  ...))
end
function rsop.target2(endfun, ...)
	if type(endfun) ~= "function" then
		Debug.Message("rsop.target2 first Parameter must be function.")
	end
	return rsef.target_base(nil,  endfun,  rsef.list("opc",  ...))
end
function rsop.target3(checkfun, ...)
	if type(checkfun) ~= "function" then
		Debug.Message("rsop.target3 first Parameter must be function.")
	end
	return rsef.target_base(checkfun,  nil,  rsef.list("opc",  ...))
end

function rsop.cost(...)
	return rscost.cost0(nil,  nil,  rsef.list("ops",  ...))
end
function rsop.cost2(costfun,  ...)
	return rscost.cost0(nil,  costfun,  rsef.list("ops",  ...))
end
function rsop.cost3(checkfun,  ...)
	return rscost.cost0(checkfun,  nil,  rsef.list("ops",  ...)) 
end

--Target function: Get target attributes
function rstg.GetTargetAttribute(e, tp, eg, ep, ev, re, r, rp, target_list)
	if not target_list then return "tg", 0, 0, 0, 0, nil end
	--0.List type  ("cost", "tg", "opc")
	local list_type = target_list[1] or "tg" 
	--1.Filter
	local filter_function = target_list[2] or aux.TRUE 
	filter_function = type(filter_function) == "table" and filter_function or { filter_function }
	local filter_card, filter_group = table.unpack(filter_function)
	--2.Category  (categroy string, solve function, hint for select )
	local category_val = type(target_list[3]) == "table" and target_list[3] or { target_list[3] }
	local category_str_list0,  category_fun,  sel_hint = table.unpack(category_val)
	local _,  category_list,  category_str_list = rsef.GetRegisterCategory(nil, category_str_list0)
	--3.Locaion Self
	local loc_self,  loc_oppo = target_list[4],  target_list[5]
	if type(loc_self) == "number" and not loc_oppo then loc_oppo = 0 end
	--5.Minum Count
	local minct, maxct = target_list[6], target_list[7]
	minct = type(minct) == "nil" and 1 or minct
	minct = type(minct) == "function" and minct(e, tp, eg, ep, ev, re, r, rp) or minct
	minct = minct == 0 and 999 or minct
	--6.Max Count
	maxct = type(maxct) == "nil" and minct or maxct 
	maxct = type(maxct) == "function" and maxct(e, tp, eg, ep, ev, re, r, rp) or maxct
	--7.Except Group 
	local except_fun = target_list[8]

	--8.specially player target effect value
	-- case 1 (for old card "dish", now not use)
	if rsof.Table_List_OR(category_str_list, "dish") then 
		--case 1.1
		if type(loc_self) == "number" and loc_self > 0 then loc_self = LOCATION_HAND end
		if type(loc_oppo) == "number" and loc_oppo > 0 then loc_oppo = LOCATION_HAND end
		--case 1.2 
		if type(filter_card) == "number" then 
			if filter_card == 0 then
				loc_self = true 
			elseif filter_card > 0 and not loc_self then 
				loc_self = LOCATION_HAND 
				minct = filter_card
			elseif filter_card < 0 and not loc_oppo then 
				loc_oppo = LOCATION_HAND 
				minct = -filter_card
			end
			filter_card = aux.TRUE 
		end
	end
	local player_list1 = { "rec", "dam", "disd", "dd", "dr", "dh" }
	-- case 2 ,switch rec, dam, disd, dd ,dr ,dh format 
	if rsof.Table_Intersection(category_str_list, player_list1)  then
		--case 2.1 
		local loc = rsof.Table_List(category_str_list, "dh") and LOCATION_HAND or 0xff 
		if type(loc_self) == "number" and loc_self > 0 then loc_self = loc end
		if type(loc_oppo) == "number" and loc_oppo > 0 then loc_oppo = loc end
		--case 2.2
		if type(filter_card) == "function" then
			filter_card = filter_card(e, tp, eg, ep, ev, re, r, rp)
		end
		--case 2.3 
		if type(filter_card) == "number" then 
			if filter_card == 0 then
				loc_self = nil 
			elseif filter_card > 0 and not loc_self then 
				loc_self = 0xff 
				minct = filter_card
			elseif filter_card < 0 and not loc_oppo then 
				loc_oppo = 0xff 
				minct = -filter_card
			end
			filter_card = aux.TRUE 
		end
	end
	--9.Fix for solve self 
	if not loc_self and not loc_oppo then loc_self = "self" end
	if rsof.Check_Boolean(loc_self, true) then loc_self = "eg" end
	if loc_self and not loc_oppo then loc_oppo = 0 end
	if loc_oppo and not loc_self then loc_self = 0 end
	if minct and not maxct then maxct = minct end   
	if maxct and not minct then minct = maxct end

	return list_type, filter_card, filter_group, category_list, category_str_list, category_fun, sel_hint, loc_self, loc_oppo, minct, maxct, except_fun
end
--Get except group use for Duel.IsExistingMatchingCard,  eg
function rsgf.GetExceptGroup(e, tp, eg, ep, ev, re, r, rp, except_parama)
	local except_group = Group.CreateGroup()
	local except_type = aux.GetValueType(except_parama)
	if except_type == "Card" or except_type == "Group" then 
		rsgf.Mix(except_group, except_parama)
	elseif except_type == "boolean" then 
		rsgf.Mix(except_group, e:GetHandler())
	elseif except_type == "function" then
		rsgf.Mix(except_group, except_parama(e, tp, eg, ep, ev, re, r, rp))
	end
	return except_group, #except_group
end
--Card Filter: Ex-parama for no "Card" and "Aux" 
function rscf.CardOrAuxFilter(filter_card)
	return function(c, e, tp, ...)
		if rsof.Table_List(Card, filter_card) or rsof.Table_List(aux, filter_card) then 
			return filter_card(c)
		else
			return filter_card(c, e, tp, ...)
		end
	end
end
--Effect target: Check chkc & chk
function rstg.TargetCheck(e, tp, eg, ep, ev, re, r, rp, chk, chkc, target_list_total)
	local c = e:GetHandler()
	--1. Get the first target list parameter
	local list_type, filter_card, filter_group, category_list, category_str_list, category_fun, sel_hint, loc_self, loc_oppo, minct, maxct, except_fun= rstg.GetTargetAttribute(e, tp, eg, ep, ev, re, r, rp, target_list_total[1])
	--2. Get except group
	local except_group = rsgf.GetExceptGroup(e, tp, eg, ep, ev, re, r, rp, except_fun)
	--3. Check 1 Target Card (chkc)
	if chkc then
		--3.1. Check Self
		if type(loc_self) == "string" then 
			if loc_self == "self" then
				return chkc == c and (not filter_card or rscf.CardOrAuxFilter(filter_card)(chkc, e, tp, eg, ep, ev, re, r, rp))
			elseif loc_self == "eg" then 
				return eg:IsContains(chkc) and (not filter_card or rscf.CardOrAuxFilter(filter_card)(chkc, e, tp, eg, ep, ev, re, r, rp))
			end
			return false
		end
		--3.2. Check if target are 2 or more 
		for idx = 2, #target_list_total do 
			local target_list = target_list_total[idx]
			if target_list and target_list[0] == "tg" then 
				return false
			end
		end
		--3.3. Check if there are 2 or more target cards
		if minct > 1 then return false end
		--3.4. Check if meet the conditions 
		if not chkc:IsLocation(loc_self + loc_oppo) then return false end 
		if loc_self == 0 and loc_oppo > 0 and chkc:IsControler(tp) then return false end
		if loc_oppo == 0 and loc_self > 0 and chkc:IsControler(1 - tp) then return false end
		if #except_group > 0 and except_group:IsContains(chkc) then return false end
		if filter_card and not rscf.CardOrAuxFilter(filter_card)(chkc, e, tp, eg, ep, ev, re, r, rp) then return false end
		return true
	end 
	--4. Check if meet the conditions 
	if chk == 0 then 
		local player_list1 = { CATEGORY_RECOVER, CATEGORY_DAMAGE, CATEGORY_DECKDES, CATEGORY_DRAW }
		--4.1. Ignore check (Force Effects)
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) or e:IsHasType(EFFECT_TYPE_QUICK_F) then return true end
		--4.2. Creat used check 
		local used_group = Group.CreateGroup()
		local used_count_list = { [0] = 0, [1] = 0, [1] = 0, [2] = 0}
		--4.3. Checking 
		--4.3.1. Get check main function 
		local target_fun = list_type == "tg" and Duel.IsExistingTarget or Duel.IsExistingMatchingCard 
		--4.3.2. Formally checking
		--4.3.2.1 Checking self 
		if type(loc_self) == "string" and loc_self == "self" then 
			return not except_group:IsContains(c) and rstg.TargetFilter(c, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list, table.unpack(target_list_total))
		--4.3.2.2 Checking not self and eg
		else 
			local minct2 = (type(minct) ~= "number" or minct == 0) and 1 or minct
			if rsof.Table_Intersection(category_list, player_list1) then 
				minct2 = 1
			end
			if minct2 == 999 then return false end 
			local must_sel_group 
			--special : Release 
			local release_group = rsgf.CheckReleaseGroup(list_type, category_list, loc_self, loc_oppo, filter_card, except_group, e, tp, eg, ep, ev, re, r, rp)
			if type(loc_self) == "string" and loc_self == "eg" then 
				must_sel_group = eg:Filter(rscf.CardOrAuxFilter(filter_card), except_group, e, tp, eg, ep, ev, re, r, rp)
				-- appoint eg, cannot use "Lair of Darkness" to replace-release other cards.
				if release_group then 
					must_sel_group = must_sel_group:Filter(aux.IsInGroup, nil, release_group)
				end
			end
			if filter_group and not (type(loc_self) == "string" and loc_self == "eg") then 
				must_sel_group = Duel.GetMatchingGroup(rscf.CardOrAuxFilter(filter_card), tp, loc_self, loc_oppo, except_group, e, tp, eg, ep, ev, re, r, rp)
				-- do not appoint any card, can use "Lair of Darkness" to replace-release other cards.
				if release_group then 
					must_sel_group = release_group:Clone()
				end
			end
			if not filter_group then 
				if not must_sel_group then 
					return target_fun(rstg.TargetFilter, tp, loc_self, loc_oppo, minct2, except_group, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list, table.unpack(target_list_total))
				else
					return must_sel_group:IsExists(rstg.TargetFilter, minct2, except_group, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list, table.unpack(target_list_total))
				end
			else
				return must_sel_group and must_sel_group:CheckSubGroup(rstg.GroupFilter, minct2, maxct, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list, table.unpack(target_list_total))
			end
		end
	end
end
function rsgf.CheckReleaseGroup(list_type, category_list, loc_self, loc_oppo, filter_card, except_group, e, tp, eg, ep, ev, re, r, rp)
	if list_type ~= "cost" or not rsof.Table_List(category_list, CATEGORY_RELEASE) or loc_self ~= "number" then return end
	local g = Group.CreateGroup()
	local rg = Duel.GetReleaseGroup(tp, true) 
	--Tribute from your hand or Mzone 
	if loc_self & LOCATION_MZONE ~=0 then
		g:Merge(rg:Filter(Card.IsLocation, except_group, LOCATION_MZONE))
	end
	if loc_self & LOCATION_HAND ~=0 then
		g:Merge(rg:Filter(Card.IsLocation, except_group, LOCATION_HAND))
	end
	--Tribute from other loc
	local rg2 = Duel.GetMatchingGroup(Card.IsReleasable, tp, loc_self, loc_oppo, except_group)
	g:Merge(rg2)
	g = g:Filter(rscf.CardOrAuxFilter(filter_card), except_group, e, tp, eg, ep, ev, re, r, rp)
	return g
end
--Effect target: Select Cards
function rstg.TargetSelect(e, tp, eg, ep, ev, re, r, rp, target_list_total)
	local c = e:GetHandler()
	local player_target_list = { CATEGORY_RECOVER, CATEGORY_DAMAGE, CATEGORY_DECKDES, CATEGORY_DRAW, CATEGORY_HANDES }
	local player_target_list1 = { CATEGORY_RECOVER, CATEGORY_DAMAGE, CATEGORY_DECKDES, CATEGORY_DRAW }
	--1. Creat used check
	local used_group = Group.CreateGroup()
	local used_count_list = { [0] = 0, [1] = 0, [1] = 0, [2] = 0}
	local info_list = { }
	local selected_group_total_list = { }
	local costed_group_total = Group.CreateGroup()
	--2. Selecting 
	--for idx, target_list in pairs(target_list_total) do 
	--cannot use above method because may have target_list_total[0]
	for idx = 1, #target_list_total do 
		local target_list = target_list_total[idx]
		--2.0. Get Next target_list
		local target_list_next = { }
		for idx2, target_list_next_par in pairs(target_list_total) do 
			if idx2 > idx then
				table.insert(target_list_next, target_list_next_par)
			end
		end
		--2.1. Get target list parameter
		local list_type, filter_card, filter_group, category_list, category_str_list, category_fun, sel_hint, loc_self, loc_oppo, minct, maxct, except_fun = rstg.GetTargetAttribute(e, tp, eg, ep, ev, re, r, rp, target_list)
		--2.2. Get except group
		local except_group = rsgf.GetExceptGroup(e, tp, eg, ep, ev, re, r, rp, except_fun)
		except_group:Merge(used_group)
		--2.3. Set must select group  
		--2.4. Formally Selecting
		--Check Sub Group 
		--2.4.1. Special case - Release 
		local must_sel_group 
		local release_group = rsgf.CheckReleaseGroup(list_type, category_list, loc_self, loc_oppo, filter_card, except_group, e, tp, eg, ep, ev, re, r, rp)
		if type(loc_self) == "string" and loc_self == "eg" then 
			must_sel_group = eg:Filter(rscf.CardOrAuxFilter(filter_card), except_group, e, tp, eg, ep, ev, re, r, rp)
			-- appoint eg, cannot use "Lair of Darkness" to replace-release other cards.
			if release_group then 
				must_sel_group = must_sel_group:Filter(aux.IsInGroup, nil, release_group)
			end
		end
		if filter_group and not (type(loc_self) == "string" and loc_self == "eg") then 
			must_sel_group = Duel.GetMatchingGroup(rscf.CardOrAuxFilter(filter_card), tp, loc_self, loc_oppo, except_group, e, tp, eg, ep, ev, re, r, rp)
			-- do not appoint any card, can use "Lair of Darkness" to replace-release other cards.
			if release_group then 
				must_sel_group = release_group:Clone()
			end
		end
		if type(loc_self) == "string" and loc_self == "self" then 
			if rscf.CardOrAuxFilter(filter_card)(c, e, tp, eg, ep, ev, re, r, rp) then 
				must_sel_group = Group.FromCards(c)
			else
				must_sel_group = Group.CreateGroup()
			end
		end
		--2.4.2. Base Selecting
		local sel_fun = list_type == "tg" and Duel.SelectTarget or Duel.SelectMatchingCard 
		local sel_hint2 = rsef.GetDefaultSelectHint(category_list, loc_self, loc_oppo, sel_hint)   
		local selected_group	 
		Duel.Hint(HINT_SELECTMSG, tp, sel_hint2)
		--2.4.2.1. Select from must select group
		if must_sel_group then
			if filter_group then 
				if list_type ~= "opc" then
					selected_group = must_sel_group:SelectSubGroup(tp, rstg.GroupFilter, false, minct, maxct, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list, target_list, table.unpack(target_list_next))
				end
			else
				--2.4.2.1.1. Select whole group
				if (type(loc_self) == "string" and loc_self == "self") or type(minct) == "boolean" then
					selected_group = must_sel_group
				--2.4.2.1.2. Select from group
				elseif (type(loc_self) == "number" or (type(loc_self) == "string" and loc_self == "eg")) and type(minct) ~= "boolean" and list_type ~= "opc" then
					selected_group = must_sel_group:Select(tp, minct, maxct, nil)
				end
			end
			--Set target card
			if list_type == "tg" and selected_group and #selected_group > 0 then  
				Duel.SetTargetCard(selected_group)
			end 
		--2.4.2.2. Directly select
		else
			--2.4.2.2.1. Select whole group , or not select but for register operation_info_card_or_group
			if ((type(minct) == "boolean" or list_type == "opc")) and not rsof.Table_Intersection(category_list, player_target_list1) then 
				selected_group = Duel.GetMatchingGroup(rstg.TargetFilter, tp, loc_self, loc_oppo, except_group, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list, target_list, table.unpack(target_list_next))
				if list_type == "tg" and selected_group and #selected_group > 0 then  
					Duel.SetTargetCard(selected_group)
				end
			--2.4.2.2.2. Player target 
			elseif rsof.Table_Intersection(category_list, player_target_list1) then 
				local val_player = loc_self > 0 and tp or 1 - tp
				selected_group = { [val_player] = minct, [val_player + 2] = maxct, [1 - val_player] = 0, [1 - val_player + 2] = 0}   
			--2.4.2.2.3. Select 
			elseif list_type ~= "opc" and not rsof.Table_Intersection(category_list, player_target_list1) then
				selected_group = sel_fun(tp, rstg.TargetFilter, tp, loc_self, loc_oppo, minct, maxct, except_group, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list, target_list, table.unpack(target_list_next))  
				used_group:Merge(selected_group)
			end
		end  
		if aux.GetValueType(selected_group) == "Group" then
			used_group:Merge(selected_group)
		end
		--2.5. Solve cost to selected_group   
		if list_type == "cost" or list_type == "ops" then 
			local cost_result, costed_group = rscost.CostSolve(selected_group, category_str_list, category_fun, list_type, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list)
			if not cost_result or (type(cost_result) == "number" and cost_result <= 0) or (aux.GetValueType(cost_result) == "Group" and #cost_result <= 0) then
				return 
			else
				--costed_group_total:Merge(Duel.GetOperatedGroup())
				if costed_group and aux.GetValueType(costed_group) == "Group" then
					costed_group_total:Merge(costed_group)
				elseif aux.GetValueType(selected_group) == "Group" then
					costed_group_total:Merge(selected_group)
				end
			end
		end
		--2.6. Register Operationinfo for target
		if list_type ~= "cost" then 
			for _, category in pairs(category_list) do 
				local is_player = rsof.Table_List(player_target_list, category)
				local info_card_or_group, info_count, info_player, info_loc_or_paramma = nil, 0, 0, 0
				info_card_or_group = aux.GetValueType(selected_group) == "Group" and selected_group or nil
				if not is_player then 
					info_count = type(minct) == "number" and minct or #selected_group
				end
				if aux.GetValueType(selected_group) ~= "Group" or category == CATEGORY_HANDES then
					if (type(loc_self) == "number" and loc_self > 0) and (type(loc_oppo) == "number" and loc_oppo > 0) then
						info_player = PLAYER_ALL 
					elseif (type(loc_self) == "number" and loc_self > 0) and (type(loc_oppo) ~= "number" or loc_oppo <= 0) then
						info_player = tp 
					elseif (type(loc_self) ~= "number" or loc_self <= 0) and (type(loc_oppo) == "number" and loc_oppo > 0) then 
						info_player = 1 - tp 
					end
				end
				if is_player then 
					info_loc_or_paramma = minct
				else
					--cause wulala change its script (used can check if card / group contains deck,  now only check loc contains deck) 
					--if aux.GetValueType(selected_group) ~= "Group" then 
					if type(loc_self) == "number" and type(loc_oppo) == "number" then
						info_loc_or_paramma = info_loc_or_paramma | ((loc_self or 0) | (loc_oppo or 0))
					end
					--end
				end
				Duel.SetOperationInfo(0, category, info_card_or_group, info_count, info_player, info_loc_or_paramma)
				if is_player and e:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET) then 
					Duel.SetTargetPlayer(info_player)
					Duel.SetTargetParam(info_loc_or_paramma)
				end
			end
		end
		if selected_group and #selected_group > 0 then 
			table.insert(selected_group_total_list, selected_group)
		end
	end
	local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS) 
	return tg, selected_group_total_list, costed_group_total
end
--Effect target: Target filter 
function rstg.TargetFilter(c, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list, target_list1, target_list2, ...)
	local used_group2 = used_group:Clone() 
	local used_count_list2 = rsof.Table_Clone(used_count_list)
	if target_list1 then
		local list_type, filter_card, filter_group, category_list, category_str_list, category_fun, sel_hint, loc_self, loc_oppo, minct, maxct, except_fun = rstg.GetTargetAttribute(e, tp, eg, ep, ev, re, r, rp, target_list1)
		if rsof.Table_List_OR(category_list, CATEGORY_RECOVER, CATEGORY_DAMAGE) then
			--no_use
		elseif rsof.Table_List(category_list, CATEGORY_DECKDES) then 
			local deckdes_player = loc_self > 0 and tp or 1 - tp
			used_count_list2[deckdes_player] = used_count_list2[deckdes_player] + minct 
			if Duel.GetFieldGroupCount(deckdes_player, LOCATION_DECK, 0) < used_count_list2[deckdes_player] then return false end
			if list_type == "cost" and not Duel.IsPlayerCanDiscardDeckAsCost(deckdes_player, minct) then return false end
			if list_type ~= "cost" and not Duel.IsPlayerCanDiscardDeck(deckdes_player, minct) then return false end
		elseif rsof.Table_List(category_list, CATEGORY_DRAW) then
			local draw_player = loc_self > 0 and tp or 1 - tp
			used_count_list2[draw_player] = used_count_list2[draw_player] + minct  
			if Duel.GetFieldGroupCount(draw_player, LOCATION_DECK, 0) < used_count_list2[draw_player] then return false end
			if not Duel.IsPlayerCanDraw(draw_player, minct) then return false end
		elseif rsof.Table_List(category_list, CATEGORY_HANDES) then
			used_group2:AddCard(c) 
			if filter_card and not rscf.CardOrAuxFilter(filter_card)(c, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list) then return false end
			if list_type == "cost" and not c:IsDiscardable(REASON_COST) then return false end
			if list_type ~= "cost" and not c:IsDiscardable(REASON_EFFECT) then return false end
		else
			used_group2:AddCard(c) 
			if list_type == "tg" and not c:IsCanBeEffectTarget(e) then return false end
			if filter_card and not rscf.CardOrAuxFilter(filter_card)(c, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list) then return false end
		end
	end 
	if target_list2 then
		local player_list1 = { CATEGORY_RECOVER, CATEGORY_DAMAGE, CATEGORY_DECKDES, CATEGORY_DRAW }
		local list_type, filter_card, filter_group, category_list, category_str_list, category_fun, sel_hint, loc_self, loc_oppo, minct, maxct, except_fun = rstg.GetTargetAttribute(e, tp, eg, ep, ev, re, r, rp, target_list2)
		local target_fun = list_type == "tg" and Duel.IsExistingTarget or Duel.IsExistingMatchingCard 
		local except_group = rsgf.GetExceptGroup(e, tp, eg, ep, ev, re, r, rp, except_fun)
		except_group:Merge(used_group2)
		if type(loc_self) == "string" and loc_self == "self" then
			return not except_group:IsContains(e:GetHandler()) and rstg.TargetFilter(e:GetHandler(), e, tp, eg, ep, ev, re, r, rp, used_group2, used_count_list2, target_list2, ...) 
		else 

			local minct2 = (type(minct) ~= "number" or minct == 0) and 1 or minct
			if rsof.Table_Intersection(category_list, player_list1) then 
				minct2 = 1
			end
			if minct2 == 999 then return false end 

			local must_sel_group 
			--special : Release 
			local release_group = rsgf.CheckReleaseGroup(list_type, category_list, loc_self, loc_oppo, filter_card, except_group, e, tp, eg, ep, ev, re, r, rp)
			if type(loc_self) == "string" and loc_self == "eg" then 
				must_sel_group = eg:Filter(rscf.CardOrAuxFilter(filter_card), except_group, e, tp, eg, ep, ev, re, r, rp)
				-- appoint eg, cannot use "Lair of Darkness" to replace-release other cards.
				if release_group then 
					must_sel_group = must_sel_group:Filter(aux.IsInGroup, nil, release_group)
				end
			end
			if filter_group and not (type(loc_self) == "string" and loc_self == "eg") then 
				must_sel_group = Duel.GetMatchingGroup(rscf.CardOrAuxFilter(filter_card), tp, loc_self, loc_oppo, except_group, e, tp, eg, ep, ev, re, r, rp)
				-- do not appoint any card, can use "Lair of Darkness" to replace-release other cards.
				if release_group then 
					must_sel_group = release_group:Clone()
				end
			end

			if not filter_group then
				if not must_sel_group then 
					return target_fun(rstg.TargetFilter, tp, loc_self, loc_oppo, minct2, except_group, e, tp, eg, ep, ev, re, r, rp, used_group2, used_count_list2, target_list2, ...)
				else
					return must_sel_group:IsExists(rstg.TargetFilter, minct2, except_group, e, tp, eg, ep, ev, re, r, rp, used_group2, used_count_list2, target_list2, ...)
				end
			else
				return must_sel_group and must_sel_group:CheckSubGroup(rstg.GroupFilter, minct2, maxct, e, tp, eg, ep, ev, re, r, rp, used_group2, used_count_list2, target_list2, ...)
			end
		end
	end
	return true
end
--Effect target: Group filter 
function rstg.GroupFilter(g, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list, target_list1, target_list2, ...)
	local used_group2 = used_group:Clone() 
	local used_count_list2 = rsof.Table_Clone(used_count_list)
	if target_list1 then
		local list_type, filter_card, filter_group, category_list, category_str_list, category_fun, sel_hint, loc_self, loc_oppo, minct, maxct, except_fun = rstg.GetTargetAttribute(e, tp, eg, ep, ev, re, r, rp, target_list1)
		used_group2:Merge(g) 
		if list_type == "tg" and g:FilterCount(Card.IsCanBeEffectTarget, nil, e) ~= #g then return false end
		--if g:FilterCount(rscf.CardOrAuxFilter(filter_card), nil, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list) ~= #g then return false end
		if filter_group and not filter_group(g, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list) then return false end
	end   
	if target_list2 then
		local list_type, filter_card, filter_group, category_list, category_str_list, category_fun, sel_hint, loc_self, loc_oppo, minct, maxct, except_fun = rstg.GetTargetAttribute(e, tp, eg, ep, ev, re, r, rp, target_list2)
		local target_fun = list_type == "tg" and Duel.IsExistingTarget or Duel.IsExistingMatchingCard 
		local except_group = rsgf.GetExceptGroup(e, tp, eg, ep, ev, re, r, rp, except_fun)
		except_group:Merge(used_group2)
		if type(loc_self) == "string" and loc_self == "self" then 
			return not except_group:IsContains(e:GetHandler()) and rstg.TargetFilter(e:GetHandler(), e, tp, eg, ep, ev, re, r, rp, used_group2, used_count_list2, target_list2, ...) 
		else 
			local minct2 = (type(minct) ~= "number" or minct == 0) and 1 or minct
			local player_list1 = { CATEGORY_RECOVER, CATEGORY_DAMAGE, CATEGORY_DECKDES, CATEGORY_DRAW }
			if rsof.Table_Intersection(category_list, player_list1) then 
				minct2 = 1
			end
			if minct2 == 999 then return false end 

			local must_sel_group 
			--special : Release 
			local release_group = rsgf.CheckReleaseGroup(list_type, category_list, loc_self, loc_oppo, filter_card, except_group, e, tp, eg, ep, ev, re, r, rp)
			if type(loc_self) == "string" and loc_self == "eg" then 
				must_sel_group = eg:Filter(rscf.CardOrAuxFilter(filter_card), except_group, e, tp, eg, ep, ev, re, r, rp)
				-- appoint eg, cannot use "Lair of Darkness" to replace-release other cards.
				if release_group then 
					must_sel_group = must_sel_group:Filter(aux.IsInGroup, nil, release_group)
				end
			end
			if filter_group and not (type(loc_self) == "string" and loc_self == "eg") then 
				must_sel_group = Duel.GetMatchingGroup(rscf.CardOrAuxFilter(filter_card), tp, loc_self, loc_oppo, except_group, e, tp, eg, ep, ev, re, r, rp)
				-- do not appoint any card, can use "Lair of Darkness" to replace-release other cards.
				if release_group then 
					must_sel_group = release_group:Clone()
				end
			end

			if not filter_group then
				if not must_sel_group then 
					return target_fun(rstg.TargetFilter, tp, loc_self, loc_oppo, minct2, except_group, e, tp, eg, ep, ev, re, r, rp, used_group2, used_count_list2, target_list2, ...)
				else
					return must_sel_group:IsExists(rstg.TargetFilter, minct2, except_group, e, tp, eg, ep, ev, re, r, rp, used_group2, used_count_list2, target_list2, ...)
				end 
			else
				return must_sel_group and must_sel_group:CheckSubGroup(rstg.GroupFilter, minct2, maxct, e, tp, eg, ep, ev, re, r, rp, used_group2, used_count_list2, target_list2, ...)
			end
		end
	end
	return true  
end
--cost solve
function rscost.CostSolve(selected_group, category_str_list, category_fun, list_type, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list)
	local cost_sucess_group
	local cost_sucess_count = 0
	local solve_string = category_str_list[1]
	if #category_str_list == 1 and (not solve_string or (type(solve_string) == "string" and solve_string == "")) and not category_fun then
		return Group.CreateGroup(), 0, true
	end
	if category_fun then
		local value = category_fun(selected_group, e, tp, eg, ep, ev, re, r, rp, used_group, used_count_list)
		if aux.GetValueType(value) == "Card" or aux.GetValueType(value) == "Group" then
			cost_sucess_group = rsgf.Mix2(value)
		else
			cost_sucess_group = Duel.GetOperatedGroup()
		end
		return cost_sucess_group, #cost_sucess_group
	end
	if not category_str_list or #category_str_list == 0 then return true end
	local reason = list_type == "cost" and REASON_COST or REASON_EFFECT 
	if reason ~= REASON_COST then
		rsop.CheckOperationHint(selected_group)
	end
	return rsop.Operation_Solve(selected_group, solve_string, reason, { }, 1, e, tp, eg, ep, ev, re, r, rp)
end
--cost: togarve / remove / discard / release / tohand / todeck as cost
function rscost.cost0(checkfun, costfun, cost_list)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		if chk == 0 then 
			return rstg.TargetCheck(e, tp, eg, ep, ev, re, r, rp, chk, nil, cost_list) and (not checkfun or checkfun(e, tp, eg, ep, ev, re, r, rp))
		end
		local _, _, cost_group = rstg.TargetSelect(e, tp, eg, ep, ev, re, r, rp, cost_list)
		if costfun then
			costfun(cost_group, e, tp, eg, ep, ev, re, r, rp)
		end
	end
end
function rscost.cost(...)
	return rscost.cost0(nil,  nil,  rsef.list("cost",  ...))
end
function rscost.cost2(costfun,  ...)
	return rscost.cost0(nil,  costfun,  rsef.list("cost",  ...))
end
function rscost.cost3(checkfun,  ...)
	return rscost.cost0(checkfun,  nil,  rsef.list("cost",  ...)) 
end
--cost check
function rscost.CostCheck(e, tp, eg, ep, ev, re, r, rp, chk, costlist)
	return rstg.TargetCheck(e, tp, eg, ep, ev, re, r, rp, chk, nil, costlist)
end
--operation / cost function: do operation in card / group
function rsop.Operation_Solve(selected_group, category_str, reason, ex_para_list, chk, e, tp, eg, ep, ev, re, r, rp)
	ex_para_list = type(ex_para_list) == "table" and ex_para_list or { ex_para_list }
	local op_list = rscate.cate_selhint_list[category_str][6] 
	rsop.chk = chk  
	rsop.chk_e = e 
	rsop.chk_p = tp 
	local solve_list = { }
	local op_fun = chk == 0 and aux.TRUE or function()
		return 0, Group.CreateGroup()
	end
	local para_len = 0
	if op_list then
		op_fun = op_list[1]
		para_len = op_list[2]
		local val, val2
		for idx = 3, para_len + 2 do
			val = op_list[idx]
			if type(val) == "string" then
				if val == "solve_parama" then
					val2 = selected_group
				elseif val == "activate_player" then
					val2 = tp
				elseif val == "activate_effect" then
					val2 = e
				elseif val == "reason" then
					val2 = reason 
				end
			elseif type(val) == "function" and rsof.reason_fun[val] then
				val2 = val(reason)
			else
				val2 = val
			end
			solve_list[idx - 2] = val2
		end
		if para_len > 1 then
			local val_ex
			for idx = 1, para_len - 1 do 
				val_ex = ex_para_list[idx]
				if type(val_ex) ~= "nil" then 
					solve_list[idx + 1] = val_ex
				end
			end
		end
	end
	local sl = solve_list
	--local res1, res2, res3 = op_fun(table.unpack(solve_list))
	local res1, res2, res3 = op_fun(sl[1], sl[2], sl[3], sl[4], sl[5], sl[6], sl[7], 
		sl[8], sl[9], sl[10], sl[11], sl[12])
	rsop.chk = 1
	rsop.chk_e = nil
	rsop.chk_p = 0
	return res1, res2, res3 
end
-------------------"Part_Cost_Function"---------------------
--cost: remove count form self
function rscost.rmct(cttype, ct1, ct2, issetlabel)
	ct1 = ct1 or 1
	ct2 = ct2 or ct1
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		local minct= rsof.Check_Boolean(ct1) and c:GetCounter(cttype) or ct1
		local maxct= rsof.Check_Boolean(ct2) and c:GetCounter(cttype) or ct2
		if chk == 0 then return c:IsCanRemoveCounter(tp, cttype, minct, REASON_COST) end
		if maxct > minct then
		   local rmlist = { }
		   for i = minct, maxct do
			   table.insert(rmlist, i)
		   end
		   minct = Duel.AnnounceNumber(tp, table.unpack(rmlist))
		end
		c:RemoveCounter(tp, cttype, minct, REASON_COST)
		rscost.costinfo[e] = minct
		if issetlabel then
		   e:SetLabel(minct)
		end
	end
end
--cost: remove count form self field
function rscost.rmct2(cttype, loc_self, loc_oppo, ct1, ct2, issetlabel)
	loc_self = loc_self or 1
	loc_oppo = loc_oppo or 0
	ct1 = ct1 or 1
	ct2 = ct2 or ct1
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		local minct= rsof.Check_Boolean(ct1) and c:GetCounter(cttype) or ct1
		local maxct= rsof.Check_Boolean(ct2) and c:GetCounter(cttype) or ct2
		if chk == 0 then return Duel.IsCanRemoveCounter(tp, loc_self, loc_oppo, cttype, minct, REASON_COST) end
		if maxct > minct then
		   local rmlist = { }
		   for i = minct, maxct do
			   table.insert(rmlist, i)
		   end
		   minct = Duel.AnnounceNumber(tp, table.unpack(rmlist))
		end
		Duel.RemoveCounter(tp, loc_self, loc_oppo, cttype, minct, REASON_COST)
		rscost.costinfo[e] = minct
		if issetlabel then
		   e:SetLabel(minct)
		end
	end
end
--cost: remove overlay card form self
function rscost.rmxmat(ct1, ct2, issetlabel)
	ct1 = ct1 or 1
	ct2 = ct2 or ct1
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		local minct= rsof.Check_Boolean(ct1) and c:GetOverlayCount(cttype) or ct1
		local maxct= rsof.Check_Boolean(ct2) and c:GetOverlayCount() or ct2
		if chk == 0 then return c:CheckRemoveOverlayCard(tp, minct, REASON_COST) end
		c:RemoveOverlayCard(tp, minct, maxct, REASON_COST)
		local rct = Duel.GetOperatedGroup():GetCount()
		rscost.costinfo[e] = rct
		if issetlabel then
		   e:SetLabel(rct)
		end
	end
end
--cost: if the cost is relate to the effect,  use this (real cost set in the target)
function rscost.setlab(lab_code)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		e:SetLabel(lab_code or 100)
		return true
	end
end
--cost: Pay LP
function rscost.paylp(lp, is_directly, is_lab)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local pay_lp = lp
		if rsof.Check_Boolean(lp) then pay_lp = math.floor(Duel.GetLP(tp) / 2) end
		if is_directly then pay_lp = Duel.GetLP(tp) - pay_lp end
		if chk == 0 then 
			return pay_lp > 0 and Duel.CheckLPCost(tp, pay_lp)
		end
		Duel.PayLPCost(tp, pay_lp)   
		rscost.costinfo[e] = pay_lp
		if is_lab then
			e:SetLabel(pay_lp)
		end
	end
end
--cost: Pay Multiple LP
function rscost.paylp2(base_pay, max_pay, is_lab)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local max_lp = Duel.GetLP(tp)
		if type(max_pay) == "number" then
			max_lp = math.min(max_lp, max_pay)
		end
		if chk == 0 then return Duel.CheckLPCost(tp, base_pay) end
		local max_multiple = math.floor(max_lp / base_pay)
		local pay_list = { }
		for idx = 1, max_multiple do
			pay_list[idx] = idx * base_pay
		end
		local pay_lp = Duel.AnnounceNumber(tp, table.unpack(pay_list))
		Duel.PayLPCost(tp, pay_lp)
		rscost.costinfo[e] = pay_lp 
		if is_lab or type(is_lab) == "nil" then
			e:SetLabel(pay_lp)
		end
	end
end
--cost: register flag to lim_ activate (Quick Effect activates once per chain, e.g)
function rscost.chnlim(flag_code, isplayer)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		flag_code = flag_code or c:GetOriginalCode()
		local b1 = not isplayer and c:GetFlagEffect(flag_code) == 0
		local b2 = isplayer and Duel.GetFlagEffect(tp, flag_code) == 0
		if chk == 0 then return b1 or b2 end
		if b1 then
			c:RegisterFlagEffect(flag_code, RESET_CHAIN, 0, 1)
		elseif b2 then
			Duel.RegisterFlagEffect(tp, flag_code, RESET_CHAIN, 0, 1)
		end
	end
end 
-------------------"Part_Condition_Function"---------------------
--Condition in Self Turn
function rscon.turns(e)
	return Duel.GetTurnPlayer() == e:GetHandlerPlayer()
end 
--Condition in Oppo Turn
function rscon.turno(e)
	return Duel.GetTurnPlayer() ~= e:GetHandlerPlayer()
end 
--Condition in Phase
function rscon.phase(p1, ...)
	local parlist = { p1, ... }
	--phase pass: PHASE_DRAW - PHASE_STANDBY - PHASE_MAIN1 - PHASE_BATTLE_START - PHASE_BATTLE_STEP - PHASE_DAMAGE (start) - PHASE_DAMAGE_CAL (before dcal - dcaling - after dcal) - PHASE_DAMAGE (end) - PHASE_BATTLE - PHASE_MAIN2 - PHASE_END
	return function(e, p)
		local tp = p or e:GetHandlerPlayer()
		local turnp = Duel.GetTurnPlayer()
		local phase_bp = function()
			return Duel.GetCurrentPhase() >= PHASE_BATTLE_START and Duel.GetCurrentPhase() <= PHASE_BATTLE 
		end
		local phase_dam = function()
			return Duel.GetCurrentPhase() == PHASE_DAMAGE or Duel.GetCurrentPhase() == PHASE_DAMAGE_CAL 
		end
		local phase_dambdcal = function()
			return Duel.GetCurrentPhase() == PHASE_DAMAGE and not Duel.IsDamageCalculated()
		end
		local phase_ndcal = function()
			return Duel.GetCurrentPhase() ~= PHASE_DAMAGE or not Duel.IsDamageCalculated()
		end
		local phase_mp = function()
			return Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2
		end
		local str_list = { "dp", "sp", "mp1", "bp", "bsp", "dam", "damndcal", "dambdcal", "dcal", "ndcal", "mp2", "ep", "mp" } 
		local phaselist = { PHASE_DRAW, PHASE_STANDBY, PHASE_MAIN1, phase_bp, PHASE_BATTLE_STEP, phase_dam, PHASE_DAMAGE, phase_dambdcal, PHASE_DAMAGE_CAL, phase_ndcal, PHASE_MAIN2, PHASE_END, phase_mp } 
		local mainstr_list = { }
		local turnplayerlist = { }
		local parlist2 = rsof.String_Number_To_Table(parlist) 
		for _, pstring in pairs(parlist2) do
			local mainstring, splitstring = rsof.String_NoSymbol(pstring)
			table.insert(mainstr_list, mainstring)
			table.insert(turnplayerlist, splitstring)
		end
		local phaselist2 = rsof.Table_Suit(mainstr_list, str_list, phaselist) 
		for idx, phase in pairs(phaselist2) do 
			if turnplayerlist[idx] then
				if (turnplayerlist[idx] == "_s" and turnp ~= tp) or (turnplayerlist[idx] == "_o" and turnp == tp ) then return false end
			end
			if type(phase) == "number" and Duel.GetCurrentPhase() == phase then return true 
			elseif type(phase) == "function" and phase() then return true 
			end
		end 
		return false 
	end
end
--Condition in Main Phase
function rscon.phmp(e)
	return rscon.phase("mp1,mp2")(e)
end 
--Condition: Phase no damage calculate , for change atk / def
function rscon.adcon(e)
	return rscon.phase("ndcal")(e)
end
--Condition: Battle Phase 
function rscon.phbp(e)
	return rscon.phase("bp")(e)
end
--Condition: Phase damage calculate, but not calculate 
function rscon.dambdcal(e)
	return rscon.phase("dambdcal")(e)
end
--Condition: face - up card leaves the field 
function rscon.prepup(e, tp, eg)
	local c = e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
--Condition in ADV or SP Summon Sucess
function rscon.sumtype_card(check_card, sum_list, card_filter)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local card_type
		if not sum_list then
			for sum_str,type_list in pairs(rscf.sum_list) do
				card_type = type_list[2]
				if card_type and check_card:IsType(card_type) then 
					sum_list = sum_str 
				end
			end
		end
		sum_list = sum_list or "sp"
		card_filter = card_filter or aux.TRUE 
		local sum_type
		local sum_str_list = rsof.String_Split(sum_list)
		for _, sum_str in pairs(sum_str_list) do
			sum_type = rscf.sum_list[sum_str][1]
			if check_card:GetSummonType() & sum_type == sum_type then
				return card_filter(check_card,e,tp,re,rp,check_card:GetMaterial())
			end
		end
		return false
	end
end
function rscon.sumtyps(sum_list, card_filter)
	return function(e, tp, eg, ep, ev, re, r, rp)
		return rscon.sumtype_card(e:GetHandler(), sum_list, card_filter)(e, tp, eg, ep, ev, re, r, rp)
	end
end 
function rscon.sumtypf(sum_list, card_filter, is_match_all)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local res = false  
		for tc in aux.Next(eg) do 
			res = rscon.sumtype_card(tc, sum_list, card_filter)(e, tp, eg, ep, ev, re, r, rp) 
			if res and not is_match_all then
				return true 
			end
			if not res and is_match_all then
				return false
			end
		end
		return true 
	end
end 
--Condition: Negate Effect / Activation
function rscon.disneg(dn_type, dn_filter, pl_fun)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local loc = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_LOCATION)
		local seq = nil
		if loc & LOCATION_MZONE ~=0 or loc & LOCATION_SZONE ~=0 then
			seq = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_SEQUENCE)
		end
		local tg = not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Group.CreateGroup() or Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
		if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
		if pl_fun and pl_fun == 0 and rp ~= tp then return false end
		if pl_fun and pl_fun == 1 and rp == tp then return false end
		if dn_type == "dis" and not Duel.IsChainDisablable(ev) then return false end
		if dn_type == "neg" and not Duel.IsChainNegatable(ev) then return false end
		dn_filter = dn_filter or aux.TRUE 
		if type(dn_filter) == "function" and dn_filter(e, tp, re, rp, tg, loc, seq) then return true end
		if type(dn_filter) == "string" then 
			local str_list = rsof.String_Split(dn_filter)
			for _, dn_str in pairs(str_list) do 
				if rsef.Effect_Type_Check(dn_str, re) then return true end
			end
		end
		return false
	end 
end
--Condition: Negate Effect / Activation 
function rscon.dis(dn_filter, pl_fun)
	return function(...)
		return rscon.disneg("dis", dn_filter, pl_fun)(...)
	end
end
function rscon.neg(dn_filter, pl_fun)
	return function(...)
		return rscon.disneg("neg", dn_filter, pl_fun)(...)
	end
end
--Condition: Is exisit matching card
function rscon.excardfilter(filter, var_list, e, tp, eg, ep, ev, re, r, rp)
	return function(c)
		if not filter then return true end
		if #var_list == 0 then return filter(c, e, tp, eg, ep, ev, re, r, rp) end
		return filter(c, table.unpack(rsof.Table_Mix(var_list, { e, tp, eg, ep, ev, re, r, r })))
	end
end
function rscon.excard(filter, loc_self, loc_oppo, ct, except_group, ...)
	local var_list = { ... }
	return function(e, tp, eg, ep, ev, re, r, rp)
		filter = filter or aux.TRUE 
		loc_self = loc_self or LOCATION_MZONE 
		loc_oppo = loc_oppo or 0
		ct= ct or 1
		tp= type(tp) == "number" and tp or e:GetHandlerPlayer()
		return Duel.IsExistingMatchingCard(rscon.excardfilter(filter, var_list, e, tp, eg, ep, ev, re, r, rp), tp, loc_self, loc_oppo, ct, except_group)
	end
end 
-- rscon.excard + Card.IsFaceup 
function rscon.excard2(filter, loc_self, loc_oppo, ct, except_group, ...)
	local filter2 = aux.AND(filter, Card.IsFaceup)
	return rscon.excard(filter2, loc_self, loc_oppo, ct, except_group, ...)
end
--Condition: Summon monster to a link zone
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

-----------------"Part_Operation_Function"-------------------
--Operation: Negative Effect / Activate / Summon / SpSummon
function rsop.disneg(dn_type, dn_str, ex_op)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local rc = re:GetHandler()
		local res = not ex_op and true or ex_op(e, tp, eg, ep, ev, re, r, rp, 0)
		if rsof.Check_Boolean(res,true) or type(res) == "nil" then
			if dn_type == "dis" then
				res = Duel.NegateEffect(ev)
			else
				res = Duel.NegateActivation(ev)
			end
			if rsof.Check_Boolean(res,true) then 
				if dn_str and dn_str ~= "dum" and not rc:IsRelateToEffect(re) then 
					res = false
				end
				if dn_str and rc:IsRelateToEffect(re) then
					res = rsop.Operation_Solve(eg, dn_str, REASON_EFFECT, { }, 1, e, tp, eg, ep, ev, re, r, rp) > 0
				end
			end
			if res or type(res) == "nil" then
				ex_op(e, tp, eg, ep, ev, re, r, rp, 1)
			end
		end
		ex_op(e, tp, eg, ep, ev, re, r, rp, 2)
	end
end
function rsop.dis(dn_str, ex_op)
	return function(...)
		return rsop.disneg("dis", dn_str, ex_op)(...)
	end
end
function rsop.neg(dn_str, ex_op)
	return function(...)
		return rsop.disneg("neg", dn_str, ex_op)(...)
	end
end
--Function:outer case function for SelectCards 
function rsop.SelectExPara(chk_hint, is_break, sel_hint)
	if chk_hint then
		chk_hint = rshint.SwitchHintFormat("w", chk_hint)
	end
	rsop.SelectExPara_checkhint = chk_hint
	rsop.SelectExPara_isbreak = is_break
	rsop.SelectExPara_selecthint = sel_hint
	return true
end
--Function: Select card but not solve 
function rsop.SelectCards(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, ...)
	filter = type(filter) == "table" and filter or { filter }
	local card_filter, group_filter = table.unpack(filter)
	card_filter = card_filter or aux.TRUE 
	local g = Duel.GetMatchingGroup(card_filter, tp, loc_self, loc_oppo, except_obj, ...)
	return rsgf.SelectCards(sel_hint, g, sp, { aux.TRUE, group_filter }, minct, maxct, except_obj, ...)  
end
--Function: Select and solve 
function rsop.SelectOperate(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_list, ...)
	local sg = rsop.SelectCards(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, ...)
	if #sg == 0 then
		return 0, #sg
	else
		return rsop.Operation_Solve(sg, sel_hint, REASON_EFFECT, solve_list, 1, nil, sp)
	end
end
--Group:Select card from group 
function rsgf.SelectCards(sel_hint, g, sp, filter, minct, maxct, except_obj, ...)
	minct = minct or 1
	maxct = maxct or minct
	local chk_hint, is_break, sel_hint2 = rsop.SelectExPara_checkhint, rsop.SelectExPara_isbreak, rsop.SelectExPara_selecthint
	rsop.SelectExPara(nil, nil, nil)
	filter = type(filter) == "table" and filter or { filter }
	local card_filter, group_filter = table.unpack(filter)
	card_filter = card_filter or aux.TRUE 
	local tg = g:Filter(card_filter, except_obj, ...)
	-- case1 , no suit group for card_filter
	if #tg <= 0 or (type(minct) == "number" and #tg < minct) then
		return Group.CreateGroup()
	end
	if chk_hint and not rshint.SelectYesNo(sp, chk_hint) then 
		return Group.CreateGroup()
	end 

	if not rsof.Check_Boolean(minct) then
		rshint.Select(sp, sel_hint2 or sel_hint)
		if not group_filter then 
			tg = tg:Select(sp, minct, maxct, except_obj, ...)
		else
			tg = tg:Filter(aux.TRUE,except_obj)
			tg = tg:SelectSubGroup(sp, group_filter, false, minct, maxct, ...)
		end
		if tg:IsExists(Card.IsLocation, 1, nil, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED) then
			Duel.HintSelection(tg)
		end
	end 
	if is_break then
		Duel.BreakEffect()
	end
	return tg, tg:GetFirst()
end
--Group:Select card from group and do operation on it
function rsgf.SelectOperate(sel_hint, g, sp, filter, minct, maxct, except_obj, solve_list, ...)
	local sg = rsgf.SelectCards(sel_hint, g, sp, filter, minct, maxct, except_obj, ...)
	if #sg == 0 then
		return 0, #sg
	else
		return rsop.Operation_Solve(sg, sel_hint, REASON_EFFECT, solve_list, 1, e, tp, eg, ep, ev, re, r, rp)
	end
end
--Operation: Equip 
function rsop.Equip(e, equip_card, equip_target, keep_face_up, equip_oppo_side, equip_quick_buff)
	local c = e:GetHandler()
	local tp = e:GetHandlerPlayer()
	tp = not equip_oppo_side and tp or 1 - tp 
	if type(keep_face_up) == "nil" then keep_face_up = true end
	if not equip_card or not equip_target or equip_card == equip_target then return false end
	if not Duel.Equip(tp, equip_card, equip_target, keep_face_up) then return end
	local e1, eff_list
	local buff_list = { }
	if equip_card:GetOriginalType() & TYPE_EQUIP == 0 then 
		e1 = rsef.SV({ c, equip_card, true }, EFFECT_EQUIP_LIMIT, rsop.equip_val, nil, nil, rsrst.std)
		e1:SetLabelObject(equip_target)
		if equip_target == c then e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) end
	else
		eff_list = { equip_card:IsHasEffect(EFFECT_EQUIP_LIMIT) }
		e1 = eff_list[1]
	end
	if equip_quick_buff then
		buff_list = { rscf.QuickBuff_EQ({ c, equip_card, true }, table.unpack(equip_quick_buff)) }
	end
	for _, buff in pairs(buff_list) do
		buff:SetType(EFFECT_TYPE_EQUIP)
		buff:SetProperty(0)
	end
	return true, e1, table.unpack(buff_list)
end
function rsop.equip_val(e, c)
	return c == e:GetLabelObject()
end
--Operation: Get sucessful solve count
function rsop.GetOperatedCorrectlyCount(solve_loc)
	local solve_g = Duel.GetOperatedGroup()
	local success_g = solve_g:Filter(Card.IsLocation, nil, solve_loc)
	return #success_g, success_g, solve_g
end
--Operation: Check sucessful solve 
function rsop.CheckOperateCorrectly(solve_loc, check_count)
	local success_ct, success_g = rsop.GetOperatedCorrectlyCount(solve_loc)
	if check_count then 
		return #success_g == check_count, #success_g , success_g 
	else 
		return #success_g > 0, #success_g, success_g 
	end 
end 
--Operation: Send to Deck and Draw 
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
--Operation function: for following operation,  check hint 
function rsop.CheckOperationHint(g, hint, confirm)
	local is_hint, is_confirm = false
	if rsof.Check_Boolean(hint, true) then 
		is_hint = true 
	end
	if type(hint) == "nil" then 
		is_hint = g:FilterCount(Card.IsLocation, nil, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED) == #g 
	end
	if rsof.Check_Boolean(confirm, true) then 
		is_confirm = true 
	end
	if type(confirm) == "nil" then 
		is_confirm = g:FilterCount(Card.IsLocation, nil, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED) ~= #g 
	end
	if not rshint.nohint and is_hint then
		Duel.HintSelection(g)
	end
	return is_hint, is_confirm
end
--Opeartion: Get Extra return value
function rsop.Operation(fun1, ...)
	local ct, og, tc =  fun1(...)
	if not og then
		og = Duel.GetOperatedGroup()
		tc = og:GetFirst()
	end
	return ct, og ,tc
end
--Operation: Destroy
function rsop.Destroy(corg, reason, loc)
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		local f = reason & REASON_REPLACE ~= 0 and rscf.rdesfilter() or Card.IsDestructable
		return #sg >0 and sg:FilterCount(f, nil, rsop.chk_e) == #sg 
	end
	return rsop.Operation(Duel.Destroy, sg, reason, loc)
end
--Operation: Release 
function rsop.Release(corg, reason)
	reason= reason or REASON_EFFECT 
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		local f = reason & REASON_EFFECT ~= 0 and Card.IsReleasableByEffect or Card.IsReleasable
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end
	if #sg <= 0 then return 0, nil end
	local f = function(c)
		return (c:IsType(TYPE_SPELL + TYPE_TRAP) and not c:IsOnField()) or c:IsLocation(LOCATION_DECK + LOCATION_EXTRA)
	end
	if sg:IsExists(f, 1, nil, LOCATION_DECK + LOCATION_EXTRA + LOCATION_HAND) then
		return rsop.Operation(Duel.SendtoGrave, sg, reason | REASON_RELEASE)
	else
		return rsop.Operation(Duel.Release, sg, reason)
	end
end
--Operation: Remove
function rsop.Remove(corg, pos, reason)
	pos = pos or POS_FACEUP 
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		return #sg >0 and sg:FilterCount(Card.IsAbleToRemove, nil, rsop.chk_p, pos, reason) == #sg
	end
	return rsop.Operation(Duel.Remove, sg, pos, reason)
end
--Operation: Send to hand and confirm 
function rsop.SendtoHand(corg, p, reason, no_confirm)
	local sg = rsgf.Mix2(corg)
	reason= reason or REASON_EFFECT 
	if rsop.chk == 0 then
		if #sg <= 0 then return false end
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToHandAsCost or Card.IsAbleToHand 
		return sg:FilterCount(f, nil) == #sg or sg:Filter(Card.IsLocation, nil, LOCATION_HAND) == #sg
	end
	local ct, og, tc = rsop.Operation(Duel.SendtoHand, sg, p, reason)
	local og2 = Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #og2 > 0 and not no_confirm then
		for p = 0, 1 do
			local cg = og2:Filter(Card.IsControler,nil,p)
			if #cg > 0 then 
				Duel.ConfirmCards(1 - p, cg)
			end
		end
	end
	return ct, og, tc
end
--Operation: Send to deck
function rsop.SendtoDeck(corg, tp, seq, reason)
	seq = seq or 2 
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToDeckAsCost or Card.IsAbleToDeck 
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end
	return rsop.Operation(Duel.SendtoDeck, sg, tp, seq, reason)
end
--Operation: Send to extra
function rsop.SendtoExtra(corg, tp, seq, reason)
	seq = seq or 2 
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToExtraAsCost or Card.IsAbleToExtra
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end
	return rsop.Operation(Duel.SendtoDeck, sg, tp, seq, reason)
end
--Operation: Send to main and extra (for cost)
function rsop.SendtoMAndE(corg, tp, seq, reason)
	seq = seq or 2 
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToDeckOrExtraAsCost or Card.IsAbleToDeck
		return #sg >0 and sg:FilterCount(f, nil) == #sg
	end
	return rsop.Operation(Duel.SendtoDeck, sg, tp, seq, reason)
end
--Operation: P send to extra 
function rsop.SendtoExtraP(corg, tp, reason)
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then
		local f = reason & REASON_COST ~= 0 and aux.TRUE or Card.IsAbleToExtra
		return #sg >0 and sg:FilterCount(f, nil) == #sg and sg:FilterCount(Card.IsForbidden, nil) == 0
	end
	return rsop.Operation(Duel.SendtoDeck, sg, tp, seq, reason)
end
--Operation: Send to grave
function rsop.SendtoGrave(corg, reason)
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		local f 
		if reason & REASON_RETURN ~= 0 then return sg:FilterCount(Card.IsLocation, nil, LOCATION_REMOVED) == #sg end
		local f = reason & REASON_COST ~= 0 and Card.IsAbleToGraveAsCost or Card.IsAbleToGrave
		return #sg >0 and sg:FilterCount(f, nil) == #sg 
	end
	return rsop.Operation(Duel.SendtoGrave, sg, reason)
end
--DiscardDeck for rscost.cost
function rsop.DiscardDeck_Special(selected_group, reason)
	if rsop.chk == 0 then return true end
	local ct = 0
	for p = 0, 1 do 
		local minct = selected_group[p]
		local maxct = selected_group[p + 2]
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
			rshint.Select(p, rshint.stgct)
			dct = Duel.AnnounceNumber(p, table.unpack(ct_list))
		end
		if dct > 0 then
			ct = ct + Duel.DiscardDeck(p, dct, reason)
		end 
	end
	local og = Duel.GetOperatedGroup()
	return ct, og, og:GetFirst()
end
--Operation: Change position
function rsop.ChangePosition(corg, p1, p2, p3, p4, ...)
	local sg = rsgf.Mix2(corg)
	local f
	if rsop.chk == 0 then 
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
			ct2, og2 = rsop.Operation(Duel.ChangePosition, tc, pos)
			ct = ct + ct2 
			og:Merge(og2)
		end
		return ct, og, og:GetFirst()
	elseif p2 then
		return rsop.Operation(Duel.ChangePosition, sg, p1, p2, p3, p4, ...)
	else
		return rsop.Operation(Duel.ChangePosition, sg, p1, p1, p1, p1, ...)
	end
end
--Operation: Get control
function rsop.GetControl(corg, p, rst_ph, rst_tct, zone)
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		return #sg >0 and sg:FilterCount(Card.IsControlerCanBeChanged, nil, false, zone) == #sg
	end 
	return rsop.Operation(Duel.GetControl, sg, p, rst_ph, rst_tct, zone)
end
--Operation : Confirm (Look)
function rsop.ConfirmCards(corg)
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then  
		return sg:FilterCount(Card.IsPublic, nil) == 0
	end 
	local cg
	for p = 0, 1 do
		cg = sg:Filter(Card.IsControler, nil, p)
		if #cg > 0 then
			Duel.ConfirmCards(1 - p, cg)
			Duel.ShuffleHand(p)
		end
	end
	return #sg, sg, sg:GetFirst()
end
--Operation : Reveal
function rsop.RevealCards(corg, rst_list)
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then  
		return sg:FilterCount(Card.IsPublic, nil) == 0
	end 
	if not rst then return rsop.ConfirmCards(corg) 
	else
		for tc in aux.Next(sg) do
			local e1 = rsef.SV({c,c,true}, EFFECT_PUBLIC, 1, nil, nil, rst_list, "cd")
		end
	end
	return #sg, sg, sg:GetFirst()
end
--Operation:MoveToField
function rsop.MoveToField(corg, movep, targetp, loc, pos, enable, zone)
	local g = rsgf.Mix2(corg)
	targetp = targetp or movep 
	pos= pos or POS_FACEUP 
	enable = enable or true 
	if rsop.chk == 0 then 
		return g:FilterCount(Card.IsForbidden, nil) == 0 and Duel.GetLocationCount(targetp, loc, movep, LOCATION_REASON_TOFIELD, zone) >= #g
	end
	if #g <= 0 then return 0, nil end
	local correctg = Group.CreateGroup()
	for tc in aux.Next(g) do 
		if tc:IsType(TYPE_PENDULUM) then 
			ploc = loc or LOCATION_PZONE 
		else
			ploc = loc or rsef.GetRegisterRange(tc)  
		end
		local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
		if fc and ploc == LOCATION_FZONE then
			Duel.SendtoGrave(fc, REASON_RULE)
			Duel.BreakEffect()
		end
		local bool = false
		if zone then
			bool = Duel.MoveToField(tc, movep, targetp, ploc, pos, enable, zone)
		else
			bool = Duel.MoveToField(tc, movep, targetp, ploc, pos, enable)
		end
		if bool then
			correctg:AddCard(tc)
		end
	end
	local facedowng = correctg:Filter(Card.IsFacedown, nil)
	if #facedowng > 0 then
		Duel.ConfirmCards(1 - movep, facedowng)
	end
	return #correctg, correctg, correctg:GetFirst()
end
--Operation function:MoveToField and treat activate
function rsop.MoveToField_Activate(corg, movep, targetp, loc, pos, enable, zone)
	local g = rsgf.Mix2(corg)
	local tc = g:GetFirst()
	targetp = targetp or movep 
	pos = POS_FACEUP 
	enable = enable or true 
	if tc:IsType(TYPE_PENDULUM) then 
		ploc = loc or LOCATION_PZONE 
	else
		ploc = loc or rsef.GetRegisterRange(tc)
	end
	if ploc == LOCATION_MZONE then
		Debug.Message("rsop.Activate can only activate Spell / Trap!")
		return false
	end
	if rsop.chk == 0 then 
		return tc and tc:GetActivateEffect() and tc:GetActivateEffect():IsActivatable(movep,true,true) 
	end
	if not tc then return 0, nil end
	local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
	if fc and ploc == LOCATION_FZONE then
		Duel.SendtoGrave(fc, REASON_RULE)
		Duel.BreakEffect()
	end
	local bool = false
	if zone then 
		bool = Duel.MoveToField(tc, movep, targetp, ploc, pos, enable, zone)
	else
		bool = Duel.MoveToField(tc, movep, targetp, ploc, pos, enable)
	end
	if bool then
		local te = tc:GetActivateEffect()
		if te then
			te:UseCountLimit(tp, 1, true)
			local tep = tc:GetControler()
			local cost = te:GetCost()
			if cost then cost(te, tep, eg, ep, ev, re, r, rp, 1) end
		end
		if ploc == LOCATION_FZONE then
			Duel.RaiseEvent(tc, 4179255, te, 0, tp, tp, Duel.GetCurrentChain())
		end
		return true, tc
	end
	return false, nil
end
--Operation: Return to field
function rsop.ReturnToField(corg, pos, zone)
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		return # sg > 0
	end
	local rg,rg2,ft = Group.CreateGroup(), Group.CreateGroup(), 0
	for p = 0, 1 do
		rg = sg:Filter(aux.FilterEqualFunction(Card.GetPreviousControler, p), nil)
		if #rg > 0 then
			ft = Duel.GetLocationCount(p, LOCATION_MZONE, p, LOCATION_REASON_TOFIELD, zone or 0xff)
			rg2 = rg:Clone()
			if #rg2 > ft then
				rg2 = rg:Select(p, ft, ft, nil)
			end
			rg:Sub(rg2)
			for tc in aux.Next(rg2) do 
				Duel.ReturnToField(tc, pos or tc:GetPreviousPosition(), zone or 0xff)
			end
			for tc in aux.Next(rg) do
				Duel.ReturnToField(tc, pos or tc:GetPreviousPosition())
			end
		end
	end
	return #rg, rg, rg:GetFirst()
end
--Operation: SSet
function rsop.SSet(corg, sp, tp, confirm) 
	if type(confirm) == "nil" then confirm = true end
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then 
		return #sg > 0 and sg:FilterCount(Card.IsSSetable, nil) == #sg
	end
	tp = tp or sp
	return rsop.Operation(Duel.SSet, sp, sg, tp, confirm)
end
--Operation: Dummy
function rsop.DummyOperate(corg)
	local sg = rsgf.Mix2(corg)
	if rsop.chk == 0 then
		return #sg > 0 
	end
	return #sg, sg, sg:GetFirst()
end
--Operation:Deck Move to top 
function rsop.SortDeck(corg, seq, confirm)
	local g = rsgf.Mix2(corg)   
	if rsop.chk == 0 then 
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
--Operation function:Overlay
function rsop.Overlay_Filter(c,e)
	if not e then return c:IsCanOverlay() 
	else
		return not c:IsImmuneToEffect(e) and c:IsCanOverlay(e:GetHandlerPlayer())
	end
end
function rsop.Overlay(e, xyzc, mat_corg, set_sum_mat, ex_over)
	--e = e or Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	local g = rsgf.Mix2(mat_corg):Filter(rsop.Overlay_Filter,nil,e)
	if not xyzc or not xyzc:IsType(TYPE_XYZ) or #g <= 0 then return 0, nil end
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

----------------"Part_ZoneSequence_Function"------------------
--Get pend zone
function rszsf.GetUseAblePZoneCount(tp, g_or_c)
	local ft = 0
	if Duel.CheckLocation(tp, LOCATION_PZONE, 0) then ft = ft + 1 end
	if Duel.CheckLocation(tp, LOCATION_PZONE, 1) then ft = ft + 1 end
	local g = rsgf.Mix2(g_or_c)
	for tc in aux.Next(g) do
		if tc:IsControler(tp) and tc:IsLocation(LOCATION_SZONE) and tc:IsType(TYPE_PENDULUM) then
			ft = ft + 1 
		end
	end
	return ft
end 

--get excatly colomn zone,  import the seq
--zone[1][1] means your colomn Mzone,  zone[1][2] means your colomn Szone,  zone[1][3] means your colomn Mzone + Szone
--zone[2] is the same,  zone[3] is zone[1] + zone[2] (all players)
--seq must use rsv.GetExcatlySequence to Get true sequence
function rszsf.GetExcatlyColumnZone(seq)
	local zone = { }
	for i = 0, 1 do
		zone[i] = { }
		if i == 1 then seq = seq + 16 end
		zone[i][1] = 2^seq 
		zone[i][2] = (2^seq) * 0x100
		zone[i][3] = zone[i][1] + zone[i][2]
	end 
	zone[3] = { }
	zone[3][1] = zone[1][1] + zone[2][1]
	zone[3][2] = zone[1][2] + zone[2][2]
	zone[3][3] = zone[1][3] + zone[2][3]
	return zone
end
--Get Surrounding Zone (up, down, left & right zone)
--p:Use this player's camera to see the sequence,  default cp
--contains: Include itself's zone(mid)
--truezone: 1 - p's zone must * 0x10000
function rszsf.GetSurroundingZone(c, p, truezone, contains)
	local seq = c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc = c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp = c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	return rszsf.GetSurroundingZone2(seq, loc, cp, p, truezone, contains)
end
----Get Surrounding Zone (up, down, left & right zone)
--Use sequence to get Surrounding Zone
--p: p's sequence
--contains: Include itself's zone(mid)
--truezone: 1 - p's zone must * 0x10000
function rszsf.GetSurroundingZone2(seq, loc, cp, p, truezone, contains)
	local nozone = { [0] = 0, [1] = 0}
	if not p then p = cp end
	if not rsof.Check_Boolean(truezone, false) then truezone = true end
	if not rsof.Check_Boolean(contains, false) then contains = true end
	if loc == LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED + LOCATION_HAND then
		Debug.Message("rszsf.GetSurroundingZone2: Location is not on field")
		return nozone, nozone, nozone 
	end
	if loc == LOCATION_PZONE or (loc == LOCATION_SZONE and seq > 4) then
		return nozone, nozone, nozone
	end
	if loc == LOCATION_SZONE and seq > 4 then 
		return nozone, nozone, nozone 
	end
	local mzone = { [0] = 0, [1] = 0}
	local szone = { [0] = 0, [1] = 0}
	if loc == LOCATION_MZONE then
		if seq == 0 or seq == 5 then mzone[cp] = mzone[cp] + 0x2 end
		if seq == 4 or seq == 6 then mzone[cp] = mzone[cp] + 0x8 end
		if seq > 0 and seq < 4 then mzone[cp] = mzone[cp] + 2^(seq - 1) + 2^(seq + 1) end
		if seq == 5 then mzone[1 - cp] = mzone[1 - cp] + 0x8 end
		if seq == 6 then mzone[1 - cp] = mzone[1 - cp] + 0x2 end
		if seq == 1 then 
			mzone[cp] = mzone[cp] + 0x20 
			mzone[1 - cp] = mzone[1 - cp] + 0x40 
		end
		if seq == 3 then 
			mzone[cp] = mzone[cp] + 0x40 
			mzone[1 - cp] = mzone[1 - cp] + 0x20 
		end
		if seq < 5 then szone[cp] = szone[cp] + 2^seq end
		if contains then mzone[cp] = mzone[cp] + 2^seq end
	elseif loc == LOCATION_SZONE then
		if seq == 0 then szone[cp] = szone[cp] + 0x2 end
		if seq == 4 then szone[cp] = szone[cp] + 0x8 end   
		if seq > 0 and seq < 4 then szone[cp] = szone[cp] + 2^(seq - 1) + 2^(seq + 1) end
		mzone[cp] = mzone[cp] + 2^seq
		if contains then szone[cp] = szone[cp] + 2^seq end
	end
	szone[0] = szone[0] * 0x100
	szone[1] = szone[1] * 0x100
	if truezone then
		mzone[1 - p] = mzone[1 - p] * 0x10000
		szone[1 - p] = szone[1 - p] * 0x10000
	end
	local ozone = { }
	for i = 0, 1 do
		ozone[i] = mzone[i] + szone[i]
	end
	return mzone, szone, ozone
end

-------------------"Part_Group_Function"---------------------
--Filter group : check different player 
function rsgf.dnpcheck(g)
	return g:GetClassCount(Card.GetControler) == #g
end
--Get Surrounding Group (up, down, left & right zone)
--contains: Include itself's zone(mid)
function rsgf.GetSurroundingGroup(c, contains)
	local seq = c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc = c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp = c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	return rsgf.GetSurroundingGroup2(seq, loc, cp, contains)
end
--Get Surrounding Group (up, down, left & right zone)
--contains: Include itself's zone(mid)
function rsgf.GetSurroundingGroup2(seq, loc, cp, contains)
	local f = function(c)
		return not c:IsLocation(LOCATION_SZONE) or c:GetSequence() < 5
	end
	local mzone, szone, ozone = rszsf.GetSurroundingZone2(seq, loc, cp, cp, true, contains)
	local g = Duel.GetMatchingGroup(f, 0, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
	local sg = Group.CreateGroup()
	local zone = ozone[0] + ozone[1]
	for tc in aux.Next(g) do 
		local seq = tc:GetSequence()
		if not tc:IsControler(cp) then seq = seq + 16 end
		local tczone = 2^seq
		if tc:IsLocation(LOCATION_SZONE) then tczone = tczone * 0x100 end
		if tczone & zone ~=0 then 
			sg:AddCard(tc)
		end
	end
	return sg
end
--Group effect: get adjacent group
function rsgf.GetAdjacentGroup(c, contains)
	return rsgf.GetAdjacentGroup2(c:GetSequence(), c:GetLocation(), c:GetControler(), contains)
end 
--Group effect: get adjacent group (use sequence)
function rsgf.GetAdjacentGroup2(seq, loc, tp, contains)
	local g = Group.CreateGroup()
	if seq > 0 and seq < 5 then
		rsgf.Mix(g, Duel.GetFieldCard(tp, loc, seq - 1))
	end
	if seq < 4 then
		rsgf.Mix(g, Duel.GetFieldCard(tp, loc, seq + 1))
	end
	if contains then rsgf.Mix(g, Duel.GetFieldCard(tp, loc, seq)) end
	return g
end
--Group effect: Get Target Group for Operations
function rsgf.GetTargetGroup(tg_filter, ...)
	local g, e, tp = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER)
	local tg = g and g:Filter(rscf.TargetFilter, nil, e, tp, tg_filter, ...) or Group.CreateGroup()
	return tg, tg:GetFirst()
end
--Group effect: Mix Card & Group, add to the first group
function rsgf.Mix(g, ...)
	local list = { ... } 
	for _, val in pairs(list) do
		if aux.GetValueType(val) == "Group" then
			g:Merge(val)
		elseif aux.GetValueType(val) == "Card" then
			g:AddCard(val)
		end
	end
	return g, #g 
end
Group.Mix = rsgf.Mix
--Group effect: Mix Card & Group, return new group
function rsgf.Mix2(...)
	local g = Group.CreateGroup()
	local list = { ... }
	for _, val in pairs(list) do
		if aux.GetValueType(val) == "Group" then
			g:Merge(val)
		elseif aux.GetValueType(val) == "Card" then
			g:AddCard(val)
		end
	end
	return g, #g
end
--Group effect:Change Group to Table
function rsgf.Group_To_Table(g)
	local cardlist = { }
	for tc in aux.Next(g) do
		table.insert(cardlist, tc)
	end
	return cardlist
end
--Group effect:Change Group to Table
function rsgf.Table_To_Group(list)
	local group = Group.CreateGroup()
	for _, value in pairs(list) do
		if aux.GetValueType(value) == "Card" or aux.GetValueType(value) == "Group" then
			rsgf.Mix(group, value)
		end
	end
	return group 
end
-------------------"Part_Card_Function"---------------------

--Card function: local m and cm and cm.rssetcode 
function rscf.DefineCard(code, setcode)
	if not _G["c"..code] then _G["c"..code] = { }
		setmetatable(_G["c"..code], Card)
		_G["c"..code].__index = _G["c"..code]
	end
	local ccodem = _G["c"..code]   
	if setcode and not ccodem.rssetcode then
		ccodem.rssetcode = setcode
	end
	return code, ccodem
end
--Card function: rsxx.IsXSetXX
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
--Register qucik attribute buff in cards
function rscf.QuickBuff_Base(reg_list, eff_type, affect_self, ...)
	local buff_list = { ... }  
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	local reset
	local res = rsof.Table_List(buff_list, "rst") 
	res = res or rsof.Table_List(buff_list, "reset") 
	if not res then 
		table.insert(buff_list, "rst") 
		table.insert(buff_list, rsrst.std) 
	end
	local elist_single = { }
	local elist_cache = { }
	local elist_total = { }
	local next_val, reg_val
	for idx, buff_str in pairs(buff_list) do 
		next_val = buff_list[idx + 1]
		if  type(buff_str) == "string" and (buff_str == "reset" or buff_str == "rst") then 
			rsef.effet_no_register = false 
			for _, reg_eff in pairs(elist_cache) do 
				rsef.RegisterReset(reg_eff, next_val)
				rsef.RegisterEffect(reg_list, reg_eff)
			end
			elist_cache = { }
		elseif type(buff_str) == "string" and buff_str ~= "reset" and buff_str ~= "rst" then  
			rsef.effet_no_register = true 
			reg_val = type(next_val) ~= "string" and next_val or 1
			if buff_str ~= "mat" and buff_str ~= "cp" then   
				elist_single = { rsef.Attribute(reg_list, eff_type, buff_str, reg_val, nil, nil, nil, nil, nil, reset, nil, nil, affect_self) }
			elseif buff_str == "mat" then
				reg_handler:SetMaterial(reg_val)
			elseif buff_str == "cp" then
				reg_handler:RegisterFlagEffect(rscode.Pre_Complete_Proc, rsrst.std, 0, 1)
			end   
			elist_cache = rsof.Table_Mix(elist_cache, elist_single)
			elist_total = rsof.Table_Mix(elist_total, elist_single)
		end
	end
	rsef.effet_no_register = false  
	return table.unpack(elist_total)
end
--Quick Buff that affect self and not affect other cards, so must RESET_DISABLE 
function rscf.QuickBuff(reglist, ...)
	return rscf.QuickBuff_Base(reglist, "sv", true, ...)
end
--Quick Buff that not affect self or affect other cards, so do not need RESET_DISABLE 
function rscf.QuickBuff_ND(reglist, ...)
	return rscf.QuickBuff_Base(reglist, "sv", false, ...)
end
--Quick Buff for rsop.Equip
function rscf.QuickBuff_EQ(reglist, ...)
	return rscf.QuickBuff_Base(reglist, "eq", false, ...)
end
--Card effect:Auxiliary.ExceptThisCard 
function rscf.GetSelf(e) 
	if not e then e = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT) end
	return aux.ExceptThisCard(e)
end
--Card effect:Auxiliary.ExceptThisCard + Card.IsFaceup()
function rscf.GetFaceUpSelf(e) 
	local c = rscf.GetSelf(e) 
	if not c then return nil end
	return c:IsFaceup() and c or nil
end
--Card / Summon effect: Set Special Summon Produce
function rscf.AddSpecialSummonProcdure(reg_list, range, con, tg, op, desc_list, lim_list, val, reset_list)
	local reg_owner, reg_handler, reg_ignore = rsef.GetRegisterCard(reg_list)
	if not desc_list then desc_list = rshint.spproc end
	local flag = not reg_handler:IsSummonableCard() and "uc,cd" or "uc" 
	local e1 = rsef.Register(reg_list, EFFECT_TYPE_FIELD, EFFECT_SPSUMMON_PROC, desc_list, lim_list, nil, flag, range, rscf.AddSpecialSummonProcdure_con(con), nil, tg, op, val, nil, nil, reset_list)
	return e1
end
rssf.AddSpecialSummonProcdure = rscf.AddSpecialSummonProcdure
function rscf.AddSpecialSummonProcdure_con(con)
	return function(e, c)
		if c == nil then return true end
		local tp = c:GetControler()
		if not con then return (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0) or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0) end
		return con(e, c, tp)
	end
end
--Card / Summon effect: Is monster can normal or special summon
function rscf.SetSummonCondition(reg_list, is_nsable, sum_value, reset_list)
	local reg_owner, reg_handler, reg_ignore = rsef.GetRegisterCard(reg_list)
	if reg_handler:IsStatus(STATUS_COPYING_EFFECT) then return end
	if rsof.Check_Boolean(is_nsable, false) then
		 reg_handler:EnableReviveLimit()
	end
	sum_value = sum_value or aux.FALSE 
	local e1 = rsef.SV(reg_list, EFFECT_SPSUMMON_CONDITION, sum_value, nil, nil, reset_list, "uc,cd")
	return e1
end 
rssf.SetSummonCondition = rscf.SetSummonCondition

--Check Built - in SetCode / Series Main Set
function rscf.CheckSetCardMainSet(c, settype, series1, ...) 
	local serieslist = { series1, ... }
	local seriesnormallist = { }
	local seriescustomlist = { }
	for _, series in pairs(serieslist) do 
		if type(series) == "number" then
			table.insert(seriesnormallist, series) 
		else
			table.insert(seriescustomlist, series) 
		end
	end
	local str_list = rsof.String_Number_To_Table(seriescustomlist)
	local codelist = { }
	local effectlist = { }
	local addcodelist = { }
	if settype == "base" then
		if #seriesnormallist > 0 and c:IsSetCard(table.unpack(seriesnormallist)) then return true end
		codelist = { c:GetCode() } 
		effectlist = { c:IsHasEffect(EFFECT_ADD_SETCODE) } 
	elseif settype == "fus" then
		if #seriesnormallist > 0 and c:IsFusionSetCard(table.unpack(seriesnormallist)) then return true end
		codelist = { c:GetFusionCode() }
		effectlist = { c:IsHasEffect(EFFECT_ADD_FUSION_SETCODE), c:IsHasEffect(EFFECT_ADD_SETCODE) } 
	elseif settype == "link" then
		if #seriesnormallist > 0 and c:IsLinkSetCard(table.unpack(seriesnormallist)) then return true end
		codelist = { c:GetLinkCode() }
		effectlist = { c:IsHasEffect(EFFECT_ADD_LINK_SETCODE), c:IsHasEffect(EFFECT_ADD_SETCODE) } 
	elseif settype == "org" then
		if #seriesnormallist > 0 and c:IsOriginalSetCard(table.unpack(seriesnormallist)) then return true end
		codelist = { c:GetOriginalCode() }
		effectlist = { }
	elseif settype == "pre" then
		if #seriesnormallist > 0 and c:IsPreviousSetCard(table.unpack(seriesnormallist)) then return true end
		codelist = { c:GetPreviousCodeOnField() }
		effectlist = rscf.Previous_Set_Code_List
	end
	for _, effect in pairs(effectlist) do
		local string = rsval.valinfo[effect]
		if type(string) == "string" then 
			table.insert(addcodelist, string)
		end
	end
	for _, code in ipairs(codelist) do 
		local setcodestring
		local res = not _G["c"..code] and true or false
		if res then _G["c"..code] = { } end
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			setcodestring = _G["c"..code].rssetcode
		end
		if res then _G["c"..code] = nil end
		if setcodestring then
			local setcodelist = rsof.String_Number_To_Table(setcodestring)
			for _, string in pairs(str_list) do 
				for _, setcode in pairs(setcodelist) do
					local setcodelist2 = rsof.String_Split(setcode,  '_')
					if rsof.Table_List(setcodelist2, string) then return true end
				end
			end
		end
	end
	if #addcodelist > 0 then
		for _, string in pairs(str_list) do 
			for _, setcode in pairs(addcodelist) do
				local addcodelist2 = rsof.String_Split(setcode,  '_')
				if rsof.Table_List(addcodelist2, string) then return true end
			end
		end
	end
	return false 
end 
--Check Built - in Base SetCode / Series
function rscf.CheckSetCard(c, series1, ...) 
	return rscf.CheckSetCardMainSet(c, "base", series1, ...) 
end
Card.CheckSetCard = rscf.CheckSetCard
--Check Built - in Fusion SetCode / Series
function rscf.CheckFusionSetCard(c, series1, ...) 
	return rscf.CheckSetCardMainSet(c, "fus", series1, ...) 
end
Card.CheckFusionSetCard = rscf.CheckFusionSetCard
--Check Built - in Link SetCode / Series
function rscf.CheckLinkSetCard(c, series1, ...) 
	return rscf.CheckSetCardMainSet(c, "link", series1, ...) 
end
Card.CheckLinkSetCard = rscf.CheckLinkSetCard
--Check Built - in Original SetCode / Series
function rscf.CheckOriginalSetCard(c, series1, ...) 
	return rscf.CheckSetCardMainSet(c, "org", series1, ...)
end
Card.CheckOriginalSetCard = rscf.CheckOriginalSetCard
--Check Built - in Previous SetCode / Series
function rscf.CheckPreviousSetCard(c, series1, ...) 
	return rscf.CheckSetCardMainSet(c, "pre", series1, ...)
end
Card.CheckPreviousSetCard = rscf.CheckPreviousSetCard
--Card / Summon effect:Record Summon Procedure
function rssf.EnableSpecialProcedure()
	if rssf.EnableSpecialProcedure_Switch then return end
	local e1 = rsef.FC({ true, 0 }, EVENT_ADJUST)
	e1:SetOperation(rssf.EnableSpecialProcedure_Op)
	rssf.EnableSpecialProcedure_Switch = e1
end
function rssf.EnableSpecialProcedure_Op(e, tp)
	local g = Duel.GetMatchingGroup(Card.IsType, 0, 0xff, 0xff, nil, TYPE_SYNCHRO + TYPE_XYZ + TYPE_LINK)
	local f6 = aux.AddSynchroProcedure
	local f7 = aux.AddSynchroMixProcedure
	local f8 = aux.AddXyzProcedure
	local f9 = aux.AddXyzProcedureLevelFree
	local f10 = aux.AddLinkProcedure
	aux.AddSynchroProcedure = rscf.GetBaseSynchroProduce1
	aux.AddSynchroMixProcedure = rscf.GetBaseSynchroProduce2
	aux.AddXyzProcedure = rscf.GetBaseXyzProduce1
	aux.AddXyzProcedureLevelFree = rscf.GetBaseXyzProduce2
	aux.AddLinkProcedure = rscf.GetBaseLinkProduce1
	Card.RegisterEffect = rscf.RegisterEffect2

	local e1 = Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(rssf.EnableSpecialProcedure_Op_regop)
	e1:SetTargetRange(1, 1)
	Duel.RegisterEffect(e1, 0) 

	for tc in aux.Next(g) do
		tc:IsSpecialSummonable()
		local cid = tc:CopyEffect(tc:GetOriginalCode(), 0, 1)
	end

	aux.AddSynchroProcedure = f6
	aux.AddSynchroMixProcedure = f7
	aux.AddXyzProcedure = f8
	aux.AddXyzProcedureLevelFree = f9
	aux.AddLinkProcedure = f10
	Card.RegisterEffect = rscf.RegisterEffect
	e:Reset()
end 
function rssf.EnableSpecialProcedure_Op_regop(e, c, tp, st, sp, stp, se)
	if not c:IsType(rscf.extype) or c:IsType(TYPE_FUSION) then return false end
	rscf.ssproce[c] = rscf.ssproce[c] or { [1] = { }, [2] = { } }
	if se and se:GetCode() == EFFECT_SPSUMMON_PROC and not rsof.Table_List(rscf.ssproce[c][1], se) then 
		c:RegisterFlagEffect(rscode.Special_Procedure, 0, 0, 1)
		table.insert(rscf.ssproce[c][1], se)
		table.insert(rscf.ssproce[c][1], se:GetCondition() or aux.TRUE)
	end
	if se and rscf.ssproce[se] then return false end
	return se and se:GetCode() == EFFECT_SPSUMMON_PROC 
end
rscf.RegisterEffect = Card.RegisterEffect
function rscf.RegisterEffect2(c, e, ignore)
	rscf.ssproce[c] = rscf.ssproce[c] or { [1] = { }, [2] = { } }
	if e:GetCode() == EFFECT_SPSUMMON_PROC then 
		local flag1, flag2 = e:GetProperty()
		local flag1_uc = flag1
		if flag1 & EFFECT_FLAG_UNCOPYABLE ~=0 then
			flag1_uc = flag1 - EFFECT_FLAG_UNCOPYABLE 
		end
		e:SetProperty(flag1_uc, flag2)
		rscf.RegisterEffect(c, e, ignore)
		e:SetProperty(flag1, flag2)
		rscf.ssproce[e] = true 
		table.insert(rscf.ssproce[c][2], e)
		table.insert(rscf.ssproce[c][2], e:GetCondition() or aux.TRUE)
	end
	return 
end
function rscf.SwitchSpecialProcedure_filter(c)
	return c:GetFlagEffect(rscode.Special_Procedure) > 0
end
function rssf.SwitchSpecialProcedure(dis_idx, enb_idx)

end
function rscf.GetBaseSynchroProduce1(c, f1, f2, minc, maxc)
	if c.dark_synchro == true then
		rscf.AddSynchroProcedureSpecial(c, aux.NonTuner(f1), nil, nil, rscf.DarkTuner(f2), minc, maxc or 99)
	else
		rscf.AddSynchroProcedureSpecial(c, aux.Tuner(f1), nil, nil, f2, minc, maxc or 99)
	end
end
function rscf.GetBaseSynchroProduce2(c, f1, f2, f3, f4, minc, maxc, gc)
	rscf.AddSynchroProcedureSpecial(c, f1, f2, f3, f4, minc, maxc or 99, gc)
end
function rscf.XyzProcedure_TransformLv(xyzc, lv)
	return  function(g)
				return g:FilterCount(Card.IsXyzLevel, nil, xyzc, lv) == #g
			end
end
function rscf.GetBaseXyzProduce1(c, f, lv, ct, alterf, desc, maxct, op)
	rscf.AddXyzProcedureSpecial(c, f, rscf.XyzProcedure_TransformLv(c, lv), ct, maxct or ct, alterf, desc, op)
end 
function rscf.GetBaseXyzProduce2(c, f, gf, minc, maxc, alterf, desc, op)
	rscf.AddXyzProcedureSpecial(c, f, gf, minc, maxc or minc, alterf, desc, op)
end
function rscf.GetBaseLinkProduce1(c, f, min, max, gf)
	rscf.AddLinkProcedureSpecial(c, f, min, max, gf)
end
--Check is matg exist syncard's right materials
function rscf.GetLocationCountFromEx(...)
	return 1
end
function rscf.CheckSynchroMaterial(sync, tp, smat, matg, min, max, checkft, checkmust, checkpend)
	max = max or 99
	local proce = sync.rs_synchro_parammeter[1]
	if not proce then return false end
	local con = proce:GetCondition()
	local f = Duel.GetLocationCountFromEx
	Duel.GetLocationCountFromEx = checkft and Duel.GetLocationCountFromEx or rscf.GetLocationCountFromEx 
	local f2 = aux.MustMaterialCheck 
	aux.MustMaterialCheck = checkmust and aux.MustMaterialCheck or aux.TRUE 
	local ctype = TYPE_PENDULUM 
	TYPE_PENDULUM = checkpend and TYPE_PENDULUM or TYPE_SPELL  
	local res= not con or con(nil, sync, smat, matg, min, max)   
	Duel.GetLocationCountFromEx = f
	aux.MustMaterialCheck = f2
	TYPE_PENDULUM = ctype
	return res
end
--Select syncard's right materials 
function rsgf.SelectSynchroMaterial(sync, tp, smat, matg, min, max, checkft, checkmust, checkpend)
	max = max or 99
	local proce = sync.rs_synchro_parammeter[1]
	if not proce then return false end
	local tg = proce:GetTarget()
	local f = Duel.GetLocationCountFromEx
	Duel.GetLocationCountFromEx = checkft and Duel.GetLocationCountFromEx or rscf.GetLocationCountFromEx 
	local f2 = aux.MustMaterialCheck 
	local ctype = TYPE_PENDULUM 
	TYPE_PENDULUM = checkpend and TYPE_PENDULUM or TYPE_SPELL
	aux.MustMaterialCheck = checkmust and aux.MustMaterialCheck or aux.TRUE   
	local e1 = rsef.SV({ sync, nil, true }, rscode.Synchro_Material, nil, 0xff) 
	tg(e1, tp, nil, nil, nil, nil, nil, nil, 1, sync, smat, matg, min, max)
	local g = e1:GetLabelObject()
	Duel.GetLocationCountFromEx = f
	aux.MustMaterialCheck = f2  
	TYPE_PENDULUM = ctype  
	if not g then e1:Reset() return false end
	local og = g:Clone()
	og:KeepAlive()
	e1:Reset()
	return og
end
--Card / Summon function: Custom Synchro Procedure 
rscf.AddSynchroProcedure = aux.AddSynchroProcedure
function rscf.AddSynchroProcedureSpecial(c, f1, f2, f3, f4, minc, maxc, gc)
	local mt = getmetatable(c)
	if not rscf.AddSynchroProcedureSpecial_Switch then 
		rscf.AddSynchroProcedureSpecial_Switch = true
		rscf.GetSynMaterials	= aux.GetSynMaterials
		aux.GetSynMaterials = rscf.GetSynMaterials2
		rscf.SynMixCheckGoal	= aux.SynMixCheckGoal
		aux.SynMixCheckGoal = rscf.SynMixCheckGoal2
		rscf.SynMixCondition	= aux.SynMixCondition
		aux.SynMixCondition = rscf.SynMixCondition2
		rscf.SynMixTarget = aux.SynMixTarget
		aux.SynMixTarget = rscf.SynMixTarget2
		rscf.SynMixOperation	= aux.SynMixOperation
		aux.SynMixOperation = rscf.SynMixOperation2  
	end
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(rscf.SynMixCondition2(f1, f2, f3, f4, minc, maxc, gc))
	e1:SetTarget(Auxiliary.SynMixTarget(f1, f2, f3, f4, minc, maxc, gc))
	e1:SetOperation(Auxiliary.SynMixOperation(f1, f2, f3, f4, minc, maxc, gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and not c.rs_synchro_parammeter then
		mt.rs_synchro_parammeter = { e1, f1, f2, f3, f4, minc, maxc or minc, gc }
	end
	return e1
end
--Get synchro materials,  fix for special material
function rscf.GetSynMaterials2(tp, syncard)
	local mg1 = rscf.GetSynMaterials(tp, syncard)
	local mg2 = Duel.GetMatchingGroup(rscf.ExtraSynMaterialsFilter, tp, 0xff, 0xff, mg1, syncard, tp)
	if #mg2 > 0 then mg1:Merge(mg2) end
	return mg1
end
function rscf.ExtraSynMaterialsFilter(c, sc, tp)
	if c:IsOnField() and not c:IsFaceup() then return false end
	return c:IsHasEffect(rscode.Extra_Synchro_Material, tp) and c:IsCanBeSynchroMaterial(sc) 
end
function rscf.SCheckOtherMaterial(c, mg, sc, tp)
	local le = { c:IsHasEffect(rscode.Extra_Synchro_Material, tp) }
	if #le == 0 then return true end
	for _, te in pairs(le) do
		local f = te:GetValue()
		if not f or f(te, sc, mg) then return true end
	end
	return false
end
function rscf.SUncompatibilityFilter(c, sg, sc, tp)
	local mg = sg:Filter(aux.TRUE, c)
	return not rscf.SCheckOtherMaterial(c, mg, sc, tp)
end
function rscf.SynMixCheckGoal2(tp, sg, minc, ct, syncard, sg1, smat, gc, mgchk)
	mgchk= mgchk or rssf.synchro_material_group_check
	local mg = rsgf.Mix2(sg, sg1)
	--step 1,  check extra material
	if mg:IsExists(rscf.SUncompatibilityFilter, 1, nil, mg, syncard, tp) then return false end
	--step 2,  check material group filter function
	--useless 
	--if syncard.rs_synchro_material_check and not syncard.rs_synchro_material_check(mg, syncard, tp) then return false end
	--step 3,  check level fo dark_synchro and non - level_synchro 
	local f = Card.GetLevel
	local darktunerg = mg:Filter(Card.IsType, nil, TYPE_TUNER)
	local darktunerlv = darktunerg:GetSum(Card.GetSynchroLevel, syncard)
	Card.GetLevel = function(sc)
		if syncard.dark_synchro and syncard == sc then
			return darktunerlv * 2-f(sc)
		end
		if sc.rs_synchro_level then return sc.rs_synchro_level
		else return f(sc)
		end
	end
	--step 4,  check Ladian 1,  use material's custom lv (if any)
	local f2 = Card.GetSynchroLevel
	Card.GetSynchroLevel = function(sc, sc2)
		local lvcheck = syncard.rs_synchro_ladian 
		if type(lvcheck) == "number" then return lvcheck
		elseif type(lvcheck) == "function" then 
			local lv = lvcheck(sc, mg, sc2, tp)
			if type(lv) == "number" then return lv 
			else return f2(sc, sc2) 
			end
		end
	end
	local bool1 = rscf.SynMixCheckGoal(tp, sg, minc, ct, syncard, sg1, smat, gc, mgchk)
	Card.GetSynchroLevel = f2
	--step 5,  check Ladian 2,  use material's base lv
	local bool2 = rscf.SynMixCheckGoal(tp, sg, minc, ct, syncard, sg1, smat, gc, mgchk)
	Card.GetLevel = f
	return bool1 or bool2
end
function rscf.SynMixCondition2(f1, f2, f3, f4, minc, maxc, gc)
	return function(e, c, smat, mg1, min, max)
		if mg1 and aux.GetValueType(mg1) ~= "Group" then return false end
		return rscf.SynMixCondition(f1, f2, f3, f4, minc, maxc, gc)(e, c, smat, mg1, min, max)
	end
end
function rscf.SynMixTarget2(f1, f2, f3, f4, minc, maxc, gc)
	return function(e, tp, eg, ep, ev, re, r, rp, chk, c, smat, mg1, min, max)
		rssf.synchro_material_group_check = nil
		if mg1 then
			rssf.synchro_material_group_check = true
		end
		return rscf.SynMixTarget(f1, f2, f3, f4, minc, maxc, gc)(e, tp, eg, ep, ev, re, r, rp, chk, c, smat, mg1, min, max)
	end
end
function rscf.SynMixOperation2(f1, f2, f3, f4, minct, maxc, gc)
	return  function(e, tp, eg, ep, ev, re, r, rp, c, smat, mg, min, max)
				local g = e:GetLabelObject()
				rscf.SynchroCustomOperation(g, c, e, tp)
				g:DeleteGroup()
			end
end
function rscf.SynchroCustomOperation(mg, c, e, tp)
	c:SetMaterial(mg)  
	rscf.SExtraMaterialCount(mg, sync, tp)
	--case 1,  Summon Effect Custom
	if rssf.SynchroMaterialAction then
		rssf.SynchroMaterialAction(mg, c, e, tp)
		rssf.SynchroMaterialAction = nil
	--case 2,  Summon Procedure Custom 
	elseif c.rs_synchro_material_action then
		c.rs_synchro_material_action(mg, c, e, tp)
	--case 3,  Base Summon Procedure
	else
		Duel.SendtoGrave(mg, REASON_SYNCHRO + REASON_MATERIAL)
	end
end
function rscf.SExtraMaterialCount(mg, sync, tp)
	for tc in aux.Next(mg) do
		local le = { tc:IsHasEffect(rscode.Extra_Synchro_Material, tp) }
		for _, te in pairs(le) do
			local sg = mg:Filter(aux.TRUE, tc)
			local f = te:GetValue()
			if not f or f(te, sync, sg) then
				te:UseCountLimit(tp)
			end
		end
	end
end
--Card / Summon function: Special Synchro Summon Procedure
--Force a synchro level for a synchro monster's synchro procedure
function rscf.AddSynchroProcedureSpecial_SynchroLevel(c, lv, ...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_level then
		local mt = getmetatable(c)
		mt.rs_synchro_level = lv 
	end
	local e1 = rscf.AddSynchroProcedureSpecial(c, ...)
	return e1
end
--Dark Synchro Procedure
function rscf.AddSynchroProcedureSpecial_DarkSynchro(c, ...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.dark_synchro then
		local mt = getmetatable(c)
		mt.dark_synchro = true
	end
	local e1 = rscf.AddSynchroProcedureSpecial(c, ...)
	return e1
end
--Ladian's Synchro Procedure (treat tuner as another lv)
function rscf.AddSynchroProcedureSpecial_Ladian(c, f1, lv, f2, f3, f4, minc, maxc, extrafilter)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_ladian then
		local mt = getmetatable(c)
		mt.rs_synchro_ladian = { lv, extrafilter }
	end
	local e1 = rscf.AddSynchroProcedureSpecial(c, f1, f2, f3, f4, minc, maxc)
	return e1
end
--Custom Synchro Materials' Action
function rscf.AddSynchroProcedureSpecial_CustomAction(c, actionfun, ...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_synchro_material_action then
		local mt = getmetatable(c)
		mt.rs_synchro_material_action = actionfun
	end
	local e1 = rscf.AddSynchroProcedureSpecial(c, ...)
	return e1
end 

--Card / Summon function: Custom Xyz Procedure 
function rscf.AddXyzProcedureSpecial(c, f, gf, minc, maxc, alterf, desc, op)
	local mt = getmetatable(c)
	if not rscf.AddXyzProcedureSpecial_Switch then
		rscf.AddXyzProcedureSpecial_Switch = true
		rscf.XyzLevelFreeCondition2 = aux.XyzLevelFreeCondition2
		aux.XyzLevelFreeCondition2 = rscf.XyzLevelFreeCondition22
		rscf.XyzLevelFreeTarget2 = aux.XyzLevelFreeCondition2
		aux.XyzLevelFreeTarget2 = rscf.XyzLevelFreeTarget22
		rscf.XyzLevelFreeOperation2 = aux.XyzLevelFreeOperation2
		aux.XyzLevelFreeOperation2 = rscf.XyzLevelFreeOperation22
		rscf.XyzLevelFreeGoal = aux.XyzLevelFreeGoal
		rscf.XyzLevelFreeFilter = aux.XyzLevelFreeFilter
		aux.XyzLevelFreeFilter = rscf.XyzLevelFreeFilter2
	end
	--aux.XyzLevelFreeGoal = rscf.XyzLevelFreeGoal2(minc, maxc or minc)
	alterf = alterf or aux.FALSE 
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	--if alterf then
		maxc= maxc or minc
		e1:SetCondition(rscf.XyzLevelFreeCondition22(f, gf, minc, maxc, alterf, desc, op))
		e1:SetTarget(rscf.XyzLevelFreeTarget22(f, gf, minc, maxc, alterf, desc, op))
		e1:SetOperation(rscf.XyzLevelFreeOperation22(f, gf, minc, maxc, alterf, desc, op))
	--[[else
		e1:SetCondition(Auxiliary.XyzLevelFreeCondition(f, gf, minc, maxc))
		e1:SetTarget(Auxiliary.XyzLevelFreeTarget(f, gf, minc, maxc))
		e1:SetOperation(Auxiliary.XyzLevelFreeOperation(f, gf, minc, maxc))--]]
	--end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and not c.rs_xyz_parammeter then
		mt.rs_xyz_parammeter = { e1, f1, f2, f3, f4, maxc, gc }
	end
	return e1
end
function rscf.XCheckUtilityMaterial(c, mg, xyzc, tp)
	local le = { c:IsHasEffect(rscode.Utility_Xyz_Material, tp) }
	if #le == 0 then return 1, { 1} end
	local maxreduce = 1
	local reducelist = { 1}
	for _, te in pairs(le) do
		local val = te:GetValue()
		local reduce = 1
		if type(val) == "number" then reduce = val end
		if type(val) == "function" then reduce = val(te, xyzc, mg, tp) end
		maxreduce = math.max(maxreduce, reduce or 2) 
		table.insert(reducelist, reduce or 2)
	end
	return maxreduce, reducelist
end
function rscf.XUncompatibilityFilter(c, sg, xyzc, tp)
	local mg = sg:Filter(aux.TRUE, c)
	return not rscf.XCheckOtherMaterial(c, mg, xyzc, tp, sg)
end
function rscf.XCheckOtherMaterial(c, mg, xyzc, tp, sg)
	local le = { c:IsHasEffect(rscode.Extra_Xyz_Material, tp) }
	if #le == 0 then return true end
	for _, te in pairs(le) do
		local f = te:GetValue()
		if not f or f(te, xyzc, mg, sg) then return true end
	end
	return false
end
function rscf.IsCanBeXyzMaterial(c, xyzc)
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
function rscf.XyzLevelFreeFilter2(c, xyzc, f)
	return (not c:IsOnField() or c:IsFaceup()) and rscf.IsCanBeXyzMaterial(c, xyzc) and (not f or f(c, xyzc))   
end
function rscf.ExtraXyzMaterialsFilter(c, xyzc, tp, f)
	if c:IsType(TYPE_TOKEN) then return false end
	if c:IsOnField() and not c:IsFaceup() then return false end
	return c:IsHasEffect(rscode.Extra_Xyz_Material, tp) and rscf.IsCanBeXyzMaterial(c, xyzc) and (not f or f(c))
end
function rscf.XyzLevelFreeGoal2(minct, maxct, og)
	return function(g, tp, xyzc, gf)
		--case 1,  extra material check 
		if not og and g:IsExists(rscf.XUncompatibilityFilter, 1, nil, g, xyzc, tp) then return false end
		--case 2,  normal check
		if (gf and not gf(g, og, tp, xyzc)) or Duel.GetLocationCountFromEx(tp, tp, g, xyzc) <= 0 then return false end
		--if #g < minct then return false end
		if #g > maxct then return false end
		--case 3,  utility check,  separate mg and ug for easy calculate
		local ug = g:Filter(Card.IsHasEffect, nil, rscode.Utility_Xyz_Material, tp)
		local mg = g:Clone()
		mg:Sub(ug)
		local totalreducelist = { }
		local sumlist = { #mg }
		for tc in aux.Next(ug) do 
			local ct = 0
			local sumlist2 = rsof.Table_Clone(sumlist)
			local _, reducelist = rscf.XCheckUtilityMaterial(tc, g, xyzc, tp)
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
			if matct >= minct and matct <= maxct then return true end
		end
		return false
	end
end
function rscf.XyzLevelFreeCondition22(f, gf, minct, maxct, alterf, desc, op)
	return  function(e, c, og, min, max)
				if c == nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp = c:GetControler()
				local mg = nil
				--other material
				local mgextra = nil
				if og then
					mg = og
				else
					mg = Duel.GetFieldGroup(tp, LOCATION_MZONE, 0)
					mgextra = Duel.GetMatchingGroup(rscf.ExtraXyzMaterialsFilter, tp, 0xff, 0xff, mg, c, tp, f)
				end
				local altg = mg:Filter(Auxiliary.XyzAlterFilter, nil, alterf, c, e, tp, op):Filter(Auxiliary.MustMaterialCheck, nil, tp, EFFECT_MUST_BE_XMATERIAL)
				if (not min or min <= 1) and altg:GetCount() > 0 then
					return true
				end
				local minc = minct
				local maxc = maxct
				if min then
					if min > minc then minc = min end
					if max < maxc then maxc = max end
					--if minc > maxc then return false end
				end
				mg = mg:Filter(rscf.XyzLevelFreeFilter2, nil, c, f)
				if mgextra and #mgextra > 0 then mg:Merge(mgextra) end
				local sg = Auxiliary.GetMustMaterialGroup(tp, EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter, 1, nil, mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional = Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				--minc to 1 for utility xyz material
				local res = mg:CheckSubGroup(rscf.XyzLevelFreeGoal2(minc, maxc, og), 1, maxc, tp, c, gf)
				Auxiliary.GCheckAdditional = nil
				return res
			end
end
function rscf.XyzLevelFreeTarget22(f, gf, minct, maxct, alterf, desc, op)
	return  function(e, tp, eg, ep, ev, re, r, rp, chk, c, og, min, max)
				if og and not min then
					return true
				end
				local minc = minct
				local maxc = maxct
				if min then
					if min > minc then minc = min end
					if max < maxc then maxc = max end
				end
				local mg = nil
				--other material
				local mg3 = nil
				if og then
					mg = og
					mg3 = og
				else
					mg = Duel.GetFieldGroup(tp, LOCATION_MZONE, 0)
					mg3 = Duel.GetMatchingGroup(rscf.ExtraXyzMaterialsFilter, tp, 0xff, 0xff, mg, c, tp, f)
				end
				local sg = Auxiliary.GetMustMaterialGroup(tp, EFFECT_MUST_BE_XMATERIAL)
				local mg2 = mg:Filter(rscf.XyzLevelFreeFilter2, nil, c, f)
				mg3:Merge(mg2)
				--other material
				Duel.SetSelectedCard(sg)
				local b1 = mg3:CheckSubGroup(rscf.XyzLevelFreeGoal2(minc, maxc, og), 1, maxc, tp, c, gf)
				local b2 = (not min or min <= 1) and mg:IsExists(Auxiliary.XyzAlterFilter, 1, nil, alterf, c, e, tp, op)
				local g = nil
				if b2 and (not b1 or Duel.SelectYesNo(tp, desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
					g = mg:FilterSelect(tp, Auxiliary.XyzAlterFilter, 1, 1, nil, alterf, c, e, tp, op)
					if op then op(e, tp, 1, g:GetFirst()) end
				else
					e:SetLabel(0)
					Duel.SetSelectedCard(sg)
					Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
					local cancel = Duel.IsSummonCancelable()
					Auxiliary.GCheckAdditional = Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
					g = mg3:SelectSubGroup(tp, rscf.XyzLevelFreeGoal2(minc, maxc, og), cancel, 1, maxc, tp, c, gf)
					Auxiliary.GCheckAdditional = nil
				end
				if g and g:GetCount() > 0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function rscf.XyzLevelFreeOperation22(f, gf, minct, maxct, alterf, desc, op)
	return  function(e, tp, eg, ep, ev, re, r, rp, c, og, min, max)
				if og and not min then
					rscf.XyzCustomOperation(og, c, e, tp, false)
				else
					local mg = e:GetLabelObject()
					rscf.XyzCustomOperation(mg, c, e, tp, true)
				end
			end
end
function rscf.XyzCustomOperation(mg, c, e, tp, checkog)
	c:SetMaterial(mg)
	if checkog then
		rscf.XExtraMaterialCount(mg, c, tp)
	end
	local sg = Group.CreateGroup()
	local tc = mg:GetFirst()
	while tc do
		local sg1 = tc:GetOverlayGroup()
		sg:Merge(sg1)
	tc = mg:GetNext()
	end 
	--case 1,  Summon Effect Custom (Book of Cain)
	if rssf.XyzMaterialAction then
		rssf.XyzMaterialAction(mg, sg, c, e, tp)
		rssf.XyzMaterialAction = nil
	--case 2,  Summon Procedure Custom 
	elseif c.rs_xyz_material_action then
		c.rs_xyz_material_action(mg, sg, c, e, tp)
	--case 3,  Base Alterf Xyz Procedure
	elseif e:GetLabel() == 1 then
		if #sg > 0 then
			Duel.Overlay(c, sg)
		end
		Duel.Overlay(c, mg)
	--case 4,  Base Normal Xyz Procedure
	else
		Duel.SendtoGrave(sg, REASON_RULE)
		Duel.Overlay(c, mg)
	end
	--if used hand material,  shuffle hand
	if mg:IsExists(Card.IsPreviousLocation, 1, nil, LOCATION_HAND) then
		Duel.ShuffleHand(tp)	
	end
	mg:DeleteGroup()
end
function rscf.XExtraMaterialCount(mg, xyzc, tp)
	for tc in aux.Next(mg) do
		local le = { tc:IsHasEffect(rscode.Extra_Xyz_Material, tp) }
		for _, te in pairs(le) do
			local sg = mg:Filter(aux.TRUE, tc)
			local f = te:GetValue()
			if not f or f(te, xyzc, sg, mg) then
				te:UseCountLimit(tp)
			end
		end
	end
end
--Card / Summon function: Special Xyz Summon Procedure
--Custom Xyz Materials' Action
function rscf.AddXyzProcedureSpecial_CustomAction(c, actionfun, ...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_xyz_material_action then
		local mt = getmetatable(c)
		mt.rs_xyz_material_action = actionfun
	end
	local e1 = rscf.AddXyzProcedureSpecial(c, ...)
	return e1
end
function rscf.XyzMaterialAction(c, actionfun)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_xyz_material_action then
		local mt = getmetatable(c)
		mt.rs_xyz_material_action = actionfun
	end
end


--Card / Summon function: Custom Link Procedure 
function rscf.AddLinkProcedureSpecial(c, f, min, max, gf)
	if not rscf.AddLinkProcedureSpecial_Switch then
		rscf.AddLinkProcedureSpecial_Switch = true
		rscf.LCheckOtherMaterial = aux.LCheckOtherMaterial 
		aux.LCheckOtherMaterial = rscf.LCheckOtherMaterial2
		rscf.GetLinkMaterials = aux.GetLinkMaterials
		aux.GetLinkMaterials	= rscf.GetLinkMaterials2
		rscf.LinkOperation = aux.LinkOperation
		aux.LinkOperation = rscf.LinkOperation2
	end
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max == nil then max = c:GetLink() end
	e1:SetCondition(Auxiliary.LinkCondition(f, min, max, gf))
	e1:SetTarget(Auxiliary.LinkTarget(f, min, max, gf))
	e1:SetOperation(rscf.LinkOperation2(f, min, max, gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and not c.rs_link_parammeter then
		local mt = getmetatable(c)
		mt.rs_link_parammeter = { e1, f, min, max, gf }
	end
	return e1
end
function rscf.GetLinkMaterials2(tp, f, lc)
	local mg = Duel.GetMatchingGroup(Auxiliary.LConditionFilter, tp, LOCATION_MZONE, 0, nil, f, lc)
	local mg2 = Duel.GetMatchingGroup(Auxiliary.LExtraFilter, tp, 0xff, 0xff, nil, f, lc, tp)
	if mg2:GetCount() > 0 then mg:Merge(mg2) end
	return mg
end
function rscf.LinkOperation2(f, minc, maxc, gf)
	return  function(e, tp, eg, ep, ev, re, r, rp, c, og, lmat, min, max)
				local g = e:GetLabelObject()
				rscf.LinkCustomOperation(g, c, e, tp, og)
				g:DeleteGroup()
			end
end
function rscf.LinkCustomOperation(mg, c, e, tp, checkog)
	c:SetMaterial(mg)
	if checkog then
		Auxiliary.LExtraMaterialCount(mg, c, tp)
	end
	--case 1,  Summon Effect Custom
	if rssf.LinkMaterialAction then
		rssf.LinkMaterialAction(mg, c, e, tp, checkog)
		rssf.LinkMaterialAction = nil
	--case 2,  Summon Procedure Custom 
	elseif c.rs_link_material_action then
		c.rs_link_material_action(mg, c, e, tp, checkog)
	--case 3,  Base Summon Procedure
	else
		Duel.SendtoGrave(mg, REASON_LINK + REASON_MATERIAL)
	end
end
--Change aux function to repair bug in multiple other material link
function rscf.LCheckOtherMaterial2(c, mg, lc, tp)
	local le = { c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL, tp) }
	if #le == 0 then return true end
	for _, te in pairs(le) do
		local f = te:GetValue()
		if not f or f(te, lc, mg) then return true end
	end
	return false
end
--Card / Summon function: Special Link Summon Procedure
--Custom Link Materials' Action
function rscf.AddLinkProcedureSpecial_CustomAction(c, actionfun, ...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_link_material_action then
		local mt = getmetatable(c)
		mt.rs_link_material_action = actionfun
	end
	local e1 = rscf.AddLinkProcedureSpecial(c, ...)
	return e1
end
function rscf.LinkMaterialAction(c, actionfun)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	if not c.rs_link_material_action then
		local mt = getmetatable(c)
		mt.rs_link_material_action = actionfun
	end
end

--Card effect: Set field info
function rscf.SetFieldInfo(c)
	local seq = c:IsOnField() and c:GetSequence() or c:GetPreviousSequence()
	local loc = c:IsOnField() and c:GetLocation() or c:GetPreviousLocation()
	local cp = c:IsOnField() and c:GetControler() or c:GetPreviousControler()
	if loc == LOCATION_DECK + LOCATION_GRAVE + LOCATION_REMOVED + LOCATION_HAND then
		Debug.Message("rscf.SetFieldInfo: Location is not on field.")
	else
		rscf.fieldinfo[c] = { seq, loc, cp }
	end
end
--Card effect: Get field info
function rscf.GetFieldInfo(c)
	if not rscf.fieldinfo[c] or not rscf.fieldinfo[c][1] then
		Debug.Message("rscf.GetFieldInfo: Didn't use rscf.SetFieldInfo set field information")
		return nil
	end
	return rscf.fieldinfo[c][1], rscf.fieldinfo[c][2], rscf.fieldinfo[c][3]
end
--Card effect: Check if c is surrounding to tc 
function rscf.IsSurrounding(c, tc)
	if not tc:IsOnField() then return false end
	local g = rsgf.GetSurroundingGroup(tc, true)
	return g:IsContains(c)
end
--Card effect: Check if c is surrounding to tc,  c is previous on field
function rscf.IsPreviousSurrounding(c, tc)
	local seq, loc, p = c:GetPreviousSequence(), c:GetPreviousLocation(), c:GetPreviousControler()
	if loc & LOCATION_ONFIELD == 0 or not tc:IsOnField() then
		return false
	end
	local mzone, szone, ozone = rszsf.GetSurroundingZone(tc)
	local zone = ozone[0] + ozone[1]
	if p ~= tc:GetControler() then seq = seq + 16 end
	local czone = 2^seq
	if loc == LOCATION_SZONE then czone = czone * 0x100 end
	return czone & zone ~=0   
end
--Card effect: Get First Target Card for Operations
function rscf.TargetFilter(c, e, tp, filter, ...)
	local var_list = { ... }
	if not c:IsRelateToEffect(e) then return false end
	if not filter then return true end
	if not ... then return filter(c, e, tp) 
	else
		return filter(c, table.unpack(rsof.Table_Mix(var_list, { e, tp })))
	end
end
function rscf.GetTargetCard(card_filter, ...)
	local tc = Duel.GetFirstTarget()
	if not tc then return nil end
	local e, tp = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_EFFECT, CHAININFO_TRIGGERING_PLAYER) 
	if rscf.TargetFilter(tc, e, tp, card_filter, ...) then return tc 
	else return nil
	end
end
--Card effect: qucik register dark_synchro type 
function rscf.EnableDarkSynchroAttribute(reg_list, reset_list)
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	if not reset_list and reg_owner == reg_handler and not reg_handler:IsStatus(STATUS_COPYING_EFFECT) and not reg_owner.dark_synchro then 
		local mt = getmetatable(reg_handler) 
		mt.dark_synchro = true
	end
	if reset_list then 
		local e1 = rsef.SV_ADD(reg_list, "type", "TYPE_DARKSYNCHRO", nil, reset_list, "cd, ch", rshint.darksynchro)
		return e1
	end
end
--Card effect: qucik register dark_tuner type 
function rscf.EnableDarkTunerAttribute(reg_list, reset_list)
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	if not reset_list and reg_owner == reg_handler and not reg_handler:IsStatus(STATUS_COPYING_EFFECT) and not reg_owner.dark_tuner then 
		local mt = getmetatable(reg_handler) 
		mt.dark_tuner = true
	end
	if reset_list then 
		local e1 = rsef.SV_ADD(reg_list, "type", "TYPE_DARKTUNER", nil, reset_list, "cd, ch", rshint.darktuner)
		return e1
	end
end
--Card filter: Is Dark Synchro
function rscf.IsDarkSynchro(c)
	return c.dark_synchro == true
end
--Card filter: Is Dark Tuner 
function rscf.IsDarkTuner(c)
	return rscf.DarkTuner(nil)(c)
end
--Card filter: Dark Tuner for Dark Synchro Summon
function rscf.DarkTuner(f, ...)
	local ext_paramms = { ... }
	return  function(target)
				local type_list = { target:IsHasEffect(EFFECT_ADD_TYPE) }
				local bool = false
				for _, e in pairs(type_list) do
					if rsval.valinfo[e] == "TYPE_DARKTUNER" then
						bool = true
					break 
					end
				end
				return (target.dark_tuner or bool) and aux.Tuner(f, table.unpack(ext_paramms))(target)
			end
end
--Card filter: face up + filter
function rscf.fufilter(f, ...)
	local ext_paramms = { ... }
	return  function(target)
				return f(target, table.unpack(ext_paramms)) and target:IsFaceup()
			end
end
--zone filter : get location count
function rszsf.GetUseAbleMZoneCount(c, reason_pl, leave_val, use_pl, zone)
	if c:GetOriginalType() & TYPE_MONSTER == 0 then return 0 end
	reason_pl = reason_pl or c:GetControler()
	use_pl = use_pl or reason_pl
	zone = zone or 0xff
	if c:IsLocation(LOCATION_EXTRA) then return 
		Duel.GetLocationCountFromEx(use_pl, reason_pl, leave_val, c, zone)
	elseif leave_val then return 
		Duel.GetMZoneCount(reason_pl, leave_val, use_pl, LOCATION_REASON_TOFIELD, zone)
	else
		return Duel.GetLocationCount(reason_pl, LOCATION_MZONE, use_pl, LOCATION_REASON_TOFIELD, zone)
	end
end
--Card filter function: Special Summon Filter
function rscf.spfilter(f, ...)
	local ext_paramms = { ... }
	return function(c, e, tp)
		return c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and (not f or f(c, table.unpack(rsof.Table_Mix(ext_paramms, { e, tp })))) and c:IsType(TYPE_MONSTER)
	end
end
function rscf.spfilter2(f, ...)
	local ext_paramms = { ... }
	return function(c, e, tp)
		return c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and (not f or f(c, table.unpack(rsof.Table_Mix(ext_paramms, { e, tp })))) and rszsf.GetUseAbleMZoneCount(c, tp) > 0 and c:IsType(TYPE_MONSTER)
	end
end
--Card filter function : Face - up from Remove 
function rscf.RemovePosCheck(c)
	return not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()
end 
Card.RemovePosCheck = rscf.RemovePosCheck 
--Card filter function : Face - up from field 
function rscf.FieldPosCheck(c) 
	return not c:IsOnField() or c:IsFaceup()
end 
Card.FieldPosCheck = rscf.FieldPosCheck 
--Card filter function : destroy replace check
function rscf.rdesfilter(filter, ...)
	local ext_paramms = { ... }
	return function(c, e, tp)
		return (not filter or filter(c, table.unpack(rsof.Table_Mix(ext_paramms, { e, tp })))) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
	end
end
--Card function: Get same type base set
function rscf.GetSameType_Base(c, way_str, type1, ...)
	local type_fun = Card.GetType
	if way_str == "previous" 
		then type_fun = Card.GetPreviousTypeOnField 
	elseif way_str == "original" 
		then type_fun = Card.GetOriginalType
	end
	local type_list= type1 and { type1, ... } or { TYPE_MONSTER, TYPE_SPELL, TYPE_TRAP } 
	local total_type = 0
	local total_type_list = { }
	for _, ctype in pairs(type_list) do
		if type_fun(c) & ctype == ctype then
			total_type = total_type | ctype
			if not rsof.Table_List(total_type_list, ctype) then
				table.insert(total_type_list, ctype) 
			end
		end
	end
	return total_type, total_type_list
end
--Card function: Get same type 
function rscf.GetSameType(c, ...)
	return rscf.GetSameType_Base(c, nil, ...)
end
--Card function: Get same previous type 
function rscf.GetPreviousSameType(c, ...)
	return rscf.GetSameType_Base(c, "previous", ...)
end
--Card function: Get same original type 
function rscf.GetOriginalSameType(c, ...)
	return rscf.GetSameType_Base(c, "original", ...)
end
--Card Funcion: Check complex card type base set
function rscf.IsComplexType_Base(c, way_str, type1, type2, ...)
	local type_fun = Card.GetType
	if way_str == "previous" 
		then type_fun = Card.GetPreviousTypeOnField 
	elseif way_str == "original" 
		then type_fun = Card.GetOriginalType
	end
	local type_list = { type1, type2, ... }
	local type_public = 0
	if rsof.Check_Boolean(type2) then
		type_public = type1
		type_list = { ... }
	end
	for _, ctype in pairs(type_list) do 
		if type(ctype) == "string" then
			if ctype == "TYPE_SPELL" then
				if type_fun(c) == TYPE_SPELL then return true end
			elseif ctype == "TYPE_TRAP" then
				if type_fun(c) == TYPE_TRAP then return true end
			end
		else
			if type_fun(c) & (ctype | type_public) == (ctype | type_public) then return true end
		end
	end 
	return false
end
--Card Funcion: Check Complex card type
function rscf.IsComplexType(c, ...)
	return rscf.IsComplexType_Base(c, nil, ...)
end
Card.IsComplexType = rscf.IsComplexType
--Card Funcion: Check Complex card previous type
function rscf.IsPreviousComplexType(c, ...)
	return rscf.IsComplexType_Base(c, "previous", ...)
end
Card.IsPreviousComplexType = rscf.IsPreviousComplexType
--Card Funcion: Check Complex card original type
function rscf.IsOriginalComplexType(c, ...)
	return rscf.IsComplexType_Base(c, "original", ...)
end
Card.IsOriginalComplexType = rscf.IsOriginalComplexType
--Card Funcion: Check complex card reason 
function rscf.IsComplexReason(c, reason1, reason2, ...)
	local res_list = { reason1, reason2, ... }
	local public_reason = 0
	if rsof.Check_Boolean(reason2) then
		public_reason = reason1
		res_list = { ... }
	end
	for _, reason in pairs(res_list) do
		if c:GetReason() & (reason | public_reason) == (reason | public_reason) then return true end
	end
	return false 
end
Card.IsComplexReason = rscf.IsComplexReason

-------------------"Part_Hint_Function"---------------------

--Hint function: HINT_SELECTMSG
function rshint.Select(p, cate_or_str_or_num)
	local hint_str = nil
	if type(cate_or_str_or_num) ~= "string" then hint_str = cate_or_str_or_num end
	local hint_msg = rsef.GetDefaultSelectHint(cate_or_str_or_num, nil, nil, hint_str)
	Duel.Hint(HINT_SELECTMSG, p, hint_msg) 
end
--Hint function: HINT_CARD
function rshint.Card(code)
	Duel.Hint(HINT_CARD, 0, code) 
end
--Function: Select Yes or No
function rshint.SelectYesNo(p, hint_par, hint_code)
	local string = rshint.SwitchHintFormat("w", hint_par)
	local res = Duel.SelectYesNo(p, string)
	if res and type(hint_code) == "number" then
		rshint.Card(hint_code)
	end
	return res
end
--Function: N effects select 1
function rshint.SelectOption(p, ...)
	local fun_list = { ... }
	local off = 1
	local ops = { }
	local opval = { }
	for idx, val in pairs(fun_list) do
		if rsof.Check_Boolean(val,true) then
			local sel_hint = fun_list[idx + 1]
			ops[off] = rshint.SwitchHintFormat(nil, sel_hint)
			opval[off - 1] = (idx + 1) / 2
			off = off + 1
		end
	end
	if #ops <= 0 then 
		return nil
	else
		local op = Duel.SelectOption(p, table.unpack(ops))
		return opval[op]
	end
end
--Function: Select number options
function rshint.AnnounceNumber(tp, maxdigit)
	maxdigit = maxdigit or 7
	if maxdigit > 7 then maxdigit = 7 end
	local selectnum = {m + 1, 8 }
	local confirm = {m + 1, 9 }
	local clear = {m + 1, 10 }
	local agree = {m + 1, 7 }
	local op, isfinsh = 0, false
	local num, digitlevel, digitidx = 0, 1, maxdigit
	for digit = 1, maxdigit do 
		digitlevel = digitlevel * (digit == 1 and 1 or 10)
	end
	repeat 
		op = rsop.SelectOption_Page(tp, selectnum, confirm, nil, clear)
		if op == 2 then
			Debug.Message("Confirm select number:" .. num)
		elseif op == 3 then
			num = 0
		elseif op == 1 then
			for digit = 1, maxdigit do
				Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(m + 2, 7 - digitidx))
				num = num + Duel.AnnounceNumber(tp, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0) * digitlevel
				digitlevel = digitlevel / 10
				digitidx = digitidx - 1
			end
		end
		digitlevel, digitidx = 1, maxdigit
		for digit = 1, maxdigit do 
			digitlevel = digitlevel * (digit == 1 and 1 or 10)
		end
	until op == 0
	return num
end

-------------------"Part_Other_Function"---------------------
--Special Debug 
function rsof.DebugMSG(val_1, ...)
	local val_list = { val_1, ... }
	local hint = ""
	for idx, val in pairs(val_list) do 
		if type(val) == "string" then
			hint = hint .. val == "0x" and "" or val
		elseif type(val) == "number" then
			if val_list[idx - 1] and type(val_list[idx - 1]) == "string" and val_list[idx - 1] == "0x" then
				hint = hint .. rsof.Dec_To_Hex(val)
			else
				hint = hint .. val
			end
		else
			hint = hint .. tostring(val) 
		end
	end
	Debug.Message(hint)
end
--10 DEC to 16 HEX
function rsof.Dec_To_Hex(str)
	return string.format("0x%0X", str)
end
--split the string,  ues ", " as delim_er
function rsof.String_Split(str_input, delim_er)  
	delim_er = delim_er or ',' 
	local pos, arr = 0,  { }  
	--case string list 
	if delim_er == ',' then
		for st, sp in function() return string.find(str_input,  delim_er,  pos,  true) end do  
			table.insert(arr,  string.sub(str_input,  pos,  st - 1))  
			pos = sp + 1  
		end  
		table.insert(arr,  string.sub(str_input,  pos)) 
		return arr
	--case set code
	elseif delim_er == '_' then
		for st, sp in function() return string.find(str_input,  delim_er,  pos,  true) end do  
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
--get no symbol string (for rscf.ComplexFilter and rscon.phmp)
function rsof.String_NoSymbol(str)
	local len = string.len(str)
	local symbo_list1 = { "+", "-", " ~ ", " = "}
	local symbo_list2 = { "++", "--" }
	local symbo_list3 = { "_s", "_o" }
	local str2 = string.sub(str,  - 2)
	local str3 = string.sub(str,  - 2)
	local str1 = string.sub(str2,  - 1)
	if rsof.Table_List(symbo_list2, str2) then
		return string.sub(str, 1, len - 2), str2
	elseif rsof.Table_List(symbo_list1, str1) then
		return string.sub(str, 1, len - 1), str1
	elseif rsof.Table_List(symbo_list3, str3) then
		return string.sub(str, 1, len - 2), str3
	else
		return str
	end
end
--Sting to Table (for different formats)
--you can use "a, b, c" or { "a, b, c" } or { "a", "b", "c" } as same
--return { "a", "b", "c" }
function rsof.String_Number_To_Table(value)
	local table1 = { }
	if type(value) == "string" then
		table1 = rsof.String_Split(value)
	elseif type(value) == "number" then
		table1 = { value }
	elseif type(value) == "table" then
		for _, val in ipairs(value) do
			if type(val) == "string" then
				local table2 = rsof.String_Split(val)
				for _, val2 in ipairs(table2) do
					table.insert(table1, val2) 
				end
			else 
				table.insert(table1, val)
			end
		end
	end
	return table1
end
--suit 2 tables (for rsv_E_SV)
function rsof.Table_Suit(value1, value2, value3, value4, value4nosuit)
	local table1 = rsof.String_Number_To_Table(value1)
	local table2 = rsof.String_Number_To_Table(value2)
	local table3 = value3
	local table4 = value4
	if type(value4) ~= "table" then
		table4 = { value4 }
	end
	local res_list1, res_list2 = { }, { }
	for idx1, val1 in ipairs(table1) do
		for idx2, val2 in ipairs(table2) do
			if val1 == val2 then
				table.insert(res_list1, value3[idx2]) 
				if #table4 == 1 and not value4nosuit then
				   table.insert(res_list2, table4[1])
				else
				   table.insert(res_list2, table4[idx1])
				end
			end
		end
	end
	return res_list1, res_list2, res_list1[1], res_list2[1]
end
--other function: Find correct element in table
function rsof.Table_List_Single(base_tab, check_val)
	local exist_res, exist_idx = false, 0
	for idx, val in pairs(base_tab) do 
		if val == check_val then
			exist_res = true
			exist_idx = idx 
			break
		end
	end
	return exist_res, exist_idx
end
function rsof.Table_List_Base(check_type, base_tab, check_val1, ...)
	local check_list = { check_val1, ... }
	local res_list = { }
	for idx, check_val in pairs(check_list) do 
		local exist_res, exist_idx = rsof.Table_List_Single(base_tab, check_val)
		if check_type == "normal" then
			table.insert(res_list, exist_res)
		elseif check_type == "or" then
			res_list[1] = res_list[1] or exist_res
		elseif check_type == "and" then
			res_list[1] = res_list[1] and exist_res
		end 
		table.insert(res_list, exist_idx)
	end
	return table.unpack(res_list)
end
--other function: Find correct element in table
function rsof.Table_List(base_tab, check_val1, ...)
	return rsof.Table_List_Base("normal", base_tab, check_val1, ...)
end
--other function: Find correct element in table(match 1)
function rsof.Table_List_OR(base_tab, check_val1, ...)
	return rsof.Table_List_Base("or", base_tab, check_val1, ...)
end
--other function: Find correct element in table(match all)
function rsof.Table_List_AND(base_tab, check_val1, ...)
	return rsof.Table_List_Base("and", base_tab, check_val1, ...)
end
--other function: Find Intersection element in 2 table2
function rsof.Table_Intersection(tab1,  ...)
	local intersection_list = { }
	local tab_list = { ... }
	for _,  ele1 in pairs(tab1) do 
		table.insert(intersection_list,  ele1)
		for _,  table2 in pairs(tab_list) do
			if not rsof.Table_List(table2,  ele1) then 
				table.remove(intersection_list)
				break 
			end
		end
	end
	return #intersection_list > 0,  intersection_list
end
--other function: Clone Table
function rsof.Table_Clone(tab)
	local tab2 = { }
	for idx, val in pairs(tab) do
		tab2[idx] = val
	end
	return tab2
end
--other function: Mix Table
--error at "nil" value !!!!!!!!!
--error at no number key !!!!!!!!!
function rsof.Table_Mix(tab1, ...)
	local res_list = { }
	local list = { tab1, ... }
	local len = 0
	for _, tab in pairs(list) do
		for _, val in pairs(tab) do 
			--table.insert(res_list, val)
			
			len = len + 1
			res_list[len] = val
		end
	end
	return res_list
end
--other function: check a value is true or false
function rsof.Check_Boolean(check_val, bool_val)
	if type(bool_val) == "nil" or bool_val == true then return 
		type(check_val) == "boolean" and check_val == true
	else
		return type(check_val) == "boolean" and check_val == false
	end
end 
-------------------"Hape"---------------------
rsof.Escape_Old_Functions()
--directly enable will cause bugs,  but i am lazy to find what cards i have used this function
--rssf.EnableSpecialProcedure()
rsof.Get_Cate_Hint_Op_List()
