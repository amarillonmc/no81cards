--溯洄的轮回主
function c11771171.initial_effect(c)
	aux.AddCodeList(c,11771174)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11771171)
	e1:SetCost(c11771171.thcost)
	e1:SetTarget(c11771171.thtg)
	e1:SetOperation(c11771171.thop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771171,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11771171+1)
	e2:SetCondition(c11771171.tdcon)
	e2:SetTarget(c11771171.tdtg)
	e2:SetOperation(c11771171.tdop)
	c:RegisterEffect(e2)
	--ritual
	local e3=aux.AddRitualProcEqual2(c,c11771171.filter,LOCATION_HAND+LOCATION_GRAVE,nil,c11771171.filter,true)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,11771171+2)
	e3:SetCondition(c11771171.rlcon)
	e3:SetCost(aux.bfgcost)
	c:RegisterEffect(e3)
end
function c11771171.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c11771171.thfilter1(c)
	return c:IsCode(11771174) and c:IsAbleToHand()
end
function c11771171.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11771171.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11771171.rfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsReleasableByEffect()
end
function c11771171.thfilter2(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c11771171.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c11771171.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		if Duel.IsExistingMatchingCard(c11771171.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c11771171.thfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11771171,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g=Duel.SelectMatchingCard(tp,c11771171.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(g)
			if Duel.Release(g,REASON_EFFECT)==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=Duel.SelectMatchingCard(tp,c11771171.thfilter2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			if tc then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
function c11771171.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c11771171.tdfilter(c)
	return (c:IsFacedown() or c:IsNonAttribute(ATTRIBUTE_WATER)) and c:IsAbleToDeck()
end
function c11771171.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11771171.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c11771171.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_MZONE)
end
function c11771171.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11771171.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c11771171.filter(c,e,tp,chk)
	return c:IsAttribute(ATTRIBUTE_WATER) and c~=e:GetHandler()
end
