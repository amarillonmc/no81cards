--归回净的调音
function c19209683.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19209683+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19209683.target)
	e1:SetOperation(c19209683.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209683,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,19209683)
	e2:SetCondition(c19209683.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c19209683.thtg)
	e2:SetOperation(c19209683.thop)
	c:RegisterEffect(e2)
end
function c19209683.tgfilter(c)
	return c:IsSetCard(0xb52) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c19209683.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209683.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c19209683.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c19209683.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c19209683.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousSetCard(0x3b52) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
end
function c19209683.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(c19209683.cfilter,1,nil,tp)
end
function c19209683.thfilter(c)
	return c:IsCode(19209670) and c:IsFaceupEx() and c:IsAbleToHand()-- and c:IsType(TYPE_MONSTER)
end
function c19209683.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209683.thfilter,tp,0x30,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end
function c19209683.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19209683.thfilter),tp,0x30,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
