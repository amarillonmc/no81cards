--兔符『因幡的白兔』
function c11200067.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200067+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11200067.con1)
	e1:SetCost(c11200067.cost1)
	e1:SetTarget(c11200067.tg1)
	e1:SetOperation(c11200067.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DRAW_COUNT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(2)
	c:RegisterEffect(e3)
--
end
--
c11200067.xig_ihs_0x133=1
--
function c11200067.con1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLocation(LOCATION_HAND)
end
--
function c11200067.cfilter1(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c11200067.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200067.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c11200067.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local sg2=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,sg)
	sg:Merge(sg2)
	Duel.Release(sg,REASON_COST)
end
--
function c11200067.tfilter1(c)
	return c:IsAbleToHand() and (c:IsCode(11200067) or c.xig_ihs_0x133)
end
function c11200067.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200067.tfilter1,tp,LOCATION_DECK,0,1,nil) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c11200067.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11200067.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local off=1
		local ops={}
		local opval={}
		local b1=Duel.IsPlayerCanDraw(tp,1)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
		if b1 then
			ops[off]=aux.Stringid(11200067,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11200067,1)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		local sel=opval[op]
		if sel==1 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if sel==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
			if sg:GetCount()<1 then return end
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
--
