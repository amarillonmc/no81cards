local m=53764014
local cm=_G["c"..m]
cm.name="全能神沟通"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
cm.has_text_type=TYPE_SPIRIT
function cm.filter(c,e,tp)
	return c:IsCode(c:GetOriginalCodeRule()) and c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsType(TYPE_SPIRIT) and not c:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(cm.ofilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function cm.ofilter(c,code)
	return not c:IsCode(code) and c:IsLevelAbove(5) and c:IsLevelBelow(9) and c:IsType(TYPE_SPIRIT) and ((c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove()) or c:IsAbleToGrave())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local oc=Duel.SelectMatchingCard(tp,cm.ofilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetCode()):GetFirst()
		local res=0
		if oc:IsLocation(LOCATION_GRAVE) then
			res=Duel.Remove(oc,POS_FACEUP,REASON_EFFECT)
			if res>0 and oc:IsLocation(LOCATION_REMOVED) then res=1 end
		else
			res=Duel.SendtoGrave(oc,REASON_EFFECT)
			if res>0 and oc:IsLocation(LOCATION_GRAVE) then res=1 end
		end
		if res==0 then return end
		local code=oc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		tc:RegisterEffect(e1)
		if oc:GetOriginalType()&TYPE_EFFECT==TYPE_EFFECT then
			tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
		end
	end
end
