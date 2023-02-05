--月神的天桥
function c9910065.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910065)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c9910065.target)
	e1:SetOperation(c9910065.activate)
	c:RegisterEffect(e1)
end
function c9910065.filter(c)
	return c:IsRace(RACE_FAIRY) and c:IsFaceup()
end
function c9910065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910065.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c9910065.cfilter(c)
	if c:IsFacedown() then return false end
	local og=c:GetOverlayGroup()
	return c:IsType(TYPE_XYZ) and og and og:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and c:GetRace()>0
end
function c9910065.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910065.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	if not tc then return end
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local ag=Duel.GetMatchingGroup(c9910065.cfilter,tp,LOCATION_MZONE,0,nil)
	if ag:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(9910065,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=ag:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
		e1:SetValue(sg:GetFirst():GetAttribute())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
