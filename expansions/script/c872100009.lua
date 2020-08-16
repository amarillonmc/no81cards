--永夜抄·人民教师
function c872100009.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(872100009,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,872100009)
	e5:SetTarget(c872100009.destg)
	e5:SetOperation(c872100009.desop)
	c:RegisterEffect(e5)
end
function c872100009.thfilter(c)
	return c:IsSetCard(0xba1) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c872100009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c872100009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c872100009.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c872100009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9872100009,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(872100009,1))
end
