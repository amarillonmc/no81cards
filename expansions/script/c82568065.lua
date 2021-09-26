--AK-耀步的星极
function c82568065.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c82568065.ovfilter,aux.Stringid(82568065,2))
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetDescription(aux.Stringid(82568065,0))
	e1:SetCountLimit(1,82568065)
	e1:SetCost(c82568065.thcost)
	e1:SetTarget(c82568065.thtg)
	e1:SetOperation(c82568065.thop)
	c:RegisterEffect(e1)
	--xyzlevel
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(82568065,1))
	e2:SetCountLimit(1,82568165)
	e2:SetCost(c82568065.xyzcost)
	e2:SetTarget(c82568065.xyztg)
	e2:SetOperation(c82568065.xyzop)
	c:RegisterEffect(e2)
end
function c82568065.ovfilter(c)
	return c:IsCode(82568031) and c:GetOverlayCount()>0
end
function c82568065.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82568065.thfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c82568065.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568065.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82568065.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82568065.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c82568065.tgfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c82568065.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsLevelAbove(1) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82568065.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,c82568065.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82568065.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and tc:IsLevelAbove(1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RANK)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetValue(c:GetRank())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end