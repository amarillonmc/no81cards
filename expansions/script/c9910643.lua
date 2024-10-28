--始祖岭岩龙皇
function c9910643.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,c9910643.ovfilter,aux.Stringid(9910643,0),3,c9910643.xyzop)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910643,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9910643.descon)
	e1:SetTarget(c9910643.destg)
	e1:SetOperation(c9910643.desop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910643.negcon)
	e2:SetCost(c9910643.negcost)
	e2:SetTarget(aux.nbtg)
	e2:SetOperation(c9910643.negop)
	c:RegisterEffect(e2)
end
function c9910643.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5957)
end
function c9910643.xyzop(e,tp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_COST)
end
function c9910643.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9910643.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*1200)
end
function c9910643.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*1200,REASON_EFFECT)
	end
end
function c9910643.cfilter1(c)
	return c:IsFaceupEx() and c:IsType(TYPE_TUNER) and c:IsLevel(3)
end
function c9910643.cfilter2(c)
	return c:IsFaceupEx() and c:IsCode(9911675)
end
function c9910643.negcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local b1=Duel.IsExistingMatchingCard(c9910643.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsEnvironment(9911675,tp)
		or Duel.IsExistingMatchingCard(c9910643.cfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
	return Duel.IsChainNegatable(ev) and (b1 or b2)
end
function c9910643.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_COST)
end
function c9910643.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
