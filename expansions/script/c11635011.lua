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
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(cm.plcost)
	e4:SetTarget(cm.pltg)
	e4:SetOperation(cm.plop)
	c:RegisterEffect(e4)
end
cm.SetCard_shixianggui=true
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and  bit.band(r,REASON_EFFECT)~=0  and Duel.GetLP(1-tp)>0  and re:IsActiveType(TYPE_MONSTER)--and re:GetHandler().SetCard_shixianggui
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1163,1)
	Duel.Hint(HINT_CARD,0,m)
	local ct=e:GetHandler():GetCounter(0x1163)
	if ct>0 then
		Duel.BreakEffect()
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct*50)
	end
end
function cm.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabel(e:GetHandler():GetCounter(0x1163))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=e:GetHandler():GetCounter(0x1163)
		return ct>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	end
end
function cm.plop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local ft=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ft*-50)
		tc:RegisterEffect(e1)
		local preatk=tc:GetAttack()
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end