--电子音姬 强音
function c33200651.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200651)
	e1:SetCost(c33200651.thcost)
	e1:SetTarget(c33200651.thtg)
	e1:SetOperation(c33200651.thop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c33200651.efcon)
	e2:SetOperation(c33200651.efop)
	c:RegisterEffect(e2)
end

--e1
function c33200651.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c33200651.thfilter(c)
	return c:IsCode(33200650) and c:IsAbleToHand()
end
function c33200651.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200651.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200651.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c33200651.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

function c33200651.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard():IsSetCard(0xa32a)
end
function c33200651.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(33200651,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33200651.cost)
	e1:SetTarget(c33200651.destg)
	e1:SetOperation(c33200651.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200651,2))
end
function c33200651.desfilter(c,datk)
	return c:IsFaceup() and c:GetAttack()<datk
end
function c33200651.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33200651.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local datk=e:GetHandler():GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c33200651.desfilter,tp,0,LOCATION_MZONE,1,nil,datk) end
	local g=Duel.GetMatchingGroup(c33200651.desfilter,tp,0,LOCATION_MZONE,nil,datk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c33200651.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsOnField() and e:GetHandler():IsFaceup() then
		local g=Duel.GetMatchingGroup(c33200651.desfilter,tp,0,LOCATION_MZONE,nil,datk)
		Duel.Destroy(g,REASON_EFFECT)
	end
end