local m=53750016
local cm=_G["c"..m]
cm.name="异律回廊"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetLabel(1)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end
function cm.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and (c:IsRace(RACE_REPTILE) or c:IsSetCard(0x9532)) and c:IsAbleToDeckAsCost()
end
function cm.tgfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToGrave()
end
function cm.thfilter(c)
	return c:IsSetCard(0x9532) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.fselect(g,tp)
	local ct=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	return (ct==0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)) or (ct==1 and Duel.IsPlayerCanDraw(tp,1)) or (ct==2 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil))
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:CheckSubGroup(cm.fselect,2,2,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_COST)
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsType,nil,TYPE_MONSTER)
		if ct==0 then
			e:SetCategory(CATEGORY_TOGRAVE)
			e:SetProperty(0)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		elseif ct==1 then
			e:SetCategory(CATEGORY_DRAW)
			e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(1)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		else
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e:SetProperty(0)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		end
		e:SetLabel(ct+1)
		e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	elseif e:GetLabel()==2 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and g:CheckSubGroup(cm.fselect,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_COST)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsType,nil,TYPE_MONSTER)
	if ct==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif ct==1 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	e:SetLabel(ct+1)
	e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsPreviousControler(c:GetOwner()) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function cm.filter1(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_REPTILE) and c:IsAbleToHand()
end
function cm.filter2(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x9532) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	g:Merge(g2)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
