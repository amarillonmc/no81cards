--方舟骑士-凛冬
c29065536.named_with_Arknight=1
function c29065536.initial_effect(c)
	c:EnableCounterPermit(0x10ae)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c29065536.hspcon)
	e1:SetOperation(c29065536.hspop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065523,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c29065536.cttg)
	e2:SetOperation(c29065536.ctop)
	c:RegisterEffect(e2)
end
function c29065536.cfilter(c)
	return c:IsCode(29065521,29065523,29065536,15000129,29065537,29065549,29096814,29080482,29039748) and c:IsType(TYPE_MONSTER)
end
function c29065536.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and (Duel.IsCanRemoveCounter(tp,1,0,0x10ae,1,REASON_COST) or Duel.GetFlagEffect(tp,29096814)==1)
end
function c29065536.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetFlagEffect(tp,29096814)==1 then
	Duel.ResetFlagEffect(tp,29096814)
	else
	Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_EFFECT)
	end
end
function c29065536.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065536.cfilter,tp,LOCATION_MZONE,0,1,nil) end 
end
function c29065536.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29065536.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(math.ceil(tc:GetAttack()/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--cou
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetRange(LOCATION_MZONE) 
		e2:SetCondition(aux.bdocon)
		e2:SetOperation(c29065536.couop)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c29065536.couop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsFaceup() then
	c:AddCounter(0x10af,1) end
end