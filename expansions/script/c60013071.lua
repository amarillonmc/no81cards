-- 形象凝聚
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e0:SetTarget(cm.tg)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
end

-- 「创造」卡
function cm.souzoufil(c)
	return c.isSouzou and c:IsAbleToHand()
end
function cm.souzoudc(c)
	return c.isSouzou and c:IsDiscardable()
end
function cm.tdfil(c)
	return c:IsAbleToDeck()
end
-- 从卡组随机把 n 张「创造」卡加入手卡
function cm.ranth(e,tp,n)
	local g=Duel.GetMatchingGroup(cm.souzoufil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	if g:GetCount()>n then g=g:RandomSelect(tp,n) end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
end

function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Lingguang.canlf(tp)
	local b3=Duel.IsExistingMatchingCard(cm.souzoufil,tp,LOCATION_DECK,0,1,nil) and Lingguang.canlf(tp)
	local b4=Duel.IsExistingMatchingCard(cm.souzoudc,tp,LOCATION_HAND,0,1,nil) and Lingguang.canlf(tp)
	local b5=Duel.IsPlayerCanDraw(tp,1) and Lingguang.canlf(tp)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Lingguang.canlf(tp)
	local b3=Duel.IsExistingMatchingCard(cm.souzoufil,tp,LOCATION_DECK,0,1,nil) and Lingguang.canlf(tp)
	local b4=Duel.IsExistingMatchingCard(cm.souzoudc,tp,LOCATION_HAND,0,1,nil) and Lingguang.canlf(tp)
	local b5=Duel.IsPlayerCanDraw(tp,1) and Lingguang.canlf(tp)
	if not b1 and not b2 and not b3 and not b4 and not b5 then return end
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,0),1},
		{b2,aux.Stringid(m,1),2},
		{b3,aux.Stringid(m,2),3},
		{b4,aux.Stringid(m,3),4},
		{b5,aux.Stringid(m,4),5}})
	-- 灵光一闪I~IV：破坏衍生物
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	if op==1 then
		-- 原本：选1张手卡回到卡组，随机2张「创造」卡加入手卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tdfil,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()==0 then return end
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
		cm.ranth(e,tp,2)
	elseif op==2 then
		-- 灵光一闪I：从手卡·双方墓地选1张卡回到卡组，随机2张「创造」卡加入手卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tdfil,tp,LOCATION_HAND+LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()==0 then return end
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
		cm.ranth(e,tp,2)
	elseif op==3 then
		-- 灵光一闪II：丢弃所有手卡，随机3张「创造」卡加入手卡
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if hg:GetCount()>0 then
			Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
		end
		cm.ranth(e,tp,3)
	elseif op==4 then
		-- 灵光一闪III：丢弃最多3张「创造」卡，抽那个数量的卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,cm.souzoudc,tp,LOCATION_HAND,0,1,3,nil)
		if g:GetCount()==0 then return end
		local n=Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		if n>0 then Duel.Draw(tp,n,REASON_EFFECT) end
	elseif op==5 then
		-- 灵光一闪IV：抽1张并给对方确认，重复直到确认的卡不是「创造」卡
		local guard=0
		while guard<30 do
			guard=guard+1
			local d=Duel.Draw(tp,1,REASON_EFFECT)
			if d==0 then break end
			local g=Duel.GetOperatedGroup()
			local tc=g:GetFirst()
			if not tc then break end
			Duel.ConfirmCards(1-tp,g)
			if not tc.isSouzou then break end
		end
	end
end
