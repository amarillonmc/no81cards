--落雪，浸黑国土
function c60000079.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,60000079)
	e1:SetCost(c60000079.tzcost)
	e1:SetTarget(c60000079.tztg1)
	e1:SetOperation(c60000079.tzop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60000079,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,60000079)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c60000079.handcon)
	e2:SetCost(c60000079.handcost)
	e2:SetTarget(c60000079.tztg1)
	e2:SetOperation(c60000079.tzop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60000079,1))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,90000079)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c60000079.smcost)
	e3:SetTarget(c60000079.smtg)
	e3:SetOperation(c60000079.smop)
	c:RegisterEffect(e3)

	Duel.AddCustomActivityCounter(60000079,ACTIVITY_SPSUMMON,c60000079.counterfilter)
end
function c60000079.counterfilter(c)
	return c:IsSetCard(0x3621)
end
function c60000079.filter(c,e,tp)
	return c:IsCode(60000064) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c60000079.filter2(c)
	return c:IsFaceup() and c:IsCode(60000064) and c:IsType(TYPE_XYZ)
end
function c60000079.jster(c,e,tp,code)
	return c:IsSetCard(0x3621) and c:IsAbleToHand() and not c:IsCode(code)
end
function c60000079.fzter(c,e,tp,code)
	return c:IsSetCard(0x3621) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(code)
end
function c60000079.tzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(60000079,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60000079.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60000079.tztg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(c60000079.filter2,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return (g<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c60000079.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp)) or g>=1 end
	if g>=1 then
	elseif g<1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	end
end
function c60000079.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x3621)
end
function c60000079.tzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroupCount(c60000079.filter2,tp,LOCATION_MZONE,0,nil)
	if g<1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c60000079.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif g>=1 and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local g2=Duel.SelectMatchingCard(tp,c60000079.filter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		local tc=g2:GetFirst()
		while tc do
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
			tc=g2:GetNext()
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,60000080,0x3621,TYPES_TOKEN_MONSTER,2800,1000,6,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP) or not Duel.IsPlayerCanSpecialSummonMonster(tp,60000080,0x3621,TYPES_TOKEN_MONSTER,2800,1000,6,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		local token1=Duel.CreateToken(tp,60000080)
		local token2=Duel.CreateToken(tp,60000080)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,60000080,0x3621,TYPES_TOKEN_MONSTER,2800,1000,6,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(60000079,2)) then
			Duel.BreakEffect()
			local token3=Duel.CreateToken(tp,60000080)
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
			Duel.SpecialSummon(token3,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c60000079.rmfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCode(60000064) and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c60000079.handcon(e,tp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCustomActivityCount(60000079,tp,ACTIVITY_SPSUMMON)==0
end
function c60000079.handcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000079.rmfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetCustomActivityCount(60000079,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60000079.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=Duel.SelectMatchingCard(tp,c60000079.rmfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60000079.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.GetCustomActivityCount(60000079,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60000079.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c60000079.smter(c)
	return (c:IsAbleToHand() or c:IsAbleToGrave()) and c:IsSetCard(0x3621)
end
function c60000079.smter2(c)
	return c:IsFaceup() and c:IsCode(60000086)
end
function c60000079.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000079.smter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,tp,LOCATION_DECK)
end
function c60000079.smop(e,tp,eg,ep,ev,re,r,rp)
	local sl=Duel.GetFlagEffect(tp,60000065)
	local g1=Duel.GetMatchingGroupCount(c60000079.smter2,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c60000079.smter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if sl<3 then
			if g1>0 and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
				Duel.RegisterFlagEffect(tp,60000065,RESET_PHASE+PHASE_END,0,1)
			else tc:IsAbleToGrave()
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		elseif sl>=3 and tc:IsAbleToGrave() then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end