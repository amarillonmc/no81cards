--人理之诗 黑龙双克胜利之剑
function c22021370.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22021370+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22021370.cost)
	e1:SetTarget(c22021370.target)
	e1:SetOperation(c22021370.activate)
	c:RegisterEffect(e1)
end
c22021370.effect_with_altria=true
function c22021370.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22021370,0))
	Duel.SelectOption(tp,aux.Stringid(22021370,1))
	Duel.SelectOption(tp,aux.Stringid(22021370,2))
end
function c22021370.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
		and c:IsSetCard(0xff9)
end
function c22021370.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22021370.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22021370.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22021370.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22021370.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetLink()*1800)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(22021370,3))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetLabelObject(tc)
		e2:SetValue(1)
		e2:SetCondition(c22021370.actcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c22021370.actcon(e)
	return Duel.GetAttacker()==e:GetLabelObject()
end

