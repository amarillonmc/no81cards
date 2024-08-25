--数码兽跃迁进化!!
function c50223175.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,50223175)
	e1:SetTarget(c50223175.target)
	e1:SetOperation(c50223175.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,50223176)
	e2:SetCost(c50223175.thcost)
	e2:SetTarget(c50223175.thtg)
	e2:SetOperation(c50223175.thop)
	c:RegisterEffect(e2)
end
function c50223175.tgfilter(c,e,tp)
	if not c:IsSetCard(0xcb1) or not c:IsReleasableByEffect() or not c:IsFaceup() then return false end
	local race=c:GetRace()
	local attr=c:GetAttribute()
	local level=c:GetLevel()
	return Duel.IsExistingMatchingCard(c50223175.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,race,attr,level,e,tp)
end
function c50223175.spfilter(c,race,attr,level,e,tp)
	return c:IsSetCard(0xcb1) and c:IsRace(race) and c:IsAttribute(attr) and c:IsLevelAbove(level+1)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c50223175.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c50223175.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c50223175.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	tgc=Duel.SelectMatchingCard(tp,c50223175.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if not tgc then return end
	if Duel.Release(tgc,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local race=tgc:GetOriginalRace()
		local attr=tgc:GetOriginalAttribute()
		local level=tgc:GetOriginalLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=Duel.SelectMatchingCard(tp,c50223175.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,race,attr,level,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
			if tc:IsPreviousLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		end
		Duel.BreakEffect()
		local splv=tc:GetLevel()
		Duel.SetLP(tp,Duel.GetLP(tp)-(splv-level)*500)
	end
end
function c50223175.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c50223175.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50223175.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end