--枪塔的守护天使
function c67200706.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200706,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c67200706.condition)
	e2:SetOperation(c67200706.operation)
	c:RegisterEffect(e2)		
end
--
function c67200706.condition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c67200706.thfilter2(c)
	return c:IsSetCard(0x67f) and c:IsAbleToHand()
end
function c67200706.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 or not e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) then return end
	if re:GetHandler():IsRelateToEffect(re) and Duel.SelectYesNo(tp,aux.Stringid(67200706,1)) then
		if Duel.NegateActivation(ev)~=0 then
			Duel.Destroy(eg,REASON_EFFECT)
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			if Duel.IsExistingMatchingCard(c67200706.thfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(67200706,4)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,c67200706.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
