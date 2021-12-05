local m=53721001
local cm=_G["c"..m]
cm.name="悚牢的来访者"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local op=Duel.SelectOption(tp,1001,aux.Stringid(m,0),1004)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetLabel(op)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,op+3))
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetLabel(op)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if e:GetLabel()==0 then loc=LOCATION_HAND
	elseif e:GetLabel()==1 then loc=LOCATION_ONFIELD
	else loc=LOCATION_GRAVE end
	local tloc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep==1-tp and bit.band(tloc,loc)~=0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) and Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.DiscardDeck(tp,1,REASON_COST)
	local g=Duel.GetOperatedGroup()
	e:SetLabelObject(g:GetFirst())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():IsAttribute(ATTRIBUTE_WATER) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(200)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	else
		Duel.SetLP(tp,Duel.GetLP(tp)-500)
	end
end
