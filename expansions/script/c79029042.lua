--黑钢国际·行动-目标护送
function c79029042.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetTarget(c79029042.destg)
	e0:SetOperation(c79029042.desop)
	c:RegisterEffect(e0)
	--to deck and draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(79029042,1))
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029042.tdtg)
	e2:SetOperation(c79029042.tdop)
	c:RegisterEffect(e2)
end
function c79029042.sfilter(c)
	return c:IsSetCard(0xa900) and c:IsAbleToHand()
end
function c79029042.sfilter2(c,e,tp)
	return c:IsSetCard(0x1904) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029042.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79029042.sfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029042.sfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c79029042.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c79029042.sfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local a=Duel.SelectMatchingCard(tp,c79029042.sfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,a,1,0,0)
	g:Merge(a)
	Duel.SetTargetCard(g)
end
function c79029042.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local tc2=g:Filter(aux.TRUE,tc1)
	Duel.SendtoHand(tc1,nil,REASON_EFFECT)
	Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
end
function c79029042.filter(c)
	return c:IsSetCard(0xa900) and c:IsAbleToDeck() and c:GetFlagEffect(79029042)==0  
end
function c79029042.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c79029042.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingTarget(c79029042.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local xg=Duel.SelectTarget(tp,c79029042.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,xg,xg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c79029042.tdop(e,tp,eg,ep,ev,re,r,rp)
	local xg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not xg or xg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(xg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)	
	end 
	local tc=xg:GetFirst()
	while tc do
	tc:RegisterFlagEffect(79029042,RESET_PHASE+PHASE_END,0,1)
	tc=xg:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c79029042.val)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)  
end
function c79029042.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 0
	else return dam end
end



























