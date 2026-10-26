-- 明灭剑
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	-- 卡名记述：「凶兆的使徒 罗丝薇瑟」（灵光一闪IV 提到，可用「剑穗」代替破坏 / 触发场地②）
	aux.AddCodeList(c,60013050)

	-- ①：作为速攻魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁1次
	e0:SetTarget(cm.tg)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)

	-- ②：双方回合的结束阶段，墓地的这张卡回到手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,7))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)	-- 结束阶段的效果必须限次
	e1:SetTarget(cm.gytg)
	e1:SetOperation(cm.gyop)
	c:RegisterEffect(e1)
end

-- 「片鳞·明」「片鳞·暗」「立剑」
function cm.mingfil(c)
	return c:IsCode(60013057) and c:IsAbleToHand()
end
function cm.anfil(c)
	return c:IsCode(60013058) and c:IsAbleToHand()
end
function cm.lgfil(c)
	return (c:IsCode(60013057) or c:IsCode(60013058)) and c:IsAbleToHand()
end
function cm.kenfil(c)
	return c:IsCode(60013055) and c:IsSSetable()
end

-- ①：把卡加入手卡并持续公开
function cm.thone(e,tp,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()==0 then return end
	local fd=g:GetFirst():IsLocation(LOCATION_DECK)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
	local og=Duel.GetOperatedGroup()
	for tc in aux.Next(og) do
		Lingguang.pub(tc,e,aux.Stringid(m,6))
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.mingfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.anfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.lgfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Lingguang.canpay(c,tp)
	local b3=b1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.kenfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Lingguang.canpay(c,tp)
	local b4=b1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Lingguang.canpay(c,tp)
	if chk==0 then return b1 or b2 or b3 or b4 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.mingfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.anfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.lgfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Lingguang.canpay(c,tp)
	local b3=b1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.kenfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Lingguang.canpay(c,tp)
	local b4=b1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Lingguang.canpay(c,tp)
	if not b1 and not b2 and not b3 and not b4 then return end
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,0),1},
		{b2,aux.Stringid(m,1),2},
		{b3,aux.Stringid(m,2),3},
		{b4,aux.Stringid(m,3),4}})
	-- 灵光一闪I~III：破坏衍生物（或把「剑穗」送去墓地代替）
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	if op==1 or op==3 or op==4 then
		-- 原本效果：「片鳞·明」「片鳞·暗」各1张
		cm.thone(e,tp,cm.mingfil)
		cm.thone(e,tp,cm.anfil)
	elseif op==2 then
		-- 灵光一闪I：任意数量，2张以上必须同名
		local sel=Duel.SelectOption(tp,aux.Stringid(m,8),aux.Stringid(m,9))
		local f=cm.mingfil
		if sel==1 then f=cm.anfil end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,99,nil)
		if g:GetCount()>0 then
			local fd=g:GetFirst():IsLocation(LOCATION_DECK)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
			local og=Duel.GetOperatedGroup()
			for tc in aux.Next(og) do
				Lingguang.pub(tc,e,aux.Stringid(m,6))
			end
		end
	end
	if op==3 then
		-- 灵光一闪II：那之后，从卡组·墓地选1张「立剑」盖放
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.kenfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then Duel.SSet(tp,g) end
	elseif op==4 then
		-- 灵光一闪III：那之后，选对方场上1张卡除外
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
	end
end

-- ②
function cm.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_GRAVE) then return end
	local b1=true
	local b2=Lingguang.canpay(c,tp)
	local op=Lingguang.select(tp,{
		{b1,aux.Stringid(m,4),1},
		{b2,aux.Stringid(m,5),2}})
	if op==2 then
		-- 灵光一闪IV：回到卡组，抽1张（场上有罗丝薇瑟则抽2张）
		if not Lingguang.lf(c,tp,e) then return end
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
		local n=1
		if Duel.IsExistingMatchingCard(Lingguang.rosefilter,tp,LOCATION_MZONE,0,1,nil) then n=2 end
		Duel.Draw(tp,n,REASON_EFFECT)
	else
		-- 原本效果：回到手卡
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
