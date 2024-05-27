--再生播种机 无界星花号
function c9910672.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910672)
	e1:SetTarget(c9910672.sptg)
	e1:SetOperation(c9910672.spop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9910673)
	e2:SetTarget(c9910672.eftg)
	e2:SetOperation(c9910672.efop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910672.tgfilter(c,e,tp,mc,mg)
	local p=c:GetControler()
	local i=aux.MZoneSequence(c:GetSequence())
	return Duel.GetMZoneCount(1-p,mg,tp,LOCATION_REASON_TOFIELD,1<<(4-i))>0
		and mc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-p)
end
function c9910672.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910672.tgfilter(chkc,e,tp,c,mg) end
	if chk==0 then return Duel.IsExistingTarget(c9910672.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,c,mg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9910672.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,c,mg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910672.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or not c9910672.tgfilter(tc,e,tp,c,mg) then return end
	local p=tc:GetControler()
	local i=aux.MZoneSequence(tc:GetSequence())
	local dc=Duel.GetFieldCard(1-p,LOCATION_MZONE,4-i)
	if dc then Duel.Destroy(dc,REASON_RULE) end
	Duel.SpecialSummon(c,0,tp,1-p,false,false,POS_FACEUP,1<<(4-i))
end
function c9910672.effilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910672.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910672.effilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9910672.effilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9910672.efop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(9910672,1))
		e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c9910672.negcon)
		e1:SetCost(c9910672.negcost)
		e1:SetTarget(c9910672.negtg)
		e1:SetOperation(c9910672.negop)
		tc:RegisterEffect(e1)
		if not tc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		tc:RegisterFlagEffect(9910672,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910672,0))
	end
end
function c9910672.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c9910672.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910672.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c9910672.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
