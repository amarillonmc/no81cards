function c118861679.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE)
	e1:SetTarget(c118861679.target)
	e1:SetOperation(c118861679.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e4)
end
function c118861679.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c118861679.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c118861679.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c118861679.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c118861679.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local opt=Duel.SelectOption(tp,aux.Stringid(118861679,0),aux.Stringid(118861679,1))
	e:SetLabel(opt)
end
function c118861679.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		if e:GetLabel()==0 then
			e2:SetValue(c118861679.efilter1)
		else 
			e2:SetValue(c118861679.efilter2) 
		end
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c118861679.efilter1(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwner()~=e:GetOwner()
end
function c118861679.efilter2(e,te)
	return te:IsActiveType(TYPE_TRAP)
end