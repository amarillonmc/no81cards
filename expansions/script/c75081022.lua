--妖艳之花 卡米拉-罪秽装束
function c75081022.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75c),6,2,c75081022.ovfilter,aux.Stringid(75081022,0),2,c75081022.xyzop)
	c:EnableReviveLimit() 
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081022,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75081022)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c75081022.tdtg)
	e1:SetOperation(c75081022.tdop)
	c:RegisterEffect(e1)  
end
function c75081022.ovfilter(c)
	return c:IsFaceup() and c:IsCode(75000705)
end
function c75081022.cfilter(c)
	return c:IsSetCard(0x75c) and c:IsDiscardable()
end
function c75081022.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75081022)==0 and Duel.IsExistingMatchingCard(c75081022.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c75081022.cfilter,1,1,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,75081022,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--
function c75081022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x75c) and c:IsAbleToDeck()
end
function c75081022.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c75081022.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(c75081022.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c75081022.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c75081022.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetBaseAttack())
		c:RegisterEffect(e1)
	end
end