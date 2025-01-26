--心象风景 期望
function c19209553.initial_effect(c)
	aux.AddCodeList(c,19209513)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c19209553.condition)
	e1:SetTarget(c19209553.target)
	e1:SetOperation(c19209553.activate)
	c:RegisterEffect(e1)
end
function c19209553.chkfilter(c)
	return c:IsCode(19209513) and c:IsFaceup()
end
function c19209553.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209553.chkfilter,tp,LOCATION_MZONE,0,1,nil)
		and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function c19209553.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c19209553.atkfilter(c)
	return c:SetCode(0xb50) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c19209553.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.GetMatchingGroupCount(c19209553.atkfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(-ct*200)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
