--
local m=111006
local cm=_G["c"..m]
cm.named_with_Arknight=1
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(cm.dircon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.indcon)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.dircon(e)
	return e:GetHandler():GetColumnGroup():Filter(Card.IsType,nil,TYPE_MONSTER)==0
end
function cm.indcon(e)
	local c=e:GetHandler()
	return c:GetSequence()>4
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local atk=c:GetBaseAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e2:SetCondition(cm.damcon)
		e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,3))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_PIERCE)
			e3:SetValue(DOUBLE_DAMAGE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3)
	--attack limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(cm.atlimit)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e4)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5)
end
function cm.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end
function cm.atlimit(e,c)
	return cm.IsLeft(e:GetHandler(),c)
end
function cm.eftg(e,c)
	return cm.IsLeft(c,e:GetHandler())
end
function cm.IsLeft(c,mc)
	local tp=mc:GetControler()
	local Col=aux.GetColumn(mc,tp)
	return cm.IsLeftCard(c,tp,Col)
end
function cm.IsLeftCard(c,tp,Col)
	local Col_1=aux.GetColumn(c,tp)
	if c:IsType(TYPE_FIELD) then return true end
	return Col_1~=Col
end