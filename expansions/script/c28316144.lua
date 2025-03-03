--闪耀的黑彗星 斑鸠路加
function c28316144.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--CoMETIK spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316144,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,28316144)
	e1:SetCondition(c28316144.spcon)
	e1:SetTarget(c28316144.sptg)
	e1:SetOperation(c28316144.spop)
	c:RegisterEffect(e1)
	--luka spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316144,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,28316144)
	e2:SetCondition(c28316144.lkcon)
	e2:SetTarget(c28316144.sptg)
	e2:SetOperation(c28316144.spop)
	--c:RegisterEffect(e2)
	--CoMETIK to deck-luka
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28316144,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,38316144)
	e3:SetTarget(c28316144.tdtg)
	e3:SetOperation(c28316144.tdop)
	c:RegisterEffect(e3)
	--CoMETIK search-luka
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(28316144,4))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,48316144)
	e4:SetCondition(c28316144.thcon)
	e4:SetCost(c28316144.thcost)
	e4:SetTarget(c28316144.thtg)
	e4:SetOperation(c28316144.thop)
	c:RegisterEffect(e4)
end
function c28316144.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x283) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c28316144.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0x283) and c:IsFaceup()
end
function c28316144.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28316144.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c28316144.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28316144.spop(e,tp,eg,ep,ev,re,r,rp)
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
function c28316144.tdfilter(c,e)
	return c:IsSetCard(0x283) and c:IsFaceup() and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c28316144.gcheck(g)
	return #g==1 and g:IsExists(Card.IsCode,1,nil,28335405) or #g==2
end
function c28316144.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c28316144.tdfilter,tp,LOCATION_REMOVED,0,nil,e)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and chkc:IsCode(28335405) end
	if chk==0 then return g:CheckSubGroup(c28316144.gcheck,1,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,c28316144.gcheck,false,1,2)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
end
function c28316144.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(28316144,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #rg>0 then
			Duel.HintSelection(rg)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c28316144.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c28316144.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==0 or (#g==1 and g:IsExists(c28316144.cfilter,1,nil))
end
function c28316144.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c28316144.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c28316144.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316144.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28316144.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c28316144.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
