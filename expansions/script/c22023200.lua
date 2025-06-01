--古生物的骚动
function c22023200.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023200+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22023200.target)
	e1:SetOperation(c22023200.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023200,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22023200.cost)
	e2:SetTarget(c22023200.sptg)
	e2:SetOperation(c22023200.spop)
	c:RegisterEffect(e2)
end
function c22023200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22023200.filter1(c,e,sp)
	return c:IsCode(22023140) and c:IsFaceup()
end
function c22023200.filter2(c,e,sp)
	return c:IsSetCard(0xff1)
end
function c22023200.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg1=Duel.GetMatchingGroupCount(c22023200.filter1,tp,LOCATION_ONFIELD,0,nil)
	local tg2=Duel.GetMatchingGroupCount(c22023200.filter2,tp,LOCATION_DECK,0,nil)
		if tg1>0 and tg2>0 and Duel.SelectYesNo(tp,aux.Stringid(22023200,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22023200,1))
			local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,6,nil,0xff1)
			if g:GetCount()>0 then
				Duel.ConfirmCards(1-tp,g)
				Duel.ShuffleDeck(tp)
				local tc=g:GetFirst()
				while tc do
					Duel.MoveSequence(tc,SEQ_DECKTOP)
					tc=g:GetNext()
				end
				Duel.SortDecktop(tp,tp,g:GetCount())
		end
	end
end
function c22023200.costfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c22023200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023200.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22023200.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22023200.spfilter(c,e,tp)
	return c:IsSetCard(0xff1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22023200.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22023200.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22023200.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22023200.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end