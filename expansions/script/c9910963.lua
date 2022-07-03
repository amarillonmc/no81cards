--盛放的永夏 神山识
function c9910963.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910963.flag)
	c:RegisterEffect(e0)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910963,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910963)
	e1:SetTarget(c9910963.target)
	e1:SetOperation(c9910963.operation)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910963,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910963)
	e2:SetCost(c9910963.discost)
	e2:SetTarget(c9910963.distg)
	e2:SetOperation(c9910963.disop)
	c:RegisterEffect(e2)
end
function c9910963.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910963.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5954) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910963.filter2(c,e,tp)
	return Duel.IsExistingMatchingCard(c9910963.filter3,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c9910963.filter3(c,e,tp,tc)
	if not (c:IsSetCard(0x5954) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
	else
		return Duel.GetMZoneCount(tp,tc)>0
	end
end
function c9910963.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910963.filter1,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return #g>1 and g:IsExists(c9910963.filter2,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9910963.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9910963.filter1,tp,LOCATION_ONFIELD,0,nil,tp)
	local g2=g1:Filter(c9910963.filter2,nil,e,tp)
	if #g1<2 or #g1==0 then return end
	local g=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(c9910963.filter3,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=g1:Select(tp,2,2,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=g2:Select(tp,1,1,nil)
		g1:RemoveCard(g:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=g1:Select(tp,1,1,nil)
		g:Merge(g3)
	end
	Duel.HintSelection(g)
	if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910963.filter3),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c9910963.tdfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x5954) and c:IsReason(REASON_EFFECT)
		and c:IsAbleToDeckOrExtraAsCost()
end
function c9910963.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910963.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910963.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
end
function c9910963.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c9910963.spfilter(c,e,tp)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910963.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() or tc:IsImmuneToEffect(e) then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(math.ceil(tc:GetAttack()/2))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(RESET_TURN_SET)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e3)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910963.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910963,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=g1:Select(tp,1,1,nil)
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	end
end
