--金 属 城 -腐 恶 之 墟
local m=22348022
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetCounterLimit(0x1613,5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(22348022,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348022+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c22348022.activate)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c22348022.counter)
	c:RegisterEffect(e2)
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c22348022.atkval)
	c:RegisterEffect(e3)
	
end
function c22348022.thfilter(c)
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c22348022.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348022.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22348022,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
	end
end
function c22348022.ctfilter(c)
	return c:IsSetCard(0x613)
end
function c22348022.counter(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c22348022.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x1613,1)
	end
end
function c22348022.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1613)*-200
end
