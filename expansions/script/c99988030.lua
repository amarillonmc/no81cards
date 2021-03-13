--亡语战士 不死精锐军
function c99988030.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,99988030)
	e1:SetCondition(c99988030.spcon)
	e1:SetOperation(c99988030.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99988030,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,999880300)
	e2:SetCost(c99988030.cost)
	e2:SetTarget(c99988030.target)
	e2:SetOperation(c99988030.operation)
	c:RegisterEffect(e2)
	end
function c99988030.spfilter(c,ft)
	return c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x20df) and c:IsAbleToGraveAsCost() 
		and (ft>0 or c:GetSequence()<5)
end
function c99988030.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c99988030.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ft)
end
function c99988030.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99988030.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99988030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99988030.filter(c)
	return c:IsSetCard(0x20df) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c99988030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99988030.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99988030.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99988030.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end