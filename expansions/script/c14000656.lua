--抹杀超立方·虚无
local m=14000656
local cm=_G["c"..m]
cm.named_with_CUBE=1
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,6)
	c:EnableReviveLimit()
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(cm.atcost)
	e2:SetOperation(cm.atop)
	c:RegisterEffect(e2)
end
function cm.atcost(e,c,tp)
	return Duel.GetLP(1-tp)>=1
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local ct=math.floor(Duel.GetLP(1-tp)/2)
	Duel.PayLPCost(1-tp,ct)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ct)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e:GetHandler():RegisterEffect(e1)
end