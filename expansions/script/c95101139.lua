--黑之魂的追忆
function c95101139.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c95101139.target)
	e1:SetOperation(c95101139.activate)
	c:RegisterEffect(e1)
end
function c95101139.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c95101139.ffilter,tp,LOCATION_EXTRA,0,1,nil,c,tp)
end
function c95101139.ffilter(c,tc,tp)
	return c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(c95101139.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tc,c)
end
function c6498706.cfilter(c,tc,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and not c:IsCode(tc:GetFusionCode())
end
function c95101139.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95101139.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c95101139.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c95101139.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c95101139.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local fc=Duel.SelectMatchingCard(tp,c95101139.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,tp):GetFirst()
	if not fc then return end
	Duel.ConfirmCards(1-tp,fc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cc=Duel.SelectMatchingCard(tp,c95101139.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,fc):GetFirst()
	if not cc then return end
	Duel.ConfirmCards(1-tp,cc)
	local code1,code2=cc:GetOriginalCodeRule()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(95101139,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_FUSION_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(code1)
	tc:RegisterEffect(e1)
	if code2 then
		local e2=e1:Clone()
		e2:SetValue(code2)
		tc:RegisterEffect(e2)
	end
end
