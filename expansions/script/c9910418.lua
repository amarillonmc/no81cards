--赛博空间的守望者
function c9910418.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9910401,c9910418.matfilter,2,true,true)
	--to deck & spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910418)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910418.tdtg)
	e1:SetOperation(c9910418.tdop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c9910418.thcost)
	e2:SetTarget(c9910418.thtg)
	e2:SetOperation(c9910418.thop)
	c:RegisterEffect(e2)
end
function c9910418.matfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsFusionType(TYPE_FUSION)
end
function c9910418.tdfilter(c)
	return c:IsFaceupEx() and c:GetReason()&(REASON_FUSION+REASON_MATERIAL)==(REASON_FUSION+REASON_MATERIAL)
		and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c9910418.spfilter(c,e,tp)
	return c:IsSetCard(0x6950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c9910418.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9910418.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910418.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil)
		and Duel.IsExistingMatchingCard(c9910418.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9910418.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c9910418.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
		and tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910418.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9910418.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if chk==0 then return #g>0 and g:IsContains(e:GetHandler()) and g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==#g end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c9910418.thfilter(c)
	return c:IsSetCard(0x6950) and c:IsAbleToHand()
end
function c9910418.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910418.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910418.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910418.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
