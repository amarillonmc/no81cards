--破碎世界 核心危机
function c6160604.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,6160604)  
	e1:SetCondition(c6160604.condition)  
	e1:SetTarget(c6160604.rltg)  
	e1:SetOperation(c6160604.rlop)  
	c:RegisterEffect(e1)  
end
function c6160604.condition(e,tp,eg,ep,ev,re,r,rp) 
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetSummonLocation()==LOCATION_EXTRA and re:GetActivateLocation()==LOCATION_MZONE  
end
function c6160604.relfilter(c)  
	return c:IsReleasableByEffect()  
end  
function c6160604.rltg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,sg,sg:GetCount(),0,0)
end
function c6160604.rlop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Release(sg,REASON_EFFECT)
	local count=sg:GetCount()
		Duel.Draw(tp,count,REASON_EFFECT)
		Duel.Draw(1-tp,count,REASON_EFFECT)
end