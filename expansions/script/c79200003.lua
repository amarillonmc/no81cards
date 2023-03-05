--字界眼天照
function c79200003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,89200003+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c79200003.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79200003,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,79200003)
	e2:SetTarget(c79200003.thtg)
	e2:SetOperation(c79200003.thop)
	c:RegisterEffect(e2)
end
function c79200003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if e:IsHasType(EFFECT_TYPE_QUICK_O) then
		Duel.SetChainLimit(c79200003.chainlm)
	end
end
function c79200003.chainlm(e,rp,tp)
	return not e:GetHandler():IsCode()
end
function c79200003.filter(c)
	return c:IsSetCard(0x681) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79200003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79200003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79200003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79200003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end