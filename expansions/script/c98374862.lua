--98374862
function c98374862.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98374862+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98374862.target)
	e1:SetOperation(c98374862.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98374862)
	e2:SetCondition(c98374862.thcon)
	e2:SetTarget(c98374862.thtg)
	e2:SetOperation(c98374862.thop)
	c:RegisterEffect(e2)
end
function c98374862.tefilter(c)
	return c:IsSetCard(0x3af2) and c:IsType(TYPE_PENDULUM)
end
function c98374862.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98374862.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c98374862.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98374862,3))
	local g=Duel.SelectMatchingCard(tp,c98374862.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
function c98374862.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c98374862.thfilter(c,chk)
	return c:IsSetCard(0x3af2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c98374862.chkfilter(c)
	return c:IsSetCard(0x3af2) and c:IsFaceup() and (not c:IsLocation(LOCATION_MZONE) or c:GetSequence()>=5)
end
function c98374862.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98374862.thfilter,tp,LOCATION_DECK,0,1,nil,0) and Duel.IsExistingMatchingCard(c98374862.chkfilter,tp,LOCATION_PZONE+LOCATION_MZONE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98374862.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c98374862.chkfilter,tp,LOCATION_PZONE+LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(c98374862.thfilter,tp,LOCATION_DECK,0,nil,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	if tg:GetCount()==0 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
