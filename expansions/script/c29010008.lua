--三个猎人走上海岸
function c29010008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c29010008.target)
	e1:SetOperation(c29010008.activate)
	c:RegisterEffect(e1)	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c29010008.handcon)
	c:RegisterEffect(e2)
end
function c29010008.handcon(e)
	return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_MZONE,1,nil,ATTRIBUTE_WATER)
end
function c29010008.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29010008.ctfil(c)
	return c:IsAbleToDeck() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c29010008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29010008.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)) or (Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_WATER):GetClassCount(Card.GetOriginalCode)>=3 and Duel.GetMatchingGroup(c29010008.ctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil):GetClassCount(Card.GetCode)>=3 and Duel.IsPlayerCanDraw(tp,2)) end
	if (Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_WATER):GetClassCount(Card.GetOriginalCode)>=3 and Duel.GetMatchingGroup(c29010008.ctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil):GetClassCount(Card.GetCode)>=3 and Duel.IsPlayerCanDraw(tp,2)) and Duel.SelectYesNo(tp,aux.Stringid(29010008,0)) then 
	e:SetLabel(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	else
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
end
function c29010008.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then 
	g=Duel.GetMatchingGroup(c29010008.ctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetClassCount(Card.GetCode)<3 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	g1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp) 
	Duel.Draw(tp,2,REASON_EFFECT)   
	else
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29010008.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end











