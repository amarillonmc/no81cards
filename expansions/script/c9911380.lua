--雪狱之罪哀 梅杜萨之筏
function c9911380.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911380)
	e1:SetCost(c9911380.cost)
	e1:SetTarget(c9911380.target)
	e1:SetOperation(c9911380.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911381)
	e2:SetCondition(c9911380.tgcon)
	e2:SetCost(c9911380.tgcost)
	e2:SetTarget(c9911380.tgtg)
	e2:SetOperation(c9911380.tgop)
	c:RegisterEffect(e2)
end
function c9911380.cffilter(c)
	return c:IsSetCard(0xc956) and not c:IsPublic()
end
function c9911380.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9911380.cffilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c9911380.cffilter,tp,LOCATION_HAND,0,1,1,c):GetFirst()
	tc:RegisterFlagEffect(9911380,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function c9911380.tffilter(c,tp)
	return c:IsCode(9911367) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c9911380.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911380.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c9911380.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=Duel.SelectMatchingCard(tp,c9911380.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #tg>0 then
		local tc=tg:GetFirst()
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		if Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then
			tc:RegisterFlagEffect(9911382,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911380,0))
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetRange(LOCATION_FZONE)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
			e1:SetValue(ATTRIBUTE_WATER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,9911381,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911380.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911381)==0
end
function c9911380.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9911380.tgfilter(c)
	return c:IsSetCard(0xc956) and c:IsAbleToGrave()
end
function c9911380.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911380.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9911380.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9911380.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911380,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
