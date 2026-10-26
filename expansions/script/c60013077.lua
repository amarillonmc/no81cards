-- 交战射击
local cm,m,o=GetID()

function cm.initial_effect(c)
	-- 作为通常魔法发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end

-- 「失格狙击手 席琳娜」
function cm.thfil(c)
	return c:IsCode(60013075) and c:IsAbleToHand()
end
-- 对方场上的表侧表示怪兽
function cm.ofil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 then return end
	if Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
	-- 对方场上有表侧表示的怪兽的场合，自己抽1张
	if Duel.IsExistingMatchingCard(cm.ofil,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
