-- 玉龙·幻殇·苍龙
function c11180023.initial_effect(c)
	--xyz
	c:EnableReviveLimit()   
	aux.AddXyzProcedure(c,nil,3,2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11180023)
	e1:SetCost(c11180023.cost)
	e1:SetTarget(c11180023.target)
	e1:SetOperation(c11180023.operation)
	c:RegisterEffect(e1)
	--atk/def down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3450))
	e2:SetValue(c11180023.value1)
	c:RegisterEffect(e2)
	--atk/def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c11180023.value2)
	c:RegisterEffect(e3)
end
function c11180023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11180023.thfilter(c)
	return c:IsSetCard(0x3450,0x6450) and c:IsAbleToHand()
end
function c11180023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11180023.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11180023.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11180023.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11180023.value1(e,c)
	return Duel.GetOverlayCount(tp,LOCATION_MZONE,LOCATION_MZONE)*600
end
function c11180023.value2(e,c)
	return Duel.GetOverlayCount(tp,LOCATION_MZONE,LOCATION_MZONE)*(-600)
end