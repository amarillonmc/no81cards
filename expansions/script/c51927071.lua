--石刻龙的喷发冷凝
function c51927071.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c51927071.target)
	e1:SetOperation(c51927071.activate)
	c:RegisterEffect(e1)
end
function c51927071.thfilter(c)
	return ((c:IsLevelAbove(5) and c:IsType(TYPE_NORMAL)) or (c:IsSetCard(0x6256) and c:IsType(TYPE_MONSTER)) )and c:IsAbleToHand()
end
function c51927071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51927071.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51927071.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function c51927071.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51927071.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c51927071.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(51927071,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local tc=Duel.SelectMatchingCard(tp,c51927071.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
			if tc then
				Duel.Summon(tp,tc,true,nil)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e1:SetCode(EVENT_SUMMON_SUCCESS)
				e1:SetOperation(c51927071.checkop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c51927071.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(51927071,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCondition(c51927071.indcon)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	e:Reset()
end
function c51927071.indcon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsLevelAbove(5) and c:IsType(TYPE_NORMAL)
end
