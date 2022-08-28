--神树勇者的满开
function c9910327.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910327.target)
	e1:SetOperation(c9910327.activate)
	c:RegisterEffect(e1)
end
function c9910327.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x956)
end
function c9910327.synfilter(c,mg)
	return c:IsSynchroSummonable(nil,mg) and c:IsSetCard(0x956)
end
function c9910327.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910327.synfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910327.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910309,0,0x4011,0,0,4,RACE_PLANT,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910327.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function c9910327.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,9910309,0,0x4011,0,0,4,RACE_PLANT,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,9910328)
	if token and Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.BreakEffect()
		local mg=Group.FromCards(tc,token)
		local tg=Duel.GetMatchingGroup(c9910327.synfilter,tp,LOCATION_EXTRA,0,nil,mg)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910327,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tsg=tg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,tsg:GetFirst(),nil,mg)
		end
	end
end
