--机天使的天使升华
function c18155061.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c18155061.tg1)
	e1:SetOperation(c18155061.op1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,18155061)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c18155061.tgcon2)
	e2:SetTarget(c18155061.tg2)
	e2:SetOperation(c18155061.op2)
	c:RegisterEffect(e2)
end
function c18155061.tgf1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x7bc2) or c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c18155061.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c18155061.tgf1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c18155061.tgf1,tp,LOCATION_REMOVED,0,1,nil,tp)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c18155061.tgf1,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c18155061.opf1(c)
	return c:IsRace(RACE_FAIRY) and c:IsDefense(1000) and c:IsAttack(1400) and c:IsAbleToHand()
end
function c18155061.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and Duel.IsExistingMatchingCard(c18155061.opf1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(18155061,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c18155061.opf1,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c18155061.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c18155061.tggfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsType(TYPE_RITUAL) and c:IsReleasableByEffect()
		and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c18155061.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c)
end
function c18155061.spfilter(c,e,tp,tc)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_RITUAL) and c:IsLevel(tc:GetLevel())
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c18155061.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c18155061.thfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c18155061.tggfilter,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c18155061.tggfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c18155061.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.Release(tc,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c18155061.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc)
		local zc=g:GetFirst()
		if not zc then return end
		Duel.SpecialSummon(zc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		zc:CompleteProcedure()
	end
end