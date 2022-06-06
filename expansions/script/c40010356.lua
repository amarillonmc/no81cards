--龙刻禁录
local m=40010356
local cm=_G["c"..m]
cm.named_with_DragWizard=1
function cm.DragWizard(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DragWizard
end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--Effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)  
end
--Effect 1
function cm.thfilter(c)
	return c:IsLevel(1) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand() 
end
function cm.fselect(g)
	return g:IsExists(cm.moon,1,nil)
end
function cm.moon(c)
	return  c:IsType(TYPE_MONSTER) and cm.DragWizard(c)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.fselect,3,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if  g:CheckSubGroup(cm.fselect,3,3) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,cm.moon,1,1,nil)
		g:RemoveCard(sg:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:Select(tp,2,2,nil)
		if #sg>0 and #sg1>0 then
			sg:Merge(sg1)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleDeck(tp)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local tg=sg:Select(1-tp,1,1,nil)
			local tc=tg:GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			sg:RemoveCard(tc)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
--Effect 2
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
