--异天枝-加百列
function c22060190.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060190,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,22060190)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c22060190.cost)
	e1:SetTarget(c22060190.atktg)
	e1:SetOperation(c22060190.atkop1)
	c:RegisterEffect(e1)
end
function c22060190.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22060190.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c22060190.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(900)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
		if Duel.GetMatchingGroupCount(c22060190.ctfilter,tp,0,LOCATION_MZONE,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(22060190,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local g1=Duel.SelectMatchingCard(tp,c22060190.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
			if g1:GetCount()>0 then
				Duel.HintSelection(g1)
				Duel.GetControl(g1,tp)
			end
		end
	end
end
function c22060190.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and c:GetBaseAttack()<=900
end