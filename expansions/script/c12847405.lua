--这好吗魔女
local s,id,o=GetID()
function s.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(s.descost)
	e1:SetCondition(s.descon1)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.descon2)
	c:RegisterEffect(e2)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)<3
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=3
end
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bool=true	
	while bool do
		local tc=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		bool=tc and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.Draw(1-tp,1,REASON_EFFECT)>0 and Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(id,1))
	end
end