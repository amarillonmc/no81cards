--沧海姬 米洛维亚
function c9911003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911003)
	e1:SetCondition(c9911003.spcon1)
	e1:SetCost(c9911003.spcost)
	e1:SetTarget(c9911003.sptg)
	e1:SetOperation(c9911003.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9911003.spcon2)
	c:RegisterEffect(e2)
	--change attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911004)
	e3:SetCondition(c9911003.attcon)
	e3:SetTarget(c9911003.atttg)
	e3:SetOperation(c9911003.attop)
	c:RegisterEffect(e3)
end
function c9911003.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911003.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9911005)
end
function c9911003.attfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c9911003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetReleaseGroup(tp,true):Filter(aux.TRUE,c)
	if chk==0 then return rg:CheckSubGroup(aux.mzctcheck,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=rg:SelectSubGroup(tp,aux.mzctcheck,false,2,2,tp)
	local label=0
	if g:IsExists(c9911003.attfilter,1,nil) then label=1 end
	e:SetLabel(label)
	Duel.Release(g,REASON_COST)
end
function c9911003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	end
end
function c9911003.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6954)
end
function c9911003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ct=Duel.GetMatchingGroupCount(c9911003.drfilter,tp,LOCATION_MZONE,0,nil)
		if e:GetLabel()==1 and ct>0 and Duel.IsPlayerCanDraw(tp,ct)
			and Duel.SelectYesNo(tp,aux.Stringid(9911003,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end
function c9911003.attcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9911003.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_EARTH) end
end
function c9911003.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_EARTH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_EXTRA_RELEASE_NONSUM)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCountLimit(1)
		e2:SetValue(c9911003.relval)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c9911003.relval(e,re,r,rp)
	return (c9911003.re_activated or re:IsActivated()) and bit.band(r,REASON_COST)~=0
		and re:GetHandler():IsSetCard(0x6954) and re:IsActiveType(TYPE_MONSTER)
end
