--至高主宰·苍琼
function c11182350.initial_effect(c)
	--immune effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetValue(c11182350.immunefilter)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11182350,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,11182350)
	e1:SetTarget(c11182350.sptg)
	e1:SetOperation(c11182350.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11182350,3))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11182350+1)
	e2:SetCost(c11182350.tdcost)
	e2:SetTarget(c11182350.tdtg)
	e2:SetOperation(c11182350.tdop)
	c:RegisterEffect(e2)
	--sset
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(11182350,4))
	e22:SetCategory(CATEGORY_SSET)
	e22:SetType(EFFECT_TYPE_IGNITION)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCountLimit(1,11182350+1)
	e22:SetCost(c11182350.setcost)
	e22:SetTarget(c11182350.settg)
	e22:SetOperation(c11182350.setop)
	c:RegisterEffect(e22)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetCost(c11182350.cost)
	e3:SetTarget(c11182350.target)
	e3:SetOperation(c11182350.operation)
	c:RegisterEffect(e3)
end
function c11182350.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c11182350.filter(c)
	return c:IsCode(11182350) and c:IsAbleToHand()
end
function c11182350.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182350.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11182350.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11182350.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11182350.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182350.DisCardCostFilter,tp,0x30,0,nil,tp,0x1)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c11182350.CostFilter1,tp,0xc,0,nil,0x1)
	local g4=Duel.GetMatchingGroup(c11182350.CostFilter2,tp,0xc,0,nil,0x1)
	if chk==0 then return g1:GetCount()>0 or #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g1>0,aux.Stringid(11182350,0)},{#g3>0,aux.Stringid(11182350,1)},{#g4>0,aux.Stringid(11182350,2)})
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
function c11182350.setfilter(c)
	return c:IsSetCard(0x6454) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c11182350.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182350.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c11182350.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c11182350.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)>0 then
		if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(11182350,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	end
end
function c11182350.DisCardCostFilter(c,tp,type)
	return c:IsAbleToDeckAsCost() and c:IsHasEffect(11182305,tp) and c:IsType(type)
end
function c11182350.CostFilter1(c,type)
	return c:IsAbleToGraveAsCost() and c:IsType(type)
end
function c11182350.CostFilter2(c,type)
	return c:IsAbleToRemoveAsCost() and c:IsType(type)
end
function c11182350.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182350.DisCardCostFilter,tp,0x30,0,nil,tp,0x6)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c11182350.CostFilter1,tp,0xc,0,nil,0x6)
	local g4=Duel.GetMatchingGroup(c11182350.CostFilter2,tp,0xc,0,nil,0x6)
	if chk==0 then return g1:GetCount()>0 or #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g1>0,aux.Stringid(11182350,0)},{#g3>0,aux.Stringid(11182350,1)},{#g4>0,aux.Stringid(11182350,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		local te=c:IsHasEffect(11182305,tp)
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
function c11182350.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,0x3c,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,0x3c,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c11182350.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,0x3c,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c11182350.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11182350.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1,true)
	end
end
function c11182350.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(ATTRIBUTE_WIND)
end