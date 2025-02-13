--招手的墓场马甲
function c49811422.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,49811422)
	e2:SetCondition(c49811422.spcon)
	e2:SetCost(c49811422.spcost)
	e2:SetTarget(c49811422.sptg)
	e2:SetOperation(c49811422.spop)
	c:RegisterEffect(e2)
end
function c49811422.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c49811422.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c49811422.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c49811422.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c49811422.spfilter(c,e,tp)
	return c:IsCode(27094595) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811422.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811422.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCode(EVENT_SUMMON_SUCCESS)
			e1:SetCondition(c49811422.sgcon1)
			e1:SetOperation(c49811422.sgop1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e3:SetCode(EVENT_SUMMON_SUCCESS)
			e3:SetCondition(c49811422.regcon)
			e3:SetOperation(c49811422.regop)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e4=e3:Clone()
			e4:SetCode(EVENT_SPSUMMON_SUCCESS)
			Duel.RegisterEffect(e4,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e3:SetCode(EVENT_CHAIN_SOLVED)
			e3:SetCondition(c49811422.sgcon2)
			e3:SetOperation(c49811422.sgop2)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			if not tc:IsType(TYPE_NORMAL) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,0)
				e1:SetValue(c49811422.limit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c49811422.limit(e,re,tp)
	return not re:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c49811422.sgcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	return eg:IsExists(c49811422.filter,1,nil,1-tp) and not Duel.IsChainSolving() and tc:IsAbleToGrave()
end
function c49811422.filter(c,sp)
	return c:IsSummonPlayer(sp) and not c:IsSummonLocation(LOCATION_GRAVE)
end
function c49811422.sgop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,49811422)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end
function c49811422.regcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	return eg:IsExists(c49811422.filter,1,nil,1-tp) and Duel.IsChainSolving() and tc:IsAbleToGrave()
end
function c49811422.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,49811422,RESET_CHAIN,0,1)
end
function c49811422.sgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,49811422)>0
end
function c49811422.sgop2(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFlagEffect(tp,49811422)
	Duel.Hint(HINT_CARD,0,49811422)
	Duel.ResetFlagEffect(tp,49811422)
	Duel.DiscardDeck(tp,count,REASON_EFFECT)
end