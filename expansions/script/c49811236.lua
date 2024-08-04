--漆黑之魔王 LV10
function c49811236.initial_effect(c)
	--to hand or special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,49811236)
	e1:SetCondition(c49811236.thcon)
	e1:SetCost(c49811236.thcost)
	e1:SetTarget(c49811236.thtg)
	e1:SetOperation(c49811236.thop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c49811236.rmcon)
	e2:SetTarget(c49811236.rmtg)
	e2:SetOperation(c49811236.rmop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,49811236)
	e3:SetCost(c49811236.spcost)
	e3:SetTarget(c49811236.sptg)
	e3:SetOperation(c49811236.spop)
	c:RegisterEffect(e3)
end
c49811236.lvdn={49811234,85313220,12817939,58206034}
function c49811236.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c49811236.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c49811236.thfilter(c,e,tp,check)
	return (c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4))
		and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c49811236.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return Duel.IsExistingMatchingCard(c49811236.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check) end
end
function c49811236.thop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c49811236.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not (check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)) or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c49811236.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c49811236.splimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
function c49811236.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() then return false end
	e:SetLabelObject(tc)
	return tc and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and tc:IsAbleToRemove()
		and (tc:IsLocation(LOCATION_GRAVE) or tc:IsFaceup() and tc:IsLocation(LOCATION_EXTRA))
end
function c49811236.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c49811236.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c49811236.distg)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c49811236.discon)
		e2:SetOperation(c49811236.disop)
		e2:SetLabelObject(tc)
		Duel.RegisterEffect(e2,tp)
	end
end
function c49811236.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c49811236.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c49811236.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c49811236.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_FIEND) and c:IsAbleToDeckAsCost()
end
function c49811236.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811236.spfilter,tp,LOCATION_REMOVED,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c49811236.spfilter,tp,LOCATION_REMOVED,0,4,4,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c49811236.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811236.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end