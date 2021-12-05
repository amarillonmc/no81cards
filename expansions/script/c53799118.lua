local m=53799118
local cm=_G["c"..m]
cm.name="出演确认"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.has_text_type=TYPE_DUAL
function cm.rmfilter(c,tp)
	return c:IsType(TYPE_DUAL) and c:IsAbleToRemove() and ((c:IsLocation(LOCATION_HAND) and Duel.GetFlagEffect(tp,m)<1) or (c:IsLocation(LOCATION_MZONE) and Duel.GetFlagEffect(tp,m+1)<1) or (c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and Duel.GetFlagEffect(tp,m+2)<1)) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thfilter(c,code)
	return c:IsType(TYPE_DUAL) and not c:IsCode(code) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		if tc:IsPreviousLocation(LOCATION_HAND) then Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsPreviousLocation(LOCATION_MZONE) then Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
		else Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1) end
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCondition(cm.endcon)
		e2:SetOperation(cm.endop)
		e2:SetLabelObject(tc)
		e2:SetLabel(fid)
		Duel.RegisterEffect(e2,tp)
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
		local hc=hg:GetFirst()
		if hc and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 then Duel.ConfirmCards(1-tp,hc) end
	end
end
function cm.endcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.spfilter(c,e,tp)
	return c:GetFlagEffectLabel(m)==e:GetLabel() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local mc=e:GetLabelObject()
	if cm.spfilter(mc,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummonStep(mc,0,tp,tp,false,false,POS_FACEUP) then
		mc:EnableDualState()
	end
	Duel.SpecialSummonComplete()
end
