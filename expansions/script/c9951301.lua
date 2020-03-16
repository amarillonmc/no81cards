--愚人节·克洛伊
function c9951301.initial_effect(c)
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951301,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9951301)
	e1:SetCost(c9951301.thcost)
	e1:SetTarget(c9951301.thtg)
	e1:SetOperation(c9951301.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951301,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,995130111)
	e3:SetTarget(c9951301.target)
	e3:SetOperation(c9951301.operation)
	c:RegisterEffect(e3)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951301.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951301.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951301,0))
end
function c9951301.dfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9951301.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c9951301.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c9951301.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c9951301.thfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c9951301.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951301.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951301.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951301.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9951301.cfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost() and c:IsLevelAbove(0)
end
function c9951301.spfilter(c,e,tp,ct)
	local rlv=c:GetLevel()-e:GetHandler():GetLevel()
	if rlv<1 then return false end
	local rg=Duel.GetMatchingGroup(c9951301.cfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xba5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,ct,63)
end
function c9951301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=-Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c9951301.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9951301.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,ct)
	local rlv=g:GetFirst():GetLevel()-e:GetHandler():GetLevel()
	local rg=Duel.GetMatchingGroup(c9951301.cfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,ct,63)
	g2:AddCard(e:GetHandler())
	Duel.Remove(g2,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9951301.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
