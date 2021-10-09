--对魔忍者 超级索尼子
function c9981594.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2b),4,2)
	c:EnableReviveLimit()
 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981594,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,9981594)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c9981594.cost)
	e1:SetTarget(c9981594.target2)
	e1:SetOperation(c9981594.operation2)
	c:RegisterEffect(e1)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99815940)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9981594.target)
	e1:SetOperation(c9981594.operation)
	c:RegisterEffect(e1)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981594.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981594.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981594,0))
end 
function c9981594.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9981594.filter(c)
	return c:IsSetCard(0x2b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9981594.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981594.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9981594.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981594.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981594,0))
end
function c9981594.filter1(c,tp,satk)
	local atk1=c:GetAttack()
	return c:IsFaceup() and c:IsSetCard(0x2b) 
		and Duel.IsExistingTarget(c9981594.filter2,tp,0,LOCATION_MZONE,1,nil,atk1,satk)
end
function c9981594.filter2(c,atk1,satk)
	local atk2=c:GetAttack()
	return c:IsFaceup()  and atk1+atk2>=satk
end
function c9981594.spfilter(c,e,tp,atk)
	return c:IsRace(RACE_DRAGON+RACE_DINOSAUR+RACE_SEASERPENT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not atk or c:IsAttackBelow(atk))
end
function c9981594.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local sg=Duel.GetMatchingGroup(c9981594.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then
		if sg:GetCount()==0 then return false end
		local mg,matk=sg:GetMinGroup(Card.GetAttack)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingTarget(c9981594.filter1,tp,LOCATION_MZONE,0,1,nil,tp,matk)
	end
	local mg,matk=sg:GetMinGroup(Card.GetAttack)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c9981594.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp,matk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c9981594.filter2,tp,0,LOCATION_MZONE,1,1,nil,g1:GetFirst():GetLevel(),matk)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9981594.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=tg:GetFirst()
	local atk=0
	if tc:IsLocation(LOCATION_GRAVE) then atk=atk+tc:GetAttack() end
	tc=tg:GetNext()
	if tc and tc:IsLocation(LOCATION_GRAVE) then atk=atk+tc:GetAttack() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981594.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,atk)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		c:SetCardTarget(tc)
	end
	Duel.SpecialSummonComplete()
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981594,0))
end