--虹龍·護
function c11185210.initial_effect(c)
	c:EnableCounterPermit(0x452)
	aux.AddCodeList(c,0x452)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCountLimit(1,11185210)
	e1:SetCost(c11185210.spcost)
	e1:SetTarget(c11185210.sptg)
	e1:SetOperation(c11185210.spop)
	c:RegisterEffect(e1)
	--tofield
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11185210+1)
	e2:SetTarget(c11185210.rmtg)
	e2:SetOperation(c11185210.rmop)
	c:RegisterEffect(e2)
end
function c11185210.cfilter(c)
	return c:IsSetCard(0x453) and not c:IsPublic()
end
function c11185210.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185210.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11185210.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	if e:GetHandler()==g:GetFirst() then
		e:SetLabel(1)
	end
end
function c11185210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11185210.thfilter(c)
	return c:IsType(0x6) and c:IsSetCard(0x453) and c:IsAbleToHand()
end
function c11185210.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		if Duel.SelectYesNo(tp,aux.Stringid(11185210,1)) then c:AddCounter(0x452,1) end
		local ck=e:GetLabel()
		local g=Duel.GetMatchingGroup(c11185210.thfilter,tp,LOCATION_DECK,0,nil)
		if ck~=1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11185210,0)) then
			e:SetLabel(0)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11185210.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11185210.splimit(e,c)
	return not (c:IsRace(RACE_WYRM) or aux.IsCodeListed(c,0x452))
end
function c11185210.rmfilter(c)
	return c:IsSetCard(0x453) and c:IsType(0x6) and c:IsAbleToRemove()
end
function c11185210.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185210.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11185210.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11185210.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end