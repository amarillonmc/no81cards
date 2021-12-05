--宇宙重构
function c72412330.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c72412330.activate)
	c:RegisterEffect(e1)
end
function c72412330.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetCondition(c72412330.spcon)
		e1:SetOperation(c72412330.spop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
			Duel.RegisterFlagEffect(tp,72412330,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2,fid)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
			Duel.RegisterFlagEffect(tp,72412330,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
		end
		Duel.RegisterEffect(e1,tp)
end
function c72412330.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetValue()
end
function c72412330.spop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end