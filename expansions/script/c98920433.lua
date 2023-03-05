--火焰零件手
function c98920433.initial_effect(c)
	--special summon
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SPSUMMON_PROC)
	e10:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e10:SetRange(LOCATION_HAND)
	e10:SetCondition(c98920433.spcon)
	e10:SetOperation(c98920433.spop)
	c:RegisterEffect(e10)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920433,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,98920433)
	e1:SetTarget(c98920433.tg)
	e1:SetOperation(c98920433.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
--effect gain
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetCode(EVENT_BE_MATERIAL)
	e20:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e20:SetCondition(c98920433.efcon)
	e20:SetOperation(c98920433.efop)
	c:RegisterEffect(e20)
end
function c98920433.spfilter(c,ft)
	return c:IsAbleToRemoveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c98920433.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c98920433.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c98920433.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98920433.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Remove(g,0,REASON_COST+REASON_TEMPORARY)
end
function c98920433.filter(c)
	return (c:IsAttack(1600) or c:IsDefense(1600)) and c:IsAbleToHand() and not c:IsCode(98920433)
end
function c98920433.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920433.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920433.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920433.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920433.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c98920433.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(98920433,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920433.drcon)
	e1:SetOperation(c98920433.drop)
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
end
function c98920433.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98920433.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end