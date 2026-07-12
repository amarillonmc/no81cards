--抒情歌鸲-红嘴山鸦
function c75038018.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75038018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75038018)
	e1:SetCondition(c75038018.spcon)
	e1:SetCost(c75038018.spcost)
	e1:SetTarget(c75038018.sptg)
	e1:SetOperation(c75038018.spop)
	c:RegisterEffect(e1) 
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCountLimit(1,2089017)
	e2:SetCondition(c75038018.effcon)
	e2:SetOperation(c75038018.effop)
	c:RegisterEffect(e2) 
	Duel.AddCustomActivityCounter(75038018,ACTIVITY_SPSUMMON,c75038018.counterfilter)
end
function c75038018.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_XYZ) and c:IsFaceup() 
end
function c75038018.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WINDBEAST)
end
function c75038018.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct==0 or ct==Duel.GetMatchingGroupCount(c75038018.cfilter,tp,LOCATION_MZONE,0,nil)
end
function c75038018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(75038018,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA) end)
	Duel.RegisterEffect(e1,tp)
end 
function c75038018.spfilter(c,e,tp)
	return not c:IsCode(75038018) and c:IsSetCard(0xf7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75038018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c75038018.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75038018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75038018.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
	Duel.SpecialSummonComplete()
end 
function c75038018.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsAttribute(ATTRIBUTE_WIND)
end
function c75038018.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75038018,1))  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c75038018.negcon)
	e1:SetOperation(c75038018.negop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c75038018.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetFlagEffect(75038018)==0 
		and re:IsActiveType(TYPE_SPELL) and re:GetActivateLocation()&LOCATION_ONFIELD~=0 
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev) 
end
function c75038018.negop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(75038018)==0
		and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(75038018,0)) then
		Duel.Hint(HINT_CARD,0,75038018)
		e:GetHandler():RegisterFlagEffect(75038018,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.NegateEffect(ev) 
	end
end

