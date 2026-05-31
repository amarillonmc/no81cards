--闪耀的放课后 小宫果穗
function c28316345.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--hokura spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316345,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316345)
	e1:SetCondition(c28316345.icon)
	e1:SetCost(c28316345.spcost)
	e1:SetTarget(c28316345.sptg)
	e1:SetOperation(c28316345.spop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c28316345.qcon)
	c:RegisterEffect(e0)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316345,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,28316345+1)
	e2:SetCondition(c28316345.reccon)
	e2:SetCost(c28316345.cost)
	e2:SetTarget(c28316345.rectg)
	e2:SetOperation(c28316345.recop)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
end
function c28316345.icon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsPlayerAffectedByEffect(tp,28361833)~=nil and e:GetHandler():IsOriginalSetCard(0x283))
end
function c28316345.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,28361833)~=nil and e:GetHandler():IsOriginalSetCard(0x283)
end
function c28316345.chkfilter(c)
	return (c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsNonAttribute(ATTRIBUTE_FIRE) or c:IsCode(28335405)) and not c:IsPublic()
end
function c28316345.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316345.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	c28316345.cost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28316345.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.ShuffleHand(tp)
end
function c28316345.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c28316345.efilter(e)
	local ct=#c28316345.effect_list
	if e:IsHasRange(LOCATION_HAND) and e:IsActivated() then c28316345.effect_list[ct+1]=e end
	return false--e:IsHasRange(LOCATION_HAND) and e:IsActivated()
end
function c28316345.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x286) and c:IsType(TYPE_MONSTER)
end
function c28316345.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local tc=e:GetLabelObject()
	if not tc or not tc:IsType(TYPE_MONSTER) then return end
	c28316345.effect_list={}
	tc:IsOriginalEffectProperty(c28316345.efilter)
	local e_list={}
	for _,te in ipairs(c28316345.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(te,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c28316345.effect_list,i) end
	end
	if #e_list==0 or not Duel.SelectYesNo(tp,aux.Stringid(28316345,3)) then return end
	Duel.BreakEffect()
	local te=e_list[1]
	--[[if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end]]--
	c28316345.effect_list={}
	--copy
	tc:CreateEffectRelation(e)--Card.IsRelateToChain
	tc:CreateEffectRelation(te)--Card.IsRelateToEffect
	local tg=te:GetTarget()
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
end
function c28316345.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_HAND+LOCATION_EXTRA) and #eg==1 and not eg:IsContains(e:GetHandler())
end
function c28316345.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28316345.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c28316345.recop(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(ag) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if aux.GetAttributeCount(g)>=3 and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c28316345.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(28316345,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c28316345.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c28316345.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffectLabel(tp,28316345) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,28316345,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,28316345,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+28362118,e,0,tp,0,0)
end
