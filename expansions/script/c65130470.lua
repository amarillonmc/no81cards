--狂才
function c65130470.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c65130470.con)
	e1:SetTarget(c65130470.tg)
	e1:SetOperation(c65130470.op)
	c:RegisterEffect(e1)
end
function c65130470.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c65130470.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c65130470.op(e,tp,eg,ep,ev,re,r,rp)	
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_CHAINING)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(c65130470.regop)  
	Duel.RegisterEffect(e2,tp)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EVENT_CHAIN_SOLVED)  
	e3:SetReset(RESET_PHASE+PHASE_END) 
	e3:SetCondition(c65130470.drcon)  
	e3:SetOperation(c65130470.drop)  
	Duel.RegisterEffect(e3,tp)  
end
function c65130470.regop(e,tp,eg,ep,ev,re,r,rp)   
	if rp==tp then
		e:GetHandler():RegisterFlagEffect(65130470,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	end
end  
function c65130470.drcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:GetFlagEffect(65130470)~=0
end  
function c65130470.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,65130471)<5 then
		Duel.ResetTimeLimit(tp,5-Duel.GetFlagEffect(tp,65130471))
	else
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if Duel.Draw(tp,1,REASON_EFFECT) >0 then Duel.RegisterFlagEffect(tp,65130471,RESET_PHASE+PHASE_END,0,1) end
end 