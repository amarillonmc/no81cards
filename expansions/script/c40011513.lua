--监视鸟遣使 影潜者 奥恩法
function c40011513.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c40011513.transcon)
	e2:SetOperation(c40011513.transop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,40011513)
	e3:SetCost(c40011513.thcost)
	e3:SetTarget(c40011513.thtg)
	e3:SetOperation(c40011513.thop)
	c:RegisterEffect(e3)
end
function c40011513.dfilter(c)
	return c:IsSetCard(0xaf1b) and c:IsDiscardable()
end
function c40011513.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c40011513.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c40011513.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c40011513.filter1(c)
	return c:IsCode(40011525) and c:IsAbleToHand()
end
function c40011513.filter2(c)
	return c:IsSetCard(0xaf1b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(40011513)
end
function c40011513.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011513.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c40011513.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c40011513.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c40011513.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c40011513.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end
function c40011513.transcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalCode()==40011513 and c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
end
function c40011513.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(9911632,true)
	c:ReplaceEffect(9911632,0,0)
end
