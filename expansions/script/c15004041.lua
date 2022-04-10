local m=15004041
local cm=_G["c"..m]
cm.name="异再神凭依"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x5f3f) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	--[[
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetDescription(aux.Stringid(m,1))
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CUSTOM+15002041)
	e0:SetRange(0xff)
	e0:SetCountLimit(1)
	e0:SetCondition(cm.negcon)
	e0:SetOperation(cm.negop)
	e0:SetReset(RESET_CHAIN)
	e:GetHandler():RegisterEffect(e0)
	--]]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()~=0 then
		if Duel.SpecialSummonStep(g:GetFirst(),SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) then
			--Duel.RaiseEvent(g:GetFirst(),EVENT_CUSTOM+15002041,e,r,rp,ep,ev)
			local ag=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,g:GetFirst())
			local b1=ag:CheckWithSumGreater(Card.GetLevel,g:GetFirst():GetLevel())
			local b2=true
			local op=1
			if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
			elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,2))
			else op=Duel.SelectOption(tp,aux.Stringid(m,3))+1 end
			if op==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local sg=ag:SelectWithSumGreater(tp,Card.GetLevel,g:GetFirst():GetLevel())
				Duel.Release(sg,REASON_EFFECT)
				Duel.SpecialSummonComplete()
			end
			if op==1 then
				Duel.NegateSummon(g)
				Duel.RaiseEvent(g,EVENT_SPSUMMON_NEGATED,e,0,tp,0,0)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ae=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	return re==ae
end
function cm.sprfilter(c)
	return c:IsReleasable() and c:IsLevelAbove(1)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,eg:GetFirst())
	local b1=g:CheckWithSumGreater(Card.GetLevel,eg:GetFirst():GetLevel())
	local b2=true
	local op=1
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,2))
	else op=Duel.SelectOption(tp,aux.Stringid(m,3))+1 end
	if op==0 then
		local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,eg:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:SelectWithSumGreater(tp,Card.GetLevel,eg:GetFirst():GetLevel())
		Duel.Release(sg,REASON_EFFECT)
	end
	if op==1 then
		Duel.NegateSummon(eg)
		Duel.RaiseEvent(eg,EVENT_SPSUMMON_NEGATED,e,0,tp,0,0)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end