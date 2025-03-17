--人理之基 黄金骑士
function c22022330.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c22022330.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022330,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22022330)
	e1:SetTarget(c22022330.target)
	e1:SetOperation(c22022330.operation)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c22022330.actcon)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c22022330.atkcon)
	c:RegisterEffect(e3)
	--dice
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22022330,1))
	e4:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22022330)
	e4:SetCondition(c22022330.erecon)
	e4:SetCost(c22022330.erecost)
	e4:SetTarget(c22022330.target)
	e4:SetOperation(c22022330.operation)
	c:RegisterEffect(e4)
end
c22022330.toss_dice=true
function c22022330.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsCode(22022310) 
end
function c22022330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c22022330.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local dice=Duel.TossDice(tp,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		e1:SetValue(dice*500)
		c:RegisterEffect(e1)
	end
end
function c22022330.actcon(e)
	return Duel.IsExistingMatchingCard(c22022330.filter1,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) and Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c22022330.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c22022330.atkcon(e)
	return Duel.IsExistingMatchingCard(c22022330.filter1,tp,LOCATION_FZONE,LOCATION_FZONE,2,nil)
end
function c22022330.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end

function c22022330.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end