--星遗物引发的狂乱
function c98920066.initial_effect(c)
		--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c98920066.target)
	e1:SetOperation(c98920066.activate)
	c:RegisterEffect(e1)
end
function c98920066.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c98920066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98920066.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c98920066.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c98920066.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920066.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)~=0 then
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local g=Duel.SelectMatchingCard(tp,c98920066.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		  if g:GetCount()>0 then
			  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		  end
	end
end
function c98920066.spfilter(c,e,tp)
	return c:IsLevel(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end