--人理之诗 女神的视线
function c22020350.initial_effect(c)
	aux.AddCodeList(c,22020340)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetCountLimit(1,22020350+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22020350.cost)
	e1:SetTarget(c22020350.target)
	e1:SetOperation(c22020350.activate)
	c:RegisterEffect(e1)
end
function c22020350.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("嗯，让他们尝尝苦头吧！")
end
function c22020350.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c22020350.spfilter(c,e,tp)
	return c:IsCode(22020340) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c22020350.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22020350.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020350.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22020350.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c22020350.chainlm)
	end
end
function c22020350.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_SPELL)
end
function c22020350.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
		Debug.Message("女神的视线！")
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_SPELL)
		tc:RegisterEffect(e1)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22020350.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(22020350,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c22020350.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		end
	end
end
