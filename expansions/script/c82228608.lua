local m=82228608
local cm=_G["c"..m]
cm.name="荒兽 魉"
function cm.initial_effect(c)
	--to deck & draw
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_TO_GRAVE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.drtg)  
	e1:SetOperation(cm.drop)  
	c:RegisterEffect(e1)  
	--negate 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)  
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_XMATERIAL)  
	e2:SetCode(EVENT_BATTLE_CONFIRM)  
	e2:SetCost(cm.cost)  
	e2:SetCondition(cm.negcon)   
	e2:SetOperation(cm.negop)  
	c:RegisterEffect(e2)
end
function cm.tdfilter(c)  
	return c:IsSetCard(0x2299) and c:IsAbleToDeck()  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)  
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	if tg:GetCount()<=0 then return end  
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)  
	local g=Duel.GetOperatedGroup()  
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end  
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)  
	if ct==3 then  
		Duel.Draw(tp,1,REASON_EFFECT)  
	end  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end 
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return c:IsSetCard(0x2299) and c:IsRelateToBattle() and bc and bc:GetControler()~=tp and bc:IsFaceup() and bc:IsRelateToBattle() and not (bc:GetAttack()==0 and bc:GetDefense()==0 and (bc:IsDisabled() or not bc:IsType(TYPE_EFFECT)))
end  
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetHandler():GetBattleTarget() 
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then 
		Duel.NegateRelatedChain(bc,RESET_TURN_SET) 
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetValue(RESET_TURN_SET)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e3:SetValue(0)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		bc:RegisterEffect(e3) 
		local e4=e3:Clone()  
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL)   
		bc:RegisterEffect(e4)   
	end
end