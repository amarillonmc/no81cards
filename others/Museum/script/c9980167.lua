--魔法纪录·灵魂宝石
function c9980167.initial_effect(c)
	 --counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980167,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9980167)
	e1:SetCost(c9980167.cost)
	e1:SetTarget(c9980167.target)
	e1:SetOperation(c9980167.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980167,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,99801670)
	e2:SetCost(c9980167.spcost)
	e2:SetTarget(c9980167.sptg)
	e2:SetOperation(c9980167.spop)
	c:RegisterEffect(e2)
end
c9980167.counter_add_list={0x1}
function c9980167.cosfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbc4) and c:IsAbleToGraveAsCost()
end
function c9980167.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c9980167.cosfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9980167.cosfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9980167.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c9980167.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9980167.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980167.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9980167.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x1,g:GetFirst():GetLevel())
end
function c9980167.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=tc:GetLevel()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and ct>0 then
		tc:AddCounter(0x1,ct)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980167,0))
end
function c9980167.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xbc4) and c:IsAbleToRemoveAsCost()
end
function c9980167.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9980167.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9980167.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9980167.spfilter(c,e,tp)
	return c:IsSetCard(0x3bc4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980167.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980167.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9980167.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980167.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
