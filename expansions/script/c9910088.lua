--落樱之月神
function c9910088.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910088)
	e1:SetCost(c9910088.cost)
	e1:SetTarget(c9910088.target)
	e1:SetOperation(c9910088.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9910089)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910088.sptg)
	e2:SetOperation(c9910088.spop)
	c:RegisterEffect(e2)
end
function c9910088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910088.thfilter(c)
	return c:IsSetCard(0x9951) and not c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910088.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910088.disfilter(c,tp)
	return c:IsSetCard(0x9951) and c:IsDiscardable(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c9910088.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
end
function c9910088.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_FAIRY)
end
function c9910088.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910088.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c9910088.disfilter,tp,LOCATION_HAND,0,1,nil,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(9910088,0)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			if Duel.DiscardHand(tp,c9910088.disfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil,tp)==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c9910088.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil)
			end
		end
	end
end
function c9910088.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_RELEASE) and c:IsCanOverlay()
end
function c9910088.spfilter(c,e,tp,mc)
	local g=Group.FromCards(c,mc)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9910088.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,g)
end
function c9910088.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9910088.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910088.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910088.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	local mg=Duel.GetMatchingGroup(c9910088.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,mg,#mg,0,0)
end
function c9910088.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910088.filter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #mg>0 then
			Duel.Overlay(tc,mg)
		end
	end
end
