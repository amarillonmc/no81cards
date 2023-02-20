--晚会上的邂逅，是你我命运之始
function c12852106.initial_effect(c)
	aux.AddCodeList(c,12852102)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12852108+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c12852106.condition)
	e1:SetTarget(c12852106.target)
	e1:SetOperation(c12852106.activate)
	c:RegisterEffect(e1)	
end
function c12852106.cfilter(c)
	return c:IsFaceup() and c:IsCode(12852102)
end
function c12852106.cfilter1(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_SPELLCASTER) and Duel.IsExistingMatchingCard(c12852106.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c12852106.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xa77) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c12852106.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12852106.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12852106.filter(c)
	return c:IsCode(12852102) and c:IsAbleToHand()
end
function c12852106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12852106.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12852106.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12852106.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c12852106.cfilter1,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(12852106,1)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c12852106.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
			if g:GetCount()>0 then
				local tc=g:GetFirst()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local g1=Duel.SelectMatchingCard(tp,c12852106.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
				if g1:GetCount()>0 then
					Duel.Equip(tp,g1:GetFirst(),tc)
				end
			end
		end
	end
end