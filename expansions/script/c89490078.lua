--兽水军的帷幄
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89490042,89490072)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,1)
	e5:SetCode(EFFECT_CANNOT_DISCARD_HAND)
	e5:SetCondition(s.excon)
	e5:SetTarget(s.extarget)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(0,LOCATION_HAND)
	e6:SetCondition(s.excon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS})
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(custom_code)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(s.atkcon2)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
function s.excon(e)
	return Duel.IsEnvironment(89490042)
end
function s.extarget(e,dc,re,r)
	return r&REASON_COST==REASON_COST
end
function s.cfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc34) and c:IsSummonPlayer(tp)
end
function s.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil,tp)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetTurnPlayer()==tp then
		e:SetCategory(CATEGORY_ATKCHANGE)
	else
		e:SetCategory(0)
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(s.cfilter2,nil,tp)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetTurnPlayer()==tp then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		else
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetRange(LOCATION_MZONE)
			e3:SetLabelObject(c)
			e3:SetValue(s.efilter)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
function s.efilter(e,te)
	if te:GetHandler()==e:GetLabelObject() then return false end
	if te:IsActivated() and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		return not g or not g:IsContains(e:GetHandler())
	end
	return true
end
