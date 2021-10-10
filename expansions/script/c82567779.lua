
local m=82567779
local cm=_G["c"..m]
function c82567779.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82567779)
	e1:SetTarget(c82567779.target)
	e1:SetOperation(c82567779.activate)
	c:RegisterEffect(e1)
end
function c82567779.cfilter(c)
	return c:IsSetCard(0x825) and c:IsLocation(LOCATION_ONFIELD) and (c:IsLevelAbove(5) or c:IsLinkAbove(2) or c:IsRankAbove(1))
end
function c82567779.filter(c)
	return (c:IsSetCard(0x825) or c:IsCode(82567874,82567875,82568020,82568055,82568202)) and c:IsAbleToHand()
end
function c82567779.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567779.filter,tp,LOCATION_GRAVE,0,2,nil) and Duel.CheckReleaseGroup(tp,c82567779.cfilter,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c82567779.activate(e,tp,eg,ep,ev,re,r,rp)
	if not  Duel.CheckReleaseGroup(tp,c82567779.ctfilter,1,nil) then return false end 
	local g1=Duel.SelectReleaseGroup(tp,c82567779.cfilter,1,1,nil)
	local tc=g1:GetFirst()
	Duel.Release(g1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567779.filter),tp,LOCATION_GRAVE,0,2,2,tc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end