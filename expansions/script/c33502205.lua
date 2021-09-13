--冰汽时代 墓园
local m=33502205
local cm=_G["c"..m]
Duel.LoadScript("c33502200.lua")
function cm.initial_effect(c)
	local e2=syu.tograve(c,m,nil,nil,cm.gop,CATEGORY_TOHAND)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsSetCard(0x1a81)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	 local ct=eg:FilterCount(cm.cfilter,nil,tp)
	if ct>0 then
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function cm.filter(c,tp)
	return c:IsSetCard(0x1a81) and c:IsAbleToHand()
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end