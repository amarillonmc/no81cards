--共难的远古造物
dofile("expansions/script/c9910700.lua")
function c9911751.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911751+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9911751.cost)
	e1:SetTarget(c9911751.target)
	e1:SetOperation(c9911751.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911751,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c9911751.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c9911751.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (not c:IsLocation(LOCATION_HAND)
		or Duel.IsExistingMatchingCard(c9911751.cfilter,tp,LOCATION_ONFIELD,0,1,c)) end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9911751.cfilter,tp,LOCATION_ONFIELD,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c9911751.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c9911751.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911751.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9911751.tdfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c9911751.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911751.tdfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if ct>0 then
			Duel.SetLP(tp,Duel.GetLP(tp)-ct*1100)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabel()~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c9911751.setop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9911751.setfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and QutryYgzw.SetFilter(c,e,tp)
end
function c9911751.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911751)
	local ct=Duel.GetMatchingGroupCount(aux.NecroValleyFilter(c9911751.setfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ct=math.min(ct,ft,3)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911751.setfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,ct,ct,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		QutryYgzw.Set2(sg,e,tp)
	end
end
