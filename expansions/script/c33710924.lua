--劳改复制体
function c33710924.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33710924.tg)
	e1:SetOperation(c33710924.op)
	c:RegisterEffect(e1)
end
function c33710924.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=e:GetHandler():GetAttack()+e:GetHandler():GetDefense()
	if chk==0 then return num>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(num)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,num)
end
function c33710924.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end