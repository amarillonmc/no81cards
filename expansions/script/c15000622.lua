local m=15000622
local cm=_G["c"..m]
cm.name="幻智的白翼·白面鸮"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--reg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,15010622)
	e3:SetCost(cm.atcost)
	e3:SetCondition(cm.atcon)
	e3:SetOperation(cm.atop)
	c:RegisterEffect(e3)  
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())<=2000
end
function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,15000622)==0
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerAffectedByEffect(tp,15000622) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BE_BATTLE_TARGET)
		e1:SetCondition(cm.negcon)
		e1:SetOperation(cm.negop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(15000622)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.RegisterFlagEffect(tp,15000622,RESET_PHASE+PHASE_END,0,114514)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0xf36) and Duel.GetFlagEffect(tp,15000622)~=0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateAttack()
	Duel.ResetFlagEffect(tp,15000622)
end