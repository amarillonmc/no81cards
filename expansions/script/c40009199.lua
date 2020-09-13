--时机龙骑·原点回归
function c40009199.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,c40009199.mfilter,4,3)  
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009199,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,40009199)
	e1:SetCondition(c40009199.hdcon)
	e1:SetTarget(c40009199.hdtg)
	e1:SetOperation(c40009199.hdop)
	c:RegisterEffect(e1)  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009199,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,40009200+EFFECT_COUNT_CODE_DUEL)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c40009199.thcon)
	e2:SetTarget(c40009199.atktg)
	e2:SetOperation(c40009199.atkop)
	c:RegisterEffect(e2)  
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009199,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c40009199.pencon)
	e3:SetTarget(c40009199.pentg)
	e3:SetOperation(c40009199.penop)
	c:RegisterEffect(e3)
end
function c40009199.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c40009199.cfilter(c,tp)
	return c:IsFaceup() 
		and c:IsSetCard(0xf1c) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c40009199.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009199.cfilter,1,nil,tp)
end
function c40009199.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c40009199.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c40009199.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009199.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(40009199,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCondition(c40009199.discon)
	e3:SetOperation(c40009199.chop)
	Duel.RegisterEffect(e3,tp)
	Duel.SetChainLimit(c40009199.chlimit)
end
function c40009199.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	Duel.SetChainLimit(c40009199.chlimit)
end
function c40009199.chlimit(e,ep,tp)
	return tp==ep
end
function c40009199.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.IsExistingMatchingCard(c40009199.chfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c40009199.chfilter2,tp,LOCATION_MZONE,0,1,nil)
end
end
function c40009199.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009199.chfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c40009199.chfilter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c40009199.chfilter1(c)
	return c:IsType(TYPE_PENDULUM)   
end
function c40009199.chfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:GetSequence()<5
end
function c40009199.chop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
	Duel.Hint(HINT_CARD,0,40009199)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,c40009199.chfilter1,tp,LOCATION_PZONE,0,1,1,nil)
	local tc1=g1:GetFirst()
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectMatchingCard(tp,c40009199.chfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g2)
	local tc2=g2:GetFirst()
		--local seq1=tc1:GetPreviousSequence()
	   -- local seq2=tc2:GetPreviousSequence()
	Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end

end
function c40009199.pencon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009199.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c40009199.penfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xf1c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009199.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c40009199.penfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40009199,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end