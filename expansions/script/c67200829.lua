--腐海之主 阿比鲁斯
function c67200829.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200829,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200829)
	e1:SetCost(c67200829.thcon)
	e1:SetTarget(c67200829.target)
	e1:SetOperation(c67200829.activate)
	c:RegisterEffect(e1)   
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200829,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e3:SetCountLimit(1,67200830)
	e3:SetCondition(c67200829.condition)
	e3:SetTarget(c67200829.sptg)
	e3:SetOperation(c67200829.spop)
	c:RegisterEffect(e3) 
end
function c67200829.cfilter1(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSummonPlayer(tp)
end
function c67200829.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200829.cfilter1,1,nil,tp)
end
function c67200829.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c67200829.spfilter2,tp,LOCATION_PZONE,0,1,c,e,tp,c)
end
function c67200829.xyzlv(e,c,rc)
	return e:GetHandler():GetLevel()+e:GetLabel()*0x10000
end
function c67200829.spfilter2(c,e,tp,mc)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	local e1=nil
	local e2=nil
	if c:IsLevelAbove(1) and mc:IsLevelAbove(1) then
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(c67200829.xyzlv)
		e1:SetLabel(mc:GetLevel())
		c:RegisterEffect(e1,true)
		e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetValue(c67200829.xyzlv)
		e2:SetLabel(c:GetLevel())
		mc:RegisterEffect(e2,true)
	end
	local res=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,mc),2,2)
	if e1 then e1:Reset() end
	if e2 then e2:Reset() end
	return res
end
function c67200829.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c67200829.spfilter1,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c67200829.spfilter3(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200829.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c67200829.spfilter3,nil,e,tp)
	if g:GetCount()<2 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc1:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	tc1:RegisterEffect(e2)
	local e3=e1:Clone()
	tc2:RegisterEffect(e3)
	local e4=e2:Clone()
	tc2:RegisterEffect(e4)
	Duel.SpecialSummonComplete()
	Duel.AdjustAll()
	if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
	local e5=nil
	local e6=nil
	if tc1:IsLevelAbove(1) and tc2:IsLevelAbove(1) then
		e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_XYZ_LEVEL)
		e5:SetValue(c67200829.xyzlv)
		e5:SetLabel(tc2:GetLevel())
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e5,true)
		e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_XYZ_LEVEL)
		e6:SetValue(c67200829.xyzlv)
		e6:SetLabel(tc1:GetLevel())
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e6,true)
	end
	local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,g,2,2)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	else
		if e5 then e5:Reset() end
		if e6 then e5:Reset() end
	end
end

--
function c67200829.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c67200829.setfilter1(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function c67200829.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200829.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c67200829.setfilter1,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,0,1,c,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c67200829.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,c67200829.setfilter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,c,tp)
	local tc1=g1:GetFirst()
	if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			Duel.NegateActivation(ev)
			tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		c:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if c:IsLocation(LOCATION_PZONE) and Duel.IsExistingMatchingCard(c67200829.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(67200829,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c67200829.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #tg>0 then
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end