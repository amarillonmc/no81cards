--淫梦的 普露梅西亚
function c75075604.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75075604,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75075604)
	e1:SetCondition(c75075604.spcon1)
	e1:SetTarget(c75075604.hsptg)
	e1:SetOperation(c75075604.hspop)
	c:RegisterEffect(e1) 
	local e0=e1:Clone()
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetCondition(c75075604.spcon2)
	c:RegisterEffect(e0)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075604,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75075605)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c75075604.postg)
	e2:SetOperation(c75075604.posop)
	c:RegisterEffect(e2)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetCondition(c75075604.atkcon)
	e4:SetTarget(c75075604.disable)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c75075604.atkcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsFacedown))
	e3:SetValue(c75075604.efilter)
	c:RegisterEffect(e3)
end
function c75075604.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
end
function c75075604.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
end
function c75075604.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c75075604.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c75075604.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c75075604.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c75075604.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c75075604.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
--
function c75075604.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanChangePosition() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c75075604.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
--
function c75075604.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c75075604.disable(e,c)
	local seq=aux.MZoneSequence(c:GetSequence())
	return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil,seq)
end
--
function c75075604.efilter(e,te)
	return not te:IsSetCard(0x757)
end
