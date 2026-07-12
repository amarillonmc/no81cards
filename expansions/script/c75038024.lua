--抒情歌鸲-宝冠百灵鸟
function c75038024.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,99)
	--ov 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetTarget(c75038024.ovtg)
	e1:SetOperation(c75038024.ovop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c75038024.thcost)
	e2:SetTarget(c75038024.thtg)
	e2:SetOperation(c75038024.thop)
	c:RegisterEffect(e2)
end 
function c75038024.ovfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c75038024.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75038024.ovfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end 
end
function c75038024.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		local og=Duel.SelectMatchingCard(tp,c75038024.ovfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil) 
		Duel.Overlay(c,og)
	end 
end 
function c75038024.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75038024.thfilter(c)
	return c:IsSetCard(0xf7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c75038024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75038024.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75038024.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75038024.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

