--邃曙龙 帕莱克滕-泰初
function c9910823.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9910823.spcon)
	e1:SetCost(c9910823.spcost)
	e1:SetTarget(c9910823.sptg)
	e1:SetOperation(c9910823.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910823.negcon)
	e2:SetTarget(aux.nbtg)
	e2:SetOperation(c9910823.negop)
	c:RegisterEffect(e2)
	if not c9910823.global_check then
		c9910823.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c9910823.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9910823.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),9910823,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c9910823.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,9910823)>=3
end
function c9910823.dfilter(c,e,tp,lv)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c9910823.spfilter,tp,LOCATION_HAND,0,1,c,e,tp,lv)
end
function c9910823.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9910823.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,lv-c:GetLevel())
end
function c9910823.eqfilter(c,tp,lv)
	return c:IsSetCard(0x6951) and c:IsType(TYPE_MONSTER) and c:IsLevel(lv) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c9910823.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local fe=Duel.IsPlayerAffectedByEffect(tp,9910802)
	local b2=Duel.IsExistingMatchingCard(c9910823.dfilter,tp,LOCATION_HAND,0,1,c,e,tp,lv)
	if chk==0 then return c:IsDiscardable() and c:IsLevelAbove(2) and (fe or b2) end
	if fe and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9910802,0))) then
		Duel.Hint(HINT_CARD,0,9910802)
		fe:UseCountLimit(tp)
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c9910823.dfilter,tp,LOCATION_HAND,0,1,1,c,e,tp,lv)
		g:AddCard(c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
	e:SetLabel(lv)
end
function c9910823.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c9910823.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or lv<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9910823.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sc=Duel.SelectMatchingCard(tp,c9910823.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp,lv-tc:GetLevel()):GetFirst()
		if not sc then return end
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c9910823.eqlimit)
		sc:RegisterEffect(e1)
	end
end
function c9910823.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c9910823.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c9910823.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
