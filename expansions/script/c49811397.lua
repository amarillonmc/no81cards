--バグマンV
function c49811397.initial_effect(c)	
	--search and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811397,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,49811397)
	e1:SetCost(c49811397.thcost)
	e1:SetTarget(c49811397.thtg)
	e1:SetOperation(c49811397.thop)
	c:RegisterEffect(e1)
	--search2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811397,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811398)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c49811397.thcon2)
	e2:SetTarget(c49811397.thtg2)
	e2:SetOperation(c49811397.thop2)
	c:RegisterEffect(e2)
end
function c49811397.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c49811397.thfilter(c)
	return c:IsCode(87526784,23915499,50319138) and c:IsAbleToHand()
end
function c49811397.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsLevel(3) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
end
function c49811397.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811397.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811397.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c49811397.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(c49811397.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(49811397,1)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c49811397.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end
function c49811397.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c49811397.thcon2(e)
	return Duel.IsExistingMatchingCard(c49811397.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c49811397.thfilter2(c)
	return c:IsCode(6430659,32835363,98535702) and c:IsAbleToHand()
end
function c49811397.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811397.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c49811397.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c49811397.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g then
		local tg=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
			local gc=Duel.GetOperatedGroup()
			if #gc>0 then
				Duel.Damage(tp,#gc*500,REASON_EFFECT)
				Duel.Damage(1-tp,#gc*500,REASON_EFFECT)
			end
		end
	end
end
