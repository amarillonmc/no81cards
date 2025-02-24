--Good Hello 鹿乃
function c75646413.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75646413)
	e1:SetCost(c75646413.cost)
	e1:SetTarget(c75646413.tg)
	e1:SetOperation(c75646413.op)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCost(c75646413.spcost)
	e2:SetTarget(c75646413.sptg)
	e2:SetOperation(c75646413.spop)
	c:RegisterEffect(e2)
end
function c75646413.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_ONFIELD 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then loc=LOCATION_MZONE end
	if chk==0 then return e:GetHandler():GetFlagEffect(75646413)==0 and Duel.IsExistingMatchingCard(c75646413.cfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c75646413.cfilter,tp,loc,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
	e:GetHandler():RegisterFlagEffect(75646413,RESET_CHAIN,0,1)   
end
function c75646413.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x32c4) 
		and c:IsAbleToDeckOrExtraAsCost()
end
function c75646413.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75646413.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
end
function c75646413.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil)==1 end
	if g:GetFirst():IsSetCard(0x32c4) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646413.filter(c)
	return c:IsSetCard(0x32c4) and (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck() or c:IsFaceup())
end
function c75646413.filter2(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck() or c:IsFaceup()
end
function c75646413.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c75646413.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646413.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c75646413.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c75646413.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,0,2,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,2) then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function c75646413.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg then return end
	if tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()>0	  then
		Duel.SendtoDeck(tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE),nil,2,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) 
		end
	end
	if tg:Filter(Card.IsLocation,nil,LOCATION_REMOVED):GetCount()>0 then
		Duel.SendtoGrave(tg:Filter(Card.IsLocation,nil,LOCATION_REMOVED),REASON_EFFECT+REASON_RETURN)
	end
	if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(75646413,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end