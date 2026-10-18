-- 轮滞永劫
local cm,m,o=GetID()

local F_KKKD=60013040+10000000	-- 「刻刻帝」②的适用次数（场地与陷阱共用同一个计数器，锚在 6040 号段）

function cm.initial_effect(c)
	-- 卡名记述：「时崎狂三·时崎狂三」
	aux.AddCodeList(c,60013039)

	-- 这张卡也能丢弃1张其他手卡，从手卡发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)

	-- ①：自己场上的卡被战斗·效果破坏的场合
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RELEASE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 没写次数限制的效果，也要限同一连锁1次
	e1:SetCondition(cm.descon)
	e1:SetCost(cm.actcost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	-- ②：双方的回合结束阶段，墓地的这张卡回到卡组
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)	-- 结束阶段的效果必须限次，否则会在结束阶段反复诱发
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.gytg)
	e2:SetOperation(cm.gyop)
	c:RegisterEffect(e2)
end

-- 手卡发动的condition：自己回合，或是自己场上有仪式怪兽的对方回合
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return true end
	return Duel.IsExistingMatchingCard(cm.ritualf,tp,LOCATION_MZONE,0,1,nil)
end
function cm.ritualf(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
-- 从手卡发动时的cost：丢弃1张其他手卡（从场上发动时不丢）
function cm.disfil(c)
	return c:IsDiscardable()
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsLocation(LOCATION_HAND)
			or Duel.IsExistingMatchingCard(cm.disfil,tp,LOCATION_HAND,0,1,c)
	end
	if c:IsLocation(LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,cm.disfil,tp,LOCATION_HAND,0,1,1,c)
		if #g>0 then Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD) end
	end
end
-- ①的condition：自己场上的卡被破坏
function cm.desfil(c,tp)
	local onfield=c:IsLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_ONFIELD)
	local mine=c:IsControler(tp) or c:IsPreviousControler(tp)
	return onfield and mine
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.desfil,1,nil,tp)
end
-- 「时崎狂三·时崎狂三」
function cm.affil(c)
	return c:IsCode(60013039)
end
-- 「刻刻帝·七之弹（Zayin）」
function cm.bltfilter(c)
	return c:IsCode(60013047) and c:IsAbleToHand()
end
-- ①的target
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,0,1-tp,LOCATION_ONFIELD)
end
-- ①的operation：墓地1张回手卡，解放对方场上至多2张，那之后可以检索「七之弹」
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 从自己墓地选1张卡回到手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
	if #hg>0 then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
	-- 从对方场上选至多2张卡解放
	local rg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if rg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rel=rg:Select(tp,0,math.min(2,rg:GetCount()),nil)
		if rel:GetCount()>0 then Duel.Release(rel,REASON_EFFECT) end
	end
	-- 那之后，可以丢弃1张其他手卡，把「七之弹」加入手卡
	local hh=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if c:IsLocation(LOCATION_HAND) then hh:RemoveCard(c) end
	if hh:GetCount()==0 then return end
	if not Duel.IsExistingMatchingCard(cm.bltfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=Duel.SelectMatchingCard(tp,cm.disfil,tp,LOCATION_HAND,0,1,1,c)
	if #dg==0 or Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,cm.bltfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #sg>0 then
		local fd=sg:GetFirst():IsLocation(LOCATION_DECK)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		if fd then Duel.ShuffleDeck(tp) end
	end
end
-- ②的target：把这张卡送回卡组（无论能否选卡都要执行）
function cm.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_GRAVE)
end
-- ②的operation：墓地这张卡回卡组，那之后可以选对方场上1张卡回卡组；有狂三时再抽1张
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	-- 「刻刻帝」②的适用次数
	Duel.RegisterFlagEffect(tp,F_KKKD,0,0,1)
	-- 那之后，可以选对方场上1张卡回到卡组
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
	end
	-- 自己场上有狂三的场合，自己再抽1张
	if Duel.IsExistingMatchingCard(cm.affil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
