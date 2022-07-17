local m=53796017
local cm=_G["c"..m]
cm.name="索拉丁女孩蠍媛"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.immval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.immval(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:GetOwner()~=e:GetHandler() and te:IsActivated() and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local res=false
	if rc:IsHasCardTarget(c) then res=true end
	if re:GetOwner()~=e:GetHandler() and re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(re) then res=true end
	if not res then return end
	local op=0
	if rc:IsRelateToEffect(re) and Duel.IsPlayerCanDraw(1-rp,1) then op=Duel.SelectOption(1-rp,aux.Stringid(m,0),aux.Stringid(m,1)) elseif rc:IsRelateToEffect(re) then op=Duel.SelectOption(1-rp,aux.Stringid(m,0)) elseif Duel.IsPlayerCanDraw(1-rp,1) then op=Duel.SelectOption(1-rp,aux.Stringid(m,1))+1 else return end
	Duel.Hint(HINT_CARD,0,m)
	if op==0 then
		rc:CancelToGrave()
		if Duel.SendtoHand(rc,rp,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(1-rp,1) then Duel.Draw(1-rp,1,REASON_EFFECT) end
	else
		if Duel.Draw(rp,1,REASON_EFFECT)~=0 and rc:IsRelateToEffect(re) then
			rc:CancelToGrave()
			Duel.SendtoHand(rc,1-rp,REASON_EFFECT)
		end
	end
end
