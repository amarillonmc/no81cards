--可可豆的甜蜜热恋
local m=33330174
local cm=_G["c"..m]
Duel.LoadScript("c81000000.lua")
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local opt=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))
	if opt==0 then
		local h1=Duel.Draw(tp,2,REASON_EFFECT)
		local h2=Duel.Draw(1-tp,2,REASON_EFFECT)
		if h1>0 or h2>0 then Duel.BreakEffect() end
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_HAND,0,1,1,nil,1-tp)
		local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,1-tp,LOCATION_HAND,0,1,1,nil,tp)
		Duel.SendtoHand(g1,1-tp,REASON_EFFECT)
		Duel.SendtoHand(g2,tp,REASON_EFFECT)
	end
end
