--醍醐灌顶！
local m=33711119
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function cm.check(c)
	return c:IsType(TYPE_TOKEN) and (c:IsAttackAbove(1) or c:IsDefenseAbove(1))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.check,tp,LOCATION_MZONE,0,nil)
	local sum=0
	for tc in aux.Next(g) do
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(0)
		tc:RegisterEffect(e2)
		if tc:IsAttack(0) and tc:IsDefense(0) then sum=sum+def+atk end
	end
	if sum>0 then
		Duel.BreakEffect()
		if Duel.Recover(tp,sum,REASON_EFFECT)>0 and Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_TOKEN) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,99,nil,TYPE_TOKEN)
			local num=Duel.Release(g,REASON_EFFECT)
			Duel.Recover(tp,num*1000,REASON_EFFECT)
		end
	end
end
function cm.handcon(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,TYPE_TOKEN)>=2
end