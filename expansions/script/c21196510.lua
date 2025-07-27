--超机龙兵 暴风骏足
local m=21196510
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not cm._ then
		cm._=true
		cm_tohand_limit_botton=true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetRange(0xff)
		e0:SetCountLimit(1)
		e0:SetOperation(cm.op0)
		c:RegisterEffect(e0)
		cm_tohand_limit = {}
		cm_resolve_table = {}
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_ADJUST)
		ce1:SetCondition(cm.limit_hack_con)
		ce1:SetOperation(cm.limit_hack_op)
		Duel.RegisterEffect(ce1,1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
cm.record_doesnot_contain = 
	function(table,effect)
		for _, value in pairs(table) do
			if value == effect then
				return false
			end
		end
		return true
	end
cm.check_or_add_new_limit = 
	function(add_or_not)
		local is_new_limit = false
		for tp = 0,1 do
			if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_TO_HAND) then
				local limit_table = {Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_TO_HAND)}
				for _, limit_effect in ipairs(limit_table) do
					if cm.record_doesnot_contain(cm_tohand_limit,limit_effect) then
						if add_or_not then
							table.insert(cm_tohand_limit,limit_effect)
							table.insert(cm_resolve_table,limit_effect)
						end
						is_new_limit = true
					end
				end
			end
		end
		local rg = Duel.GetFieldGroup(0,0xff,0xff)
		for tc in aux.Next(rg) do 
			if tc:IsHasEffect(tp,EFFECT_CANNOT_TO_HAND) then
				local limit_table = {tc:IsHasEffect(EFFECT_CANNOT_TO_HAND)}
				for _, limit_effect in ipairs(limit_table) do
					if cm.record_doesnot_contain(cm_tohand_limit,limit_effect) then
						if add_or_not then
							table.insert(cm_tohand_limit,limit_effect)
							table.insert(cm_resolve_table,limit_effect)
						end
						is_new_limit = true
					end
				end
			end
		end
		return is_new_limit
	end
cm.limit_hack_con = 
	function(effect)
		return cm.check_or_add_new_limit(false)
	end
cm.limit_hack_op = 
	function(effect)
		cm_resolve_table = {}
		if cm.check_or_add_new_limit(true) then
			for _,v in ipairs(cm_resolve_table) do
				local con =	v:GetCondition() or aux.TRUE
				local tg  = v:GetTarget()	 or aux.TRUE		
				local val = v:GetValue() 	 or aux.TRUE
				if v:IsHasType(EFFECT_TYPE_SINGLE) then
					v:SetCondition
					(
						function(ne,...)
							return cm_tohand_limit_botton and con(ne,...)
						end
					)
				else
					v:SetTarget
					(
						function(ne,nc,...)
							return cm_tohand_limit_botton and tg(ne,nc,...)
						end
					)
					v:SetValue
					(
						function(ne,nte,ntp,...)
							return cm_tohand_limit_botton and val(ne,nte,ntp,...)
						end
					)
				end
			end
		end
	end
function cm.q(c)
	return c:GetOriginalCode()==m
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	for p = 0,1 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(cm.op0_con)
		e1:SetOperation(cm.op0_op)
		Duel.RegisterEffect(e1,p)
	end
	e:Reset()
end
function cm.op0_con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(cm.q,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY,0,1,nil)
end
function cm.op0_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0)) then
		local g=Duel.SelectMatchingCard(tp,cm.q,tp,LOCATION_DECK+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY,0,1,99,nil)
		cm_tohand_limit_botton=false
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		cm_tohand_limit_botton=true
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.w(c)
	return c:IsSetCard(0x6919)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW) and Duel.IsExistingMatchingCard(cm.w,tp,LOCATION_EXTRA,0,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(cm.op_val1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetValue(cm.op_val1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.Hint(3,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,cm.w,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		local te=tc.special
		local be=Effect.CreateEffect(c)
		be:SetDescription(aux.Stringid(m,1))
		be:SetType(EFFECT_TYPE_FIELD)
		be:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		be:SetCode(EFFECT_SPSUMMON_PROC)
		be:SetRange(LOCATION_EXTRA+LOCATION_HAND)
		be:SetCondition(te:GetCondition())
		be:SetTarget(te:GetTarget())
		be:SetOperation(te:GetOperation())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetTarget(cm.op_tg1)
		e1:SetLabelObject(be)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetTargetRange(0,LOCATION_EXTRA)
		e2:SetTarget(cm.op_tg2)
		e2:SetLabelObject(be)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)	
	end	
end
function cm.op_val1(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x6919) and bit.band(loc,LOCATION_ONFIELD)>0
end
function cm.op_tg1(e,c)
	return c:IsCode(m)
end
function cm.op_tg2(e,c)
	return c:IsFacedown()
end
function cm.e(c)
	return c:IsSpecialSummonable() and c:IsFacedown()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.e,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.e,tp,0,LOCATION_EXTRA,nil)
	if #g<=0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()	
	if tc then
	Duel.SpecialSummonRule(1-tp,tc,0)
	end
end