--ＵＬＴＩＭＡＴＥ　ＫＮＯＷＬＥＤＧＥ
local m=33703017
local cm=_G["c"..m]
--Script by Okes
function cm.initial_effect(c)
	--penlum
	aux.EnablePendulumAttribute(c)
	--bp dam double
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(aux.TRUE)
	e5:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e5)
	local e15=e5:Clone()
	e15:SetValue(aux.ChangeBattleDamage(0,DOUBLE_DAMAGE))
	c:RegisterEffect(e15)
	--draw +
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	--direct attack
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DIRECT_ATTACK)
	e12:SetRange(LOCATION_PZONE)
	e12:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e12:SetCondition(cm.dacon)
	c:RegisterEffect(e12)
	--recover
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e32:SetCode(EVENT_BATTLE_DAMAGE)
	e32:SetRange(LOCATION_PZONE)
	e32:SetCondition(cm.reccon)
	e32:SetOperation(cm.recop)
	c:RegisterEffect(e32)
	--hand ex 2
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_HAND_LIMIT)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTargetRange(1,0)
	e0:SetValue(2)
	c:RegisterEffect(e0)
	--adjuse hand
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_ADJUST)
	e13:SetRange(LOCATION_PZONE)
	e13:SetCondition(cm.ajcon)
	e13:SetOperation(cm.ajop)
	c:RegisterEffect(e13)
end
--direct attack
function cm.daf(c) 
	return c:IsFaceup() and c:IsCode(m) 
end  
function cm.dacon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.daf,tp,LOCATION_PZONE,0,1,e:GetHandler(),nil)
end
--recover
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	return cm.dacon(e) and ac~=nil and ac and Duel.GetAttackTarget()==nil
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	local ap=ac:GetControler()
	Duel.Recover(ap,ev,REASON_EFFECT)
end
--adjuse hand
function cm.ajcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	return #g>1
end
function cm.ajop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local hg=g:Filter(Card.IsDiscardable,nil,REASON_EFFECT)
	if #g>1 and #hg>0 then 
		g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		ct=#g-1
		Duel.DiscardHand(tp,Card.IsDiscardable,ct,ct,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)
	end
end