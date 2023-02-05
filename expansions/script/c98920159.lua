--混沌之极爆裂
function c98920159.initial_effect(c)
	aux.AddCodeList(c,89631139)
		--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c98920159.target)
	e1:SetOperation(c98920159.activate)
	c:RegisterEffect(e1)
end
function c98920159.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xdd)
end
function c98920159.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98920159.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920159.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98920159.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c98920159.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	tc:RegisterEffect(e3)
	if tc:IsCode(89631139) then
		   Duel.BreakEffect()
		   local e4=Effect.CreateEffect(tc)
		   e4:SetType(EFFECT_TYPE_SINGLE)
		   e4:SetCode(EFFECT_IMMUNE_EFFECT)
		   e4:SetValue(c98920159.efilter)
		   e4:SetOwnerPlayer(tp)
		   e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		   tc:RegisterEffect(e4)
	end
   if tc:IsType(TYPE_FUSION) then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
   end
   local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
   if tc:IsType(TYPE_RITUAL) then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
   end
end
function c98920159.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end