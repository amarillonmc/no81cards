--不朽的守护者
function c49811388.initial_effect(c)
	aux.AddCodeList(c,34022290)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,49811388)
	e1:SetCost(c49811388.cost)
	e1:SetTarget(c49811388.target)
	e1:SetOperation(c49811388.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811389)
	e2:SetCost(c49811388.negcost)
	e2:SetCondition(c49811388.negcon)
	e2:SetTarget(c49811388.negtg)
	e2:SetOperation(c49811388.negop)
	c:RegisterEffect(e2)
end
function c49811388.costfilter(c,e,tp)
	local eg=c:GetEquipGroup()
	local cg=Group.FromCards(c,e:GetHandler())
	cg:Merge(eg)
	return c:IsCode(34022290) and c:IsAbleToHandAsCost() and eg:FilterCount(Card.IsAbleToHandAsCost,nil)==#eg and #eg>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,cg) and c:IsFaceup()
end
function c49811388.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811388.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c49811388.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	local cg=tc:GetEquipGroup()
	cg:AddCard(tc)
	Duel.SendtoHand(cg,nil,REASON_COST)
end
function c49811388.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)==0 then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	end
end
function c49811388.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c49811388.pcfilter(c)
	return c:IsSetCard(0x52) and c:IsType(TYPE_MONSTER) and c:IsPublic() and c:IsAbleToDeckAsCost()
end
function c49811388.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811388.pcfilter,tp,LOCATION_HAND,0,1,nil)
	and e:GetHandler():IsAbleToDeckAsCost() end
	local tc=Duel.SelectMatchingCard(tp,c49811388.pcfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local tg=Group.FromCards(tc,e:GetHandler())
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c49811388.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp==1-tp
end
function c49811388.spfilter(c,e,tp)
	return c:IsSetCard(0x52) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and ((c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0)
	 or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function c49811388.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811388.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)==0 then
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	end
end
function c49811388.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c49811388.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
