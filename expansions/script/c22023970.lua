--人理彼面 马纳南
function c22023970.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22022600,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6ff1),1,true,true)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023970,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22023970)
	e1:SetCondition(c22023970.thcon)
	e1:SetTarget(c22023970.thtg)
	e1:SetOperation(c22023970.thop)
	c:RegisterEffect(e1)
	--activate trap in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023970,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_COUNTER))
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetValue(22023970)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c22023970.reccon)
	e4:SetOperation(c22023970.recop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c22023970.reccon1)
	e5:SetOperation(c22023970.recop1)
	c:RegisterEffect(e5)
end
function c22023970.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c22023970.filter(c)
	return c:IsCode(22023960) and c:IsAbleToHand()
end
function c22023970.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023970.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c22023970.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22023970.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,3,nil)
		Duel.SelectOption(tp,aux.Stringid(22023970,1))
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

function c22023970.reccon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_TRAP) and re:IsActiveType(TYPE_COUNTER) and rp==tp and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0
end
function c22023970.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22023970)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c22023970.reccon1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_TRAP) and re:IsActiveType(TYPE_COUNTER) and re:GetHandler():IsCode(22023960) and rp==tp and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0
end
function c22023970.recop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22023970,3))
	Duel.Draw(tp,1,REASON_EFFECT)
end