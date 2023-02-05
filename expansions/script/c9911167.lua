--溯雪回响·冬马和纱
function c9911167.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c9911167.mfilter,nil,2,2,c9911167.ovfilter,aux.Stringid(9911167,0),c9911167.xyzop)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9911167.imcon)
	e1:SetValue(c9911167.efilter)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetCondition(c9911167.imcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021220,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_DETACH_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c9911167.destg)
	e3:SetOperation(c9911167.desop)
	c:RegisterEffect(e3)
end
function c9911167.mfilter(c)
	return c:IsRank(4)
end
function c9911167.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3958) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost()
end
function c9911167.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3958) and c:IsType(TYPE_XYZ)
end
function c9911167.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911167.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9911167.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9911167.imcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x3958)
end
function c9911167.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c9911167.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c9911167.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.Destroy(g,REASON_EFFECT)
end
