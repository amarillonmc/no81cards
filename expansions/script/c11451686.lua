--代号：穿山甲
local m=11451686
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_RECOVER)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=false
	if c:GetFlagEffect(m)==0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		ac=true
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,7))
	end
	local bc=false
	if c:GetFlagEffect(m+1)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		bc=true
		c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,8))
	end
	if ac and not bc then
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,2))
		Duel.NegateEffect(ev)
	elseif ac and bc then
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,3))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3))
		Duel.NegateEffect(ev)
		Duel.Destroy(c,REASON_EFFECT)
	elseif not ac and bc then
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,4))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,4))
		--damage up
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetLabelObject(re)
		e1:SetValue(cm.damval)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		--recover conversion
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_REVERSE_RECOVER)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(1,1)
		e2:SetLabelObject(e1)
		e2:SetValue(1)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
		--reset
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetCountLimit(1)
		e3:SetLabelObject(e2)
		e3:SetCondition(cm.rscon)
		e3:SetOperation(cm.rsop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	else
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,5))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,5))
	end
end
function cm.damval(e,re,val,r,rp)
	if r&REASON_EFFECT==REASON_EFFECT and re and re==e:GetLabelObject() then return val*4 end
	return val
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject() and e:GetLabelObject():GetLabelObject() and e:GetLabelObject():GetLabelObject():GetLabelObject() and re==e:GetLabelObject():GetLabelObject():GetLabelObject()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te~=nil and aux.GetValueType(te)=="Effect" then
		local te2=te:GetLabelObject()
		if te2~=nil and aux.GetValueType(te2)=="Effect" then te2:Reset() end
		te:Reset()
	end
	e:Reset()
end