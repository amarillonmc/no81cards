--驱动装·山吹
function c29010028.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()  
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCondition(c29010028.discon)
	e1:SetOperation(c29010028.disop)
	c:RegisterEffect(e1)  
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetTarget(c29010028.desreptg)
	e2:SetValue(c29010028.desrepval)
	e2:SetOperation(c29010028.desrepop)
	c:RegisterEffect(e2)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c29010028.damval2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(c29010028.damcon)
	c:RegisterEffect(e4)
end
function c29010028.damval2(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.GetFlagEffect(tp,29010028)==0 then
	Duel.Hint(HINT_CARD,0,29010028)
	Duel.RegisterFlagEffect(tp,29010028,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(29010028,0))
		return 0
	end
	return val
end
function c29010028.damcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,29010028)==0 and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c29010028.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c29010028.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c29010028.repfilter,1,nil,tp)
	  and c:IsSummonType(SUMMON_TYPE_SYNCHRO)  and Duel.GetFlagEffect(tp,29010028)==0 end
	return true
end
function c29010028.desrepval(e,c)
	return c29010028.repfilter(c,e:GetHandlerPlayer())
end
function c29010028.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,29010028,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(29010028,0))
	Duel.Hint(HINT_CARD,0,29010028)
end
function c29010028.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fe=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return rp==1-tp and fe:GetHandlerPlayer()==tp and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.GetFlagEffect(tp,29010028)==0
end
function c29010028.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29010028)
	Duel.NegateActivation(ev)
	Duel.RegisterFlagEffect(tp,29010028,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(29010028,0))
end














