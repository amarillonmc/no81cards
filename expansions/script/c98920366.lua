--灵神-不知火
function c98920366.initial_effect(c)
	c:SetSPSummonOnce(98920366)
	--synchro summon
	aux.AddSynchroProcedure(c,c98920366.synfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920366,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c98920366.thtg)
	e1:SetOperation(c98920366.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920366,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,98920366)
	e2:SetTarget(c98920366.sptg)
	e2:SetOperation(c98920366.spop)
	c:RegisterEffect(e2)
end
function c98920366.synfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c98920366.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c98920366.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c98920366.spfilter(c,e,tp,code)
	return c:IsSetCard(0xd9) and not c:IsCode(code) and c:IsAbleToRemove()
end
function c98920366.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c98920366.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920366.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98920366.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c98920366.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()   
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.SelectMatchingCard(tp,c98920366.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
		if tc:IsLocation(LOCATION_DECK) and g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c98920366.filter(c,e,tp)
	return c:IsSetCard(0xd9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920366.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920366.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920366.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920366.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end