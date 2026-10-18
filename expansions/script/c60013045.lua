-- 瞬光残影
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

	-- ①：检索「时崎狂三·时崎狂三」，场上有狂三时改为检索记述卡；那之后可以检索「八之弹」
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 没写次数限制的效果，也要限同一连锁1次
	e1:SetCost(cm.actcost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	-- ②：墓地的这张卡和场上1只「时崎狂三·时崎狂三」回到卡组
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)	-- 陷阱的墓地效果是二速，对方回合也能发动
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.gycon)
	e2:SetTarget(cm.gytg)
	e2:SetOperation(cm.gyop)
	c:RegisterEffect(e2)
end

-- 手卡发动的condition：自己回合，或是自己场上没有怪兽的对方回合
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return true end
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
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
-- 「时崎狂三·时崎狂三」
function cm.affil(c)
	return c:IsCode(60013039)
end
function cm.thfilter(c)
	return cm.affil(c) and c:IsAbleToHand()
end
-- 通常陷阱以外、有「时崎狂三·时崎狂三」卡名记述的卡
function cm.othfilter(c)
	return aux.IsCodeListed(c,60013039) and c:GetType()~=TYPE_TRAP and c:IsAbleToHand()
end
-- 「刻刻帝·八之弹（Het）」
function cm.bltfilter(c)
	return c:IsCode(60013042) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsExistingMatchingCard(cm.affil,tp,LOCATION_MZONE,0,1,nil) then
			return Duel.IsExistingMatchingCard(cm.othfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		end
		return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- ①：检索
	local f=cm.thfilter
	if Duel.IsExistingMatchingCard(cm.affil,tp,LOCATION_MZONE,0,1,nil) then f=cm.othfilter end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		local fd=g:GetFirst():IsLocation(LOCATION_DECK)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if fd then Duel.ShuffleDeck(tp) end
	end
	-- 那之后，可以丢弃1张其他手卡，把「八之弹」加入手卡
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if c:IsLocation(LOCATION_HAND) then hg:RemoveCard(c) end
	if hg:GetCount()==0 then return end
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
-- ②的condition：自己场上有「时崎狂三·时崎狂三」
function cm.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.affil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tdfilter(c)
	return cm.affil(c) and c:IsAbleToDeck()
end
-- ②的target
function cm.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
-- ②的operation：墓地这张卡＋场上1只狂三回卡组，那之后可以让自己墓地1张卡回到手卡
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g==0 then return end
	g:AddCard(c)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	-- 「刻刻帝」②的适用次数
	Duel.RegisterFlagEffect(tp,F_KKKD,0,0,1)
	-- 那之后，可以选自己墓地1张卡回到手卡
	if not Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,1,nil)
	if #hg>0 then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
end
