--人理之诗 鹤翼三连
function c22020590.initial_effect(c)
	aux.AddCodeList(c,22020220)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22020590+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22020590.condition)
	e1:SetTarget(c22020590.target)
	e1:SetOperation(c22020590.activate)
	c:RegisterEffect(e1)
end
function c22020590.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020240)
end
function c22020590.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c22020590.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return ct>0 and aux.dscon()
end
function c22020590.atkfilter2(c)
	return c:IsFaceup() and c:IsCode(22020220)
end
function c22020590.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c22020590.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22020590.atkfilter2(chkc) end
	if chk==0 and ct<=1 then return Duel.IsExistingTarget(c22020590.atkfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22020590.atkfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22020590.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22020590.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct=g:GetCount()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and ct>=1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetDescription(aux.Stringid(22020590,0))
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetCode(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)
		e5:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5)
		Duel.SelectOption(tp,aux.Stringid(22020590,3))
	end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and ct>=2 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetLabelObject(tc)
		e2:SetValue(1)
		e2:SetCondition(c22020590.actcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(22020590,1))
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		Duel.SelectOption(tp,aux.Stringid(22020590,4))
	end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and ct>=3 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(22020590,2))
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EXTRA_ATTACK)
		e3:SetValue(2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		Duel.SelectOption(tp,aux.Stringid(22020590,5))
	end
end
function c22020590.actcon(e)
	return Duel.GetAttacker()==e:GetLabelObject()
end