--BB 事象兵器
function c32500512.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetCountLimit(1,32500512)
	e1:SetCost(c32500512.eqcost)
	e1:SetTarget(c32500512.eqtg)
	e1:SetOperation(c32500512.eqop)
	c:RegisterEffect(e1)
	-- Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,32500513)
	e2:SetTarget(c32500512.sptg)
	e2:SetOperation(c32500512.spop)
	c:RegisterEffect(e2)
end
function c32500512.cfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function c32500512.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32500512.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32500512.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c32500512.eqfilter(c,tp)
	return c:IsSetCard(0xae1) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c32500512.eqfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end
function c32500512.eqfilter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xae1) and not c:IsForbidden()
end
function c32500512.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c32500512.eqfilter(chkc,tp) end
	if chk==0 then return Duel.GetFlagEffect(tp,32500512)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c32500512.eqfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c32500512.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0)
end
function c32500512.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32500512.eqfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,ec,tp)
		local ec=g:GetFirst()
		if not ec or not Duel.Equip(tp,ec,tc) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c32500512.eqlimit)
		e1:SetLabelObject(tc)
		ec:RegisterEffect(e1)
	end
end
function c32500512.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c32500512.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c32500512.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
end
function c32500512.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
		Duel.SortDecktop(p,p,1)
	end
end