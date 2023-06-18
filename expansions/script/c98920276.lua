--解码语者·炽热弹丸
function c98920276.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),3)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98920276.imcon)
	e1:SetValue(c98920276.efilter)
	c:RegisterEffect(e1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98920276.atkval)
	c:RegisterEffect(e1)
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920276,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c98920276.atcon)
	e1:SetOperation(c98920276.atop)
	c:RegisterEffect(e1)
end
function c98920276.cfilter(c)
	return c:IsFacedown() or not c:IsType(TYPE_LINK)
end
function c98920276.imcon(e)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	return g:GetCount()>0 and not g:IsExists(c98920276.cfilter,1,nil)
end
function c98920276.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c98920276.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c98920276.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local lg=e:GetHandler():GetLinkedGroup():Filter(c98920276.atkfilter,nil)
	return lg:GetSum(Card.GetLink)*300
end
function c98920276.atcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsChainAttackable()
end
function c98920276.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end