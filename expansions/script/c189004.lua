--
function c189004.initial_effect(c)
	c:EnableReviveLimit()
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(189004,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,189004)
	e2:SetCost(c189004.thcost)
	e2:SetTarget(c189004.thtg)
	e2:SetOperation(c189004.thop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetDescription(aux.Stringid(189004,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(c189004.contg)
	e3:SetOperation(c189004.conop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(189004,2))
	e4:SetCost(c189004.cost)
	c:RegisterEffect(e4)
end
c189004.Dakexiaer=true
function c189004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c189004.thfilter(c)
	return c:IsCode(189003) and c:IsAbleToHand()
end
function c189004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c189004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c189004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(c189004.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c189004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c189004.contg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	g:GetFirst():RegisterFlagEffect(189004,RESET_CHAIN+RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c189004.conop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
function c189004.conop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsControler(1-tp) and tc:GetFlagEffectLabel(189004)>0 and tc:IsLocation(LOCATION_MZONE) then
		Duel.GetControl(tc,tp)
	end
end
