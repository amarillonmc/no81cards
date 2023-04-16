--骑甲虫 重装长枪兵
function c98920560.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit() 
--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98920560.atkval)
	c:RegisterEffect(e1)
--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920560,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCost(c98920560.cost)
	e1:SetCondition(c98920560.atcon)
	e1:SetOperation(c98920560.atop)
	c:RegisterEffect(e1)
--destroy reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetOperation(c98920560.regop)
	c:RegisterEffect(e2)
--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c98920560.drtg)
	e3:SetOperation(c98920560.drop)
	c:RegisterEffect(e3)
end
function c98920560.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920560.atkfilter(c)
	return c:IsSetCard(0x170)
end
function c98920560.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsSetCard,nil,0x170)
	return g:GetCount()*1000
end
function c98920560.atcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsChainAttackable()
end
function c98920560.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c98920560.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	local ct=c:GetFlagEffectLabel(98920560)
	if ct then
		c:SetFlagEffectLabel(98920560,ct+1)
	else
		c:RegisterFlagEffect(98920560,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c98920560.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffectLabel(98920560)
	if chk==0 then return ct and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c98920560.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffectLabel(98920560)
	Duel.Draw(tp,ct,REASON_EFFECT)
end