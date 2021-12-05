local m=53799156
local cm=_G["c"..m]
cm.name="五等分的魔理沙"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetSequence()<5
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)==5
end
function cm.callback(c)
	local seq=c:GetSequence()
	if seq==0 and not c:IsCode(53711005) then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,53711005) end
	if seq==1 and not c:IsCode(53711007) then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,53711007) end
	if seq==2 and not c:IsCode(53711009) then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,53711009) end
	if seq==3 and not c:IsCode(53711008) then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,53711008) end
	if seq==4 and not c:IsCode(53711006) then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,53711006) end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	cg:ForEach(cm.callback)
	local ct=0
	for tc in aux.Next(cg) do
		if tc:GetFlagEffect(m)>0 then
			ct=ct+1
			tc:ResetFlagEffect(m)
		end
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return ct==5 and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	cg:ForEach(cm.callback)
	local ct=0
	for tc in aux.Next(cg) do
		if tc:GetFlagEffect(m)>0 then ct=ct+1 end
	end
	if ct~=5 then return end
	for tc in aux.Next(cg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(tc:GetFlagEffectLabel(m))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:ResetFlagEffect(m)
	end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
