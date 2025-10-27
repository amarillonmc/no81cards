--虹龍·双头龙
function c11185245.initial_effect(c)
	aux.AddCodeList(c,0x452)
	c:EnableCounterPermit(0x452)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x453,0x452),1,1)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11185245,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11185245)
	e1:SetCost(c11185245.cost)
	e1:SetTarget(c11185245.settg)
	e1:SetOperation(c11185245.setop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11185245,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11185245+1)
	e2:SetTarget(c11185245.tdtg)
	e2:SetOperation(c11185245.tdop)
	c:RegisterEffect(e2)
end
function c11185245.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x452,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x452,1,REASON_COST)
end
function c11185245.setfilter(c)
	return c:IsSetCard(0x453) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c11185245.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11185245.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11185245,1))
end
function c11185245.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c11185245.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c11185245.tdfilter(c)
	return c:IsSetCard(0x453) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c11185245.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11185245.tdfilter,tp,0x3a,0,1,nil) end
	local g=Duel.GetMatchingGroup(c11185245.tdfilter,tp,0x3a,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11185245,2))
end
function c11185245.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,c11185245.tdfilter,tp,0x3a,0,1,5,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			if Duel.SelectYesNo(tp,aux.Stringid(11185245,0)) then e:GetHandler():AddCounter(0x452,1) end
		end
	end
end