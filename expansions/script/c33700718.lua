--逃离虚毒
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700718
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3) 
	--damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,0))
	e8:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(cm.damcon)
	e8:SetOperation(cm.damop)
	c:RegisterEffect(e8)
end
function cm.cfilter(c,e)
	return c:IsFaceup() and not c:IsSetCard(0x144b)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x144b)
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.GetFieldGroup(tp,0,LOCATION_MZONE)<=0 then
	   Duel.Damage(1-tp,ct*100,REASON_EFFECT)
	else
	   for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-ct*100)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	   end
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.filter,nil,e)
	if g:GetCount()<=0 then return end
	if g:GetCount()==2 then
	   for tc in aux.Next(g) do
		   tc:RemoveCounter(tp,0x144b,1,REASON_EFFECT)
		   c:AddCounter(0x144b,1)
	   end
	else
	   local tc=g:GetFirst()
	   local ct=tc:GetCounter(0x144b)
	   local ct2=1
	   if ct>1 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		  ct2=2
	   end
	   tc:RemoveCounter(tp,0x144b,ct2,REASON_EFFECT)
	   c:AddCounter(0x144b,ct2)
	end
end
function cm.filter(c,e)
	return c:IsFaceup() and c:IsCanRemoveCounter(tp,0x144b,1,REASON_EFFECT) and (not e or c:IsRelateToEffect(e))
end
