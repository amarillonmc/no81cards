--赛博空间机甲 光体翼
function c9910432.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9910432.splimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(c9910432.econ)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetValue(c9910432.atlimit)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c9910432.negcon)
	e5:SetOperation(c9910432.negop)
	c:RegisterEffect(e5)
end
function c9910432.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x6950) and se:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9910432.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function c9910432.atlimit(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(1-tp) and c:IsStatus(STATUS_SPSUMMON_TURN) and not c:IsImmuneToEffect(e)
end
function c9910432.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsDefensePos()
end
function c9910432.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910432.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(9910432)<=0
end
function c9910432.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(9910432,0)) then
		Duel.Hint(HINT_CARD,0,9910432)
		if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c9910432.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,c9910432.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEUP_ATTACK)
		end
		e:GetHandler():RegisterFlagEffect(9910432,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
