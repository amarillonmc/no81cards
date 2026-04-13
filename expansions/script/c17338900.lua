local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	c:EnableReviveLimit()	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(s.imcon)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(s.copycost)
	e2:SetTarget(s.copytg)
	e2:SetOperation(s.copyop)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.sccon)
	e3:SetTarget(s.sctg)
	e3:SetOperation(s.scop)
	c:RegisterEffect(e3)
	if not c17338900.global_check then
		c17338900.global_check=true
		c17338900.effect_list={}
	end
end
function s.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4) or c:IsRank(4)
end
function s.imcon(e) return e:GetHandler():GetOverlayCount()>0 end
function s.efilter(e,te) return te:IsActiveType(TYPE_TRAP) end
function s.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17338900.efilter(e)
	local ct=#c17338900.effect_list
	if (e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_SPSUMMON_SUCCESS) and e:IsActivated() then c17338900.effect_list[ct+1]=e end
	return false
end
function c17338900.tlfilter(te,tp)
	return not (te:GetHandler():IsOriginalCodeRule(91812341) and te:GetCode()==EVENT_SUMMON_SUCCESS and Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP))
end
function c17338900.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x108a) and c:IsLevel(4)) then return false end
	c17338900.effect_list={}
	c:IsOriginalEffectProperty(c17338900.efilter)
	for _,te in ipairs(c17338900.effect_list) do
		local tg=te:GetTarget()
		if (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) and c17338900.tlfilter(te,tp) then return true end
	end
	return false
end
function c17338900.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c17338900.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,c17338900.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
end
function c17338900.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() then return end
	c17338900.effect_list={}
	tc:IsOriginalEffectProperty(c17338900.efilter)
	local e_list={}
	for _,te in ipairs(c17338900.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end
	end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c17338900.effect_list={}
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scfilter(c) return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil) end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,tc,nil)
	end
end