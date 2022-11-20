--老猎人
function c10113071.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10113071.adcon)
	e2:SetValue(c10113071.efilter)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetCondition(c10113071.adcon)
	e3:SetValue(c10113071.adval)
	c:RegisterEffect(e3)
	--code
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CHANGE_CODE)  
	e5:SetValue(c10113071.codeval)
	c:RegisterEffect(e5)
	--gain effect while attack announce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetOperation(c10113071.effop)
	c:RegisterEffect(e6)
	--gain effect after Duel.ChangeAttackTarget()
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_BATTLE_START)
	e7:SetOperation(c10113071.effop)
	c:RegisterEffect(e7)
	--gain effect after Duel.CalculateDamage()
	local e8=e7:Clone()
	e8:SetCode(EVENT_BATTLED)
	c:RegisterEffect(e8)
	--gain effect after filp
	local e9=e7:Clone()
	e9:SetCode(EVENT_BATTLE_CONFIRM)
	c:RegisterEffect(e9)
	--to defense
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetCondition(c10113071.poscon)
	e10:SetOperation(c10113071.posop)
	c:RegisterEffect(e10) 
	local g=Group.CreateGroup()
	g:KeepAlive()
	e10:SetLabelObject(g)
	e10:SetLabel(0)
	e6:SetLabelObject(e10)
	e7:SetLabelObject(e10)
	e8:SetLabelObject(e10)
	e9:SetLabelObject(e10)
end
function c10113071.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc,cid2,g=c:GetBattleTarget(),e:GetLabelObject():GetLabel(),e:GetLabelObject():GetLabelObject()
	if not bc or bc:IsFacedown() or bc:IsControler(tp) then return end
	if g:GetCount()>=1 then
	   local tc=g:GetFirst()
	   if tc==bc then return end
	   c:ResetEffect(cid2,RESET_COPY)
	end
	cid=c:CopyEffect(bc:GetOriginalCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,1)
	e:GetLabelObject():SetLabel(cid)
	g:Clear()
	g:AddCard(bc)
end
function c10113071.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10113071.adcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and bc and bc:IsControler(1-e:GetHandlerPlayer()) and bc:IsFaceup()
end
function c10113071.adval(e,c)
	return e:GetHandler():GetBattleTarget():GetAttack() 
end
function c10113071.codeval(e,c)
	return e:GetHandler():GetBattleTarget():GetCode() 
end
function c10113071.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c10113071.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
