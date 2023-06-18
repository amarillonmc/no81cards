--量子驱动 α搜救机
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = Scl.SetID(10130001)
if Scl_Quantadrive then return end
Scl_Quantadrive = {}
Scl_Quantadrive.Summon = 0
Scl_Quantadrive.Summon_Limit = {}
Scl_Quantadrive.Summon_Buff = {}
function Scl_Quantadrive.FilpEffect(c, cs, cid, desc, ctgy, tg, op)
	local e1 = Scl.CreateFlipMandatoryEffect(c, desc, nil, ctgy .. ",ChangePosition,Return2Hand", nil, nil, nil, tg, s.filp_op(op))
	cs.Scl_Quantadrive_Filp_Effect = e1
	return e1
end
function s.filp_op(op) 
	return function(e,tp,...)
		local _, c = Scl.GetActivateCard(true)
		if c and not c:IsStatus(STATUS_BATTLE_DESTROYED) then 
			local turn_set = c:IsOnField() and c:IsCanTurnSet() and c:GetFlagEffect(id) == 0
			local spsum_set = not c:IsOnField() and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
			local st_set = not c:IsOnField() and c:IsSSetable()
			local b1 = turn_set or spsum_set or st_set
			local b2 = not c:IsLocation(LOCATION_HAND) and c:IsAbleToHand()
			if b1 or b2 then
				local op = Scl.SelectOption(tp, b1, {id, 1}, b2, {id, 2}, true, {id, 0})
				if op == 1 then
					if turn_set then
						Duel.ChangePosition(c, POS_FACEDOWN_DEFENSE)
						c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
					elseif spsum_set then
						if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) > 0 then
							Duel.ConfirmCards(1-tp, c)
						end
					else
						Duel.SSet(tp, c)
					end
				elseif op == 2 then
					Scl.Send2Hand(c, nil, REASON_EFFECT, true)
				end
			end
		end
		op(e,tp,...)
	end
end
function Scl_Quantadrive.NormalSummonEffect(c, cs, cid, event)
	local e1 = Scl.CreateFieldTriggerOptionalEffect(c, event, "NormalSummon/Set", {1, cid}, "NormalSummon/Set", "Delay,DamageStep","Hand",s.normal_summon_con, { "Cost", "Reveal", aux.NOT(Card.IsPublic) }, {"~Target", "NormalSummon/Set", s.normal_summon_filter, "Hand,MonsterZone"}, s.normal_summon_op)
	return e1
end
function s.normal_summon_cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function s.normal_summon_con(e,tp,eg)
	return eg:IsExists(s.normal_summon_cfilter,1,nil,tp)
end
function s.normal_summon_filter(c)
	return c:IsSetCard(0xa336) and c:IsType(TYPE_MONSTER) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function s.normal_summon_op(e,tp)
	Scl_Quantadrive.Summon = Scl_Quantadrive.Summon + 1
end
function s.shuffle_filter(c)
	return c:IsFacedown() and c:GetSequence() < 5
end
function Scl_Quantadrive.Shuffle(tp)
	local g = Duel.GetMatchingGroup(s.shuffle_filter,tp,LOCATION_MZONE,0,nil)
	if #g > 0 then
		Duel.ShuffleSetCard(g)
	end
end
function Scl_Quantadrive.CreateNerveContact(cs, ...)
	cs.Scl_Quantadrive_Effects = { ... }
	for _, e in pairs({ ... }) do
		local op = e:GetOperation() or aux.TRUE
		e:SetOperation(s.nerve_op(op))
	end
end
function s.nerve_filter(c,e,tp,eg,ep,ev,re,r,rp)
	local code = c:GetOriginalCode()
	if not c:IsSetCard(0xa336) or Duel.GetFlagEffect(tp, code) ~= 0 or code == e:GetHandler():GetOriginalCode()  then return false end
	local eft_arr = c.Scl_Quantadrive_Effects
	if not eft_arr then return false end
	for _, ae in pairs(eft_arr) do
		local tg = ae:GetTarget() or aux.TRUE
		if tg(e,tp,eg,ep,ev,re,r,rp,0) then
			return true
		end
	end
	return false
end
function s.summon_op(e,tp,eg,ep,ev,re,r,rp)
	local ct = Scl_Quantadrive.Summon
	--local ect = e:GetLabel() or 0
	local tct = 1
	local tc = e:GetLabelObject()
	if ct > 1 then
		local sum_buff = Scl_Quantadrive.Summon_Buff[tct] or aux.TRUE
		local hc = Scl_Quantadrive.Summon_Limit[tct]
		if not hc then
			_, hc = Scl.SelectCards("NormalSummon/Set",tp,s.normal_summon_filter,tp,"Hand,MonsterZone",0,1,1,nil)
		end
		if hc then
			local minct, maxct = hc:GetTributeRequirement()
			if minct > 0 and Duel.CheckTribute(hc, minct) then
				local g = Duel.SelectTribute(tp, hc, minct, maxct)
				hc:SetMaterial(g)
				Duel.Release(g, REASON_MATERIAL + REASON_SUMMON)
			end
			local pos = Duel.SelectPosition(tp, hc, POS_FACEUP_ATTACK + POS_FACEDOWN_DEFENSE)
			sum_buff(hc, e,tp,eg,ep,ev,re,r,rp)
			hc:RegisterFlagEffect(id + 100, RESETS_WITHOUT_TO_FIELD_SCL, 0, 1, hc:GetFieldID())
			Duel.MoveToField(hc, tp, tp, LOCATION_MZONE, pos, true)
			Debug.PreSummon(hc, minct > 0 and SUMMON_TYPE_ADVANCE  or SUMMON_TYPE_NORMAL, LOCATION_HAND)
			hc:SetStatus(STATUS_SUMMON_TURN, true)
			if hc:IsFaceup() then
				Duel.RaiseEvent(hc, EVENT_SUMMON_SUCCESS, nil, 0, tp, tp, 0)
				Duel.RaiseSingleEvent(hc, EVENT_SUMMON_SUCCESS, nil, 0, tp, tp, 0)
			else
				Duel.RaiseEvent(hc, EVENT_MSET, nil, 0, tp, tp, 0)
				Duel.RaiseSingleEvent(hc, EVENT_MSET, nil, 0, tp, tp, 0)
			end
		end
		tct = tct + 1
	end
	if ct > 0 then
		local hc = Scl_Quantadrive.Summon_Limit[tct]
		if not hc then
			_, hc = Scl.SelectCards("NormalSummon/Set",tp,s.normal_summon_filter,tp,"Hand,MonsterZone",0,1,1,nil)
		end
		local sum_buff = Scl_Quantadrive.Summon_Buff[tct] or aux.TRUE
		sum_buff(hc, e,tp,eg,ep,ev,re,r,rp)
		if hc then
			hc:RegisterFlagEffect(id + 100, RESETS_WITHOUT_TO_FIELD_SCL, 0, 1, hc:GetFieldID())
			Scl.NormalSummon(hc, tp, true, nil)
		end
	end
	Scl_Quantadrive.Summon = 0
	Scl_Quantadrive.Summon_Limit = { }
	Scl_Quantadrive.Summon_Buff = { }
end
function s.nerve_op(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		if Scl_Quantadrive.NerveContact_Forbbiden or Scl_Quantadrive.NerveContact_Forbbiden2 then 
			s.summon_op(e,tp,eg,ep,ev,re,r,rp)
			return 
		end  
		Scl_Quantadrive.NerveContact_Forbbiden = true
		local arr = { Duel.IsPlayerAffectedByEffect(tp, 10130014) }
		if #arr == 0 then 
			Scl_Quantadrive.NerveContact_Forbbiden = false
			s.summon_op(e,tp,eg,ep,ev,re,r,rp)
			return 
		end
		local ae = arr[1]
		local ac = ae:GetHandler()
		if not ae:CheckCountLimit(tp) or ac:GetFlagEffect(1) == 0 then 
			Scl_Quantadrive.NerveContact_Forbbiden = false
			s.summon_op(e,tp,eg,ep,ev,re,r,rp)
			return 
		end
		Scl.Mandatory_Effect_Target_Check = true
		local g = Duel.GetMatchingGroup(s.nerve_filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,eg,ep,ev,re,r,rp)
		Scl.Mandatory_Effect_Target_Check = false
		if #g == 0 then 
			Scl_Quantadrive.NerveContact_Forbbiden = false
			s.summon_op(e,tp,eg,ep,ev,re,r,rp)
			return 
		end
		if not Duel.SelectEffectYesNo(tp, ac, aux.Stringid(10130014, 0)) then 
			Scl_Quantadrive.NerveContact_Forbbiden = false
			s.summon_op(e,tp,eg,ep,ev,re,r,rp)
			return 
		end
		Scl.HintCard(10130014)
		local ct,og,tc = Scl.SelectAndOperateCardsFromGroup("Look",g,tp,aux.TRUE,1,1,nil)()
		if not tc then 
			Scl_Quantadrive.NerveContact_Forbbiden = false
			s.summon_op(e,tp,eg,ep,ev,re,r,rp)
			return 
		end
		Duel.RegisterFlagEffect(tp,tc:GetOriginalCode(),RESET_EP_SCL,0,1)
		ae:UseCountLimit(tp, 1)
		local eft_arr = tc.Scl_Quantadrive_Effects
		local desc_arr = { }
		local eft_arr2 = { }
		Scl.Mandatory_Effect_Target_Check = true
		for _, ae in pairs(eft_arr) do
			local tg = ae:GetTarget() or aux.TRUE
			if tg(e,tp,eg,ep,ev,re,r,rp,0) then
				table.insert(desc_arr, ae:GetDescription())
				table.insert(eft_arr2, ae)
			end
		end
		Scl.Mandatory_Effect_Target_Check = false
		Scl.HintSelect(tp, {10130014, 1})
		local opt = Duel.SelectOption(tp, table.unpack(desc_arr)) + 1
		local exop = eft_arr2[opt]:GetOperation() or aux.TRUE 
		exop(e,tp,eg,ep,ev,re,r,rp)
		Scl_Quantadrive.NerveContact_Forbbiden = false
		--s.summon_op(e,tp,eg,ep,ev,re,r,rp)
	end
end
-------------------------------
if s then
-------------------------------
function s.initial_effect(c)
	local e1 = Scl_Quantadrive.FilpEffect(c, s, id, "SetCard", "SetCard", { "~Target", "SetCard", s.setfilter, "GY" }, s.setop)
	local e2 = Scl_Quantadrive.NormalSummonEffect(c, s, id, "BeFlippedFaceup")
	Scl_Quantadrive.CreateNerveContact(s, e1, e2)
end
function s.setfilter(c,e,tp)
	if c:IsType(TYPE_MONSTER) then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		return c:IsSSetable()
	end
end
function s.setop(e,tp)
	Scl.SelectAndOperateCards("SetCard",tp, aux.NecroValleyFilter(s.setfilter), tp, "GY", 0, 1, 1, nil,e,tp)()
end
-------------------------------
end