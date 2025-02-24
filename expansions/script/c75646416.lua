--某条街的白日梦 鹿乃
function c75646416.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c75646416.disop)
	c:RegisterEffect(e2)
	--TOGRAVE
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c75646416.cost)
	e3:SetTarget(c75646416.target)
	e3:SetOperation(c75646416.operation)
	c:RegisterEffect(e3)
end
function c75646416.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_GRAVE or loc==LOCATION_EXTRA then
		Duel.NegateEffect(ev)
	end
end
function c75646416.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil)==1 end
	if g:GetFirst():IsSetCard(0x32c4) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646416.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c75646416.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c75646416.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646416.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c75646416.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c75646416.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
	if e:GetLabel()==1 and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end