--觉醒的愤怒
function c33700163.initial_effect(c)
		 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33700163.condition)
	e1:SetTarget(c33700163.target)
	e1:SetOperation(c33700163.activate)
	c:RegisterEffect(e1)
end
function c33700163.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.GetTurnPlayer()==1-tp
end
function c33700163.filter(c,g)
	return c:IsFaceup() 
	and g:Filter(Card.IsReleasable,c)==g:GetCount()-1 
end
function c33700163.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil) 
   if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and  chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c33700163.filter,tp,LOCATION_MZONE,0,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c33700163.filter,tp,LOCATION_MZONE,0,1,1,nil,g)
end
function c33700163.activate(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
	 if tc:IsRelateToEffect(e) and tc:IsFaceup() then
   local lp=Duel.GetLP(tp)
   Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	local lp2=Duel.GetLP(tp)
   local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,tc)
   Duel.Release(g,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lp-lp2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		 local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_RISE_TO_FULL_HEIGHT)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetLabel(tc:GetRealFieldID())
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ONLY_BE_ATTACKED)
		e4:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
end
end
