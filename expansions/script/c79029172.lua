--雷神工业·医疗干员-Lancet-2
function c79029172.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--check 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+79029172)
	e1:SetOperation(c79029172.regop)
	c:RegisterEffect(e1)
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029172.condition)
	e1:SetTarget(c79029172.target)
	e1:SetOperation(c79029172.operation)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029172.splimit)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_BATTLE_START+TIMING_ATTACK)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,79029172)
	e3:SetCondition(c79029172.spcon)
	e3:SetTarget(c79029172.sptg)
	e3:SetOperation(c79029172.spop)
	c:RegisterEffect(e3) 
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c79029172.ctcon)
	e4:SetOperation(c79029172.ctop)
	c:RegisterEffect(e4) 
	--self destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(c79029172.descon)
	c:RegisterEffect(e5)
end
function c79029172.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029172.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c79029172.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029172.cfilter,1,nil,tp)
end
function c79029172.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029172.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	  local x=eg:Select(tp,1,1,nil)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	  local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	  local nseq=math.log(s,2)
	  Duel.MoveSequence(x:GetFirst(),nseq)
end
function c79029172.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP 
end
function c79029172.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCountFromEx(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029172.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Recover(tp,500,REASON_EFFECT)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+79029172,e,0,tp,0,0)
end
function c79029172.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0
end
function c79029172.ctop(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Recover(tp,x*100,REASON_EFFECT)
	end
end
function c79029172.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetBattleTarget()
	if c:IsRelateToBattle() then
		c:RegisterFlagEffect(79029172,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
function c79029172.descon(e)
	return e:GetHandler():GetFlagEffect(79029172)~=0 and Duel.GetCurrentPhase()==PHASE_BATTLE 
end





