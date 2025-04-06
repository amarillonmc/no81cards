--故国龙裔·天启神坛
function c88480135.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c88480135.lcheck)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88480135,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(c88480135.cost)
	e1:SetOperation(c88480135.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88480135,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88480135)
	e2:SetCondition(c88480135.discon)
	e2:SetCost(c88480135.discost)
	e2:SetTarget(c88480135.distg)
	e2:SetOperation(c88480135.disop)
	c:RegisterEffect(e2)
end
function c88480135.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x410)
end
function c88480135.costfilter(c)
	return c:IsSetCard(0x410) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceupEx() and c:IsAbleToGraveAsCost()
end
function c88480135.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88480135.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88480135.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c88480135.activate(e,tp,eg,ep,ev,re,r,rp)
	--damage conversion
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c88480135.rev)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88480135.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0
end
function c88480135.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c88480135.cgfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(0x1) and c:IsSetCard(0x410)
end
function c88480135.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88480135.cgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88480135.cgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c88480135.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c88480135.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end