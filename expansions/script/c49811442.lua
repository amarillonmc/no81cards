--第13人的埋葬者马甲
function c49811442.initial_effect(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c49811442.spcon)
	e3:SetCost(c49811442.spcost)
	e3:SetTarget(c49811442.sptg)
	e3:SetOperation(c49811442.spop)
	c:RegisterEffect(e3)
end
function c49811442.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811442.spconfilter,1,nil,1-tp) and not Duel.IsChainSolving() and Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=13
end
function c49811442.spconfilter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c49811442.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c49811442.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c49811442.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c49811442.spfilter(c,e,tp)
	return c:IsCode(32864) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811442.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811442.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=13 then
				local cg=Duel.GetDecktopGroup(tp,13)
				local tg=Group.FilterSelect(cg,tp,c49811442.sgfilter,1,1,nil)
				Duel.ConfirmDecktop(tp,13)
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
			if not tc:IsType(TYPE_NORMAL) then
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,0)
				e1:SetValue(c49811442.limit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c49811442.sgfilter(c)
	return c:IsAbleToGrave()
end
function c49811442.limit(e,re,tp)
	return not re:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c49811442.sgcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	return eg:IsExists(c49811442.filter,1,nil,1-tp) and not Duel.IsChainSolving() and tc:IsAbleToGrave()
end
function c49811442.filter(c,sp)
	return c:IsSummonPlayer(sp) and not c:IsSummonLocation(LOCATION_GRAVE)
end
function c49811442.sgop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,49811442)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end
function c49811442.regcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	return eg:IsExists(c49811442.filter,1,nil,1-tp) and Duel.IsChainSolving() and tc:IsAbleToGrave()
end
function c49811442.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,49811442,RESET_CHAIN,0,1)
end
function c49811442.sgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,49811442)>0
end
function c49811442.sgop2(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFlagEffect(tp,49811442)
	Duel.Hint(HINT_CARD,0,49811442)
	Duel.ResetFlagEffect(tp,49811442)
	Duel.DiscardDeck(tp,count,REASON_EFFECT)
end