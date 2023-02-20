--曙龙生息之星河
function c9910819.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,9910819)
	e2:SetCost(c9910819.thcost)
	e2:SetTarget(c9910819.thtg)
	e2:SetOperation(c9910819.thop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910819,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9910820)
	e3:SetTarget(c9910819.sptg)
	e3:SetOperation(c9910819.spop)
	c:RegisterEffect(e3)
end
function c9910819.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910819.thfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsRace(RACE_DRAGON+RACE_SEASERPENT+RACE_WYRM) and c:IsAbleToHand()
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c9910819.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910819.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c9910819.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910819.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910819.filter(c,e,tp,g)
	local lv=c:GetLevel()
	return c:IsReason(REASON_DESTROY) and c:IsSetCard(0x6951) and g:IsContains(c)
		and lv>0 and Duel.IsExistingMatchingCard(c9910819.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,lv)
end
function c9910819.spfilter(c,e,tp,lv)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c9910819.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9910819.filter(chkc,e,tp,eg) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910819.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9910819.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910819.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=0
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910819.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetLevel())
		local sc=g:GetFirst()
		if sc then
			sc:SetMaterial(nil)
			ct=Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
	if ct==0 then return end
	local g2=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,nil)
	if #g2==0 or Duel.SelectOption(tp,aux.Stringid(9910819,1),aux.Stringid(9910819,2))==0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif #g2>0 then
		Duel.BreakEffect()
		local sg=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Release(sg,REASON_EFFECT)
	end
end
