--我已经没钱去拯救人理了
function c22025000.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22025000+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22025000.cttg)
	e1:SetOperation(c22025000.ctop)
	c:RegisterEffect(e1)
end
function c22025000.ctfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:IsControlerCanBeChanged()
end
function c22025000.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22025000.ctfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and Duel.IsExistingTarget(c22025000.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c22025000.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c22025000.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		if Duel.GetControl(tc,1-tp)~=0 then
			Duel.Draw(tp,3,REASON_EFFECT)
		end
	end
end