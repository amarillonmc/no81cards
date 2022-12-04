local m=53739015
local cm=_G["c"..m]
cm.name="异金的涌动"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.desfilter1(c,e)
	return c:IsFacedown() and c:IsCanBeEffectTarget(e)
end
function cm.filter(c,e)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local p=c:GetControler()
	local res=Duel.IsExistingMatchingCard(cm.desfilter1,p,0,LOCATION_MZONE,1,nil,e1)
	if e1 then e1:Reset() end
	local bool=Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)
	local re={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
	local flag=true
	if bool then
		for k,v in ipairs(re) do
			local val=v:GetValue()
			local check=true
			if val==1 then check=false end
			if aux.GetValueType(val)=="function" then val=val(v,v,p) end
			if val==1 or val==true then flag=false end
		end
	end
	return res and flag and c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsHasEffect(EFFECT_CANNOT_TRIGGER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CUSTOM+m)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(cm.ready)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+m,e,0,0,0,0)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.ready(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local bool=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)
	local re={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	local flag=true
	if bool then
		for k,v in ipairs(re) do
			local val=v:GetValue()
			local check=true
			if val==1 then check=false end
			if aux.GetValueType(val)=="function" then val=val(v,v,tp) end
			if val==1 or val==true then flag=false end
		end
	end
	if e:GetHandler():IsType(TYPE_EFFECT) and flag and not e:GetHandler():IsHasEffect(EFFECT_CANNOT_TRIGGER) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_CUSTOM+m)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetTarget(cm.destg)
		e1:SetOperation(cm.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,0,0,0)
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.desfilter1,tp,0,LOCATION_MZONE,nil,e)
	if #g==0 then
		e:Reset()
		return false
	end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function cm.desfilter(c,tc)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then return tc:IsSSetable(true) else return tc:IsSSetable() end
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return e:GetLabel()==1 and chkc:IsOnField() and chkc:IsControler(tp) and cm.desfilter(chkc,e:GetHandler()) end
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and Duel.GetFlagEffect(tp,m)==0
	local b2=Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,e:GetHandler()) and e:GetHandler():IsLocation(LOCATION_GRAVE) and Duel.GetFlagEffect(tp,m+50)==0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and b2 then s=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) elseif b1 then s=Duel.SelectOption(tp,aux.Stringid(m,1)) else s=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
	e:SetLabel(s)
	if s==0 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		e:SetProperty(EFFECT_FLAG_DELAY)
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	end
	if s==1 then
		Duel.RegisterFlagEffect(tp,m+50,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(0)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if g:GetCount()==0 then return end
		local tc=g:RandomSelect(tp,1):GetFirst()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
	if e:GetLabel()==1 then
		if e:GetHandler():IsRelateToEffect(e) then Duel.SSet(tp,e:GetHandler()) end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
