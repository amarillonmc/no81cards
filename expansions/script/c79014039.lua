--《幽灵唯我一人》
function c79014039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c79014039.accost) 
	e1:SetTarget(c79014039.actg) 
	e1:SetOperation(c79014039.acop) 
	c:RegisterEffect(e1) 
	--to grave 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c79014039.tgcon)
	e1:SetOperation(c79014039.tgop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_HAND_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0) 
	e2:SetValue(100)
	c:RegisterEffect(e2)
	--dis 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetRange(LOCATION_SZONE) 
	e3:SetValue(c79014039.disval) 
	c:RegisterEffect(e3)  
	--
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c79014039.ctcon)
	e4:SetCost(c79014039.ctcost)
	e4:SetTarget(c79014039.cttg)
	e4:SetOperation(c79014039.ctop)
	c:RegisterEffect(e4) 
	--act in set turn
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
	e5:SetCondition(c79014039.actcon)
	c:RegisterEffect(e5)
end 
function c79014039.pbfil(c) 
	if c:IsLocation(LOCATION_MZONE) then 
	return c:IsFaceup() and c:IsCode(79014038)
	else return not c:IsPublic() and c:IsCode(79014038) end  
end 
function c79014039.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c79014039.pbfil,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c79014039.pbfil,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return b1 or b2 end 
	if b1 then 
	else 
	local g=Duel.SelectMatchingCard(tp,c79014039.pbfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)  
	end 
end 
function c79014039.acfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT) 
end 
function c79014039.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c79014039.acfil,tp,LOCATION_MZONE,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_MZONE,5) or Duel.CheckLocation(tp,LOCATION_MZONE,6)) end 
	local g=Duel.SelectTarget(tp,c79014039.acfil,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack()) 
end 
function c79014039.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_MZONE,5) or Duel.CheckLocation(tp,LOCATION_MZONE,6)) then  
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(79014039,15)) 
		c:SetCardTarget(tc)  
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT) 
		local op=0 
		local b1=Duel.CheckLocation(tp,LOCATION_MZONE,6)
		local b2=Duel.CheckLocation(tp,LOCATION_MZONE,5)
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(79014039,1),aux.Stringid(79014039,0))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(79014039,1))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(79014039,0))+1
		else
			return false
		end
		if op==0 then
			Duel.MoveSequence(tc,6)
		else
			Duel.MoveSequence(tc,5)
		end 
	end 
end   
function c79014039.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)  
end
function c79014039.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c79014039.disval(e) 
	local tp=e:GetHandlerPlayer() 
	local zone=0 
	zone=bit.bor(zone,1)
	zone=bit.bor(zone,2)
	zone=bit.bor(zone,4)
	zone=bit.bor(zone,8)
	zone=bit.bor(zone,16) 
	return zone  
end 
function c79014039.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return Duel.GetAttacker()==tc or Duel.GetAttackTarget()==tc
end
function c79014039.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end 
	local tc=e:GetHandler():GetFirstCardTarget()
	e:SetLabelObject(tc)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST) 
end 
function c79014039.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c79014039.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=e:GetLabelObject()
	if tc and tc:IsOnField() and tc:IsFaceup() then 
		--double
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE) 
		e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE)) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE) 
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1) 
		e1:SetLabel(Duel.GetTurnCount()) 
		e1:SetCondition(function(e) 
		return Duel.GetTurnCount()~=e:GetLabel() end) 
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end 
end 
function c79014039.actckfil(c) 
	return c:IsFaceup() and c:IsCode(79014038)   
end 
function c79014039.actcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c79014039.actckfil,tp,LOCATION_MZONE,0,1,nil) 
end











