--陷阵营救
function c9330011.initial_effect(c)
	aux.AddCodeList(c,9330001)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c9330011.target)
	e1:SetValue(c9330011.indct)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9330011,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,9330011)
	e2:SetTarget(c9330011.sptg1)
	e2:SetOperation(c9330011.spop1)
	c:RegisterEffect(e2)
	--shuffle & draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9330011,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,9330011)
	e3:SetTarget(c9330011.drtg)
	e3:SetOperation(c9330011.drop)
	c:RegisterEffect(e3)
end
function c9330011.target(e,c)
	return c:IsSetCard(0xaf93) and not c:IsCode(9330011)
end
function c9330011.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c9330011.filter(c)
	return c:IsCode(9330001) and c:IsFaceup()
end
function c9330011.spfilter(c,e,tp,check,tid)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetTurnID()==tid and c:IsSetCard(0xaf93)
		and (check or c:IsCode(9330001))
end
function c9330011.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chk1=Duel.IsExistingMatchingCard(c9330011.filter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c9330011.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,chk1,Duel.GetTurnCount())
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9330011,0))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9330011.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local chk1=Duel.IsExistingMatchingCard(c9330011.filter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9330011.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,chk1,Duel.GetTurnCount())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9330011.tdfilter(c)
	return c:IsSetCard(0xaf93) and c:IsAbleToDeck()
end
function c9330011.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9330011.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c9330011.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9330011,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9330011.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9330011.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
