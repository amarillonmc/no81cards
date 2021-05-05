--测试卡
function c40009172.initial_effect(c)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009172,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c40009172.chop)
	c:RegisterEffect(e3)   
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009172,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,40009172+EFFECT_COUNT_CODE_DUEL)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e2:SetOperation(c40009172.atkop)
	c:RegisterEffect(e2)
end
function c40009172.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(40009172,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCondition(c40009172.discon)
	e3:SetOperation(c40009172.chop)
	Duel.RegisterEffect(e3,tp)
	Duel.SetChainLimit(c40009172.chlimit)
end
function c40009172.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	Duel.SetChainLimit(c40009172.chlimit)
end
function c40009172.chlimit(e,ep,tp)
	return tp==ep
end
function c40009172.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.IsExistingMatchingCard(c40009172.chfilter1,tp,LOCATION_PZONE,0,1,nil) and Duel.IsExistingMatchingCard(c40009172.chfilter2,tp,LOCATION_MZONE,0,1,nil)
end
end
function c40009172.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009172.chfilter1,tp,LOCATION_PZONE,0,1,nil) and Duel.IsExistingMatchingCard(c40009172.chfilter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c40009172.chfilter1(c)
	return c:IsType(TYPE_PENDULUM)   
end
function c40009172.chfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:GetSequence()<5
end
function c40009172.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,40009172)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,c40009172.chfilter1,tp,LOCATION_PZONE,0,1,1,nil)
	local tc1=g1:GetFirst()
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectMatchingCard(tp,c40009172.chfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g2)
	local tc2=g2:GetFirst()
		--local seq1=tc1:GetPreviousSequence()
	   -- local seq2=tc2:GetPreviousSequence()
	if Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
	end
	Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)

end