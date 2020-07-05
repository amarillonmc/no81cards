local m=82206048
local cm=_G["c"..m]
cm.name="植占师7-灯台"
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(cm.synfilter),1)  
	c:EnableReviveLimit()
	--ret&draw  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,m)   
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)
	--negate  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_DISABLE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)  
	e2:SetCountLimit(1,82216048)  
	e2:SetTarget(cm.target2)  
	e2:SetOperation(cm.operation2)  
	c:RegisterEffect(e2)	 
end
function cm.synfilter(c)  
	return c:IsSetCard(0x129d) 
end
function cm.filter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x129d) and c:IsAbleToDeck()  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,3,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,3,3,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
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
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)  
end  
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetValue(RESET_TURN_SET)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e2)  
		if tc:IsType(TYPE_TRAPMONSTER) then  
			local e3=Effect.CreateEffect(c)  
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)  
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
			tc:RegisterEffect(e3)  
		end  
	end  
end 