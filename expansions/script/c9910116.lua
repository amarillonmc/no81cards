--战车道计策·伪装
function c9910116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910116+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910116.target)
	e1:SetOperation(c9910116.activate)
	c:RegisterEffect(e1)
end
function c9910116.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end
function c9910116.cfilter(c)
	return c:IsSetCard(0x952) and c:IsType(TYPE_MONSTER)
end
function c9910116.spfilter(c,e,tp)
	return c:IsSetCard(0x952) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910116.tofifilter(c)
	return c:IsSetCard(0x952) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9910116.xyzfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsXyzSummonable(nil)
end
function c9910116.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local ct=g:FilterCount(c9910116.cfilter,nil)
	Duel.SortDecktop(tp,tp,g:GetCount())
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910116.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if ct>0 and #g1>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910116,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g1:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
		ct=ct-1
	end
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910116.tofifilter),tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>2 then ft=2 end
	if ct>0 and #g2>0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(9910116,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g2:Select(tp,1,ft,nil)
		local fc=sg:GetFirst()
		while fc do
			Duel.MoveToField(fc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			fc:RegisterEffect(e1)
			fc=sg:GetNext()
		end
		ct=ct-1
	end
	local g3=Duel.GetMatchingGroup(c9910116.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if ct>0 and #g3>0 and Duel.SelectYesNo(tp,aux.Stringid(9910116,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g3:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),nil)
	end
end
