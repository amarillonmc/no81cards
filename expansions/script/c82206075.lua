local m=82206075
local cm=_G["c"..m]
cm.name="大暗黑天"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--change effect type  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCode(m)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(1,0)  
	c:RegisterEffect(e2)  
	--ret&draw  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_FZONE)  
	e3:SetCountLimit(1)   
	e3:SetTarget(cm.target)  
	e3:SetOperation(cm.operation)  
	c:RegisterEffect(e3)
end
function cm.setfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x29c) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() 
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local sg=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=sg:GetFirst()  
		if tc then  
			if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())  
				e1:SetType(EFFECT_TYPE_SINGLE)  
				e1:SetCode(EFFECT_CANNOT_TRIGGER)  
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
				tc:RegisterEffect(e1)  
			end   
		end  
	end
end
function cm.filter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x29c) and c:IsAbleToDeck()   and c:IsFaceup()
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc) end  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,3,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,3,3,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp) 
	if not e:GetHandler():IsRelateToEffect(e) then return end   
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end  
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)  
	local g=Duel.GetOperatedGroup()  
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end  
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)  
	if ct==3 then  
		Duel.BreakEffect()  
		Duel.Draw(tp,1,REASON_EFFECT)  
	end  
end  