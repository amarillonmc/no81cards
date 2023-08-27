local m=82207016
local cm=_G["c"..m]
cm.name="黑悠悠"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),1,2)   
	c:EnableReviveLimit()
	--ret&draw  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)   
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
	local e4=e3:Clone()  
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetCode(aux.indoval)
	c:RegisterEffect(e4)  
	local e5=e3:Clone()   
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)  
	c:RegisterEffect(e5)
end
function cm.filter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
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
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())  
			e1:SetType(EFFECT_TYPE_FIELD)  
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)  
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
			e1:SetTargetRange(LOCATION_MZONE,0)  
			e1:SetTarget(cm.efftg)  
			e1:SetValue(aux.tgoval)  
			e1:SetReset(RESET_PHASE+PHASE_END)  
			Duel.RegisterEffect(e1,tp) 
		end
	end
end  
function cm.efftg(e,c)  
	return c:IsType(TYPE_MONSTER)  
end  