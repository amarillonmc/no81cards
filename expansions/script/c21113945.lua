--芳青之梦 与共
function c21113945.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(c21113945.actcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,21113945)
	e1:SetTarget(c21113945.tg)
	e1:SetOperation(c21113945.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,21113946)
	e2:SetCost(c21113945.cost2)
	e2:SetTarget(c21113945.tg2)
	e2:SetOperation(c21113945.op2)
	c:RegisterEffect(e2)	
end
function c21113945.act(c)
	return c:IsFaceup() and c:IsSetCard(0xc914) and c:IsDisabled()
end
function c21113945.actcon(e)
	return Duel.IsExistingMatchingCard(c21113945.act,e:GetHandlerPlayer(),4,0,1,nil)
end
function c21113945.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0x30,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0x30,0,1,6,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,0x30)
end
function c21113945.q(c,e,tp,link)
	return Duel.GetLocationCountFromEx(tp)>0 and c:IsSetCard(0xc914) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and c:IsType(TYPE_LINK) and c:IsLink(link)
end
function c21113945.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
	local s=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local sg=Duel.GetMatchingGroup(c21113945.q,tp,LOCATION_EXTRA,0,nil,e,tp,s)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(21113945,0)) then
		Duel.BreakEffect()
		Duel.Hint(3,tp,HINTMSG_SPSUMMON)
		local rg=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(rg,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		rg:GetFirst():CompleteProcedure()
		end
	end
end
function c21113945.w(c)
	return c:IsSetCard(0xc914) and c:IsType(1) and c:IsAbleToRemoveAsCost()
end
function c21113945.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c21113945.w,tp,0x10,0,1,c) end
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21113945.w,tp,0x10,0,1,1,c)
	g:Merge(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21113945.e(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c21113945.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21113945.e,tp,0,12,1,nil) end
	Duel.Hint(3,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c21113945.e,tp,0,12,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,1-tp,12)	
end
function c21113945.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end