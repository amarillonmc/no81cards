--黑之魂的拥抱
function c95101164.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,95101164)
	e1:SetTarget(c95101164.target)
	e1:SetOperation(c95101164.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,95101164+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c95101164.ovtg)
	e2:SetOperation(c95101164.ovop)
	c:RegisterEffect(e2)
end
function c95101164.thfilter(c)
	return c:IsSetCard(0xbbf) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95101164.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101164.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95101164.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c95101164.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c95101164.xfilter(c)
	return c:IsSetCard(0xbbf) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c95101164.ovfilter(c)
	return c:IsSetCard(0xbbf) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c95101164.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101164.xfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c95101164.ovfilter,tp,LOCATION_DECK,0,1,nil,0) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95101164.ovop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c95101164.xfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c95101164.ovfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g~=1 then return end
	Duel.Overlay(tc,g)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
