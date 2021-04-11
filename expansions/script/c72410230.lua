--电晶激活
function c72410230.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72410230+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c72410230.target)
	e1:SetOperation(c72410230.activate)
	c:RegisterEffect(e1)
end
function c72410230.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9729)
end
function c72410230.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c72410230.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c72410230.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c72410230.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c72410230.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		 local e1=Effect.CreateEffect(e:GetHandler())
		 e1:SetDescription(aux.Stringid(72410230,0))
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(72410230)
		 e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		 e1:SetValue(1)
		 tc:RegisterEffect(e1)
		 tc:RegisterFlagEffect(72410230,RESET_EVENT+RESETS_STANDARD,0,2)
	end
end
