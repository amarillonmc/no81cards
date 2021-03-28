--晓天之剑圣 格吉特·赫利俄斯
function c40009526.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	--e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e1:SetCondition(c40009526.atkcon)
	e1:SetValue(c40009526.atkval)
	c:RegisterEffect(e1) 
	--lvchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009526,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009526)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c40009526.spcon1)
	e1:SetTarget(c40009526.lvtg)
	e1:SetOperation(c40009526.lvop)
	c:RegisterEffect(e1)
end
function c40009526.atkcon(e)--,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c40009526.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local g=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.--GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	--local val=g:GetSum(Card.GetRank)*500
	--if tp==1 then
		--zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
   -- end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(c40009526.atkval)
		c:RegisterEffect(e1)
	end
end
function c40009526.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsControler(1-tp) then a=Duel.GetAttackTarget() end
	return a
end
function c40009526.atkval(e,c)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)*300
end
function c40009526.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c40009526.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c40009526.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009526.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009526.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40009526.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c40009526.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c40009526.actlimit1)
	e1:SetLabel(tc:GetAttack())
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c40009526.actlimit2)
	e3:SetLabel(tc:GetAttack())
	Duel.RegisterEffect(e3,tp)
	c:RegisterFlagEffect(0,RESET_EVENT+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40009526,1))
end
function c40009526.actlimit1(e,c)
	return c:IsAttackAbove(e:GetLabel())
end
function c40009526.actlimit2(e,c)
	return c:IsAttackBelow(e:GetLabel())
end