--蚀刻龙·反刻钟龙
function c55100039.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55100039,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,55100039)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c55100039.cost)
	e1:SetTarget(c55100039.target)
	e1:SetOperation(c55100039.operation)
	c:RegisterEffect(e1)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55100039,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,55100039)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c55100039.cost)
	e1:SetTarget(c55100039.target2)
	e1:SetOperation(c55100039.operation2)
	c:RegisterEffect(e1)
--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(55100039,2))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e7:SetCondition(c55100039.rtdcon)
	e7:SetTarget(c55100039.rtdtg)
	e7:SetOperation(c55100039.rtdop)
	c:RegisterEffect(e7)
end
function c55100039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c55100039.filter(c)
	return c:IsSetCard(0x9551) and c:IsAbleToHand()
end
function c55100039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55100039.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55100039.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55100039.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c55100039.filter2(c)
	return c:IsSetCard(0xa551) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c55100039.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c55100039.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55100039.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55100039.filter2,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c55100039.rtdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c55100039.rtdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c55100039.rtdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end