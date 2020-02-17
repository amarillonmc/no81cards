--激帝国歌劇団 ！
function c9950976.initial_effect(c)
	aux.AddCodeList(c,9950973,9950974,9950975)
	aux.AddRitualProcGreater2(c,c9950976.ritual_filter,LOCATION_GRAVE+LOCATION_HAND,nil,c9950976.mfilter)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c9950976.thcon)
	e2:SetCost(c9950976.thcost)
	e2:SetTarget(c9950976.thtg)
	e2:SetOperation(c9950976.thop)
	c:RegisterEffect(e2)
end
function c9950976.ritual_filter(c,e,tp,m1,m2,ft)
	return c:IsLevelAbove(10)
end
function c9950976.mfilter(c)
	return c:IsCode(9950973,9950974,9950975)
end
function c9950976.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c9950976.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToRemoveAsCost()
end
function c9950976.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9950976.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950976.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950976.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c9950976.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950976.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950976.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950976.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
