--狱符「星光线条」
function c1003017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1003017.target)
	e1:SetOperation(c1003017.activate)
	c:RegisterEffect(e1)
end
function c1003017.filter(c,des)
	return c:IsFaceup() and c:IsSetCard(0xa200) and (des or c:IsDestructable())
end
function c1003017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c1003017.filter(chkc,false) end
	if chk==0 then return Duel.IsExistingTarget(c1003017.filter,tp,LOCATION_MZONE,0,1,nil,false)
		and Duel.IsExistingMatchingCard(c1003017.filter,tp,LOCATION_MZONE,0,2,nil,true) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1003017.filter,tp,LOCATION_MZONE,0,1,1,nil,false)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1003017.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c1003017.filter,tp,LOCATION_MZONE,0,nil,true)
		local ac=g:GetFirst()
		while ac do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			ac:RegisterEffect(e1)
			ac=g:GetNext()
		end
	end
end