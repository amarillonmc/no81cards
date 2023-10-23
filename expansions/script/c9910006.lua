--折纸使 蓝原紫苑
function c9910006.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910006,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910006)
	e1:SetCondition(c9910006.rpcon)
	e1:SetTarget(c9910006.rptg)
	e1:SetOperation(c9910006.rpop)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910005)
	e2:SetCondition(c9910006.sccon1)
	e2:SetTarget(c9910006.sctg)
	e2:SetOperation(c9910006.scop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c9910006.sccon2)
	c:RegisterEffect(e3)
end
function c9910006.rpcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c9910006.rpfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function c9910006.rpsfilter(c,tp)
	return c9910006.rpfilter(c,tp) and c:IsSetCard(0x3950) and not c:IsCode(9910006)
end
function c9910006.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910006.rpfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c9910006.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910006,1))
		local g=Duel.SelectMatchingCard(tp,c9910006.rpfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		local sg=Duel.GetMatchingGroup(c9910006.rpsfilter,tp,LOCATION_DECK,0,nil,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910006,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910006,3))
			local tg=sg:Select(tp,1,1,nil)
			local fc=tg:GetFirst()
			Duel.BreakEffect()
			Duel.MoveToField(fc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c9910006.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5950)
end
function c9910006.sccon1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	return not g or not g:IsExists(c9910006.confilter,1,nil)
end
function c9910006.sccon2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	return g and g:IsExists(c9910006.confilter,1,nil)
end
function c9910006.filter1(c,e,tp)
	local mg=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,LOCATION_MZONE,0,nil,nil)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	mg:AddCard(c)
	return mg:CheckSubGroup(c9910006.matfilter,1,#mg,tp,c)
end
function c9910006.matfilter(g,tp,mc)
	if not g:IsContains(mc) then return false end
	return Duel.IsExistingMatchingCard(c9910006.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c9910006.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,#mg,#mg)
end
function c9910006.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c9910006.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910006.filter1,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910006.filter1,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910006.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
	if Duel.SpecialSummonComplete()==0 then return end
	Duel.AdjustAll()
	if not tc:IsLocation(LOCATION_MZONE) then return end
	local xyzg=Duel.GetMatchingGroup(c9910006.ovfilter,tp,LOCATION_EXTRA,0,nil,tp,tc)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		local fg=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,LOCATION_MZONE,0,nil,nil)
		local sg=fg:SelectSubGroup(tp,c9910006.gselect,false,1,7,xyz,tc)
		Duel.XyzSummon(tp,xyz,sg)
	end
end
function c9910006.ovfilter(c,tp,mc)
	local mg=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,LOCATION_MZONE,0,nil,nil)
	mg:AddCard(mc)
	return mg:CheckSubGroup(c9910006.gselect,1,#mg,c,mc)
end
function c9910006.gselect(g,c,mc)
	if not g:IsContains(mc) then return false end
	return c:IsXyzSummonable(g,#g,#g)
end
