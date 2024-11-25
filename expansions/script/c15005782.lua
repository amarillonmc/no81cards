local m=15005782
local cm=_G["c"..m]
cm.name="反诘视界-『苦难与阳光』"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3f43),aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2,true)
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.desreptg)
	e3:SetValue(cm.desrepval)
	e3:SetOperation(cm.desrepop)
	c:RegisterEffect(e3)
end
function cm.disfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and aux.NegateMonsterFilter(c)
end
function cm.rlfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,cm.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local g2=Duel.GetMatchingGroup(cm.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if c:IsSummonType(SUMMON_TYPE_FUSION) then
		e:SetCategory(CATEGORY_RELEASE+CATEGORY_DISABLE+CATEGORY_DESTROY)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_RELEASE+CATEGORY_DISABLE)
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g2,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(cm.rlfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=g:Select(tp,1,1,nil)
		if Duel.Release(g1,REASON_EFFECT)~=0 and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if e:GetLabel() and e:GetLabel()==1 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_PSYCHO) and c:IsControler(tp)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetCount()==1 and eg:IsExists(cm.repfilter,1,nil,tp)
		and (eg:GetFirst():IsReleasableByEffect() or Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,2,nil)) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(cm.repfilter,nil,tp)
		Duel.SetTargetCard(g)
		return true
	else return false end
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=ag:GetFirst()
	local b1=tc:IsReleasableByEffect()
	local b2=Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,4)},
		{b2,aux.Stringid(m,5)})
	if op==1 then
		Duel.Release(tc,REASON_EFFECT)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end