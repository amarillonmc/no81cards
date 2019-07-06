--甜蜜间者
function c33700157.initial_effect(c)
	 --lp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700157.cost)
	e1:SetCode(EVENT_DRAW)
	e1:SetCountLimit(1,33700157)
	e1:SetCondition(c33700157.con)
	e1:SetTarget(c33700157.tg)
	e1:SetOperation(c33700157.op)
	c:RegisterEffect(e1)
end
function c33700157.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function c33700157.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c33700157.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c33700157.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
   if Duel.IsChainDisablable(0) 
	and Duel.CheckLPCost(1-tp,500) and Duel.SelectYesNo(1-tp,aux.Stringid(33700157,0)) then
	Duel.PayLPCost(1-tp,500)
	Duel.NegateEffect(0)
   else 
   Duel.Recover(p,d,REASON_EFFECT)
end
end