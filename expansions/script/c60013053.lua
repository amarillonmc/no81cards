-- 剑穗
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")

function cm.initial_effect(c)
	-- 卡名记述：「凶兆的使徒 罗丝薇瑟」（这张卡的代替破坏效果由各灵光一闪卡内置调用）
	aux.AddCodeList(c,60013050)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁1次
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end

function cm.selfilter(c)
	return c:IsCode(m) and c:IsAbleToDeck()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.selfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
			and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
-- ①：从手卡选任意数量的「剑穗」回到卡组，抽那个数量的卡
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.selfilter,tp,LOCATION_HAND,0,1,99,e:GetHandler())
	if g:GetCount()==0 then return end
	local n=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if n>0 then Duel.Draw(tp,n,REASON_EFFECT) end
end
