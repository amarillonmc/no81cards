function c82221048.initial_effect(c)
	--Activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)	
	c:RegisterEffect(e0)
	--atk&def  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetRange(LOCATION_SZONE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetValue(c82221048.atkval)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e2)  
	--Remove
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(82221048,0))  
	e5:SetCategory(CATEGORY_REMOVE)  
	e5:SetType(EFFECT_TYPE_QUICK_O) 
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetRange(LOCATION_SZONE)  
	e5:SetCost(c82221048.tgcost)  
	e5:SetTarget(c82221048.tgtg)  
	e5:SetOperation(c82221048.tgop)  
	c:RegisterEffect(e5)  
end  
function c82221048.atkfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)  
end  
function c82221048.atkval(e,c)  
	local g=Duel.GetMatchingGroup(c82221048.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)  
	return g:GetCount()*100  
end 
 
function c82221048.costfilter1(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9f) and c:IsAbleToRemoveAsCost()  
end  
function c82221048.costfilter2(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10db) and c:IsAbleToRemoveAsCost()  
end  
function c82221048.costfilter3(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2016) and c:IsAbleToRemoveAsCost()  
end  
function c82221048.costfilter4(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10f3) and c:IsAbleToRemoveAsCost()  
end  
function c82221048.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(c82221048.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)  
	local tc=nil  
	if g:GetCount()==1 and g:GetFirst():IsLocation(LOCATION_HAND) then tc=g:GetFirst() end  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221048.costfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,tc)  
		and Duel.IsExistingMatchingCard(c82221048.costfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,tc)   and Duel.IsExistingMatchingCard(c82221048.costfilter3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,tc)   and Duel.IsExistingMatchingCard(c82221048.costfilter4,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,tc) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g1=Duel.SelectMatchingCard(tp,c82221048.costfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,tc)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g2=Duel.SelectMatchingCard(tp,c82221048.costfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,tc)  
	g1:Merge(g2)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g3=Duel.SelectMatchingCard(tp,c82221048.costfilter3,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,tc)  
	g1:Merge(g3)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g4=Duel.SelectMatchingCard(tp,c82221048.costfilter4,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,tc)  
	g1:Merge(g4)  
	Duel.Remove(g1,POS_FACEUP,REASON_COST)  
end  
function c82221048.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)  
end  
function c82221048.tgop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,nil)  
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
end  