--不逝之忆
local m=60001139
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60001129") end) then require("script/c60001129") end
cm.isColorSong=true  --乱色狂歌
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	Color_Song.AddCount(c)
end
--e1
function cm.tgf1(c)
	return c:IsAbleToHand() and c.isColorSong
end
function cm.tgf12(c)
	return c:IsAbleToGrave() and c.isColorSong
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tgf1),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.tgf12,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Color_Song.Record_Op(e,tp,eg,ep,ev,re,r,rp)
	local max=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):FilterCount(aux.NecroValleyFilter(cm.tgf1),nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgf12,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,max,e:GetHandler())
	if g:GetCount()>0 then
		local count=Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tgf1),tp,LOCATION_GRAVE,0,count,count,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
	Color_Song.Zombie_Limit(e,tp)
	Color_Song.UseEffect(e,tp)
end
--e2
function cm.tgf2(c)
	return c:IsAbleToDeck() and c.isColorSong
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tgf1),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local max=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):FilterCount(aux.NecroValleyFilter(cm.tgf1),nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tgf2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,max,nil)
	if g:GetCount()>0 then
		if g:IsExists(Card.IsFacedown,1,nil) then Duel.ConfirmCards(1-tp,g) end
		local count=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tgf1),tp,LOCATION_GRAVE,0,count,count,nil)
		if g2:GetCount()==count then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
	Color_Song.UseEffect(e,tp)
end