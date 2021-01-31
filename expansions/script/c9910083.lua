--月神的织缀
function c9910083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910083+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910083.cost)
	e1:SetTarget(c9910083.target)
	e1:SetOperation(c9910083.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910083,ACTIVITY_SPSUMMON,c9910083.counterfilter)
end
function c9910083.counterfilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c9910083.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9910083,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c9910083.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c9910083.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_FAIRY)
end
function c9910083.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910083.thfilter(c)
	return c:IsSetCard(0x9951) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910083.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910083.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local sg=g:Filter(Card.IsRace,nil,RACE_FAIRY)
	if g:GetCount()>0 and g:IsExists(c9910083.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910083,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:FilterSelect(tp,c9910083.thfilter,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleHand(tp)
	end
	Duel.ShuffleDeck(tp)
	if sg and sg:GetClassCount(Card.GetAttribute)>=2
		and Duel.IsExistingMatchingCard(c9910083.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9910083,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=Duel.SelectMatchingCard(tp,c9910083.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
	end
end
