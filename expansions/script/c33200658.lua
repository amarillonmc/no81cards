--电子音姬 Trance
function c33200658.initial_effect(c)
	c:SetSPSummonOnce(33200658)
	aux.AddXyzProcedureLevelFree(c,c33200658.mfilter,c33200658.xyzcheck,2,2)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200658,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33200658)
	e1:SetCondition(c33200658.ccon)
	e1:SetTarget(c33200658.ctg)
	e1:SetOperation(c33200658.cop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200658,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33200659)
	e2:SetTarget(c33200658.atktg)
	e2:SetOperation(c33200658.atkop)
	c:RegisterEffect(e2)
end
function c33200658.mfilter(c)
	return c:IsRace(RACE_CYBERSE)
end
function c33200658.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end

--e1
function c33200658.ccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33200658.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c33200658.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c33200658.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200658.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c33200658.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c33200658.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:IsControlerCanBeChanged() then
		if tc:IsFaceup() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e3)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_RACE)
			e5:SetValue(RACE_CYBERSE)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e5)
		end
		Duel.GetControl(tc,tp,PHASE_END,2)
	end
end

--e2
function c33200658.atkfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsFaceup()
end
function c33200658.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200658.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c33200658.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c33200658.atkfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(500)
		tc:RegisterEffect(e2)
	end
end