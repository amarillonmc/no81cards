--深海猎人
local m=88802004
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddCodeList(c,39635519)
	aux.AddRitualProcGreater2(c,c39635519.filter,LOCATION_HAND+LOCATION_GRAVE,c39635519.mfilter)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39635519,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c39635519.tg)
	e2:SetOperation(c39635519.op)
	c:RegisterEffect(e2)
	
end
function c39635519.filter(c)
	return c:IsSetCard(0x9a4)
end
function c39635519.mfilter(c)
	return c:IsSetCard(0x99a)
end
function c39635519.tfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x99a) and c:IsAbleToHand()
end
function c39635519.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39635519.tfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c39635519.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c39635519.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
