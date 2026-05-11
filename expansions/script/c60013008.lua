-- 解放极光
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m-1)~=0 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetFlagEffect(tp,m-1)
	for i=1,math.floor(num) do
		Duel.RegisterFlagEffect(tp,60013005,0,0,1)
	end
	if num>=3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,math.floor(num/3),nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
	if num>=9 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,math.floor(num/9),nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end