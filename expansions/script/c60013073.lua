-- 成对产生
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	-- 作为永续魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e0:SetOperation(cm.actop)
	c:RegisterEffect(e0)

	-- ②：自己把速攻魔法卡发动的场合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(3,m)	-- 这个卡名的②1回合最多3次
	e1:SetCondition(cm.con2)
	e1:SetOperation(cm.op2)
	c:RegisterEffect(e1)
end

-- 「创造」卡
function cm.souzoufil(c)
	return c.isSouzou and c:IsAbleToHand()
end
function cm.souzougy(c)
	return c.isSouzou and c:IsAbleToGrave()
end
-- 随机把 n 张「创造」卡送去墓地
function cm.ranthgy(e,tp,n)
	local g=Duel.GetMatchingGroup(cm.souzougy,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	if g:GetCount()>n then g=g:RandomSelect(tp,n) end
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end
-- 同名卡在自己墓地存在的「创造」卡
function cm.samegyfil(c)
	if not (c.isSouzou and c:IsAbleToHand()) then return false end
	return Duel.IsExistingMatchingCard(function(tc)
		return tc.isSouzou and tc:GetCode()==c:GetCode()
	end,tp,LOCATION_GRAVE,0,1,nil)
end
-- 墓地里有同名伴侣的「创造」卡
function cm.pairfil(c)
	if not (c.isSouzou and c:IsAbleToDeck()) then return false end
	return Duel.IsExistingMatchingCard(function(tc)
		return tc~=c and tc.isSouzou and tc:GetCode()==c:GetCode()
	end,tp,LOCATION_GRAVE,0,1,nil)
end

-- ①：作为发动时的效果处理，可以从手卡·墓地选1张卡回到卡组，把1只光属性「灵光一闪衍生物」放置
-- 「那之后」再询问是否适用灵光一闪I（即使没有回卡组也可以适用）
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 可以从手卡·墓地选1张卡回到卡组
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
	end
	-- 把1只光属性「灵光一闪衍生物」当作永续魔法卡表侧放置（白板，不附加效果）
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local token=Duel.CreateToken(tp,60013064)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	-- 那之后：可以适用灵光一闪I（与是否回了卡组无关）
	if Lingguang.canlf(tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		if Lingguang.lf(c,tp,e) then
			local g=Duel.GetMatchingGroup(cm.souzoufil,tp,LOCATION_DECK,0,nil)
			if g:GetCount()>0 then
				g=g:RandomSelect(tp,1)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				Duel.ShuffleDeck(tp)
			end
		end
	end
end

-- ②
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp or not re then return false end
	return re:IsActiveType(TYPE_QUICKPLAY)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=Lingguang.canlf(tp)
	local b3=Lingguang.canlf(tp) and Duel.IsExistingMatchingCard(cm.samegyfil,tp,LOCATION_DECK,0,1,nil)
	local b4=Lingguang.canlf(tp) and Duel.IsExistingMatchingCard(cm.pairfil,tp,LOCATION_GRAVE,0,2,nil)
	if not b1 and not b2 and not b3 and not b4 then return end
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,2),1},
		{b2,aux.Stringid(m,3),2},
		{b3,aux.Stringid(m,4),3},
		{b4,aux.Stringid(m,5),4}})
	-- 灵光一闪II~IV：破坏衍生物
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	-- 原本 / II / III：从卡组随机把1张「创造」卡送去墓地
	if op<=3 then
		cm.ranthgy(e,tp,1)
	end
	if op==2 then
		-- 灵光一闪II：那之后，从卡组选1张「创造」卡送去墓地
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.souzougy,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
		end
	elseif op==3 then
		-- 灵光一闪III：那之后，从卡组选1张同名卡在墓地存在的「创造」卡加入手卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.samegyfil,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
		end
	elseif op==4 then
		-- 灵光一闪IV：从自己墓地选2张相同卡名的「创造」卡回到卡组，自己抽2张
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local c1=Duel.SelectMatchingCard(tp,cm.pairfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if not c1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local c2=Duel.SelectMatchingCard(tp,function(tc)
			return tc~=c1 and tc.isSouzou and tc:GetCode()==c1:GetCode()
		end,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if not c2 then return end
		local g=Group.FromCards(c1,c2)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
