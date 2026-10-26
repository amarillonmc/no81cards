-- 量子种子
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	-- ①：作为速攻魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e0:SetTarget(cm.tg)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)

	-- ②：把墓地的这张卡除外才能发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCost(cm.gycost)
	e2:SetTarget(cm.gytg)
	e2:SetOperation(cm.gyop)
	c:RegisterEffect(e2)
end

-- 「创造」卡：只认 isSouzou 标记（「创造·○」「创造·□」「创造·△」）
function cm.souzoufil(c)
	return c.isSouzou and c:IsAbleToHand()
end
function cm.souzougy(c)
	return c.isSouzou and c:IsAbleToGrave()
end
-- 「不因决斗开始时初始分配在自己卡组存在的卡」
function cm.noninitfil(c)
	return c:GetReason()&(REASON_EFFECT+REASON_COST)~=0 and c:IsAbleToHand()
end

function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.souzoufil,tp,LOCATION_DECK,0,3,nil)
	local b2=Duel.IsExistingMatchingCard(cm.souzougy,tp,LOCATION_DECK,0,3,nil) and Lingguang.canlf(tp)
	local b3=Duel.IsExistingMatchingCard(cm.souzoufil,tp,LOCATION_DECK,0,3,nil) and Lingguang.canlf(tp)
	local b4=Duel.IsExistingMatchingCard(cm.noninitfil,tp,LOCATION_DECK,0,1,nil) and Lingguang.canlf(tp)
	if chk==0 then return b1 or b2 or b3 or b4 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.souzoufil,tp,LOCATION_DECK,0,3,nil)
	local b2=Duel.IsExistingMatchingCard(cm.souzougy,tp,LOCATION_DECK,0,3,nil) and Lingguang.canlf(tp)
	local b3=Duel.IsExistingMatchingCard(cm.souzoufil,tp,LOCATION_DECK,0,3,nil) and Lingguang.canlf(tp)
	local b4=Duel.IsExistingMatchingCard(cm.noninitfil,tp,LOCATION_DECK,0,1,nil) and Lingguang.canlf(tp)
	if not b1 and not b2 and not b3 and not b4 then return end
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,0),1},
		{b2,aux.Stringid(m,1),2},
		{b3,aux.Stringid(m,2),3},
		{b4,aux.Stringid(m,3),4}})
	-- 灵光一闪I~III：破坏衍生物
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	-- 灵光一闪I：从卡组把3张「创造」卡送去墓地
	if op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.souzougy,tp,LOCATION_DECK,0,3,3,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
		end
		return
	end
	-- 灵光一闪III：从卡组选1张非初始卡加入手卡
	if op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.noninitfil,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
		end
		return
	end
	-- 原本 / 灵光一闪II：从卡组把3张「创造」卡加入手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.souzoufil,tp,LOCATION_DECK,0,3,3,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
	-- 原本：对方从那之中选1张，其余回到卡组；灵光一闪II：自己选
	local seler=tp
	if op==1 then seler=1-tp end
	Duel.Hint(HINT_SELECTMSG,seler,HINTMSG_TODECK)
	local keep=g:Select(seler,1,1,nil):GetFirst()
	if not keep then return end
	local rg=g:Filter(function(tc) return tc~=keep end,nil)
	if rg:GetCount()>0 then
		Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

-- ②
function cm.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cm.gyfil(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
-- 灵光一闪IV 用：手卡·墓地的任意卡
function cm.gyany(c)
	return c:IsAbleToDeck()
end
function cm.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsExistingMatchingCard(cm.gyfil,tp,LOCATION_GRAVE,0,3,nil) then return true end
		return Lingguang.canlf(tp)
			and Duel.IsExistingMatchingCard(cm.gyany,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.gyfil,tp,LOCATION_GRAVE,0,3,nil)
	local b2=Lingguang.canlf(tp)
		and Duel.IsExistingMatchingCard(cm.gyany,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
	if not b1 and not b2 then return end
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,4),1},
		{b2,aux.Stringid(m,5),2}})
	if op==2 then
		-- 灵光一闪IV：改为从自己手卡·墓地选至多3张卡回到卡组
		if not Lingguang.lf(c,tp,e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.gyany,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,3,nil)
		if g:GetCount()>0 then Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
	else
		-- 原本：从自己墓地选3张魔法卡回到卡组
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.gyfil,tp,LOCATION_GRAVE,0,3,3,nil)
		if g:GetCount()==0 then return end
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
