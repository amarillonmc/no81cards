--珊海环的大魔导士
function c67200509.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c67200509.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x675),1,1)
	c:EnableReviveLimit()   
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200509,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c67200509.discon)
	e1:SetTarget(c67200509.distg)
	e1:SetOperation(c67200509.disop)
	c:RegisterEffect(e1)   
end
--
function c67200509.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x675)
end
--
function c67200509.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c67200509.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c67200509.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(eg,tp,REASON_EFFECT)
end

