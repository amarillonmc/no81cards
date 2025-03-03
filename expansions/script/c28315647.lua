--闪耀的黑彗星 郁田阳希
function c28315647.initial_effect(c)
	--CoMETIK spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28315647,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,28315647)
	e1:SetCondition(c28315647.spcon)
	e1:SetTarget(c28315647.sptg)
	e1:SetOperation(c28315647.spop)
	c:RegisterEffect(e1)
	--CoMETIK to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28315647,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38315647)
	e2:SetTarget(c28315647.tdtg)
	e2:SetOperation(c28315647.tdop)
	c:RegisterEffect(e2)
	--CoMETIK search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,48315647)
	e3:SetCondition(c28315647.thcon)
	e3:SetCost(c28315647.thcost)
	e3:SetTarget(c28315647.thtg)
	e3:SetOperation(c28315647.thop)
	c:RegisterEffect(e3)
end
function c28315647.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (re and re:GetHandler():IsSetCard(0x283)) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c28315647.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28315647.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_LEVEL)
		e0:SetValue(1)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e0)
		Duel.SpecialSummonComplete()
	end
end
function c28315647.tdfilter(c)
	return c:IsSetCard(0x283) and c:IsFaceup() and c:IsAbleToDeck()
end
function c28315647.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c28315647.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28315647.tdfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c28315647.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c28315647.lvfilter(c)
	return c:IsSetCard(0x284) and (c:IsLevelAbove(1) or c:IsRankAbove(1)) and c:IsFaceup()
end
function c28315647.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c28315647.lvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28315647,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,c28315647.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(tg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tg:GetFirst():RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RANK)
		tg:GetFirst():RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tg:GetFirst():RegisterEffect(e3)
		tg:GetFirst():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28315647,3))
	end
end
function c28315647.cfilter(c)
	return c:IsSetCard(0x283) and c:IsFaceup()
end
function c28315647.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28315647.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c28315647.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c28315647.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c28315647.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315647.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28315647.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c28315647.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
