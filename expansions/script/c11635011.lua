--石像鬼的诅咒尖啸
local m=11635011
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1163)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2) 
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	e3:SetOperation(cm.repop)
	c:RegisterEffect(e3)
end
cm.SetCard_shixianggui=true
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and  bit.band(r,REASON_EFFECT)~=0  and Duel.GetLP(1-tp)>0  and re:IsActiveType(TYPE_MONSTER)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x1163,1)
	Duel.Hint(HINT_CARD,0,m)
	local ct=e:GetHandler():GetCounter(0x1163)
	if ct>0 then
		Duel.BreakEffect()
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-(ct*50))
		local dg=Group.CreateGroup()	
		local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
			local preatk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(ct*-50)
			tc:RegisterEffect(e1)		   
			if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		end
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
--
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c.SetCard_shixianggui
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and (Duel.IsCanRemoveCounter(tp,1,0,0x1163,4,REASON_EFFECT) or c:IsAbleToGrave()) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAbleToGrave() and ( not Duel.IsCanRemoveCounter(tp,1,0,0x1163,4,REASON_EFFECT) or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		Duel.SendtoGrave(c,REASON_EFFECT+REASON_REPLACE)
	else
		Duel.RemoveCounter(tp,1,0,0x1163,4,REASON_EFFECT)
	end 
end
