--梦时空
local m=1000428
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side1=1000413
cm.dfc_back_side2=1000414
cm.dfc_back_side3=1000417
cm.dfc_back_side4=1000420
cm.dfc_back_side5=1000419
function c1000428.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5))
	e:SetLabel(op)
	if op==0 then
	local tcode=e:GetHandler().dfc_back_side1
	e:GetHandler():SetEntityCode(tcode,true)
	e:GetHandler():ReplaceEffect(tcode,0,0)
	local c=e:GetHandler()
	c:CancelToGrave()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
	elseif op==1 then
	local tcode1=e:GetHandler().dfc_back_side2
	e:GetHandler():SetEntityCode(tcode1,true)
	e:GetHandler():ReplaceEffect(tcode1,0,0)
	local c=e:GetHandler()
	c:CancelToGrave()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
	elseif op==2 then
	local tcode2=e:GetHandler().dfc_back_side3
	e:GetHandler():SetEntityCode(tcode2,true)
	e:GetHandler():ReplaceEffect(tcode2,0,0)
	local c=e:GetHandler()
	c:CancelToGrave()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
	elseif op==3 then
	local tcode3=e:GetHandler().dfc_back_side4
	e:GetHandler():SetEntityCode(tcode3,true)
	e:GetHandler():ReplaceEffect(tcode3,0,0)
	local c=e:GetHandler()
	c:CancelToGrave()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
	else 
	local tcode4=e:GetHandler().dfc_back_side5
	e:GetHandler():SetEntityCode(tcode4,true)
	e:GetHandler():ReplaceEffect(tcode4,0,0)
	local c=e:GetHandler()
	c:CancelToGrave()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
	end
end