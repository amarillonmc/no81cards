--人理之基 怖军
function c22024270.initial_effect(c)
	--summon  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_MZONE)
	e1:SetTarget(function(e,c) 
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler() end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1) 
	--tribute check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c22024270.valcheck)
	c:RegisterEffect(e2)
	--sum eff 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e3:SetCode(EVENT_SUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetLabelObject(e2)
	e3:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) end)
	e3:SetTarget(c22024270.sumetg) 
	e3:SetOperation(c22024270.sumeop) 
	c:RegisterEffect(e3) 
end
function c22024270.valcheck(e,c)
	local g=c:GetMaterial() 
	local tp=c:GetControler() 
	local mchk1=0 
	local mchk2=0 
	local mchk3=0 
	local tc=g:GetFirst()
	while tc do
	if tc:IsLocation(LOCATION_HAND) then mchk1=1 end 
	if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) then mchk2=1 end 
	if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(1-tp) then mchk3=1 end 
	tc=g:GetNext()
	end 
	e:SetLabel(mchk1,mchk2,mchk3)
end
function c22024270.sumetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end 
function c22024270.sumeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local mchk1,mchk2,mchk3=e:GetLabelObject():GetLabel()  
	if mchk1==1 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end 
	if mchk2==1 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_BP_TWICE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START	 and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(s.bpcon)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end 
	if mchk3==1 and Duel.SelectYesNo(1-tp,aux.Stringid(22024270,0)) then 
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,c22024270.filter,1-tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end 
end 
function c22024270.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end