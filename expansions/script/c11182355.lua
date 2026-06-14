--至高主宰·京玉
function c11182355.initial_effect(c)
	--immune effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetValue(c11182355.immunefilter)
	c:RegisterEffect(e0)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DISCARD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11182355)
	e1:SetTarget(c11182355.sptg)
	e1:SetOperation(c11182355.spop)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e11)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11182355,3))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11182355+1)
	e2:SetCost(c11182355.tgcost)
	e2:SetTarget(c11182355.tgtg)
	e2:SetOperation(c11182355.tgop)
	c:RegisterEffect(e2)
	--
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(11182355,4))
	e22:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e22:SetType(EFFECT_TYPE_IGNITION)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCountLimit(1,11182355+1)
	e22:SetCost(c11182355.rmcost)
	e22:SetTarget(c11182355.rmtg)
	e22:SetOperation(c11182355.rmop)
	c:RegisterEffect(e22)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetCost(c11182355.cost)
	e3:SetTarget(c11182355.target)
	e3:SetOperation(c11182355.operation)
	c:RegisterEffect(e3)
end
function c11182355.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c11182355.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c11182355.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		local c=e:GetHandler()
		if c:IsRelateToChain() then
			Duel.SendtoHand(c,nil,0x40)
		end
	end
end
function c11182355.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182355.DisCardCostFilter,tp,0x30,0,nil,tp,0x1)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c11182355.CostFilter1,tp,0xc,0,nil,0x1)
	local g4=Duel.GetMatchingGroup(c11182355.CostFilter2,tp,0xc,0,nil,0x1)
	if chk==0 then return g1:GetCount()>0 or #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g1>0,aux.Stringid(11182355,0)},{#g3>0,aux.Stringid(11182355,1)},{#g4>0,aux.Stringid(11182355,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		local te=tc:IsHasEffect(11182305,tp)
		if te then
			te:UseCountLimit(tp)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT+REASON_REPLACE)
		else
			Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,0x80)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g4:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,0x80)
	end
end
function c11182355.rmfilter(c)
	return c:IsSetCard(0x6454) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c11182355.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182355.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11182355.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c11182355.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c11182355.DisCardCostFilter(c,tp,type)
	return c:IsAbleToDeckAsCost() and c:IsHasEffect(11182305,tp) and c:IsType(type)
end
function c11182355.CostFilter1(c,type)
	return c:IsAbleToGraveAsCost() and c:IsType(type)
end
function c11182355.CostFilter2(c,type)
	return c:IsAbleToRemoveAsCost() and c:IsType(type)
end
function c11182355.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182355.DisCardCostFilter,tp,0x30,0,nil,tp,0x6)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c11182355.CostFilter1,tp,0xc,0,nil,0x6)
	local g4=Duel.GetMatchingGroup(c11182355.CostFilter2,tp,0xc,0,nil,0x6)
	if chk==0 then return g1:GetCount()>0 or #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g1>0,aux.Stringid(11182355,0)},{#g3>0,aux.Stringid(11182355,1)},{#g4>0,aux.Stringid(11182355,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		local te=tc:IsHasEffect(11182305,tp)
		if te then
			te:UseCountLimit(tp)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT+REASON_REPLACE)
		else
			Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,0x80)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g4:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,0x80)
	end
end
function c11182355.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0xc,0xc,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0xc,0xc,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c11182355.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0xc,0xc,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c11182355.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11182355.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11182355.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end