--生命动力
function c98920280.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920280,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920280+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98920280.rectg)
	e1:SetOperation(c98920280.recop)
	c:RegisterEffect(e1)
end
function c98920280.recfilter(c)
	return c:IsFaceup() and c:GetAttack()>0 and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER)
end
function c98920280.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c98920280.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920280.recfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98920280.recfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(g:GetFirst():GetAttack()))
end
function c98920280.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,math.ceil(tc:GetAttack()),REASON_EFFECT)
		if tc:IsRace(RACE_DRAGON) then
		   Duel.BreakEffect()
		   Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end