--救世之旅 莱昂纳多·达·芬奇
function c16401515.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5ce1),aux.NonTuner(Card.IsSetCard,0x5ce1),1)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16401515)
	e1:SetTarget(c16401515.tftg)
	e1:SetOperation(c16401515.tfop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,16401515+1)
	e2:SetCondition(c16401515.thcon)
	e2:SetCost(c16401515.thcost)
	e2:SetTarget(c16401515.thtg)
	e2:SetOperation(c16401515.thop)
	c:RegisterEffect(e2)
	--xyzlv
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c16401515.xyzlv)
	e3:SetLabel(4)
	c:RegisterEffect(e3)
	--synchro level
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_SINGLE)
	e33:SetCode(EFFECT_SYNCHRO_LEVEL)
	e33:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e33:SetRange(LOCATION_ONFIELD)
	e33:SetValue(c16401515.slevel)
	c:RegisterEffect(e33)
end
function c16401515.slevel(e,c)
	if c:IsAttribute(ATTRIBUTE_WATER) then
		return e:GetHandler():GetLevel()+4*65536
	else
		return e:GetHandler():GetLevel()
	end
end
function c16401515.xyzlv(e,c,rc)
	if rc:IsSetCard(0x6ce1) then
		return c:GetLevel()+0x10000*e:GetLabel()
	else
		return c:GetLevel()
	end
end
function c16401515.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c16401515.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.Release(c,REASON_COST)
end
function c16401515.thfilter(c)
	return c:IsSetCard(0x5ce1) and c:IsType(0x6) and c:IsAbleToHand()
end
function c16401515.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16401515.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c16401515.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16401515.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(0x2) then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Recover(tp,1000,0x40)
	end
end
function c16401515.setfilter(c)
	return c:IsSetCard(0x5ce1) and c:IsType(0x6) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c16401515.spfilter(c,e,tp)
	return c:IsSetCard(0x5ce1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c16401515.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c16401515.spfilter,tp,0x22,0,1,c,e,tp)
		and Duel.GetMZoneCount(tp,c)>0
	local b2=Duel.IsExistingMatchingCard(c16401515.setfilter,tp,0x22,0,1,nil)
	if chk==0 then return b1 or b2 end
end
function c16401515.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c16401515.spfilter,tp,0x22,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c16401515.setfilter,tp,0x22,0,1,nil)
	if not (b1 or b2) then return end
	local sel=aux.SelectFromOptions(tp,{b1,1152},{b2,1153})
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c16401515.spfilter,tp,0x22,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16401515.setfilter),tp,0x22,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end