--星态铁骑·断罪
local m=14000265
local cm=_G["c"..m]
cm.card_code_list={14000260}
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	e1:SetCondition(cm.actcon)
	c:RegisterEffect(e1)
	--disable and atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(cm.adcon)
	e2:SetTarget(cm.adtg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	--material effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(cm.indcon)
	e5:SetOperation(cm.indop)
	c:RegisterEffect(e5)
end
function cm.ffilter(c)
	return c:IsFaceup() and c:IsCode(14000260)
end
function cm.aclimit(e,re,tp)
	return true
end
function cm.actcon(e)
	return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and Duel.IsExistingMatchingCard(cm.ffilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.adcon(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL)
end
function cm.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	e1:SetCondition(cm.actcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(cm.adcon)
	e2:SetTarget(cm.adtg)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	rc:RegisterEffect(e3,true)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetValue(0)
	rc:RegisterEffect(e4,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_ADD_TYPE)
		e5:SetValue(TYPE_EFFECT)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e5,true)
	end
end