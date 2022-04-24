local m=15004044
local cm=_G["c"..m]
cm.name="异再神晕出"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15004044+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.r1filter(c,e,tp)
	local g=Duel.GetMatchingGroup(cm.r2filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local tf=Duel.GetMZoneCount(tp,c)
	return c:IsReleasable() and g:CheckSubGroup(cm.levelcheck,1,tf,c:GetLevel())
end
function cm.r2filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsSetCard(0x5f3f) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function cm.levelcheck(g,lv)
	local tc=g:GetFirst()
	local x=0
	while tc do
		x=x+tc:GetLevel()
		tc=g:GetNext()
	end
	return x<=lv and aux.dncheck(g)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.r1filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local ag=Duel.SelectMatchingCard(tp,cm.r1filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local lv=ag:GetFirst():GetLevel()
	if ag:GetFirst():IsFacedown() then Duel.ConfirmCards(1-tp,ag:GetFirst()) end
	if Duel.Release(ag:GetFirst(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(cm.r2filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		local ft=Duel.GetMZoneCount(tp)
		if (not g:CheckSubGroup(cm.levelcheck,1,ft,lv)) or ft<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,cm.levelcheck,false,1,ft,lv)
		if sg then
			sg:KeepAlive()
			Duel.SpecialSummon(sg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			local fid=e:GetHandler():GetFieldID()
			local tc=sg:GetFirst()
			while tc do
				tc:RegisterFlagEffect(15004044,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				tc=sg:GetNext()
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(sg)
			e1:SetCondition(cm.descon)
			e1:SetOperation(cm.desop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	return sg:Filter(cm.desfilter,nil,e):GetCount()~=0
end
function cm.desfilter(c,e)
	return c:GetFlagEffectLabel(15004044)==e:GetLabel()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local ag=sg:Filter(cm.desfilter,nil,e)
	Duel.Destroy(ag,REASON_EFFECT)
end