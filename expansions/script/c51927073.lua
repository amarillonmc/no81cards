--石刻龙的风化侵蚀
function c51927073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,51927073+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c51927073.condition)
	e1:SetTarget(c51927073.target)
	e1:SetOperation(c51927073.activate)
	c:RegisterEffect(e1)
end
function c51927073.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c51927073.thfilter(c)
	return ((c:IsLevelAbove(5) and c:IsType(TYPE_NORMAL)) or (c:IsSetCard(0x6256) and c:IsType(TYPE_MONSTER)) )and c:IsAbleToHand()
end
function c51927073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51927073.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51927073.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function c51927073.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51927073.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c51927073.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(51927073,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local tc=Duel.SelectMatchingCard(tp,c51927073.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e1:SetCode(EVENT_SUMMON_SUCCESS)
				e1:SetOperation(c51927073.checkop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c51927073.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(51927073,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCondition(c51927073.indcon)
	e1:SetValue(c51927073.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	e:Reset()
end
function c51927073.indcon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsLevelAbove(5) and c:IsType(TYPE_NORMAL)
end
function c51927073.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
