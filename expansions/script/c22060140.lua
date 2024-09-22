--异天枝-然德基尔
function c22060140.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060140,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22060140)
	e1:SetCost(c22060140.indcost)
	e1:SetTarget(c22060140.indtg)
	e1:SetOperation(c22060140.indop)
	c:RegisterEffect(e1)
end
function c22060140.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22060140.filter(c)
	return c:IsFaceup()
end
function c22060140.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c22060140.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22060140.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22060140.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c22060140.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		e1:SetCountLimit(4)
		tc:RegisterEffect(e1)
	end
end