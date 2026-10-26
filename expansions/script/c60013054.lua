-- 剑击
local cm,m,o=GetID()

function cm.initial_effect(c)
	-- 卡名记述：「凶兆的使徒 罗丝薇瑟」
	aux.AddCodeList(c,60013050)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁1次
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end

-- 「凶兆的使徒 罗丝薇瑟」（含同名异画）
function cm.thfil(c)
	return c:IsCode(60013050,60013051) and c:IsAbleToHand()
end
function cm.suifil(c)
	return c:IsCode(60013053)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,1,nil) then return false end
		if Duel.IsExistingMatchingCard(cm.suifil,tp,LOCATION_GRAVE,0,1,nil)
			and not Duel.IsPlayerCanDraw(tp,1) then return false end
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
-- ①：检索「罗丝薇瑟」；自己墓地有「剑穗」的场合抽1张
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
	if Duel.IsExistingMatchingCard(cm.suifil,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
