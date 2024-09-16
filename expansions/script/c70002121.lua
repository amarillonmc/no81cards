--沉思
local m=70002121
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
	function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
end
	function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,tp,3)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	Duel.ShuffleDeck(tp)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end