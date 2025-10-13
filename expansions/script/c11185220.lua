--虹龍·鋼
function c11185220.initial_effect(c)
	c:EnableCounterPermit(0x452)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCountLimit(1,11185220)
	e1:SetCost(c11185220.spcost)
	e1:SetTarget(c11185220.sptg)
	e1:SetOperation(c11185220.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11185220+1)
	e2:SetTarget(c11185220.thtg)
	e2:SetOperation(c11185220.thop)
	c:RegisterEffect(e2)
end
function c11185220.cfilter(c)
	return c:IsSetCard(0x453) and not c:IsPublic()
end
function c11185220.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185220.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11185220.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	if e:GetHandler()==g:GetFirst() then
		e:SetLabel(1)
	end
end
function c11185220.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11185220.spfilter(c,e,tp)
	return c:IsSetCard(0x453) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11185220.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		if Duel.SelectYesNo(tp,aux.Stringid(11185220,1)) then c:AddCounter(0x452,1) end
		local ck=e:GetLabel()
		local g=Duel.GetMatchingGroup(c11185220.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if ck~=1 and g:GetCount()>0 and Duel.GetMZoneCount(tp)>0
			and Duel.SelectYesNo(tp,aux.Stringid(11185220,0)) then
			e:SetLabel(0)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11185220.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11185220.splimit(e,c)
	return not (c:IsRace(RACE_WYRM) or c:IsType(TYPE_TUNER))
end
function c11185220.thfilter(c)
	return c:IsSetCard(0x453) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c11185220.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185220.thfilter,tp,0x20,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x20)
end
function c11185220.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11185220.thfilter,tp,0x20,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,0x40)
	end
end