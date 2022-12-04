--联合演唱会
function c22020870.initial_effect(c)
	aux.AddCodeList(c,22020850,22020130)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020870+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22020870.condition)
	e1:SetTarget(c22020870.target)
	e1:SetOperation(c22020870.activate)
	c:RegisterEffect(e1)
end
function c22020870.cfilter(c,code)
	return c:IsFaceup() and c:IsOriginalCodeRule(code)
end
function c22020870.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020870.cfilter,tp,LOCATION_MZONE,0,1,nil,22020130)
		and Duel.IsExistingMatchingCard(c22020870.cfilter,tp,LOCATION_MZONE,0,1,nil,22020875)
end
function c22020870.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c22020870.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(g,REASON_RULE)
end
