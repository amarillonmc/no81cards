--邪骨团 附骨之疽
local m=64800143
local cm=_G["c"..m]
Duel.LoadScript("c64800135.lua")
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,e,tp)
	return c:IsFaceup() and Duel.GetMatchingGroupCount(cm.spfilter,tp,LOCATION_SZONE,0,nil,e,c)==0
end
function cm.spfilter(c,e,mc)
	local seq=c:GetSequence()
	local tp=e:GetHandlerPlayer()
	return aux.GetColumn(mc,tp)==seq
end
function cm.thfilter(c)
	return c.setname=="Zx02" and c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if sc:IsFaceup() and sc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()<=0 then return end
		local tc=g:GetFirst()
		if tc then
			if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
			local rcz=2^aux.GetColumn(sc)
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true,rcz)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
		if sc.setname=="Zx02" then return end
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
		end
	end
end