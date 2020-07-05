--黑钢国际·行动-目标护送
function c79029042.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c79029042.destg)
	e0:SetOperation(c79029042.desop)
	c:RegisterEffect(e0)
	--to deck and draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(73594093,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79029042)
	e2:SetTarget(c79029042.tdtg)
	e2:SetOperation(c79029042.tdop)
	c:RegisterEffect(e2)
end
function c79029042.sfilter(c)
	return c:IsSetCard(0xa900)
end
function c79029042.sfilter2(c,e,tp)
	return c:IsSetCard(0x1904) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029042.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	   if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79029042.sfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029042.sfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c79029042.sfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	q=Duel.GetFirstTarget()
	Duel.SendtoHand(q,tp,REASON_EFFECT) 
	local a=Duel.SelectTarget(tp,c79029042.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,a,1,0,0)
end
function c79029042.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029042.filter(c)
	return c:IsSetCard(0xa900) and c:IsAbleToDeck()
end
function c79029042.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c79029042.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c79029042.filter,tp,LOCATION_GRAVE,0,3,nil) end
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c79029042.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c79029042.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT,REASON_COST)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
		
	end
end