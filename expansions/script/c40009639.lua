--瓦尔里纳·勇气 
function c40009639.initial_effect(c)
	aux.AddCodeList(c,40009571)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c40009639.mfilter,1,1)
	--skip 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_END) 
	e1:SetCountLimit(1,40009639+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c40009639.skcon)
	e1:SetTarget(c40009639.sktg)
	e1:SetOperation(c40009639.skop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp end)
	e2:SetOperation(c40009639.regop)
	c:RegisterEffect(e2) 
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c40009639.atkval)
	c:RegisterEffect(e1)
end 
function c40009639.mfilter(c) 
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetMaterial():IsExists(Card.IsCode,1,nil,40009571) and c:IsLinkSetCard(0x3f1a)
end  
function c40009639.skcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 or Duel.GetCurrentPhase()~=PHASE_BATTLE or Duel.GetTurnPlayer()~=tp then return false end
	return e:GetHandler():GetFlagEffect(40009639)~=0 
end
function c40009639.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c40009639.skop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	--
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
end 
function c40009639.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	c:RegisterFlagEffect(40009639,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
end 
function c40009639.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c40009639.atkval(e,c)
	return Duel.GetMatchingGroup(c40009639.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)*200 
end

