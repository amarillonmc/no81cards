--奇异增殖
local m=70002043
local cm=_G["c"..m]
function cm.initial_effect(c)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_DECK)
	e1:SetOperation(cm.adjustop)
	c:RegisterEffect(e1)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local gm=70002043
	local td1=Duel.CreateToken(tp,gm)
	Duel.SendtoDeck(td1,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local td2=Duel.CreateToken(1-tp,gm)
	Duel.SendtoDeck(td2,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
end