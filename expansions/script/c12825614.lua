--铳影-紧急行动
function c12825614.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c12825614.condition)
	e1:SetTarget(c12825614.target)
	e1:SetOperation(c12825614.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1109)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12825614)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c12825614.thtg)
	e2:SetOperation(c12825614.thop)
	c:RegisterEffect(e2)
end
function c12825614.cfilter(c)
	return c:IsFacedown() or not c:IsType(TYPE_XYZ)
end
function c12825614.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12825614.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12825614.filter(c,e,tp)
	return c:IsSetCard(0x4a71) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c12825614.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12825614.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12825614.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12825614.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c12825614.thfilter(c)
	return c:IsSetCard(0x4a71) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c12825614.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12825614.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
end
function c12825614.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12825614.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0  then
			Duel.ConfirmCards(1-tp,g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(g1,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			end
		end
	end
end