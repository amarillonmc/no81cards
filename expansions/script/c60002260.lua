--生命量产
local m=60002260
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
end
function cm.thfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6a9) 
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,3)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	g:GetFirst():RegisterEffect(e1)
	local gm=g:GetFirst():GetCode()
	local tc1=Duel.CreateToken(tp,gm)
	Duel.SendtoDeck(tc1,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local tc2=Duel.CreateToken(tp,gm)
	Duel.SendtoDeck(tc2,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local tc3=Duel.CreateToken(tp,gm)
	Duel.SendtoDeck(tc3,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
end