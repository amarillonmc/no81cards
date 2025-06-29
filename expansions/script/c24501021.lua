--神威骑士，超级转变！
function c24501021.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c24501021.excondition)
	e0:SetDescription(aux.Stringid(24501021,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24501021,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c24501021.cost)
	e1:SetTarget(c24501021.target)
	e1:SetOperation(c24501021.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	--e2:SetCost(c24501021.thcost)
	e2:SetTarget(c24501021.thtg)
	e2:SetOperation(c24501021.thop)
	c:RegisterEffect(e2)
end
function c24501021.exfilter(c)
	return c:IsSetCard(0x501) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c24501021.excondition(e)
	return Duel.IsExistingMatchingCard(c24501021.exfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c24501021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,2) end
	Duel.DiscardDeck(tp,2,REASON_COST)
end
function c24501021.tgsfilter(c,e,tp)
	return c:IsSetCard(0x501) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c24501021.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c)
end
function c24501021.spfilter1(c,e,tp,tc)
	return c:IsRace(RACE_MACHINE) and c:IsLevelBelow(tc:GetLevel()) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24501021.tgnfilter(c,tp)
	return c:IsSetCard(0x501) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_SYNCHRO) and c:IsFaceupEx() and c:IsAbleToGrave() and Duel.GetLocationCountFromEx(tp,tp,c,TYPE_SYNCHRO)>0
end
function c24501021.spfilter2(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24501021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c24501021.tgsfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c24501021.tgnfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c24501021.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if chk==0 then return (b1 or b2) end
	--Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c24501021.activate(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.DiscardDeck(tp,2,REASON_EFFECT)==0 then return end
	--local g=Duel.GetOperatedGroup()
	--if g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==0 then return end
	local b1=Duel.IsExistingMatchingCard(c24501021.tgsfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c24501021.tgnfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c24501021.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b3=b1 and b2 and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=5
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(24501021,1)},
		{b2,aux.Stringid(24501021,2)},
		{b3,aux.Stringid(24501021,3)})
	if op~=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,c24501021.tgsfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if not tc or Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c24501021.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tc):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,c24501021.tgnfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		if not tc or Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c24501021.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c24501021.tgfilter2(c)
	return c:IsSetCard(0x501) and c:IsFaceupEx() and c:IsAbleToGrave()
end
function c24501021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501021.tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24501021.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c24501021.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c24501021.tgfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	if Duel.SendtoGrave(g,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_GRAVE) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,c)
end
