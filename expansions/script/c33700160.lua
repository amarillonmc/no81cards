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
	return c:IsFaceup() 
end
function c33700160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	 local g=Duel.GetMatchingGroup(c33700160.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg,def=g:GetMaxGroup(Card.GetDefense)
	if chk==0 then return tg:GetCount()>0  end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
   Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,0)
end
function c33700160.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33700160.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg,def=g:GetMaxGroup(Card.GetDefense)
		 Duel.Destroy(tg,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		local def=0
		while tc do
			local tdef=tc:GetDefense()
			if tdef>0 then def=def+tdef end
			tc=dg:GetNext()
		end
		if def>0 then
		  Duel.BreakEffect()
		  Duel.Recover(tp,def,REASON_EFFECT,true)
		  Duel.Recover(1-tp,def,REASON_EFFECT,true)
		  Duel.RDComplete()
end
end
end