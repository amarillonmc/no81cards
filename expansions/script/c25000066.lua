--死骸降灵
function c25000066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c25000066.cost)
	e1:SetTarget(c25000066.target)
	e1:SetOperation(c25000066.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c25000066.cost)
	e2:SetTarget(c25000066.rmtg)
	e2:SetOperation(c25000066.rmop)
	c:RegisterEffect(e2)
end
function c25000066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c25000066.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost() and c:IsFaceupEx()
end
function c25000066.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25000066.gcheck(sg,tp)
	return aux.drccheck(sg) and Duel.GetMZoneCount(tp,sg)>0
end
function c25000066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c25000066.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return g:CheckSubGroup(c25000066.gcheck,2,#g,tp) and Duel.IsExistingMatchingCard(c25000066.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c25000066.gcheck,false,2,#g,tp)
	local ct=Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c25000066.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=e:GetLabel()
	local sct=math.floor(ct/2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c25000066.spfilter,tp,LOCATION_DECK,0,1,sct,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c25000066.tdfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceup()
end
function c25000066.rmfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c25000066.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(c25000066.tdfilter,tp,LOCATION_REMOVED,0,nil)
	local rg=Duel.GetMatchingGroup(c25000066.rmfilter,tp,0,LOCATION_MZONE,nil,tp)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return #tg>0 and #rg>0 and e:GetHandler():IsAbleToRemoveAsCost() end
	e:SetLabel(0)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=tg:SelectSubGroup(tp,aux.drccheck,false,1,#rg)
	local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,ct,1-tp,LOCATION_MZONE)
end
function c25000066.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c25000066.rmfilter,tp,0,LOCATION_MZONE,ct,ct,nil,tp)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
