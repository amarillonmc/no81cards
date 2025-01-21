--甜蜜萝酒
function c33700160.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c33700160.target)
	e1:SetOperation(c33700160.activate)
	c:RegisterEffect(e1)
end
function c33700160.filter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c33700160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700160.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c33700160.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg,def=g:GetMaxGroup(Card.GetDefense)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,#tg*def)
end
function c33700160.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33700160.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetDefense)
		Duel.Destroy(tg,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		local rec=dg:GetSum(Card.GetDefense)
		if rec>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,rec,REASON_EFFECT)
			Duel.Recover(1-tp,rec,REASON_EFFECT)
		end
	end
end