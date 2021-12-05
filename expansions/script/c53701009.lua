--惧 轮  梦 魇
function c53701009.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x3530),2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(53701009)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c53701009.tgtg)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c53701009.rmcon)
	e2:SetOperation(c53701009.rmop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c53701009.value)
	c:RegisterEffect(e3)
end
function c53701009.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c53701009.cfilter(c,lg,tp)
	return not c:IsType(TYPE_LINK) and not lg:IsContains(c)
end
function c53701009.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c53701009.cfilter,1,nil,lg,tp)
end
function c53701009.filter2(c)
	return c:GetSequence()<5 and c:IsFaceup() and c:IsSetCard(0x3530)
end
function c53701009.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,53701009)
	local c=e:GetHandler()
	local ag=Duel.GetMatchingGroup(c53701009.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local lg=e:GetHandler():GetLinkedGroup()
	ag:Sub(lg)
	local op=0
	if #ag>0 then op=Duel.SelectOption(tp,aux.Stringid(53701009,1),aux.Stringid(53701009,2))
	else op=Duel.SelectOption(tp,aux.Stringid(53701009,1)) end
	if op==0 then Duel.SendtoGrave(c,REASON_EFFECT)
	else Duel.Destroy(ag,REASON_EFFECT) end
end
function c53701009.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),0,LOCATION_GRAVE,nil,TYPE_MONSTER)*200
end
