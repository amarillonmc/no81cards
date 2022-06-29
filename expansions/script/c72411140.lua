--马纳历亚光魔法教师·米兰
function c72411140.initial_effect(c)
	aux.AddCodeList(c,72411020,72411030,72411141)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,72411140)
	e1:SetCondition(c72411140.thcon)
	e1:SetTarget(c72411140.target1)
	e1:SetOperation(c72411140.operation1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER,TIMING_MSET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,72411141)
	e2:SetCost(c72411140.cost2)
	e2:SetTarget(c72411140.target2)
	e2:SetOperation(c72411140.operation2)
	c:RegisterEffect(e2)
end
--e1
function c72411140.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c72411140.filter1(c)
	return c:IsCode(72411020,72411030) and c:IsAbleToHand()
end
function c72411140.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411140.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c72411140.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c72411140.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e2
function c72411140.costfilter(c,tp)
	return (c:IsSetCard(0x5729) and c:IsType(TYPE_SPELL)) or (c:IsSetCard(0x5729) or Duel.IsPlayerAffectedByEffect(tp,72413440)) and c:IsDiscardable(REASON_COST)
end
function c72411140.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72411140.costfilter,tp,LOCATION_HAND,0,1,nil,tp)  end
	Duel.DiscardHand(tp,c72411140.costfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
end
function c72411140.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,72411141,0,0x4011,1500,1500,1,RACE_MACHINE,ATTRIBUTE_EART) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)   
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c72411140.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,72411141,0,0x4011,1500,1500,1,RACE_MACHINE,ATTRIBUTE_EART) then return end
			local token=Duel.CreateToken(tp,72411141)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummonComplete()
		end
end
 
