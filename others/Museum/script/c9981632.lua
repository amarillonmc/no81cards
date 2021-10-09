--DD斩首
function c9981632.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9981632.target)
	e1:SetOperation(c9981632.activate)
	c:RegisterEffect(e1)
end
function c9981632.filter(c)
	return c:IsFaceup() 
end
function c9981632.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981632.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c9981632.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*500)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9981632.chlimit)
	end
end
function c9981632.chlimit(e,ep,tp)
	return tp==ep
end
function c9981632.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9981632.filter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
