-- 剑之共鸣
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	-- 卡名记述：「凶兆的使徒 罗丝薇瑟」
	aux.AddCodeList(c,60013050)

	-- 作为速攻魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁1次
	e0:SetTarget(cm.tg)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
end

-- 「剑穗」
function cm.suifil(c)
	return c:IsCode(60013053) and c:IsAbleToHand()
end
-- 「凶兆的使徒 罗丝薇瑟」或「明灭剑」
function cm.rosefil(c)
	return (c:IsCode(60013050,60013051) or c:IsCode(60013056)) and c:IsAbleToHand()
end
-- 墓地里的「片鳞·明」「片鳞·暗」
function cm.lgfil(c)
	return (c:IsCode(60013057) or c:IsCode(60013058)) and c:IsAbleToHand()
end

function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.suifil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=b1 and Lingguang.canpay(c,tp)
	local b3=Duel.IsExistingMatchingCard(cm.rosefil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Lingguang.canpay(c,tp)
	local b4=Duel.IsExistingMatchingCard(cm.lgfil,tp,LOCATION_GRAVE,0,1,nil) and Lingguang.canpay(c,tp)
	local b5=Duel.IsExistingMatchingCard(cm.suifil,tp,LOCATION_HAND,0,1,nil) and Lingguang.canpay(c,tp)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.suifil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=b1 and Lingguang.canpay(c,tp)
	local b3=Duel.IsExistingMatchingCard(cm.rosefil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Lingguang.canpay(c,tp)
	local b4=Duel.IsExistingMatchingCard(cm.lgfil,tp,LOCATION_GRAVE,0,1,nil) and Lingguang.canpay(c,tp)
	local b5=Duel.IsExistingMatchingCard(cm.suifil,tp,LOCATION_HAND,0,1,nil) and Lingguang.canpay(c,tp)
	if not b1 and not b2 and not b3 and not b4 and not b5 then return end
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,0),1},
		{b2,aux.Stringid(m,1),2},
		{b3,aux.Stringid(m,2),3},
		{b4,aux.Stringid(m,3),4},
		{b5,aux.Stringid(m,4),5}})
	-- 灵光一闪I~IV：破坏衍生物（或把「剑穗」送去墓地代替）
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	if op==1 then
		-- 原本效果：从卡组·墓地选至多2张「剑穗」
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.suifil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
		cm.thop(e,tp,g)
	elseif op==2 then
		-- 灵光一闪I：任意数量的「剑穗」
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.suifil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,99,nil)
		cm.thop(e,tp,g)
	elseif op==3 then
		-- 灵光一闪II：1张「罗丝薇瑟」或「明灭剑」
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.rosefil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		cm.thop(e,tp,g)
	elseif op==4 then
		-- 灵光一闪III：从墓地拿任意数量的「片鳞·明」「片鳞·暗」
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.lgfil,tp,LOCATION_GRAVE,0,1,99,nil)
		if g:GetCount()==0 then return end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local og=Duel.GetOperatedGroup()
		for tc in aux.Next(og) do
			Lingguang.pub(tc,e,aux.Stringid(m,5))
		end
	elseif op==5 then
		-- 灵光一闪IV：把手卡任意数量的「剑穗」送去墓地，抽那个数量2倍的卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Lingguang.suifilter,tp,LOCATION_HAND,0,1,99,nil)
		if g:GetCount()==0 then return end
		local n=Duel.SendtoGrave(g,REASON_EFFECT)
		if n>0 then Duel.Draw(tp,n*2,REASON_EFFECT) end
	end
end
function cm.thop(e,tp,g)
	if g==nil or g:GetCount()==0 then return end
	local fd=g:GetFirst():IsLocation(LOCATION_DECK)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
end
