--勇者小伊丽的冒险
function c77096009.initial_effect(c)
	aux.AddCodeList(c,77096005) 
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77096009,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,77096009+EFFECT_COUNT_CODE_OATH) 
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(77032549) end,tp,LOCATION_MZONE,0,1,nil) end) 
	e1:SetTarget(c77096009.actg1)
	e1:SetOperation(c77096009.acop1)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(77096009,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,77096009+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c77096009.actg2)
	e1:SetOperation(c77096009.acop2)
	c:RegisterEffect(e1)
end 
function c77096009.actg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
end
function c77096009.acop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c77096009.filter(c,e,tp)
	return c:IsCode(77032549) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77096009.actg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77096009.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77096009.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77096009.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end





