
local m=82567779
local cm=_G["c"..m]
function c82567779.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82567779)
	e1:SetCost(c82567779.cost)
	e1:SetTarget(c82567779.target)
	e1:SetOperation(c82567779.activate)
	c:RegisterEffect(e1)
end
function c82567779.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x825) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x825)
	Duel.Release(g,REASON_COST)
end
function c82567779.filter(c)
	return (c:IsSetCard(0x825) or c:IsCode(82567874) or c:IsCode(82567875) or c:Iscode(82568020)) and c:IsAbleToHand()
end
function c82567779.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567779.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c82567779.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82567779.filter),tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end