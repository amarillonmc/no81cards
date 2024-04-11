if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.Excavated_Check(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e)return e:GetHandler():GetFlagEffect(53766099)>0 end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x5534) and c:IsCanAddCounter(0x153f,2)) then return false end
	local te=c.self_destroy_effect
	if not te or (not c:IsLocation(te:GetRange()) and te:GetType()&EFFECT_TYPE_SINGLE==0) then return false end
	local re={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	local flag=true
	for _,v in ipairs(re) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,tp) then flag=false end
	end
	local ae={Duel.IsPlayerAffectedByEffect(tp,EFFECT_ACTIVATE_COST)}
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,tp) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,tp) then flag=false end
		end
	end
	local tg=te:GetTarget()
	return flag and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) and not c:IsHasEffect(EFFECT_CANNOT_TRIGGER) and not c:IsForbidden()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.efffilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc=Duel.SelectMatchingCard(tp,s.efffilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	local te=tc.self_destroy_effect
	local e1=te:Clone()
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.TRUE)
	e1:SetCost(aux.TRUE)
	e1:SetTarget(s.sdtg(Duel.GetCurrentChain()))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	tc:RegisterEffect(e1,true)
	e:SetLabelObject(tc)
	tc:CreateEffectRelation(e)
end
function s.sdtg(chain)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local c=e:GetHandler()
				local te=c.self_destroy_effect
				local tg=te:GetTarget()
				if chkc then return ev==chain and tg(te,tp,eg,ep,ev,re,r,rp,chk,chkc) end
				if chk==0 then
					e:SetCostCheck(false)
					return not tg or tg(te,tp,eg,ep,ev,re,r,rp,chk)
				end
				if tg then
					e:SetCostCheck(false)
					tg(te,tp,eg,ep,ev,re,r,rp,chk)
				end
			end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetHandler():GetFlagEffect(53766099)>0 then e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN) else e:SetProperty(0) end
		return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)==0 then return end
		local tc=e:GetLabelObject()
		if not tc or not tc:IsRelateToEffect(e) then return end
		tc:AddCounter(0x153f,2)
		if tc:GetFlagEffect(53766000)==0 and not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetTarget(s.reptg)
			e1:SetOperation(s.repop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(53766000,RESET_EVENT+RESETS_STANDARD,0,0)
		end
	end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,0x153f,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0))
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x153f,1,REASON_EFFECT)
end
function s.spfilter(c,e,tp)
	return c:IsAttack(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsCanAddCounter(tp,0x153f,1,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		tc:AddCounter(0x153f,1)
		if tc:GetFlagEffect(53766000)==0 and not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetTarget(s.reptg)
			e1:SetOperation(s.repop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(53766000,RESET_EVENT+RESETS_STANDARD,0,0)
		end
	end
end
