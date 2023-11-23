--绘色的永夏 羽未
function c9910972.initial_effect(c)
	c:EnableCounterPermit(0x6954)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit()
	--synchro success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910972.addcc)
	e1:SetTarget(c9910972.addct)
	e1:SetOperation(c9910972.addc)
	c:RegisterEffect(e1)
	--to hand or grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910972,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c9910972.cost)
	e2:SetCondition(c9910972.thcon)
	e2:SetTarget(c9910972.thtg)
	e2:SetOperation(c9910972.thop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910972,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_MOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c9910972.cost)
	e3:SetCondition(c9910972.tdcon)
	e3:SetTarget(c9910972.tdtg)
	e3:SetOperation(c9910972.tdop)
	c:RegisterEffect(e3)
end
function c9910972.addcc(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9910972.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x6954)
end
function c9910972.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x6954,3)
	end
end
function c9910972.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x6954,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x6954,1,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910972.cfilter1(c)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_GRAVE) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c9910972.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910972.cfilter1,1,nil)
end
function c9910972.thfilter(c)
	return c:IsSetCard(0x5954) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9910972.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910972.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9910972.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9910972.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function c9910972.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA)
end
function c9910972.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c9910972.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
