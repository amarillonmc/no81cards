--漂泊新月世界的归航
function c9911273.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9911273+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911273.target)
	e1:SetOperation(c9911273.activate)
	c:RegisterEffect(e1)
	--recycle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911273,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c9911273.mvcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9911273.mvtg)
	e2:SetOperation(c9911273.mvop)
	c:RegisterEffect(e2)
end
function c9911273.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9956) and c:IsControlerCanBeChanged()
end
function c9911273.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9911273.ctfilter(chkc) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingTarget(c9911273.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c9911273.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c9911273.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	if Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.GetControl(tc,1-tp,PHASE_END,1)
	end
end
function c9911273.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler())
end
function c9911273.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911273.cfilter,1,nil)
end
function c9911273.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9956) and c:IsAbleToDeck() and not c:IsCode(9911273)
end
function c9911273.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c9911273.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingTarget(c9911273.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct>3 then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9911273.tdfilter,tp,LOCATION_REMOVED,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
	Duel.SetChainLimit(aux.FALSE)
end
function c9911273.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		local ct=Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		if ct>0 then
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end
