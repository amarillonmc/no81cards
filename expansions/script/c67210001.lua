--遗品的支配术偶
function c67210001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spell/trap Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67210001,0))  
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCost(c67210001.cost)  
	e1:SetTarget(c67210001.target)
	e1:SetOperation(c67210001.operation)
	c:RegisterEffect(e1)
end
c67210001.SetCard_Relics=true 
function c67210001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67210001.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c67210001.filter1(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c67210001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c67210001.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67210001.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c67210001.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67210001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c67210001.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,tc) and Duel.SelectYesNo(tp,aux.Stringid(67210001,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67210001.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,tc)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
  

