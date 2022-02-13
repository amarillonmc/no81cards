local m=188873
local cm=_G["c"..m]
cm.name="闪刀姬伴-露世&零衣"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	e1:SetValue(cm.spval)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(function(c)return c:IsSetCard(0x1115) and c:IsType(TYPE_LINK)end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do zone=bit.bor(zone,tc:GetLinkedZone(tp)) end
	return bit.band(zone,0x1f)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=cm.checkzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function cm.spval(e,c)
	local tp=c:GetControler()
	local zone=cm.checkzone(tp)
	return 0,zone
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(LOCATION_EXTRA,0)
	e1:SetValue(function(e,c,fp,rp,r)return 2^6+2^22+2^7+2^21 end)
	Duel.RegisterEffect(e1,tp)
end
function cm.tgfilter(c,tp)
	if c:IsFacedown() or not c:IsType(TYPE_SPELL) or not c:IsAbleToGrave() then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then
		return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED,0,1,nil,true)
	else
		return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED,0,1,nil,false)
	end
end
function cm.setfilter(c,ignore)
	return c:IsFaceup() and c:IsSetCard(0x115) and c:IsType(TYPE_SPELL) and c:IsSSetable(ignore)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then Duel.SSet(tp,g:GetFirst()) end
	end
end
