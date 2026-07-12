--战术-终结
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	local setcard=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER) and setcard
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and Duel.IsChainNegatable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 then
			local tc=re:GetHandler()
			local code=tc:GetOriginalCode()
			if bit.band(tc:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(0,1)
				e1:SetTarget(s.sumlimit)
				e1:SetLabel(code)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				Duel.RegisterEffect(e2,tp)
			end
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e3:SetTarget(s.distg)
			e3:SetLabelObject(tc)
			e3:SetLabel(code)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e5:SetCode(EFFECT_CANNOT_ACTIVATE)
			e5:SetTargetRange(0,1)
			e5:SetValue(s.actlim)
			e5:SetLabel(code)
			e5:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_CHAIN_SOLVING)
			e6:SetCondition(s.discon)
			e6:SetOperation(s.disop)
			e6:SetLabelObject(tc)
			e6:SetLabel(code)
			e6:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e6,tp)
		end
	end
end
function s.sumlimit(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.actlim(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function s.negfilter(c,tc,code,tp)
	local match=(c==tc) or (c:IsControler(1-tp) and c:IsOriginalCodeRule(code))
	if not match then return false end
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return true
	else
		return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
	end
end
function s.distg(e,c)
	return s.negfilter(c,e:GetLabelObject(),e:GetLabel(),e:GetHandlerPlayer())
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local code=e:GetLabel()
	return s.negfilter(re:GetHandler(),tc,code,tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end