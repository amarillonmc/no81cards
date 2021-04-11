--致命炽燃
function c72411630.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72411630+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c72411630.condition)
	e1:SetTarget(c72411630.target)
	e1:SetOperation(c72411630.activate)
	c:RegisterEffect(e1)
end
function c72411630.confilter(c,tp)
	return c:IsSetCard(0x5729) and c:IsSetCard(0xc726) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c72411630.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c72411630.confilter,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c72411630.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,nil,0,0)
end
function c72411630.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c72411630.activate(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local dn=1
	if n<=20 then dn=2 end
	if n<=5 then dn=3 end
	local dam=Duel.Damage(1-tp,dn*1000,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c72411630.desfilter,tp,0,LOCATION_MZONE,nil,dam)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end

end