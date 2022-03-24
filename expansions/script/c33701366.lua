--乘上加帕里节奏！
local m=33701366
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsSetCard(0x442) and c:IsAbleToDeck() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.adcheck(c)
	return c:IsSetCard(0x442) and c:IsAbleToHand()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=tp
	local num=Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(cm.filter),p,LOCATION_GRAVE+LOCATION_HAND,0,1,num,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
		Duel.BreakEffect()
		local sg=Duel.GetDecktopGroup(tp,ct)
		Duel.ConfirmDecktop(tp,ct)
		if sg:GetClassCount(Card.GetCode)==sg:GetCount() then
			local og=sg:Filter(cm.adcheck,nil)
			sg:Sub(og)
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(og,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,og)
			if sg:GetCount()==0 then Duel.ShuffleDeck(tp)  return end
			local op=Duel.SelectOption(p,aux.Stringid(m,2),aux.Stringid(m,3))
			if op==0 then
				Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			else
				Duel.SendtoDeck(sg,nil,1,REASON_EFFECT) 
			end
		end
	end
end
function cm.disfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
